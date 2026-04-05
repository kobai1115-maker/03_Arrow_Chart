import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/settings_service.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _apiKeyController;

  @override
  void initState() {
    super.initState();
    _apiKeyController = TextEditingController();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final apiKey = await ref.read(settingsServiceProvider).getApiKey();
    if (apiKey != null) {
      _apiKeyController.text = apiKey;
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _saveApiKey() async {
    await ref.read(settingsServiceProvider).saveApiKey(_apiKeyController.text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('設定を保存しました')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isDeveloper = authState.role == 'developer' || authState.role == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (isDeveloper) ...[
            const Text(
              'AI目標提案の設定',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Gemini APIキーを入力してください。目標文の自動リライト機能に使用されます。',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: 'Gemini API Key',
                hintText: 'AIza...',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _saveApiKey,
              icon: const Icon(Icons.save),
              label: const Text('APIキーを保存して戻る'),
            ),
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 20),
          ],
          const Text(
            '操作設定',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('ノード編集ダイアログの入力確定'),
            subtitle: Text(
              ref.watch(enterToSubmitProvider) 
                ? 'Enterで確定 (Shift+Enterで改行)' 
                : 'Shift+Enterで確定 (Enterで改行)',
            ),
            value: ref.watch(enterToSubmitProvider),
            onChanged: (value) async {
              await ref.read(enterToSubmitProvider.notifier).setEnterToSubmit(value);
            },
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 40),
          const Divider(),
          const SizedBox(height: 20),
          const Text(
            'アプリについて',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Arrow Chart App v1.0.0\nケアマネジャーの業務をAIで強力にサポートします。',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
