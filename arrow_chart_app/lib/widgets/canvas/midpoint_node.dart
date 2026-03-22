import 'package:flutter/material.dart';
import '../../models/node_model.dart';
import '../../theme/app_theme.dart';

class MidpointNodeWidget extends StatelessWidget {
  final ChartNode node;
  final bool isSelected;
  final bool isConnecting;
  final double zoomLevel;
  final VoidCallback onHandleTap;

  const MidpointNodeWidget({
    super.key,
    required this.node,
    this.isSelected = false,
    this.isConnecting = false,
    required this.zoomLevel,
    required this.onHandleTap,
  });

  @override
  Widget build(BuildContext context) {
    // 中点ノードは論理的な分岐点であり、記号（ギザギザ等）自体は EdgePainter が描画するため、
    // ウィジェットとしては透明（不可視）だが、タップ判定ができるようにサイズを持たせた領域にする。
    return Container(
      width: node.width,
      height: node.height,
      color: Colors.transparent, // ヒット判定のために必要
    );
  }
}
