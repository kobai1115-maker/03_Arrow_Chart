import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/diagram_model.dart';
import '../models/node_model.dart';
import '../models/edge_model.dart';
import '../services/diagram_repository.dart';
import '../database/app_database.dart';
import '../providers/auth_provider.dart';

const _uuid = Uuid();

/// ダイアグラム状態を管理する StateNotifier
class DiagramNotifier extends StateNotifier<Diagram> {
  final DiagramRepository? _repository;
  final AppAuthState? _authState;
  
  // 履歴管理用のスタック
  final List<Diagram> _history = [];
  final List<Diagram> _redoStack = [];
  static const int _maxHistory = 50;

  DiagramNotifier({DiagramRepository? repository, AppAuthState? authState})
      : _repository = repository,
        _authState = authState,
        super(Diagram(id: _uuid.v4(), title: '新規関係性ダイアグラム'));

  /// 現在の状態を履歴に保存
  void _addToHistory() {
    if (_history.isNotEmpty && _history.last == state) return;
    _history.add(state);
    if (_history.length > _maxHistory) {
      _history.removeAt(0);
    }
    _redoStack.clear();
  }

  /// ひとつ前の状態に戻す (Ctrl+Z)
  void undo() {
    if (_history.isEmpty) return;
    _redoStack.add(state);
    final previous = _history.removeLast();
    state = previous;
    _save(isUndoRedo: true);
  }

  /// やり直す (Ctrl+Y / Ctrl+Shift+Z)
  void redo() {
    if (_redoStack.isEmpty) return;
    _history.add(state);
    final next = _redoStack.removeLast();
    state = next;
    _save(isUndoRedo: true);
  }

  /// ダイアグラムを丸ごと差し替え（読込時）
  void loadDiagram(Diagram diagram) {
    _addToHistory();
    state = diagram;
  }

  /// 新規ダイアグラムを初期化 (Free版制限チェック付き)
  Future<bool> newDiagram() async {
    final canCreate = await _checkLimit();
    if (!canCreate) return false;

    _addToHistory();
    state = Diagram(id: _uuid.v4(), title: '新規関係性ダイアグラム');
    _save();
    return true;
  }

  /// 制限チェック (Freeプランは3枚まで)
  Future<bool> _checkLimit() async {
    if (_repository == null) return true;
    if (_authState?.isPremium == true) return true;

    final count = await _repository.getDiagramCount();
    return count < 3;
  }

  /// タイトル更新
  void updateTitle(String title) {
    _addToHistory();
    state = state.copyWith(title: title, updatedAt: DateTime.now());
    _save();
  }

  // ─── ノード操作 ───

  void addNode(NodeType type, double x, double y) {
    _addToHistory();
    final node = ChartNode(
      id: _uuid.v4(),
      type: type,
      x: x,
      y: y,
      text: type == NodeType.subjective ? '主観的事実' : (type == NodeType.objective ? '客観的事実' : ''),
      width: type == NodeType.midpoint ? 32.0 : 140.0,
      height: type == NodeType.midpoint ? 32.0 : 80.0,
    );
    state = state.copyWith(
      nodes: [...state.nodes, node],
      updatedAt: DateTime.now(),
    );
    _save();
  }

  void moveNode(String nodeId, double dx, double dy) {
    var updatedNodes = state.nodes.map((n) {
      if (n.id == nodeId) {
        return n.copyWith(x: n.x + dx, y: n.y + dy);
      }
      return n;
    }).toList();

    final connectedEdges = state.edges.where((e) => e.sourceId == nodeId || e.targetId == nodeId).toList();
    for (final edge in connectedEdges) {
      final otherNodeId = edge.sourceId == nodeId ? edge.targetId : edge.sourceId;
      final otherNode = updatedNodes.firstWhere((n) => n.id == otherNodeId, orElse: () => state.nodes.firstWhere((n) => n.id == otherNodeId));
      
      if (otherNode.type == NodeType.midpoint) {
        final edgesWithMidpoint = state.edges.where((e) => e.sourceId == otherNode.id || e.targetId == otherNode.id).toList();
        ChartNode? parentSource;
        ChartNode? parentTarget;
        
        for (final e in edgesWithMidpoint) {
           if (e.targetId == otherNode.id) {
             parentSource = updatedNodes.firstWhere((n) => n.id == e.sourceId, orElse: () => state.nodes.firstWhere((n) => n.id == e.sourceId));
           } else if (e.sourceId == otherNode.id && e.relation != EdgeRelation.causeEffect) {
             parentTarget = updatedNodes.firstWhere((n) => n.id == e.targetId, orElse: () => state.nodes.firstWhere((n) => n.id == e.targetId));
           }
        }
        
        String? targetToUpdate;
        for (final e in edgesWithMidpoint) {
          if (e.sourceId == otherNode.id) {
             targetToUpdate ??= e.targetId;
             if (e.relation == edge.relation) {
                targetToUpdate = e.targetId;
                break;
             }
          }
        }
        if (targetToUpdate != null && parentSource == null) {
          for (final e in edgesWithMidpoint) {
            if (e.targetId == otherNode.id) {
              parentSource = updatedNodes.firstWhere((n) => n.id == e.sourceId, orElse: () => state.nodes.firstWhere((n) => n.id == e.sourceId));
              break;
            }
          }
          parentTarget = updatedNodes.firstWhere((n) => n.id == targetToUpdate, orElse: () => state.nodes.firstWhere((n) => n.id == targetToUpdate));
        }

        if (parentSource != null && parentTarget != null) {
           final newMidX = (parentSource.center.dx + parentTarget.center.dx) / 2 - (otherNode.width / 2);
           final newMidY = (parentSource.center.dy + parentTarget.center.dy) / 2 - (otherNode.height / 2);
           
           updatedNodes = updatedNodes.map((n) {
             if (n.id == otherNode.id) {
               return n.copyWith(x: newMidX, y: newMidY);
             }
             return n;
           }).toList();
        }
      }
    }

    state = state.copyWith(nodes: updatedNodes, updatedAt: DateTime.now());
    // 移動中は _save() を頻繁に呼ばない（パフォーマンスのため。ドラッグ終了時に別途呼ぶ運用も可）
  }

