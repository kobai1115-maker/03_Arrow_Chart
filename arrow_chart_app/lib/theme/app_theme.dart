import 'package:flutter/material.dart';

/// アプリ全体のテーマ定義
class AppTheme {
  // 医療・介護現場向けの目に優しいカラーパレット (Teal & Soft Green)
  static const _primaryColor = Color(0xFF00796B); // 落ち着いたティールグリーン
  static const _secondaryColor = Color(0xFF4DB6AC); // 柔らかいティール
  
  // 背景色: まぶしさを抑えたクリーンなウォームグレー
  static const _backgroundColor = Color(0xFFF7F9FA);
  static const _surfaceColor = Colors.white;
  static const _cardColor = Colors.white;

  // ノードのカラー: 医療現場で安心感を与えるパステルカラー
  static const subjectiveColor = Color(0xFFFFF0F5); // ほんのり温かいラベンダー/ピンク (主観)
  static const objectiveColor = Color(0xFFE3F2FD);  // クリーンなライトブルー (客観)
  
  // 線のカラー: 視認性が高く、かつ強すぎないブルーグレー
  static const causeEffectEdgeColor = Color(0xFF78909C); 
  static const paradoxEdgeColor = Color(0xFF78909C); 
  static const connectionEdgeColor = Color(0xFF78909C);

  // テキストカラー: 真っ黒を避け、コントラストを保ったチャコールグレー
  static const _textColor = Color(0xFF374151);

  static const subjectiveGradient = LinearGradient(
    colors: [subjectiveColor, subjectiveColor],
  );

  static const objectiveGradient = LinearGradient(
    colors: [objectiveColor, objectiveColor],
  );

  static const paradoxGradient = LinearGradient(
    colors: [paradoxEdgeColor, paradoxEdgeColor],
  );

  // 滑らかで広がりのあるシャドウ (Material 3に近い立体感)
  static List<BoxShadow> get premiumShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light, 
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        primary: _primaryColor,
        secondary: _secondaryColor,
        brightness: Brightness.light,
        surface: _surfaceColor,
        onSurface: _textColor,
      ),
      scaffoldBackgroundColor: _backgroundColor,
      cardColor: _cardColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1, // スクロール時にわずかな影
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: _textColor,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: _textColor),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _textColor,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _backgroundColor,
        selectedColor: _primaryColor.withOpacity(0.1),
        labelStyle: const TextStyle(color: _textColor),
        side: BorderSide(color: _primaryColor.withOpacity(0.2)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
