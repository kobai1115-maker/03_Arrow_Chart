import 'package:flutter/material.dart';
import '../../models/node_model.dart';
import '../../theme/app_theme.dart';

/// 主観的事実ノード（□ 四角形）ウィジェット
class SubjectiveNodeWidget extends StatelessWidget {
  final ChartNode node;
  final bool isSelected;
  final bool isConnecting;
  final double zoomLevel;
  final VoidCallback? onHandleTap;

  const SubjectiveNodeWidget({
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
    
    return Opacity(
      opacity: isSelected || isConnecting ? 1.0 : 0.85, // 0.4 -> 0.85 (視認性向上)
      child: Container(
        width: node.width,
        height: node.height,
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        decoration: BoxDecoration(
          gradient: AppTheme.subjectiveGradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.blueAccent
                : isConnecting
                    ? AppTheme.subjectiveColor.withValues(alpha: 0.8)
                    : Colors.grey.shade400, // 非選択時は目立たないグレー
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
                padding: const EdgeInsets.all(8.0),
                child: showDetail
                    ? Text(
                        node.text,
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xFF2D2D2D), // 常に読みやすい濃い色
                          fontSize: node.fontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : Icon(
                        Icons.square_outlined,
                        color: Colors.grey.shade700,
                        size: 20,
                      ),
              ),
            ),
            // タイプラベル
            Positioned(
              top: 2,
              left: 6,
              child: Text(
                '□ 主観',
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 8,
                ),
              ),
            ),
            // 接続ハンドル（右端）
            Positioned(
              right: -8,
              top: node.height / 2 - 12,
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
