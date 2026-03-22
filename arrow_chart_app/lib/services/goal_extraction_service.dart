import '../models/diagram_model.dart';
import '../models/node_model.dart';
import '../models/edge_model.dart';

/// 抽出された目標候補
class GoalCandidate {
  final String needs;               // ニーズ（〜したい）
  final String needsNodeId;         // □ノードのID
  final String longTermGoal;        // 長期目標（〜できる：逆説の○）
  final String longTermNodeId;      // 逆説ペアの○ノードのID
  final String shortTermGoal;       // 短期目標（〜できる：最上流○）
  final String shortTermNodeId;     // 最上流○ノードのID
  final bool hasLoop;               // 悪循環(ループ)が含まれるか
  final List<String>? loopTexts;    // ループを構成するノードのテキスト

  const GoalCandidate({
    required this.needs,
    required this.needsNodeId,
    required this.longTermGoal,
    required this.longTermNodeId,
    required this.shortTermGoal,
    required this.shortTermNodeId,
    this.hasLoop = false,
    this.loopTexts,
  });
}

class TraversalResult {
  final ChartNode node;
  final List<ChartNode>? loopNodes;

  TraversalResult(this.node, {this.loopNodes});
}

/// ケアプラン目標抽出サービス
class GoalExtractionService {
  /// 解決不可能な（短期目標にふさわしくない）客観的事実のキーワード
  static const unfixableKeywords = ['転倒', '骨折', '病', '疾患', '不全'];

  /// ダイアグラムから目標候補を抽出
  List<GoalCandidate> extractGoals(Diagram diagram) {
    final candidates = <GoalCandidate>[];

    // 逆説（paradox）エッジで結ばれた□○ペアを検索
    final paradoxEdges =
        diagram.edges.where((e) => e.relation == EdgeRelation.paradox);

    for (final edge in paradoxEdges) {
      final sourceNode = diagram.findNode(edge.sourceId);
      final targetNode = diagram.findNode(edge.targetId);
      if (sourceNode == null || targetNode == null) continue;

      // □（ニーズ）と○（長期目標の起点）のペアを特定
      ChartNode? needsNode;
      ChartNode? resultNode; // 構造の終着点となる○

      if (sourceNode.type == NodeType.subjective &&
          targetNode.type == NodeType.objective) {
        needsNode = sourceNode;
        resultNode = targetNode;
      } else if (sourceNode.type == NodeType.objective &&
          targetNode.type == NodeType.subjective) {
        needsNode = targetNode;
        resultNode = sourceNode;
      }

      if (needsNode == null || resultNode == null) continue;

      // 短期目標: ○を起点に順接エッジを遡る。ループや解決可能な最上流を見つける。
      final visited = <String>{};
      final result = _findSolvableRootCauseOrLoop(diagram, resultNode.id, [], visited);
      final shortTermNode = result.node;

      bool hasLoop = result.loopNodes != null;
      List<String>? loopTexts;
      String stGoalText = shortTermNode.text;

      if (hasLoop) {
        // 例：A -> B -> C -> A のようなループテキストを生成
        loopTexts = result.loopNodes!.map((n) => n.text).toList();
        stGoalText = "悪循環: ${loopTexts.join(' → ')}";
      }

      candidates.add(GoalCandidate(
        needs: needsNode.text,
        needsNodeId: needsNode.id,
        longTermGoal: resultNode.text,
        longTermNodeId: resultNode.id,
        shortTermGoal: stGoalText,
        shortTermNodeId: shortTermNode.id,
        hasLoop: hasLoop,
        loopTexts: loopTexts,
      ));
    }

    return candidates;
  }

  /// 解決可能な最上流のObjectiveノードを探す。ループがあれば悪循環として返す。
  TraversalResult _findSolvableRootCauseOrLoop(
      Diagram diagram, String nodeId, List<String> path, Set<String> visited) {
    // ループ検知 (現在の探索パスに既に含まれる場合 -> 悪循環/閉路)
    if (path.contains(nodeId)) {
      final startIndex = path.indexOf(nodeId);
      final loopIds = path.sublist(startIndex);
      final loopNodes = loopIds
          .map((id) => diagram.findNode(id))
          .whereType<ChartNode>()
          .toList();
      // 終端として現在のノードも追加
      loopNodes.add(diagram.findNode(nodeId)!);
      return TraversalResult(diagram.findNode(nodeId)!, loopNodes: loopNodes);
    }

    // すでに他のルートから訪問済みの場合は探索終了（重複探索を防ぐ）
    if (visited.contains(nodeId)) {
      return TraversalResult(diagram.findNode(nodeId)!);
    }
    // 訪問済みリストに記録
    visited.add(nodeId);

    final newPath = List<String>.from(path)..add(nodeId);

    // このノードの原因を探す
    final incomingEdges = diagram.edges.where(
      (e) =>
          e.relation == EdgeRelation.causeEffect &&
          e.targetId == nodeId,
    );

    for (final edge in incomingEdges) {
      final parentNode = diagram.findNode(edge.sourceId);
      if (parentNode != null && parentNode.type == NodeType.objective) {
        // さらに上流を探索（再帰）
        final result = _findSolvableRootCauseOrLoop(diagram, parentNode.id, newPath, visited);

        // ループが見つかっていればそのまま返す
        if (result.loopNodes != null) {
          return result;
        }
        
        // もし辿り着いた最上流が「解決不可能」なら、その次の子（現在のparentNode）を検討
        if (_isUnfixable(result.node.text)) {
           // parentNode自体も解決不可能かチェック
           if (!_isUnfixable(parentNode.text)) {
             return TraversalResult(parentNode);
           }
           // parentNodeもダメなら、さらに下流（元々の探索方向の戻り値）を検討
           return TraversalResult(diagram.findNode(nodeId)!);
        }
        return result;
      }
    }

    return TraversalResult(diagram.findNode(nodeId)!);
  }

  bool _isUnfixable(String text) {
    return unfixableKeywords.any((k) => text.contains(k));
  }
}
