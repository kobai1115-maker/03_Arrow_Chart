import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 認証状態を表すクラス
class AppAuthState {
  final User? user;
  final bool isPremium;
  final bool isLoading;
  final String? errorMessage;

  AppAuthState({
    this.user,
    this.isPremium = false,
    this.isLoading = false,
    this.errorMessage,
  });

  AppAuthState copyWith({
    User? user,
    bool? isPremium,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AppAuthState(
      user: user ?? this.user,
      isPremium: isPremium ?? this.isPremium,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// 認証状態を管理するNotifier
class AuthNotifier extends StateNotifier<AppAuthState> {
  final SupabaseService _supabase = SupabaseService();

  AuthNotifier() : super(AppAuthState(isLoading: true)) {
    _init();
  }

  void _init() async {
    final user = _supabase.currentUser;
    if (user != null) {
      // 初期化時に既にログインしている場合
      state = AppAuthState(user: user, isLoading: false);
      _updatePremiumStatus(user.id);
    } else {
      state = AppAuthState(isLoading: false);
    }

    // 認証状態の変更を監視
    _supabase.client.auth.onAuthStateChange.listen((data) async {
      final user = data.session?.user;
      if (user != null) {
        // 1. まずはログイン中として即座に通知（これで画面が切り替わる）
        state = state.copyWith(user: user, isLoading: false, errorMessage: null);
        
        // 2. 裏でプレミアム情報を確認して更新する
        _updatePremiumStatus(user.id);
      } else {
        state = AppAuthState(isLoading: false);
      }
    });
  }

  /// プレミアムステータスを非同期で更新
  Future<void> _updatePremiumStatus(String userId) async {
    try {
      // タイムアウトを設定して、DBが遅くても3秒で切り上げる
      final isPremium = await _supabase.isPremium(userId).timeout(
        const Duration(seconds: 3),
        onTimeout: () => false,
      );
      state = state.copyWith(isPremium: isPremium);
    } catch (_) {
      // 失敗しても無料会員として続行
      state = state.copyWith(isPremium: false);
    }
  }

  /// ログイン
  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _supabase.signIn(email: email, password: password);
      // 成功時、onAuthStateChange で isLoading: false になります
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'ログインに失敗しました: $e');
    }
  }

  /// サインアップ
  Future<void> signUp(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _supabase.signUp(email: email, password: password);
      
      if (response.session == null && response.user != null) {
        // メール認証が必要な設定になっている場合
        state = state.copyWith(
          isLoading: false, 
          errorMessage: '確認メールを送信しました。メールボックスを確認してください。'
        );
      } else {
        // すぐにログインできた場合
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '登録に失敗しました: $e');
    }
  }

  /// ログアウト
  Future<void> signOut() async {
    await _supabase.signOut();
  }
}

/// 認証状態のProvider
final authProvider = StateNotifierProvider<AuthNotifier, AppAuthState>((ref) {
  return AuthNotifier();
});
