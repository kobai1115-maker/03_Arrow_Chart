import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/node_model.dart';
import '../../models/edge_model.dart';
import '../../theme/app_theme.dart';

/// エッジ描画用の CustomPainter
/// 3種類のエッジ（順接矢印・逆説ギザギザ・単純接続）を描画
class EdgePainter extends CustomPainter {
  final List<ChartEdge> edges;
  final List<ChartNode> nodes;
  final String? selectedEdgeId;

  EdgePainter({
    required this.edges,
    required this.nodes,
    this.selectedEdgeId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final edge in edges) {
      final source = _findNode(edge.sourceId);
      final target = _findNode(edge.targetId);
      if (source == null || target == null) continue;

      final start = _getEdgePoint(source, target.center);
      final end = _getEdgePoint(target, source.center);

      final isSelected = edge.id == selectedEdgeId;

      // 選択ハイライト描画
      if (isSelected) {
        final highlightPaint = Paint()
          ..color = AppTheme.paradoxEdgeColor.withValues(alpha: 0.7)
          ..strokeWidth = 48.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
        
        // 常に直線部分はハイライト
        canvas.drawLine(start, end, highlightPaint);

        if (edge.relation == EdgeRelation.paradox) {
          // 逆説の場合はギザギザ部分もハイライト（中点ノードならそこを中心に）
          final targetNode = _findNode(edge.targetId);
          canvas.drawPath(
            _buildZigzagPath(start, end,
                fixedCenter: (targetNode?.type == NodeType.midpoint) ? targetNode!.center : null),
            highlightPaint
          );
        }

        // 意味づけ・逆説の場合は中点ハンドルを描画
        if (edge.relation == EdgeRelation.paradox || edge.relation == EdgeRelation.connection) {
          final midPoint = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
          
          final handlePaintBg = Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill;
          final handlePaintBorder = Paint()
            ..color = AppTheme.paradoxEdgeColor
            ..strokeWidth = 2.0
            ..style = PaintingStyle.stroke;
          
          // 半径16の円
          canvas.drawCircle(midPoint, 16.0, handlePaintBg);
          canvas.drawCircle(midPoint, 16.0, handlePaintBorder);

          // '+' アイコンをパスで描画
          final plusPaint = Paint()
            ..color = AppTheme.paradoxEdgeColor
            ..strokeWidth = 3.0
            ..strokeCap = StrokeCap.round;
          
          canvas.drawLine(
            Offset(midPoint.dx - 8, midPoint.dy),
            Offset(midPoint.dx + 8, midPoint.dy),
            plusPaint,
          );
          canvas.drawLine(
            Offset(midPoint.dx, midPoint.dy - 8),
            Offset(midPoint.dx, midPoint.dy + 8),
            plusPaint,
          );
        }
      }

      switch (edge.relation) {
        case EdgeRelation.causeEffect:
          _drawArrow(canvas, start, end);
          break;
        case EdgeRelation.paradox:
          final sourceNode = _findNode(edge.sourceId);
          final targetNode = _findNode(edge.targetId);
          
          if (targetNode?.type == NodeType.midpoint) {
            // 中点ノードへ向かうエッジ：終端(中点)そのものにギザギザを描画
            _drawZigzag(canvas, start, end, fixedCenter: targetNode!.center);
          } else if (sourceNode?.type == NodeType.midpoint) {
            // 中点ノードから出るエッジ：もう片方のエッジが描画しているので、ここでは直線のみ
            _drawSimpleLine(canvas, start, end);
          } else {
            // 通常のエッジ：中心にギザギザを描画
            _drawZigzag(canvas, start, end);
          }
          break;
        case EdgeRelation.connection:
          _drawSimpleLine(canvas, start, end);
          break;
      }
    }
  }

