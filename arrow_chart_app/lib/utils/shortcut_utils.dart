import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

class ShortcutUtils {
  /// macOS (またはmacOS上のWeb) かどうかを判定
  static bool get isAppleOS {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.iOS:
        return true;
      default:
        return false;
    }
  }

  /// OSに応じたメイン修飾キー（Windows/Linux: Ctrl, macOS: Cmd）付きの Activator を生成
  /// [LogicalKeySet] ではなく、必ず [SingleActivator] を使用する
  static SingleActivator getModifierActivator(LogicalKeyboardKey key, {bool shift = false}) {
    return SingleActivator(
      key,
      control: !isAppleOS,
      meta: isAppleOS,
      shift: shift,
    );
  }
}
