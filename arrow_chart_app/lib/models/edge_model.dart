import 'package:freezed_annotation/freezed_annotation.dart';

part 'edge_model.freezed.dart';
part 'edge_model.g.dart';

/// エッジの関係性
enum EdgeRelation {
  @JsonValue('cause_effect')
  causeEffect, // → 順接（〜なので〜である）
  @JsonValue('paradox')
  paradox, // ─ギザギザ─ 逆説（〜だけど〜である）
  @JsonValue('connection')
  connection, // ─ 意味づけ/背景/単なる接続
}

/// アローチャートのエッジデータモデル
@freezed
class ChartEdge with _$ChartEdge {
  const factory ChartEdge({
    required String id,
    required String sourceId,
    required String targetId,
    required EdgeRelation relation,
  }) = _ChartEdge;

  factory ChartEdge.fromJson(Map<String, dynamic> json) =>
      _$ChartEdgeFromJson(json);
}
