import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/supabase_constants.dart';

/// Supabase 連携サービス
class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  /// 初期化
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConstants.url,
      anonKey: SupabaseConstants.anonKey,
    );
  }

  // --- Auth 関連 ---

  /// サインアップ
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
    );
  }

  /// ログイン
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// ログアウト
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  /// 現在のセッション取得
  Session? get currentSession => client.auth.currentSession;

  /// 現在のユーザー取得
  User? get currentUser => client.auth.currentUser;

  // --- Profile / Subscription 関連 ---

  /// ユーザープロファイルの取得
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final data = await client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return data;
    } catch (e) {
      return null;
    }
  }

  /// プレミアムステータスの確認
  Future<bool> isPremium(String userId) async {
    final profile = await getUserProfile(userId);
    if (profile == null) return false;
    return profile['is_premium'] == true;
  }
}
