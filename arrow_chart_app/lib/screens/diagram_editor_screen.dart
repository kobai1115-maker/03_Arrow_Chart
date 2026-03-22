import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/diagram_model.dart';
import '../models/node_model.dart';
import '../models/edge_model.dart';
import '../providers/diagram_provider.dart';
import '../providers/connection_provider.dart';
import '../services/goal_extraction_service.dart';
import '../widgets/canvas/subjective_node.dart';
import '../widgets/canvas/objective_node.dart';
import '../widgets/canvas/midpoint_node.dart';
import '../widgets/edges/edge_painter.dart';
import '../widgets/dialogs/node_edit_dialog.dart';
import '../widgets/sheets/goal_suggestion_sheet.dart';
import '../widgets/sheets/care_plan_proposal_sheet.dart';
import '../theme/app_theme.dart';
import 'package:screenshot/screenshot.dart';
import '../services/export_service.dart';
import '../services/llm_service.dart';
import '../services/settings_service.dart';
import 'settings_screen.dart';
import '../shortcuts/canvas_intents.dart';
import '../utils/shortcut_utils.dart';
import '../widgets/app_drawer.dart';

/// アローチャートエディタ画面
class DiagramEditorScreen extends ConsumerStatefulWidget {
  const DiagramEditorScreen({super.key});

  @override
  ConsumerState<DiagramEditorScreen> createState() =>
      _DiagramEditorScreenState();
}

class _DiagramEditorScreenState extends ConsumerState<DiagramEditorScreen> {
  final TransformationController _transformController =
      TransformationController();
  double _currentZoom = 1.0;
  String? _selectedNodeId;
  String? _draggingNodeId;
  String? _resizingNodeId;
  final GoalExtractionService _goalService = GoalExtractionService();
  final ExportService _exportService = ExportService();

  // 現在のツールモード
  _ToolMode _toolMode = _ToolMode.select;
  String? _selectedEdgeId;
  
  bool _isGeneratingCarePlan = false;
  CarePlanProposal? _latestProposal;

