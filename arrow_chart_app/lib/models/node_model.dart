import 'dart:ui';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'node_model.freezed.dart';
part 'node_model.g.dart';

/// ノードの種類
enum NodeType {
  @JsonValue('subjective')
  subjective, // □ 主観的事実
  @JsonValue('objective')
  objective,  // ○ 客観的事実
  @JsonValue('midpoint')
  midpoint,   // ＋ 中点（派生結線用）
}

/// アローチャートのノードデータモデル
@freezed
class ChartNode with _$ChartNode {
  const ChartNode._(); // getterを定義するためのプライベートコンストラクタ

  const factory ChartNode({
    required String id,
    required NodeType type,
    required double x,
    required double y,
    @Default('') String text,
    @Default(140.0) double width,
    @Default(80.0) double height,
    @Default(14.0) double fontSize,
  }) = _ChartNode;

  factory ChartNode.fromJson(Map<String, dynamic> json) =>
      _$ChartNodeFromJson(json);

  /// ノードの中心座標
  Offset get center => Offset(x + width / 2, y + height / 2);

  /// ノードの矩形領域
  Rect get rect => Rect.fromLTWH(x, y, width, height);
}
