import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';
import 'project_list_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _fadeController;
  late Animation<double> _creditOpacity;

  final List<ParticleNode> _nodes = [];
  final List<ParticleEdge> _edges = [];
  final Random _random = Random();

  final List<Color> _themeColors = [
    const Color(0xFF009688), // ティールグリーン
    const Color(0xFF81C784), // ソフトグリーン
    const Color(0xFFA5D6A7), // パステル調淡いグリーン
    const Color(0xFFB2DFDB), // 非常に淡いティール
    const Color(0xFFCEE5D0), // 優しい色合い
  ];

  @override
  void initState() {
    super.initState();

    // 背景のパーティクル用無限ループのアニメーション
    _backgroundController = AnimationController(
       vsync: this,
       duration: const Duration(seconds: 10),
    )..repeat();

    // クレジット表示と画面移行用のアニメーション
    _fadeController = AnimationController(
       vsync: this,
       duration: const Duration(milliseconds: 2500),
    );

    _creditOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    // アニメーション開始
    _fadeController.forward();

    // 初期の図形（ノード）を生成
    _generateInitialParticles();

    // フレーム毎に図形と結線のライフサイクルを監視・更新
    _backgroundController.addListener(_updateParticles);

    // ホーム画面へ遷移 (5秒後)
    Future.delayed(const Duration(milliseconds: 5000), () {
      if (!mounted) return;
      
      final authState = ref.read(authProvider);
      
      // ユーザーがいない場合はログイン画面、いる場合はリスト画面へ
      final Widget nextScreen = authState.user == null 
          ? const LoginScreen() 
          : const ProjectListScreen();

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1200),
          pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  void _generateInitialParticles() {
    for (int i = 0; i < 6; i++) {
        _addRandomNode();
    }
  }

  void _addRandomNode() {
    final node = ParticleNode(
      position: Offset(0.1 + _random.nextDouble() * 0.8, 0.1 + _random.nextDouble() * 0.7),
      isCircle: _random.nextBool(),
      color: _themeColors[_random.nextInt(_themeColors.length)],
      radius: 12.0 + _random.nextDouble() * 18.0,
      createdAt: DateTime.now(),
      lifeSpan: Duration(milliseconds: 3000 + _random.nextInt(4000)),
    );
    _nodes.add(node);

    // 既存のノードが存在する場合にランダムで結線する
    if (_nodes.length > 1 && _random.nextDouble() > 0.3) {
      final otherNode = _nodes[_random.nextInt(_nodes.length - 1)];
      _edges.add(
        ParticleEdge(
          startNode: otherNode,
          endNode: node,
          type: EdgeType.values[_random.nextInt(EdgeType.values.length)],
          color: node.color,
          createdAt: DateTime.now(),
          lifeSpan: node.lifeSpan,
        )
      );
    }
  }

  void _updateParticles() {
    final now = DateTime.now();
    bool changed = false;

    // 寿命を過ぎたエッジを削除
    _edges.removeWhere((edge) {
       final age = now.difference(edge.createdAt);
       return age > edge.lifeSpan;
    });

    // 寿命を過ぎたノードを削除
    _nodes.removeWhere((node) {
      final age = now.difference(node.createdAt);
      if (age > node.lifeSpan) {
        changed = true;
        return true;
      }
      return false;
    });

    // 古いものが消えたらランダムで新しいものを補充
    if (_nodes.length < 10 && _random.nextDouble() > 0.95) {
       _addRandomNode();
       changed = true;
    }

    if (changed || mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // タイトルのフェードイン（前半 0〜60%）
    final titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    // タイトルのスライドアップ
    final titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFB), // 目に優しいクリーンな背景
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 背景：ジェネレーティブ・アニメーション（パーティクルとパス）
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return CustomPaint(
                painter: GenerativeBackgroundPainter(
                  nodes: _nodes,
                  edges: _edges,
                  time: DateTime.now(),
                ),
              );
            },
          ),

          // 上部のグラデーション：パーティクルが少し奥にあるような奥行き感を演出
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.0),
                  const Color(0xFFF9FBFB).withValues(alpha: 0.85),
                ],
                radius: 1.2,
              ),
            ),
          ),

          // 中央：アプリタイトルのアニメーション表示
          Center(
            child: AnimatedBuilder(
              animation: _fadeController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: titleOpacity,
                  child: SlideTransition(
                    position: titleSlide,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // アクセントライン（上）
                        Container(
                          width: 40,
                          height: 2,
                          decoration: BoxDecoration(
                            color: const Color(0xFF009688),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // メインタイトル
                        Text(
                          '関係性ダイアグラム',
                          style: GoogleFonts.notoSansJp(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A3C34),
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // サブタイトル（英語）
                        Text(
                          'Relationship Diagram',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF009688),
                            letterSpacing: 3.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // アクセントライン（下）
                        Container(
                          width: 40,
                          height: 2,
                          decoration: BoxDecoration(
                            color: const Color(0xFF009688),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 前面：クレジット表示（画面下部）
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: AnimatedBuilder(
                animation: _creditOpacity,
                builder: (context, child) {
                  return Opacity(
                    opacity: _creditOpacity.value,
                    child: const CreditWidget(isDrawer: false),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum EdgeType { arrow, zigzag, straight }

class ParticleNode {
  final Offset position;
  final bool isCircle; // true: ○(客観的事実), false: □(主観的事実)
  final Color color;
  final double radius;
  final DateTime createdAt;
  final Duration lifeSpan;

  ParticleNode({
    required this.position,
    required this.isCircle,
    required this.color,
    required this.radius,
    required this.createdAt,
    required this.lifeSpan,
  });
}

class ParticleEdge {
  final ParticleNode startNode;
  final ParticleNode endNode;
  final EdgeType type; // 順接の矢印, 逆説の波線, 意味づけの直線
  final Color color;
  final DateTime createdAt;
  final Duration lifeSpan;

  ParticleEdge({
    required this.startNode,
    required this.endNode,
    required this.type,
    required this.color,
    required this.createdAt,
    required this.lifeSpan,
  });
}

class GenerativeBackgroundPainter extends CustomPainter {
  final List<ParticleNode> nodes;
  final List<ParticleEdge> edges;
  final DateTime time;

  GenerativeBackgroundPainter({
    required this.nodes,
    required this.edges,
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 結線を先に描き、その上にノードを描画する
    for (final edge in edges) {
      _drawEdge(canvas, size, edge);
    }
    for (final node in nodes) {
      _drawNode(canvas, size, node);
    }
  }

  void _drawNode(Canvas canvas, Size size, ParticleNode node) {
    final age = time.difference(node.createdAt).inMilliseconds;
    final lifeSpan = node.lifeSpan.inMilliseconds;
    final progress = age / lifeSpan;

    if (progress > 1.0 || progress < 0.0) return;

    // フェードイン＆フェードアウト (Curves.easeInOut)
    double opacity = 1.0;
    if (progress < 0.2) {
      opacity = Curves.easeInOut.transform(progress / 0.2);
    } else if (progress > 0.8) {
      opacity = Curves.easeInOut.transform((1.0 - progress) / 0.2);
    }

    final paint = Paint()
      ..color = node.color.withValues(alpha: opacity * 0.8)
      ..style = PaintingStyle.fill;

    // フワフワと漂う動き
    final offsetX = sin(progress * pi * 2) * 15.0;
    final offsetY = cos(progress * pi * 2) * 15.0;
    
    final x = node.position.dx * size.width + offsetX;
    final y = node.position.dy * size.height + offsetY;
    final center = Offset(x, y);

    if (node.isCircle) {
      // 客観的事実（○）
      canvas.drawCircle(center, node.radius, paint);
    } else {
      // 主観的事実（□）
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: center, width: node.radius * 2.2, height: node.radius * 2.2),
          const Radius.circular(4.0) // 少し角を丸く
        ),
        paint,
      );
    }
  }

  void _drawEdge(Canvas canvas, Size size, ParticleEdge edge) {
    final age = time.difference(edge.createdAt).inMilliseconds;
    final lifeSpan = edge.lifeSpan.inMilliseconds;
    final progress = age / lifeSpan;

    if (progress > 1.0 || progress < 0.0) return;

    // 全体的な透明度
    double fadeOpacity = 1.0;
    if (progress < 0.2) {
      fadeOpacity = Curves.easeInOut.transform(progress / 0.2);
    } else if (progress > 0.8) {
      fadeOpacity = Curves.easeInOut.transform((1.0 - progress) / 0.2);
    }

    final paint = Paint()
      ..color = edge.color.withValues(alpha: fadeOpacity * 0.7)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 接続先ノードの現在の揺らぎ位置を計算
    final startAge = time.difference(edge.startNode.createdAt).inMilliseconds;
    final endAge = time.difference(edge.endNode.createdAt).inMilliseconds;
    final startProg = startAge / edge.startNode.lifeSpan.inMilliseconds;
    final endProg = endAge / edge.endNode.lifeSpan.inMilliseconds;

    final startOffset = Offset(
      sin(startProg * pi * 2) * 15.0,
      cos(startProg * pi * 2) * 15.0,
    );
    final endOffset = Offset(
      sin(endProg * pi * 2) * 15.0,
      cos(endProg * pi * 2) * 15.0,
    );

    final start = Offset(
      edge.startNode.position.dx * size.width,
      edge.startNode.position.dy * size.height,
    ) + startOffset;

    final targetEnd = Offset(
      edge.endNode.position.dx * size.width,
      edge.endNode.position.dy * size.height,
    ) + endOffset;

    // スッと線が伸びるアニメーション効果
    double drawProgress = 1.0;
    if (progress < 0.3) {
      drawProgress = Curves.easeInOut.transform(progress / 0.3);
    }

    final end = Offset.lerp(start, targetEnd, drawProgress)!;
    final path = Path();
    path.moveTo(start.dx, start.dy);

    if (edge.type == EdgeType.straight) {
      // 意味づけの直線
      path.lineTo(end.dx, end.dy);
      canvas.drawPath(path, paint);
    } else if (edge.type == EdgeType.arrow) {
      // 順接の矢印
      path.lineTo(end.dx, end.dy);
      canvas.drawPath(path, paint);
      
      if (drawProgress > 0.1) {
        final angle = atan2(end.dy - start.dy, end.dx - start.dx);
        final headLen = 12.0;
        final arrowPath = Path();
        arrowPath.moveTo(end.dx, end.dy);
        arrowPath.lineTo(
          end.dx - headLen * cos(angle - pi / 6),
          end.dy - headLen * sin(angle - pi / 6),
        );
        arrowPath.moveTo(end.dx, end.dy);
        arrowPath.lineTo(
          end.dx - headLen * cos(angle + pi / 6),
          end.dy - headLen * sin(angle + pi / 6),
        );
        canvas.drawPath(arrowPath, paint);
      }
    } else if (edge.type == EdgeType.zigzag) {
      // 逆説の波線（直線上に山ふたつ、谷ふたつ）
      path.lineTo(end.dx, end.dy);
      canvas.drawPath(path, paint);

      final dist = (end - start).distance;
      if (dist >= 5) {
        final direction = (end - start) / dist;
        final normal = Offset(-direction.dy, direction.dx);
        final center = start + direction * (dist / 2);

        final zWidth = min(60.0, dist);
        final amplitude = 14.0 * (zWidth / 60.0);
        final zStart = center - direction * (zWidth / 2);
        
        final step = zWidth / 8;
        
        final zigzagPath = Path();
        zigzagPath.moveTo(zStart.dx, zStart.dy);
        
        // 1. 最初の山 (Peak 1 UP)
        zigzagPath.lineTo(zStart.dx + direction.dx * (step * 1) + normal.dx * amplitude,
                    zStart.dy + direction.dy * (step * 1) + normal.dy * amplitude);
        // 2. 最初の谷 (Peak 1 DOWN)
        zigzagPath.lineTo(zStart.dx + direction.dx * (step * 3) - normal.dx * amplitude,
                    zStart.dy + direction.dy * (step * 3) - normal.dy * amplitude);
        // 3. 次の山 (Peak 2 UP)
        zigzagPath.lineTo(zStart.dx + direction.dx * (step * 5) + normal.dx * amplitude,
                    zStart.dy + direction.dy * (step * 5) + normal.dy * amplitude);
        // 4. 次の谷 (Peak 2 DOWN)
        zigzagPath.lineTo(zStart.dx + direction.dx * (step * 7) - normal.dx * amplitude,
                    zStart.dy + direction.dy * (step * 7) - normal.dy * amplitude);
        
        final zEnd = center + direction * (zWidth / 2);
        zigzagPath.lineTo(zEnd.dx, zEnd.dy);

        canvas.drawPath(zigzagPath, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant GenerativeBackgroundPainter oldDelegate) => true;
}

class CreditWidget extends StatelessWidget {
  final bool isDrawer;
  const CreditWidget({super.key, this.isDrawer = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCreditItem(
          'Methodology by',
          '吉島 豊録',
          '(Toyoroku Yoshijima) - 関係性ダイアグラムメソッド考案・著作者',
          isDrawer,
        ),
        SizedBox(height: isDrawer ? 16 : 24),
        _buildCreditItem(
          'App Developed by',
          'AXLINK',
          '',
          isDrawer,
        ),
      ],
    );
  }

  Widget _buildCreditItem(String label, String name, String description, bool isDrawer) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: isDrawer ? 9 : 10,
            color: Colors.grey[400],
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          name,
          style: GoogleFonts.notoSansJp(
            fontSize: isDrawer ? 16 : 18,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (description.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansJp(
              fontSize: isDrawer ? 8 : 10,
              color: Colors.grey[500],
            ),
          ),
        ],
      ],
    );
  }
}
