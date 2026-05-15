import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/supabase_service.dart';
import 'constants/supabase_constants.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Supabaseの初期化（AnonKey未設定時はオフラインモードで起動）
  if (SupabaseConstants.anonKey.isNotEmpty) {
    try {
      await SupabaseService.initialize();
    } catch (e) {
      debugPrint('⚠️ Supabase初期化失敗（オフラインモードで続行）: $e');
    }
  } else {
    debugPrint('ℹ️ SUPABASE_ANON_KEY未設定のためオフラインモードで起動');
  }
  
  runApp(const ProviderScope(child: ArrowChartApp()));
}

class ArrowChartApp extends StatelessWidget {
  const ArrowChartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '関係性ダイアグラム',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