  void resizeNode(String nodeId, double dw, double dh) {
    state = state.copyWith(
      nodes: state.nodes.map((n) {
        if (n.id == nodeId) {
          final newW = (n.width + dw).clamp(48.0, 500.0);
          final newH = (n.height + dh).clamp(48.0, 500.0);
          return n.copyWith(width: newW, height: newH);
        }
        return n;
      }).toList(),
      updatedAt: DateTime.now(),
    );
    _save();
  }

  void setNodePosition(String nodeId, double x, double y) {
    _addToHistory();
    state = state.copyWith(
      nodes: state.nodes.map((n) => n.id == nodeId ? n.copyWith(x: x, y: y) : n).toList(),
      updatedAt: DateTime.now(),
    );
    _save();
  }

  void updateNodeText(String nodeId, String text) {
    _addToHistory();
    state = state.copyWith(
      nodes: state.nodes.map((n) => n.id == nodeId ? n.copyWith(text: text) : n).toList(),
      updatedAt: DateTime.now(),
    );
    _save();
  }

  void updateNodeFontSize(String nodeId, double fontSize) {
    state = state.copyWith(
      nodes: state.nodes.map((n) => n.id == nodeId ? n.copyWith(fontSize: fontSize) : n).toList(),
      updatedAt: DateTime.now(),
    );
    _save();
  }

  void removeNode(String nodeId) {
    _addToHistory();
    state = state.copyWith(
      nodes: state.nodes.where((n) => n.id != nodeId).toList(),
      edges: state.edges.where((e) => e.sourceId != nodeId && e.targetId != nodeId).toList(),
      updatedAt: DateTime.now(),
    );
    _save();
  }

  // ─── エッジ操作 ───

  bool addEdge(String sourceId, String targetId, EdgeRelation relation) {
    if (sourceId == targetId) return false;
    final sourceNode = state.findNode(sourceId);
    final targetNode = state.findNode(targetId);
    if (sourceNode?.type == NodeType.midpoint && targetNode?.type == NodeType.midpoint) return false;
    if (state.edges.any((e) => e.sourceId == sourceId && e.targetId == targetId)) return false;
    if (state.edges.any((e) => e.sourceId == targetId && e.targetId == sourceId)) return false;

    _addToHistory();
    final edge = ChartEdge(id: _uuid.v4(), sourceId: sourceId, targetId: targetId, relation: relation);
    state = state.copyWith(edges: [...state.edges, edge], updatedAt: DateTime.now());
    _save();
    return true;
  }

  void removeEdge(String edgeId) {
    _addToHistory();
    state = state.copyWith(
      edges: state.edges.where((e) => e.id != edgeId).toList(),
      updatedAt: DateTime.now(),
    );
    _save();
  }

  void updateEdgeRelation(String edgeId, EdgeRelation relation) {
    state = state.copyWith(
      edges: state.edges.map((e) => e.id == edgeId ? e.copyWith(relation: relation) : e).toList(),
      updatedAt: DateTime.now(),
    );
    _save();
  }

  String? addMidpointBranch(String edgeId, double x, double y) {
    final edge = state.findEdge(edgeId);
    if (edge == null) return null;
    _addToHistory();
    final midNodeId = _uuid.v4();
    final midNode = ChartNode(id: midNodeId, type: NodeType.midpoint, x: x, y: y, text: '', width: 24.0, height: 24.0);
    final newEdge1 = ChartEdge(id: _uuid.v4(), sourceId: edge.sourceId, targetId: midNodeId, relation: edge.relation);
    final newEdge2 = ChartEdge(id: _uuid.v4(), sourceId: midNodeId, targetId: edge.targetId, relation: edge.relation);
    state = state.copyWith(
      nodes: [...state.nodes, midNode],
      edges: [...state.edges.where((e) => e.id != edgeId), newEdge1, newEdge2],
      updatedAt: DateTime.now(),
    );
    _save();
    return midNodeId;
  }

  void forceUpdate() {
    state = state.copyWith(updatedAt: DateTime.now());
    _save();
  }

  void duplicateNode(ChartNode original, double newX, double newY) {
    _addToHistory();
    final newNode = original.copyWith(id: _uuid.v4(), x: newX, y: newY);
    state = state.copyWith(nodes: [...state.nodes, newNode], updatedAt: DateTime.now());
    _save();
  }

  void saveToLocalDb() { _save(); }

  Future<void> _save({bool isUndoRedo = false}) async {
    if (_repository == null) return;
    try {
      await _repository.saveDiagram(state);
    } catch (e) {
      debugPrint('Error saving diagram: $e');
    }
  }
}

// ─── プロバイダー定義 ───

final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final diagramRepositoryProvider = Provider((ref) => DiagramRepository(ref.watch(appDatabaseProvider)));

final diagramProvider = StateNotifierProvider<DiagramNotifier, Diagram>((ref) {
  final repository = ref.watch(diagramRepositoryProvider);
  final auth = ref.watch(authProvider);
  return DiagramNotifier(repository: repository, authState: auth);
});

final projectListProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final repository = ref.watch(diagramRepositoryProvider);
  return repository.watchDiagrams();
});
