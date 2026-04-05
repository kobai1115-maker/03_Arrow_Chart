import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../constants/legal_texts.dart';
import '../screens/legal_information_screen.dart';
import '../widgets/credit_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  void _navigateToLegalScreen(BuildContext context, String title, String content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LegalInformationScreen(title: title, content: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF009688),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.teal[800],
              ),
            ),
            accountName: Text(
              user?.email?.split('@').first ?? 'ユーザー',
              style: GoogleFonts.notoSansJp(fontWeight: FontWeight.bold),
            ),
            accountEmail: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user?.email ?? ''),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: authState.isPremium ? Colors.amber : Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    authState.isPremium ? '👑 プレミアム会員' : '⏳ フリープラン',
                    style: TextStyle(
                      fontSize: 10,
                      color: authState.isPremium ? Colors.black87 : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!authState.isPremium)
            ListTile(
              leading: const Icon(Icons.star, color: Colors.amber),
              title: const Text('プレミアムにアップグレード', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('AI機能使い放題 ＆ 保存無制限'),
              onTap: () {
                // TODO: Square決済へ
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('近日公開予定：Square決済システム準備中')),
                );
              },
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('利用規約'),
            onTap: () => _navigateToLegalScreen(context, '利用規約', LegalTexts.termsOfService),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('プライバシーポリシー'),
            onTap: () => _navigateToLegalScreen(context, 'プライバシーポリシー', LegalTexts.privacyPolicy),
          ),
          ListTile(
            leading: const Icon(Icons.gavel_outlined),
            title: const Text('特定商取引法に関する表記'),
            onTap: () => _navigateToLegalScreen(context, '特定商取引法に関する表記', LegalTexts.specifiedCommercialTransactions),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('ログアウト', style: TextStyle(color: Colors.redAccent)),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('ログアウト'),
                  content: const Text('ログアウトしてもよろしいですか？'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('キャンセル')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('ログアウト')),
                  ],
                ),
              );
              if (confirmed == true) {
                await ref.read(authProvider.notifier).signOut();
              }
            },
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(bottom: 32.0),
            child: CreditWidget(isDrawer: true),
          ),
        ],
      ),
    );
  }
}
