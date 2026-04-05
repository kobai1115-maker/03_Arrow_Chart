import 'dart:ui';
import 'package:flutter/material.dart';
import '../../services/llm_service.dart';

class CarePlanProposalSheet extends StatelessWidget {
  final CarePlanProposal proposal;

  const CarePlanProposalSheet({
    super.key,
    required this.proposal,
  });

  @override
  Widget build(BuildContext context) {
    final hasLoop = proposal.hasLoop;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border.all(color: Colors.black.withOpacity(0.05)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: Color(0xFFFAB387), size: 24),
                        const SizedBox(width: 10),
                        const Text(
                          'AIケアプラン提案',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: Color(0xFF2D2D2D),
                          ),
                        ),
                        if (hasLoop) ...[
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFCC80).withOpacity(0.3), // 薄いオレンジ
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFFF9800)), // オレンジ
                            ),
                            child: const Text(
                              '悪循環検知',
                              style: TextStyle(
                                color: Color(0xFFE65100), // 濃いオレンジ
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  // Content
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      children: [
                        _buildSection(
                          icon: Icons.favorite,
                          title: 'ニーズ',
                          content: proposal.needs,
                          color: const Color(0xFFCBA6F7), // 紫系
                        ),
                        const SizedBox(height: 20),
                        _buildSection(
                          icon: Icons.flag,
                          title: '長期目標',
                          content: proposal.longTermGoal,
                          color: const Color(0xFF81C784), // 緑系
                        ),
                        const SizedBox(height: 20),
                        _buildSection(
                          icon: Icons.track_changes,
                          title: '短期目標',
                          content: proposal.shortTermGoal,
                          color: hasLoop ? const Color(0xFFFF9800) : const Color(0xFF89DCEB), // アラート時オレンジ
                        ),
                        const SizedBox(height: 20),
                        if (proposal.loopAdvice != null && proposal.loopAdvice!.isNotEmpty) ...[
                          _buildSection(
                            icon: Icons.warning_amber_rounded,
                            title: 'AIからの助言（悪循環の断ち切り方）',
                            content: proposal.loopAdvice!,
                            color: const Color(0xFFFF5722), // 濃いオレンジ
                          ),
                          const SizedBox(height: 20),
                        ],
                        _buildSection(
                          icon: Icons.list_alt,
                          title: 'ケア指針 (アセスメント項目)',
                          content: proposal.careGuidelines,
                          color: const Color(0xFFF28FAD), // ピンク系
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D2D2D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4A4A4A),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
