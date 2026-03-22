import 'package:flutter/material.dart';
import '../../models/node_model.dart';
import '../../theme/app_theme.dart';

/// 客観的事実ノード（○ 円形）ウィジェット
class ObjectiveNodeWidget extends StatelessWidget {
  final ChartNode node;
  final bool isSelected;
  final bool isConnecting;
  final double zoomLevel;
  final VoidCallback? onHandleTap;

  const ObjectiveNodeWidget({
    super.key,
    required this.node,
    this.isSelected = false,
    this.isConnecting = false,
    this.zoomLevel = 1.0,
    this.onHandleTap,
  });

  @override
  Widget build(BuildContext context) {
    final showDetail = zoomLevel >= 0.6;
    final diameter = node.width < node.height ? node.width : node.height;

    return Opacity(
      opacity: isSelected || isConnecting ? 1.0 : 0.85, 
      child: Container(
        width: node.width,
        height: node.height,
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        decoration: BoxDecoration(
          gradient: AppTheme.objectiveGradient,
          borderRadius: BorderRadius.all(
            Radius.elliptical(node.width / 2, node.height / 2),
          ),
          border: Border.all(
            color: isSelected
                ? Colors.blueAccent
                : isConnecting
                    ? AppTheme.objectiveColor.withValues(alpha: 0.8)
                    : Colors.grey.shade400,
            width: isSelected ? 5 : 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.blueAccent.withValues(alpha: 0.3),
                blurRadius: 15,
                spreadRadius: 2,
              )
            else
              ...AppTheme.premiumShadow,
          ],
        ),
        child: Stack(
          children: [
            // ノードラベル
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: showDetail
                    ? Text(
                        node.text,
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xFF2D2D2D),
                          fontSize: node.fontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : Icon(
                        Icons.circle_outlined,
                        color: Colors.grey.shade700,
                        size: 20,
                      ),
              ),
            ),
            // タイプラベル
            Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: Text(
                '○ 客観',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 8,
                ),
              ),
            ),
            // 接続ハンドル（右端）
            Positioned(
              right: -4,
              top: diameter / 2 - 12,
              child: GestureDetector(
                onTap: onHandleTap,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isConnecting
                        ? Colors.blueAccent
                        : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isConnecting ? Colors.white : Colors.grey.shade400,
                      width: 2,
                    ),
                    boxShadow: AppTheme.premiumShadow,
                  ),
                  child: Icon(
                    Icons.add,
                    size: 14,
                    color: isConnecting ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
