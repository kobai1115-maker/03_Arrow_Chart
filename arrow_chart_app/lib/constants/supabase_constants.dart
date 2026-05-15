/// Supabaseに関する定数
///
/// ビルド時に以下の環境変数で値を注入する:
///   flutter run --dart-define=SUPABASE_URL=https://xxx.supabase.co
///   flutter run --dart-define=SUPABASE_ANON_KEY=your_anon_key
///
/// 環境変数が未設定の場合はデフォルト値（開発用）を使用する。
/// ⚠️ 本番デプロイ時は必ず --dart-define で注入すること。
class SupabaseConstants {
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://sxwyshpplazqvpjymaqf.supabase.co',
  );
  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',  // 本番では必ず --dart-define で注入
  );
}
