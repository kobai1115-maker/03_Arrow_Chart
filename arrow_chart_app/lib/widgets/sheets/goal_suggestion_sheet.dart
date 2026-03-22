import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/goal_extraction_service.dart';
import '../../services/llm_service.dart';
import '../../services/settings_service.dart';
import '../../theme/app_theme.dart';

class GoalSuggestionSheet extends ConsumerStatefulWidget {
  final List<GoalCandidate> candidates;
  final VoidCallback? onClose;

  const GoalSuggestionSheet({
    super.key,
    required this.candidates,
    this.onClose,
  });

  @override
  ConsumerState<GoalSuggestionSheet> createState() => _GoalSuggestionSheetState();
}

class _GoalSuggestionSheetState extends ConsumerState<GoalSuggestionSheet> {
  final Map<String, String?> _rewrittenNeeds = {};
  final Map<String, String?> _rewrittenShortGoals = {};
  final Map<String, String?> _rewrittenLongGoals = {};
  final Map<String, bool> _isLoading = {};

  Future<void> _rewriteWithAi(GoalCandidate candidate) async {
    setState(() => _isLoading[candidate.needsNodeId] = true);

    try {
      final apiKey = await ref.read(settingsServiceProvider).getApiKey();
      
      if (apiKey == null || apiKey.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('設定画面でGemini APIキーを設定してください')),
          );
        }
        setState(() => _isLoading[candidate.needsNodeId] = false);
        return;
      }

      final llmService = LlmService(apiKey: apiKey);
      
      final results = await Future.wait([
        llmService.rewriteNeeds(candidate.needs),
        candidate.hasLoop && candidate.loopTexts != null
            ? llmService.inferShortTermGoalFromLoop(candidate.loopTexts!)
            : llmService.rewriteShortTermGoal(candidate.shortTermGoal),
        llmService.rewriteLongTermGoal(candidate.longTermGoal),
      ]);

      setState(() {
        _rewrittenNeeds[candidate.needsNodeId] = results[0];
        _rewrittenShortGoals[candidate.needsNodeId] = results[1];
        _rewrittenLongGoals[candidate.needsNodeId] = results[2];
      });
    } catch (e) {
      debugPrint('AI Rewrite Failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading[candidate.needsNodeId] = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // ハンドル
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // ヘッダー
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: Color(0xFFFAB387), size: 22),
                        const SizedBox(width: 10),
                        const Text(
                          'ケアプラン目標の提案',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: Color(0xFF2D2D2D),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: widget.onClose ?? () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  // 候補一覧
                  Expanded(
                    child: widget.candidates.isEmpty
                        ? _buildEmptyState()
                        : ListView.separated(
                            controller: scrollController,
                            padding: const EdgeInsets.all(20),
                            itemCount: widget.candidates.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 16),
                            itemBuilder: (context, index) => _buildCandidateCard(
                                context, widget.candidates[index]),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 48, color: Colors.grey.shade600),
          const SizedBox(height: 12),
          Text(
            '目標候補が見つかりません',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '□（主観的事実）と○（客観的事実）を\n逆説（⚡）のエッジで接続してください',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCandidateCard(BuildContext context, GoalCandidate candidate) {
    final rewrittenNeeds = _rewrittenNeeds[candidate.needsNodeId];
    final rewrittenShort = _rewrittenShortGoals[candidate.needsNodeId];
    final rewrittenLong = _rewrittenLongGoals[candidate.needsNodeId];
    final loading = _isLoading[candidate.needsNodeId] ?? false;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ニーズ
          _buildGoalSection(
            label: 'ニーズ',
            text: rewrittenNeeds ?? candidate.needs,
            color: const Color(0xFFCBA6F7), // 紫系
            isAi: rewrittenNeeds != null,
          ),
          const SizedBox(height: 16),
          // 長期目標
          _buildGoalSection(
            label: '長期目標',
            text: rewrittenLong ?? candidate.longTermGoal,
            color: AppTheme.objectiveColor,
            isAi: rewrittenLong != null,
          ),
          const SizedBox(height: 16),
          // 短期目標
          _buildGoalSection(
            label: candidate.hasLoop ? '短期目標 (悪循環を解消)' : '短期目標',
            text: rewrittenShort ?? candidate.shortTermGoal,
            color: candidate.hasLoop ? const Color(0xFFE5B3D3) : const Color(0xFF89DCEB), // ループならアクセント色
            isAi: rewrittenShort != null,
          ),
          const SizedBox(height: 16),
          // アクション
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (loading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (rewrittenNeeds == null)
                TextButton.icon(
                  onPressed: () => _rewriteWithAi(candidate),
                  icon: const Icon(Icons.bolt, size: 16),
                  label: const Text('AIで清書'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFB8860B), // ダークゴールデンロッド (落ち着いた黄色)
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              else
                const Row(
                  children: [
                    Icon(Icons.check_circle, color: Color(0xFFA6E3A1), size: 16),
                    SizedBox(width: 4),
                    Text(
                      'AIがリライトしました',
                      style: TextStyle(color: Color(0xFF2E7D32), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSection({
    required String label,
    required String text,
    required Color color,
    bool isAi = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: color.withValues(alpha: 1.0),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            if (isAi) ...[
              const SizedBox(width: 6),
              const Icon(Icons.auto_awesome, size: 12, color: Color(0xFFF9E2AF)),
            ],
          ],
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D2D2D),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
