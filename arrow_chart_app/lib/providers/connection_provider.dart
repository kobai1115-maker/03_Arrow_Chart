import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/edge_model.dart';

/// Tap-to-Connect 結線モードの状態
enum ConnectionMode {
  idle,             // 通常モード
  relationSelected, // 結線種類選択済み（ソース待ち）
  sourceSelected,   // ソースノード選択済み（ターゲット待ち）
}

/// 結線モードの状態クラス
class ChartConnectionState {
  final ConnectionMode mode;
  final String? sourceNodeId;
  final EdgeRelation selectedRelation;

  const ChartConnectionState({
    this.mode = ConnectionMode.idle,
    this.sourceNodeId,
    this.selectedRelation = EdgeRelation.causeEffect,
  });

  ChartConnectionState copyWith({
    ConnectionMode? mode,
    String? sourceNodeId,
    EdgeRelation? selectedRelation,
  }) {
    return ChartConnectionState(
      mode: mode ?? this.mode,
      sourceNodeId: sourceNodeId ?? this.sourceNodeId,
      selectedRelation: selectedRelation ?? this.selectedRelation,
    );
  }
}

/// Tap-to-Connect モードの StateNotifier
class ConnectionNotifier extends StateNotifier<ChartConnectionState> {
  ConnectionNotifier() : super(const ChartConnectionState());

  /// 結線種類を選択（手順１）
  void selectRelation(EdgeRelation relation) {
    state = state.copyWith(
      mode: ConnectionMode.relationSelected,
      selectedRelation: relation,
      sourceNodeId: null,
    );
  }

  /// ソースノード選択（手順２）
  void selectSource(String nodeId) {
    state = state.copyWith(
      mode: ConnectionMode.sourceSelected,
      sourceNodeId: nodeId,
    );
  }

  /// 結線タイプのみ変更（バナー内などでの使用を想定）
  void setRelation(EdgeRelation relation) {
    state = state.copyWith(selectedRelation: relation);
  }

  /// 結線完了またはキャンセル → idle に戻す
  void reset() {
    state = const ChartConnectionState();
  }

  /// 結線モード中かどうか（種類またはソースが選択されている）
  bool get isConnecting => state.mode != ConnectionMode.idle;
}

/// 結線モードのプロバイダー
final connectionProvider =
    StateNotifierProvider<ConnectionNotifier, ChartConnectionState>((ref) {
  return ConnectionNotifier();
});
