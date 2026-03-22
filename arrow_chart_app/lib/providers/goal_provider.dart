import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/goal_extraction_service.dart';
import 'diagram_provider.dart';

/// 目標抽出のプロバイダー
final goalExtractionProvider = Provider<GoalExtractionService>((ref) {
  return GoalExtractionService();
});

/// ダイアグラムの現在状態から目標候補を抽出するプロバイダー
final goalCandidatesProvider = Provider<List<GoalCandidate>>((ref) {
  final diagram = ref.watch(diagramProvider);
  final service = ref.read(goalExtractionProvider);
  return service.extractGoals(diagram);
});
