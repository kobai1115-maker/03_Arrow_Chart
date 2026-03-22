import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/diagram_model.dart';
import '../models/node_model.dart';
import '../models/edge_model.dart';

import '../services/diagram_repository.dart';
import '../database/app_database.dart';

const _uuid = Uuid();

/// ダイアグラム状態を管理する StateNotifier
class DiagramNotifier extends StateNotifier<Diagram> {
  final DiagramRepository? _repository;
  
  // 履歴管理用のスタック
  final List<Diagram> _history = [];
  final List<Diagram> _redoStack = [];
  static const int _maxHistory = 50;

  DiagramNotifier({DiagramRepository? repository})
      : _repository = repository,
        super(Diagram(id: _uuid.v4(), title: '新規アローチャート'));

  /// 現在の状態を履歴に保存
  void _addToHistory() {
    // 直近と同じ状態なら保存しない
    if (_history.isNotEmpty && _history.last == state) return;
    
    _history.add(state);
    if (_history.length > _maxHistory) {
      _history.removeAt(0);
    }
    // 新しい操作をしたらRedoスタックはクリア
    _redoStack.clear();
  }

  /// ひとつ前の状態に戻す (Ctrl+Z)
  void undo() {
    if (_history.isEmpty) return;
    
    _redoStack.add(state);
    final previous = _history.removeLast();
    state = previous;
    _save();
  }

  /// やり直す (Ctrl+Y / Ctrl+Shift+Z)
  void redo() {
    if (_redoStack.isEmpty) return;
    
    _history.add(state);
    final next = _redoStack.removeLast();
    state = next;
    _save();
  }

  /// ダイアグラムを丸ごと差し替え（読込時）
  void loadDiagram(Diagram diagram) {
    _addToHistory();
    state = diagram;
  }

  /// 新規ダイアグラムを初期化
  void newDiagram() {
    _addToHistory();
    state = Diagram(id: _uuid.v4(), title: '新規アローチャート');
    _save();
  }

  /// タイトル更新
  void updateTitle(String title) {
    _addToHistory();
    state = state.copyWith(title: title, updatedAt: DateTime.now());
    _save();
  }

  // ─── ノード操作 ───

  /// ノード追加
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