  ChartNode? _findNode(String id) {
    try {
      return nodes.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 順接矢印（→）の描画
  void _drawArrow(Canvas canvas, Offset start, Offset end) {
    final paint = Paint()
      ..color = AppTheme.causeEffectEdgeColor
      ..strokeWidth = 6.5 // さらに太く（5.5 -> 6.5）
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 直線
    canvas.drawLine(start, end, paint);

    // 矢頭
    _drawArrowHead(canvas, start, end, AppTheme.causeEffectEdgeColor);
  }

  void _drawZigzag(Canvas canvas, Offset start, Offset end, {Offset? fixedCenter}) {
    final paint = Paint()
      ..color = AppTheme.paradoxEdgeColor
      ..strokeWidth = 6.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 1. 常に直線を基礎として描画
    canvas.drawLine(start, end, paint);

    // 2. ギザギザ装飾を重ねる（中点指定があればそこを中心にする）
    final zigzagPath = _buildZigzagPath(start, end, fixedCenter: fixedCenter);
    canvas.drawPath(zigzagPath, paint);
  }

  /// 単純接続直線（─）の描画
  void _drawSimpleLine(Canvas canvas, Offset start, Offset end) {
    final paint = Paint()
      ..color = AppTheme.connectionEdgeColor
      ..strokeWidth = 5.5 // さらに太く（4.5 -> 5.5）
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(start, end, paint);
  }

  /// 矢頭の描画
  void _drawArrowHead(
      Canvas canvas, Offset from, Offset to, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const arrowSize = 20.0; // さらに大きく（16.0 -> 20.0）
    final angle = atan2(to.dy - from.dy, to.dx - from.dx);

    final path = Path()
      ..moveTo(to.dx, to.dy)
      ..lineTo(
        to.dx - arrowSize * cos(angle - pi / 6),
        to.dy - arrowSize * sin(angle - pi / 6),
      )
      ..lineTo(
        to.dx - arrowSize * cos(angle + pi / 6),
        to.dy - arrowSize * sin(angle + pi / 6),
      )
      ..close();

    canvas.drawPath(path, paint);
  }

  /// ギザギザ装飾パスを生成。fixedCenterが指定されればそこを中心に描画。
  Path _buildZigzagPath(Offset start, Offset end, {Offset? fixedCenter}) {
    final path = Path();
    final distance = (end - start).distance;
    
    // 距離が極端に短い場合は描かない
    if (distance < 5) return path;

    final direction = (end - start) / distance;
    final normal = Offset(-direction.dy, direction.dx);
    
    // ユーザー要望：山ふたつ谷ふたつ
    const zigzagWidth = 60.0; 
    const amplitude = 14.0;

    // 特定の中心点（中点ノード）が指定されていればそれを使用し、なければ線の中央を使用
    final center = fixedCenter ?? (start + direction * (distance / 2));
    final zStart = center - direction * (zigzagWidth / 2);

    // ギザギザ装飾開始点
    path.moveTo(zStart.dx, zStart.dy);

    // 8ステップで 山(UP) -> 谷(DOWN) -> 山(UP) -> 谷(DOWN) となるように頂点を結ぶ
    final step = zigzagWidth / 8;
    
    // 1. 最初の山 (Peak 1 UP)
    path.lineTo(zStart.dx + direction.dx * (step * 1) + normal.dx * amplitude,
                zStart.dy + direction.dy * (step * 1) + normal.dy * amplitude);
    // 2. 最初の谷 (Peak 1 DOWN)
    path.lineTo(zStart.dx + direction.dx * (step * 3) - normal.dx * amplitude,
                zStart.dy + direction.dy * (step * 3) - normal.dy * amplitude);
    // 3. 次の山 (Peak 2 UP)
    path.lineTo(zStart.dx + direction.dx * (step * 5) + normal.dx * amplitude,
                zStart.dy + direction.dy * (step * 5) + normal.dy * amplitude);
    // 4. 次の谷 (Peak 2 DOWN)
    path.lineTo(zStart.dx + direction.dx * (step * 7) - normal.dx * amplitude,
                zStart.dy + direction.dy * (step * 7) - normal.dy * amplitude);

    // ギザギザ装飾終了点
    final zEnd = center + direction * (zigzagWidth / 2);
    path.lineTo(zEnd.dx, zEnd.dy);

    return path;
  }

  /// ノードの境界線上の接続点を算出
  Offset _getEdgePoint(ChartNode node, Offset otherCenter) {
    // 中点（分岐点）の場合は、記号の中心点に直接接続させる（途切れないようにする）
    if (node.type == NodeType.midpoint) {
      return node.center;
    }

    final center = node.center;
    final dx = otherCenter.dx - center.dx;
    final dy = otherCenter.dy - center.dy;

    if (dx == 0 && dy == 0) return center;

    if (node.type == NodeType.objective) {
      // 楕円（Ellipse）ノードの場合の交点計算
      final a = node.width / 2; // X軸半径
      final b = node.height / 2; // Y軸半径
      
      final distance = sqrt(dx * dx + dy * dy);
      final ux = dx / distance;
      final uy = dy / distance;
      
      final t = 1 / sqrt(pow(ux / a, 2) + pow(uy / b, 2));
      
      return Offset(
        center.dx + ux * t,
        center.dy + uy * t,
      );
    } else {
      // 矩形ノードの場合
      final halfW = node.width / 2;
      final halfH = node.height / 2;

      final scaleX = dx.abs() > 0 ? halfW / dx.abs() : double.infinity;
      final scaleY = dy.abs() > 0 ? halfH / dy.abs() : double.infinity;
      
      final scale = min(scaleX, scaleY);

      return Offset(
        center.dx + dx * scale,
        center.dy + dy * scale,
      );
    }
  }

  @override
  bool shouldRepaint(covariant EdgePainter oldDelegate) => true;

  /// 指定された位置にエッジがあるかチェックする（当たり判定）
  ChartEdge? findEdgeAt(Offset position, double threshold) {
    for (final edge in edges) {
      final source = _findNode(edge.sourceId);
      final target = _findNode(edge.targetId);
      if (source == null || target == null) continue;

      final start = _getEdgePoint(source, target.center);
      final end = _getEdgePoint(target, source.center);

      // 1. まず直線部分での当たり判定（全ての線種に共通）
      final linePath = Path()
        ..moveTo(start.dx, start.dy)
        ..lineTo(end.dx, end.dy);
      
      if (_isPointNearPath(position, linePath, threshold)) {
        return edge;
      }

      // 2. 逆説（ギザギザ）の場合、山/谷の部分での判定も追加
      if (edge.relation == EdgeRelation.paradox) {
        final targetNode = _findNode(edge.targetId);
        final zigzagPath = _buildZigzagPath(start, end,
            fixedCenter: (targetNode?.type == NodeType.midpoint) ? targetNode!.center : null);
        if (_isPointNearPath(position, zigzagPath, threshold)) {
          return edge;
        }
      }
    }
    return null;
  }

  bool _isPointNearPath(Offset p, Path path, double threshold) {
    for (final metric in path.computeMetrics()) {
      const samplingRate = 3.0; // より細かくサンプリング (4.0 -> 3.0)
      for (var d = 0.0; d < metric.length; d += samplingRate) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent != null) {
          final distance = (tangent.position - p).distance;
          if (distance <= threshold) return true;
        }
      }
    }
    return false;
  }
}
