import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
