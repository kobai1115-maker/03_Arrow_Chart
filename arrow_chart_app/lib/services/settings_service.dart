import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsService {
  static const _keyGeminiApiKey = 'gemini_api_key';
  static const _keyEnterToSubmit = 'enter_to_submit';

  Future<void> saveApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyGeminiApiKey, apiKey);
  }

  Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyGeminiApiKey);
  }

  Future<void> saveEnterToSubmit(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEnterToSubmit, value);
  }

  Future<bool> getEnterToSubmit() async {
    final prefs = await SharedPreferences.getInstance();
    // デフォルトはfalse（Enterで改行、Shift+Enterで確定）
    return prefs.getBool(_keyEnterToSubmit) ?? false;
  }
}

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService();
});

final geminiApiKeyProvider = FutureProvider<String?>((ref) {
  final service = ref.watch(settingsServiceProvider);
  return service.getApiKey();
});

// 設定値を同期的に扱うためのStateNotifier（ローディングなども管理）
class EnterToSubmitNotifier extends StateNotifier<bool> {
  final SettingsService service;

  EnterToSubmitNotifier(this.service) : super(false) {
    _load();
  }

  Future<void> _load() async {
    state = await service.getEnterToSubmit();
  }

  Future<void> setEnterToSubmit(bool value) async {
    await service.saveEnterToSubmit(value);
    state = value;
  }
}

final enterToSubmitProvider = StateNotifierProvider<EnterToSubmitNotifier, bool>((ref) {
  final service = ref.watch(settingsServiceProvider);
  return EnterToSubmitNotifier(service);
});