  // キーボードショートカット用のフォーカスノード
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    _transformController.dispose();
    super.dispose();
  }

  bool _isTextEditing() {
    final focusNode = FocusManager.instance.primaryFocus;
    return focusNode != null && focusNode.context?.widget is EditableText;
  }

  void _deleteSelected() {
    if (_selectedNodeId != null) {
      ref.read(diagramProvider.notifier).removeNode(_selectedNodeId!);
      setState(() => _selectedNodeId = null);
    } else if (_selectedEdgeId != null) {
      ref.read(diagramProvider.notifier).removeEdge(_selectedEdgeId!);
      setState(() => _selectedEdgeId = null);
    }
  }

  void _copySelected() {
    if (_selectedNodeId != null) {
      final node = ref.read(diagramProvider).findNode(_selectedNodeId!);
      if (node != null) {
        final nodeJson = jsonEncode(node.toJson());
        Clipboard.setData(ClipboardData(text: 'ArrowChartNode:$nodeJson'));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ノードをコピーしました'), duration: Duration(seconds: 1)),
        );
      }
    }
  }

  void _paste() async {
    final data = await Clipboard.getData('text/plain');
    if (data != null && data.text != null && data.text!.startsWith('ArrowChartNode:')) {
      final jsonStr = data.text!.substring('ArrowChartNode:'.length);
      try {
        final nodeJson = jsonDecode(jsonStr);
        final oldNode = ChartNode.fromJson(nodeJson);
        // ややずらしてペーストする
        final offsetX = oldNode.x + 20;
        final offsetY = oldNode.y + 20;
        ref.read(diagramProvider.notifier).duplicateNode(oldNode, offsetX, offsetY);
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final diagram = ref.watch(diagramProvider);
    final connectionState = ref.watch(connectionProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: 'ナビゲーションメニューを開く',
          ),
        ),
        title: Text(diagram.title),
        actions: [
          // 目標抽出ボタン
          IconButton(
            onPressed: () => _generateCarePlan(),
            icon: const Icon(Icons.auto_awesome),
            tooltip: 'AIケアプラン提案',
          ),
          // PDFエクスポートボタン (キャンバス & ケアプラン)
          IconButton(
            onPressed: () => _exportService.exportAsPdf(context, diagram.title, proposal: _latestProposal),
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'PDFで出力（キャンバス＆ケアプラン）',
          ),
          // 画像エクスポートボタン
          IconButton(
            onPressed: () => _exportService.exportAsImage(context, diagram.title),
            icon: const Icon(Icons.image),
            tooltip: '画像（PNG）で出力',
          ),
          // メニュー
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'rename':
                  _showRenameDialog(context);
                  break;
                case 'clear':
                  _confirmClear(context);
                  break;
                case 'export_img':
                  _exportService.exportAsImage(context, diagram.title);
                  break;
                case 'export_pdf':
                  _exportService.exportAsPdf(context, diagram.title, proposal: _latestProposal);
                  break;
                case 'export_json':
                  final jsonStr = jsonEncode(diagram.toJson());
                  _exportService.exportAsJson(context, jsonStr, diagram.title);
                  break;
                case 'import_json':
                  final jsonStr = await _exportService.importFromJson(context);
                  if (jsonStr != null && mounted) {
                    try {
                      final importedDiagram = Diagram.fromJson(jsonDecode(jsonStr));
                      ref.read(diagramProvider.notifier).loadDiagram(importedDiagram);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('プロジェクトを読み込みました')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('不正なファイル形式です')),
                      );
                    }
                  }
                  break;
                case 'list':
                  Navigator.pop(context);
                  break;
                case 'settings':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'rename', child: Text('タイトルを変更')),
              const PopupMenuItem(value: 'list', child: Text('プロジェクト一覧へ')),
              const PopupMenuItem(value: 'clear', child: Text('新規作成')),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'export_img', child: Text('画像(PNG)で書き出し')),
              const PopupMenuItem(value: 'export_pdf', child: Text('PDFで書き出し')),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'export_json', child: Text('プロジェクトを保存(.arrow)')),
              const PopupMenuItem(value: 'import_json', child: Text('プロジェクトを読込')),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'settings', child: Text('設定 (APIキー)')),
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          Shortcuts(
            shortcuts: <ShortcutActivator, Intent>{
              ShortcutUtils.getModifierActivator(LogicalKeyboardKey.keyZ): const UndoIntent(),
          ShortcutUtils.getModifierActivator(LogicalKeyboardKey.keyZ, shift: true): const RedoIntent(),
          if (!ShortcutUtils.isAppleOS)
            SingleActivator(LogicalKeyboardKey.keyY, control: true): const RedoIntent(),
          ShortcutUtils.getModifierActivator(LogicalKeyboardKey.keyC): const CopyIntent(),
          ShortcutUtils.getModifierActivator(LogicalKeyboardKey.keyX): const CutIntent(),
          ShortcutUtils.getModifierActivator(LogicalKeyboardKey.keyV): const PasteIntent(),
          ShortcutUtils.getModifierActivator(LogicalKeyboardKey.keyA): const SelectAllIntent(),
          ShortcutUtils.getModifierActivator(LogicalKeyboardKey.keyS): const SaveIntent(),
          const SingleActivator(LogicalKeyboardKey.delete): const DeleteNodeIntent(),
          const SingleActivator(LogicalKeyboardKey.backspace): const DeleteNodeIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            UndoIntent: CallbackAction<UndoIntent>(onInvoke: (intent) {
              if (_isTextEditing()) return null;
              ref.read(diagramProvider.notifier).undo();
              return null;
            }),
            RedoIntent: CallbackAction<RedoIntent>(onInvoke: (intent) {
              if (_isTextEditing()) return null;
              ref.read(diagramProvider.notifier).redo();
              return null;
            }),
            CopyIntent: CallbackAction<CopyIntent>(onInvoke: (intent) {
              if (_isTextEditing()) return null;
              _copySelected();
              return null;
            }),
            CutIntent: CallbackAction<CutIntent>(onInvoke: (intent) {
              if (_isTextEditing()) return null;
              _copySelected();
              _deleteSelected();
              return null;
            }),
            PasteIntent: CallbackAction<PasteIntent>(onInvoke: (intent) {
              if (_isTextEditing()) return null;
              _paste();
              return null;
            }),
            SelectAllIntent: CallbackAction<SelectAllIntent>(onInvoke: (intent) {
              if (_isTextEditing()) return null;
              return null;
            }),
            DeleteNodeIntent: CallbackAction<DeleteNodeIntent>(onInvoke: (intent) {
              if (_isTextEditing()) return null;
              _deleteSelected();
              return null;
            }),
            SaveIntent: CallbackAction<SaveIntent>(onInvoke: (intent) {
              ref.read(diagramProvider.notifier).saveToLocalDb();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('保存しました'), duration: Duration(seconds: 1)),
              );
              return null;
            }),
          },
          child: Focus(
          focusNode: _focusNode,
          autofocus: true,
          canRequestFocus: true,
          child: Stack(
          children: [
            // キャンバス（ピンチズーム & パン対応）
            InteractiveViewer(
            transformationController: _transformController,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            minScale: 0.2,
            maxScale: 3.0,
            onInteractionUpdate: (details) {
              setState(() {
                _currentZoom = _transformController.value.getMaxScaleOnAxis();
              });
            },
            child: GestureDetector(
              onTapDown: (_) {
                // タップ時にフォーカスを要求してショートカットキーを有効にする
                if (!_focusNode.hasFocus) {
                  _focusNode.requestFocus();
                }
              },
              onTapUp: (details) {
                if (_toolMode == _ToolMode.addSubjective) {
                  _addNodeAtPosition(
                      NodeType.subjective, details.localPosition);
                  setState(() => _toolMode = _ToolMode.select);
                } else if (_toolMode == _ToolMode.addObjective) {
                  _addNodeAtPosition(
                      NodeType.objective, details.localPosition);
                  setState(() => _toolMode = _ToolMode.select);
                } else {
                  _handleBackgroundSingleTap(details.localPosition);
                }
              },
              onDoubleTapDown: (details) {
                // 線の削除アクション（ダブルタップ/ダブルクリックのみに制限）
                _handleBackgroundForceAction(details.localPosition);
              },
              child: Screenshot(
                controller: _exportService.screenshotController,
                child: Container(
                  width: 3000,
                  height: 3000,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Stack(
                    children: [
                      // グリッドパターン背景
                      CustomPaint(
                        size: const Size(3000, 3000),
                        painter: _GridPainter(),
                      ),
                      // エッジ描画
                      CustomPaint(
                        size: const Size(3000, 3000),
                        painter: EdgePainter(
                          edges: diagram.edges,
                          nodes: diagram.nodes,
                          selectedEdgeId: _selectedEdgeId,
                        ),
                      ),
                      // ノード描画
                      ...diagram.nodes.map((node) => _buildNodeWidget(
                          node, connectionState)),
                      // 結線中のみ、ソースノードの直上にメニューを表示
                      if (connectionState.mode == ConnectionMode.sourceSelected)
                        _buildConnectionOverlay(diagram, connectionState),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // 線の削除はダブルタップ/ダブルクリックのみとするため、FAB（削除ボタン）を廃止
          /* 
          if (_selectedEdgeId != null)
            Positioned(
              bottom: 120,
              right: 16,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.redAccent,
                onPressed: () {
                  final edge = diagram.findEdge(_selectedEdgeId!);
                  if (edge != null) _showEdgeActionMenu(edge);
                },
                child: const Icon(Icons.delete, color: Colors.white),
              ),
            ),
          */
          // ズームレベル表示
          Positioned(
            bottom: 90,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${(_currentZoom * 100).toInt()}%',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
      ),
          ),
          ),
          if (_isGeneratingCarePlan)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'AIケアプランを提案中...',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      // ツールバー（Bottom）
      bottomNavigationBar: _buildToolBar(connectionState),
    );
  }

  /// ノードウィジェットを構築
  Widget _buildNodeWidget(ChartNode node, ChartConnectionState connState) {
    final isSelected = node.id == _selectedNodeId;
    final isConnecting =
        connState.mode == ConnectionMode.sourceSelected &&
            connState.sourceNodeId == node.id;

    final Widget nodeWidget;
    if (node.type == NodeType.subjective) {
      nodeWidget = SubjectiveNodeWidget(
        node: node,
        isSelected: isSelected,
        isConnecting: isConnecting,
        zoomLevel: _currentZoom,
        onHandleTap: () => _onHandleTap(node, connState),
      );
    } else if (node.type == NodeType.objective) {
      nodeWidget = ObjectiveNodeWidget(
        node: node,
        isSelected: isSelected,
        isConnecting: isConnecting,
        zoomLevel: _currentZoom,
        onHandleTap: () => _onHandleTap(node, connState),
      );
    } else {
      nodeWidget = MidpointNodeWidget(
        node: node,
        isSelected: isSelected,
        isConnecting: isConnecting,
        zoomLevel: _currentZoom,
        onHandleTap: () => _onHandleTap(node, connState),
      );
    }

    return Positioned(
      left: node.x,
      top: node.y,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onNodeTap(node, connState),
        onDoubleTap: () => _onNodeDoubleTap(node),
        onPanStart: (details) {
          final localPos = details.localPosition;
          const threshold = 15.0; // 境界線付近の判定閾値
          
          // 右下、右、下のいずれかの境界線付近をドラッグしているか
          final isNearRight = (localPos.dx - node.width).abs() < threshold;
          final isNearBottom = (localPos.dy - node.height).abs() < threshold;
          
          if (isNearRight || isNearBottom) {
            _resizingNodeId = node.id;
          } else {
            _draggingNodeId = node.id;
            // 選択も同時に行う（手順１：シングルクリック(タップ)して選択）
            setState(() {
              _selectedNodeId = node.id;
            });
          }
        },
        onPanUpdate: (details) {
          if (_resizingNodeId == node.id) {
            final delta = details.delta / _currentZoom;
            ref.read(diagramProvider.notifier)
                .resizeNode(node.id, delta.dx, delta.dy);
          } else if (_draggingNodeId == node.id) {
            final delta = details.delta / _currentZoom;
            ref.read(diagramProvider.notifier)
                .moveNode(node.id, delta.dx, delta.dy);
          }
        },
        onPanEnd: (_) {
          _draggingNodeId = null;
          _resizingNodeId = null;
        },
        child: nodeWidget,
      ),
    );
  }

  /// ノードタップ時の処理
  void _onNodeTap(ChartNode node, ChartConnectionState connState) {
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }
    
    final connectionNotifier = ref.read(connectionProvider.notifier);

    if (connState.mode == ConnectionMode.relationSelected) {
      // 手順２：出発点を選択
      connectionNotifier.selectSource(node.id);
    } else if (connState.mode == ConnectionMode.sourceSelected) {
      // 手順３：終着点を選択
      if (connState.sourceNodeId != node.id) {
        ref.read(diagramProvider.notifier).addEdge(
              connState.sourceNodeId!,
              node.id,
              connState.selectedRelation,
            );
        connectionNotifier.reset();
      } else {
        // 自分自身を選択した場合はキャンセル
        connectionNotifier.reset();
      }
    } else {
      // 通常の選択
      if (node.type == NodeType.midpoint) {
        // 中点ノード（記号）がタップされた場合は、即座に派生結線を開始する
        connectionNotifier.selectRelation(EdgeRelation.causeEffect);
        connectionNotifier.selectSource(node.id);
        setState(() {
          _selectedNodeId = node.id;
          _selectedEdgeId = null;
        });
      } else {
        setState(() {
          _selectedNodeId = node.id;
          _selectedEdgeId = null;
        });
      }
    }
  }

  /// 手順５：通常の背景タップ判定（エッジがあったら結線開始 or 選択）
  void _handleBackgroundSingleTap(Offset localPosition) {
    final diagram = ref.read(diagramProvider);
    
    // ユーザー要望：中点（記号）周辺だけでなく、線そのものへのタップでも派生を開始する
    final painter = EdgePainter(edges: diagram.edges, nodes: diagram.nodes);
    final scaledThreshold = 12.0 / _currentZoom; // 判定を少し広くする
    final hitEdge = painter.findEdgeAt(localPosition, scaledThreshold);

    if (hitEdge != null && (hitEdge.relation == EdgeRelation.paradox || hitEdge.relation == EdgeRelation.connection)) {
      final source = diagram.findNode(hitEdge.sourceId);
      final target = diagram.findNode(hitEdge.targetId);
      if (source != null && target != null) {
        // ユーザー要望：図形と中心点の間に新たに中心点が発生することを禁止する（中点は1つまで）
        if (source.type == NodeType.midpoint || target.type == NodeType.midpoint) {
          // すでに中点が関わっている線の場合は、新規作成ではなく既存の中点を選択する
          final midNodeId = source.type == NodeType.midpoint ? source.id : target.id;
          ref.read(connectionProvider.notifier).selectRelation(EdgeRelation.causeEffect);
          ref.read(connectionProvider.notifier).selectSource(midNodeId);
          setState(() {
            _selectedNodeId = midNodeId;
            _selectedEdgeId = null; 
          });
          return;
        }

        final midPoint = Offset(
          (source.center.dx + target.center.dx) / 2,
          (source.center.dy + target.center.dy) / 2,
        );
        
        // 初めての中点を作成して派生結線を開始する
        final midNodeId = ref.read(diagramProvider.notifier).addMidpointBranch(
          hitEdge.id,
          midPoint.dx - 12,
          midPoint.dy - 12,
        );
        if (midNodeId != null) {
          ref.read(connectionProvider.notifier).selectRelation(EdgeRelation.causeEffect);
          ref.read(connectionProvider.notifier).selectSource(midNodeId);
          setState(() {
            _selectedNodeId = midNodeId;
            _selectedEdgeId = null; 
          });
        }
        return;
      }
    }

    // 順接の矢印線（causeEffect）などは選択表示を出さない。何もヒットしなければ解除。
    setState(() {
      _selectedEdgeId = null;
      _selectedNodeId = null;
    });
    ref.read(connectionProvider.notifier).reset();
  }

  /// 強制アクション判定（ダブルタップや長押し、右クリック）
  void _handleBackgroundForceAction(Offset localPosition) {
    final diagram = ref.read(diagramProvider);
    final painter = EdgePainter(edges: diagram.edges, nodes: diagram.nodes);
    final scaledThreshold = 12.0 / _currentZoom; // 強制アクション時も従来より縮小（旧: 100.0）
    final hitEdge = painter.findEdgeAt(localPosition, scaledThreshold);
    
    if (hitEdge != null) {
      _showEdgeActionMenu(hitEdge);
    }
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('新規作成'),
        content: const Text('現在のチャートをクリアして、新しいチャートを作成しますか？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('キャンセル')),
          TextButton(
            onPressed: () {
              ref.read(diagramProvider.notifier).newDiagram();
              Navigator.pop(context);
            },
            child: const Text('新規作成', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// 線のアクションメニュー
  void _showEdgeActionMenu(ChartEdge edge) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('線の操作'),
        content: const Text('この線を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('いいえ'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(diagramProvider.notifier).removeEdge(edge.id);
              setState(() => _selectedEdgeId = null);
              Navigator.pop(context);
            },
            child: const Text('はい'),
          ),
        ],
      ),
    );
  }

  /// 手順５：特定の線を選択して結線を開始
  void _startConnectionFromEdge(ChartEdge edge) {
    // 結線モード(始点選択済み)に強制移行
    ref.read(connectionProvider.notifier).selectRelation(EdgeRelation.causeEffect); // 次は順接を引く想定
    ref.read(connectionProvider.notifier).selectSource(edge.sourceId);
    setState(() {
      _selectedNodeId = edge.sourceId; // 視覚的に始点を選択
    });
  }

  /// ノードダブルタップ時の処理（テキスト入力）
  void _onNodeDoubleTap(ChartNode node) {
    // ユーザー要望：中心点（中点ノード）にはノードの編集（テキスト入力等）を発生させない
    if (node.type == NodeType.midpoint) return;

    setState(() {
      _selectedNodeId = node.id;
    });
    _showNodeEditSheet(node);
  }

  /// ハンドルタップ時の処理 (補助的な始点選択)
  void _onHandleTap(ChartNode node, ChartConnectionState connState) {
    ref.read(connectionProvider.notifier).selectSource(node.id);
  }

  /// ノード編集ダイアログ表示
  void _showNodeEditSheet(ChartNode node) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6), // 背景を少し暗くして集中させる
      builder: (context) => NodeEditDialog(
        nodeId: node.id,
        initialText: node.text,
        initialFontSize: node.fontSize,
        onTextChanged: (text) {
          ref.read(diagramProvider.notifier).updateNodeText(node.id, text);
        },
        onFontSizeChanged: (fontSize) {
          ref.read(diagramProvider.notifier).updateNodeFontSize(node.id, fontSize);
        },
        onDelete: () {
          ref.read(diagramProvider.notifier).removeNode(node.id);
          setState(() => _selectedNodeId = null);
        },
      ),
    );
  }

  /// ノードを座標に追加
  void _addNodeAtPosition(NodeType type, Offset position) {
    ref.read(diagramProvider.notifier)
        .addNode(type, position.dx - 70, position.dy - 40);
  }

  /// 目標候補を抽出して表示 (旧仕様)
  void _showGoalSuggestions(BuildContext context) {
    final diagram = ref.read(diagramProvider);
    final candidates = _goalService.extractGoals(diagram);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GoalSuggestionSheet(candidates: candidates),
    );
  }

  /// AIケアプラン提案の生成フロー
  void _generateCarePlan() async {
    final diagram = ref.read(diagramProvider);
    final candidates = _goalService.extractGoals(diagram);

    if (candidates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('目標抽出に必要な構造（主観と客観の逆説など）がありません')),
      );
      return;
    }

    setState(() {
      _isGeneratingCarePlan = true;
    });

    try {
      final apiKey = await ref.read(settingsServiceProvider).getApiKey();
      final llmService = LlmService(apiKey: apiKey);

      final specialNotes = diagram.nodes
          .where((n) => n.text.contains('!') || n.text.contains('！') || 
                        n.text.contains('?') || n.text.contains('？'))
          .map((n) => n.text)
          .toList();

      final proposal = await llmService.generateCarePlan(candidates, specialNotes: specialNotes);

      if (!mounted) return;

      setState(() {
        _latestProposal = proposal;
      });

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => CarePlanProposalSheet(proposal: proposal),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラーが発生しました: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingCarePlan = false;
        });
      }
    }
  }

  /// タイトル変更ダイアログ
  void _showRenameDialog(BuildContext context) {
    final controller = TextEditingController(
        text: ref.read(diagramProvider).title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('タイトルを変更'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'アローチャートのタイトル',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () {
              ref
                  .read(diagramProvider.notifier)
                  .updateTitle(controller.text);
              Navigator.pop(context);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  /// JSON エクスポートダイアログ
  void _showExportDialog(BuildContext context) {
    final diagram = ref.read(diagramProvider);
    final json = diagram.toJson();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('JSON エクスポート'),
        content: SingleChildScrollView(
          child: SelectableText(
            json.toString(),
            style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }

  /// 結線中のオーバーレイ表示
  Widget _buildConnectionOverlay(Diagram diagram, ChartConnectionState connState) {
    if (connState.sourceNodeId == null) return const SizedBox.shrink();
    final node = diagram.findNode(connState.sourceNodeId!);
    if (node == null) return const SizedBox.shrink();

    return Positioned(
      left: node.center.dx - 125, // 中心を合わせる
      top: node.y - 55,
      width: 250, // 充分な幅を確保して Overflow を防ぐ
      child: Center(
        child: _buildCompactConnectionMenu(connState),
      ),
    );
  }

  /// 結線モード時のコンパクトメニュー
  Widget _buildCompactConnectionMenu(ChartConnectionState connState) {
    return Material(
      elevation: 8,
      shadowColor: Colors.black45,
      borderRadius: BorderRadius.circular(22),
      color: Colors.white,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppTheme.paradoxEdgeColor.withValues(alpha: 0.4), width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCompactRelationButton('→', EdgeRelation.causeEffect, connState, '順接'),
            _buildCompactRelationButton('⚡', EdgeRelation.paradox, connState, '逆説'),
            _buildCompactRelationButton('─', EdgeRelation.connection, connState, '接続'),
            const VerticalDivider(width: 12, indent: 8, endIndent: 8),
            IconButton(
              onPressed: () => ref.read(connectionProvider.notifier).reset(),
              icon: const Icon(Icons.close, size: 20, color: Colors.grey),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 44),
              tooltip: 'キャンセル',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactRelationButton(
      String label, EdgeRelation relation, ChartConnectionState connState, String tooltip) {
    final isActive = connState.selectedRelation == relation;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () => ref.read(connectionProvider.notifier).setRelation(relation),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 36,
          height: 36,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.paradoxEdgeColor.withValues(alpha: 0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            border: isActive ? Border.all(color: AppTheme.paradoxEdgeColor.withValues(alpha: 0.5)) : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? AppTheme.paradoxEdgeColor : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  /// 下部ツールバー
  Widget _buildToolBar(ChartConnectionState connState) {
    return Container(
      height: 90,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 選択ツール
                _buildToolButton(
                  icon: Icons.near_me,
                  label: '選択',
                  isActive: _toolMode == _ToolMode.select,
                  onTap: () => setState(() => _toolMode = _ToolMode.select),
                ),
                // □ 主観的事実追加
                _buildToolButton(
                  icon: Icons.square_outlined,
                  label: '□ 主観',
                  isActive: _toolMode == _ToolMode.addSubjective,
                  color: AppTheme.subjectiveColor,
                  onTap: () => setState(
                      () => _toolMode = _ToolMode.addSubjective),
                ),
                // ○ 客観的事実追加
                _buildToolButton(
                  icon: Icons.circle_outlined,
                  label: '○ 客観',
                  isActive: _toolMode == _ToolMode.addObjective,
                  color: AppTheme.objectiveColor,
                  onTap: () =>
                      setState(() => _toolMode = _ToolMode.addObjective),
                ),
                // 結線モード
                _buildToolButton(
                  icon: Icons.link,
                  label: '結線',
                  isActive:
                      connState.mode != ConnectionMode.idle,
                  color: AppTheme.paradoxEdgeColor,
                  onTap: () {
                    if (connState.mode != ConnectionMode.idle) {
                      ref.read(connectionProvider.notifier).reset();
                    } else {
                      // 手順１：デフォルトで「順接(→)」を選択
                      ref.read(connectionProvider.notifier).selectRelation(EdgeRelation.causeEffect);
                    }
                    setState(() => _toolMode = _ToolMode.select);
                  },
                ),
                // 目標抽出
                _buildToolButton(
                  icon: Icons.auto_awesome,
                  label: '目標',
                  onTap: () => _showGoalSuggestions(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    bool isActive = false,
    Color? color,
    required VoidCallback onTap,
  }) {
    final activeColor = color ?? Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: isActive ? activeColor : Colors.grey),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? activeColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ツールモード
enum _ToolMode {
  select,
  addSubjective,
  addObjective,
}

/// グリッド背景のペインター
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    const gridSize = 40.0;
    for (var x = 0.0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
