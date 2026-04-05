import 'package:flutter/material.dart';
import '../constants/legal_texts.dart';
import '../screens/legal_information_screen.dart';
import '../screens/splash_screen.dart';

class AppDrawer extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
            child: Center(
              child: Text(
                '関係性ダイアグラム',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('情報'),
            onTap: () {},
          ),
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