  /// ノード移動
  void moveNode(String nodeId, double dx, double dy) {
    // まず指定されたノードを移動した状態を作成
    var updatedNodes = state.nodes.map((n) {
      if (n.id == nodeId) {
        return n.copyWith(x: n.x + dx, y: n.y + dy);
      }
      return n;
    }).toList();

    // 移動したノードに対するエッジから関連する中点ノードを探し、座標を再計算する
    // TODO: ここで中点座標を再計算して updatedNodes を更に更新していく
    final connectedEdges = state.edges.where((e) => e.sourceId == nodeId || e.targetId == nodeId).toList();
    for (final edge in connectedEdges) {
      // 中点ノードが関わるエッジか確認する（片方が中点なら中点から伸びるエッジ/向かうエッジの可能性）
      final otherNodeId = edge.sourceId == nodeId ? edge.targetId : edge.sourceId;
      final otherNode = updatedNodes.firstWhere((n) => n.id == otherNodeId, orElse: () => state.nodes.firstWhere((n) => n.id == otherNodeId));
      
      if (otherNode.type == NodeType.midpoint) {
        // この中点ノードは他の通常ノードペアの間の線上にあるべき
        // 中点ノードは必ず1つの causeEffect や paradox エッジを2分割するか、または1つの親から派生している。
        // 現在の中点のロジックでは、エッジを分割して中点を作っているので、
        // 中点ノードには 'source -> midpoint' と 'midpoint -> target' の2本のエッジが繋がっているはず。
        
        final edgesWithMidpoint = state.edges.where((e) => e.sourceId == otherNode.id || e.targetId == otherNode.id).toList();
        
        // 分割された元の線を構成する親ノードを探す
        ChartNode? parentSource;
        ChartNode? parentTarget;
        
        for (final e in edgesWithMidpoint) {
           if (e.targetId == otherNode.id) {
             // midpointに向かう線
             parentSource = updatedNodes.firstWhere((n) => n.id == e.sourceId, orElse: () => state.nodes.firstWhere((n) => n.id == e.sourceId));
           } else if (e.sourceId == otherNode.id && e.relation != EdgeRelation.causeEffect) {
             // midpointから出る線（かつ、派生結線ではなく分割された元の線の一部である場合。
             // addMidpointBranchで元のrelationを引き継いでいる想定）
             // 実際には派生を含めて3本以上繋がる可能性もあるが、
             // 最初に追加された2本（入る・出る）が元ノードペアとみなせる。
             // 最も正確なのは、同じ relation を持つペアを探すこと。
             parentTarget = updatedNodes.firstWhere((n) => n.id == e.targetId, orElse: () => state.nodes.firstWhere((n) => n.id == e.targetId));
           }
        }
        
        // とりあえず簡単な「入る」＆「出る(同Relation)」でペアを特定
        String? targetToUpdate;
        for (final e in edgesWithMidpoint) {
          if (e.sourceId == otherNode.id) {
             targetToUpdate ??= e.targetId;
             // 分割線と推測されるもの（元の線と同じ関係性）
             if (e.relation == edge.relation) {
                targetToUpdate = e.targetId;
                break;
             }
          }
        }
        if (targetToUpdate != null && parentSource == null) {
          // edgeは source->midpoint ではなかった、つまり midpoint->target 側だった
          for (final e in edgesWithMidpoint) {
            if (e.targetId == otherNode.id) {
              parentSource = updatedNodes.firstWhere((n) => n.id == e.sourceId, orElse: () => state.nodes.firstWhere((n) => n.id == e.sourceId));
              break;
            }
          }
          parentTarget = updatedNodes.firstWhere((n) => n.id == targetToUpdate, orElse: () => state.nodes.firstWhere((n) => n.id == targetToUpdate));
        }

        if (parentSource != null && parentTarget != null) {
           // 両端のノードの現在の（更新後の）中心点から中点座標を再計算
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

    state = state.copyWith(
      nodes: updatedNodes,
      updatedAt: DateTime.now(),
    );
  }

  /// ノードリサイズ
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

  /// ノード位置の直接セット
  void setNodePosition(String nodeId, double x, double y) {
    _addToHistory();
    state = state.copyWith(
      nodes: state.nodes.map((n) => n.id == nodeId ? n.copyWith(x: x, y: y) : n).toList(),
      updatedAt: DateTime.now(),
    );
    _save();
  }

  /// ノードテキスト更新
  void updateNodeText(String nodeId, String text) {
    _addToHistory();
    state = state.copyWith(
      nodes: state.nodes.map((n) => n.id == nodeId ? n.copyWith(text: text) : n).toList(),
      updatedAt: DateTime.now(),
    );
    _save();
  }

  /// 共通：ノードフォントサイズ更新
  void updateNodeFontSize(String nodeId, double fontSize) {
    state = state.copyWith(
      nodes: state.nodes.map((n) => n.id == nodeId ? n.copyWith(fontSize: fontSize) : n).toList(),
      updatedAt: DateTime.now(),
    );
    _save();
  }

  /// ノード削除（関連エッジも削除）
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

  /// エッジ追加（バリデーション付き）
  /// 戻り値: 成功時は true, 失敗時(エラー)は false
  bool addEdge(String sourceId, String targetId, EdgeRelation relation) {
    if (sourceId == targetId) return false;

    // ユーザー要望：中心点（midpoint）から中心点への結線は禁止
    final sourceNode = state.findNode(sourceId);
    final targetNode = state.findNode(targetId);
    if (sourceNode?.type == NodeType.midpoint && targetNode?.type == NodeType.midpoint) {
      return false;
    }

    // 重複チェック
    final exists = state.edges.any((e) => e.sourceId == sourceId && e.targetId == targetId);
    if (exists) return false;

    // 双方向（逆方向）接続の抑止ルール: 一方向性の担保
    final reverseExists = state.edges.any((e) => e.sourceId == targetId && e.targetId == sourceId);
    if (reverseExists) {
      // 逆方向の線が既に存在する場合はエラーとしてブロックする
      return false;
    }

    _addToHistory();
    final edge = ChartEdge(
      id: _uuid.v4(),
      sourceId: sourceId,
      targetId: targetId,
      relation: relation,
    );
    state = state.copyWith(
      edges: [...state.edges, edge],
      updatedAt: DateTime.now(),
    );
    _save();
    return true;
  }

  /// エッジ削除
  void removeEdge(String edgeId) {
    _addToHistory();
    state = state.copyWith(
      edges: state.edges.where((e) => e.id != edgeId).toList(),
      updatedAt: DateTime.now(),
    );
    _save();
  }

  /// エッジの関係性変更
  void updateEdgeRelation(String edgeId, EdgeRelation relation) {
    state = state.copyWith(
      edges: state.edges.map((e) => e.id == edgeId ? e.copyWith(relation: relation) : e).toList(),
      updatedAt: DateTime.now(),
    );
    _save();
  }

  /// 中点ノードを作成してエッジを分割する
  String? addMidpointBranch(String edgeId, double x, double y) {
    // 1. 対象のエッジを探す
    final edge = state.findEdge(edgeId);
    if (edge == null) return null;

    _addToHistory();
    // 2. 中点ノード(見えないノード)を作成
    final midNodeId = _uuid.v4();
    final midNode = ChartNode(
      id: midNodeId,
      type: NodeType.midpoint,
      x: x,
      y: y,
      text: '',
      width: 24.0, // 中点ハンドルのサイズ
      height: 24.0,
    );

    // 3. 元のエッジを削除し、2つの新しいエッジを作成
    final newEdge1 = ChartEdge(
      id: _uuid.v4(),
      sourceId: edge.sourceId,
      targetId: midNodeId,
      relation: edge.relation,
    );
    final newEdge2 = ChartEdge(
      id: _uuid.v4(),
      sourceId: midNodeId,
      targetId: edge.targetId,
      relation: edge.relation, // ギザギザや背景線のプロパティを引き継ぐ
    );

    state = state.copyWith(
      nodes: [...state.nodes, midNode],
      edges: [
        ...state.edges.where((e) => e.id != edgeId),
        newEdge1,
        newEdge2,
      ],
      updatedAt: DateTime.now(),
    );
    _save();
    return midNodeId;
  }

  /// インポート等で状態を強制更新
  void forceUpdate() {
    state = state.copyWith(updatedAt: DateTime.now());
    _save();
  }

  /// ノードの完全複製（コピー＆ペースト用）
  void duplicateNode(ChartNode original, double newX, double newY) {
    _addToHistory();
    // ユーザー要望に沿って新しいIDを付与して追加
    final newNode = original.copyWith(
      id: _uuid.v4(),
      x: newX,
      y: newY,
    );
    state = state.copyWith(
      nodes: [...state.nodes, newNode],
      updatedAt: DateTime.now(),
    );
    _save();
  }

  /// 手動保存トリガー
  void saveToLocalDb() {
    _save();
  }

  /// 非同期で永続化保存
  Future<void> _save() async {
    if (_repository == null) return;
    try {
      await _repository!.saveDiagram(state);
      // debugPrint('Diagram saved successfully: ${state.id}');
    } catch (e) {
      debugPrint('Error saving diagram: $e');
    }
  }
}

/// AppDatabaseのプロバイダー
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// リポジトリのプロバイダー
final diagramRepositoryProvider = Provider((ref) {
  return DiagramRepository(ref.watch(appDatabaseProvider));
});

/// ダイアグラムのプロバイダー
final diagramProvider =
    StateNotifierProvider<DiagramNotifier, Diagram>((ref) {
  final repository = ref.watch(diagramRepositoryProvider);
  return DiagramNotifier(repository: repository);
});

/// プロジェクト一覧のストリームプロバイダー
final projectListProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final repository = ref.watch(diagramRepositoryProvider);
  return repository.watchDiagrams();
});
