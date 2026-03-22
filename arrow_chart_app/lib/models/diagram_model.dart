import 'package:freezed_annotation/freezed_annotation.dart';
import 'node_model.dart';
import 'edge_model.dart';

part 'diagram_model.freezed.dart';
part 'diagram_model.g.dart';

/// ダイアグラム全体の集約モデル
@freezed
class Diagram with _$Diagram {
  const Diagram._();

  const factory Diagram({
    required String id,
    @Default('新規アローチャート') String title,
    @Default([]) List<ChartNode> nodes,
    @Default([]) List<ChartEdge> edges,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Diagram;

  /// ノードをIDで検索
  ChartNode? findNode(String nodeId) {
    try {
      return nodes.firstWhere((n) => n.id == nodeId);
    } catch (_) {
      return null;
    }
  }

  /// エッジをIDで検索
  ChartEdge? findEdge(String edgeId) {
    try {
      return edges.firstWhere((e) => e.id == edgeId);
    } catch (_) {
      return null;
    }
  }

  /// 指定ノードに接続されたエッジ一覧
  List<ChartEdge> edgesForNode(String nodeId) {
    return edges
        .where((e) => e.sourceId == nodeId || e.targetId == nodeId)
        .toList();
  }

  factory Diagram.fromJson(Map<String, dynamic> json) =>
      _$DiagramFromJson(json);
}
