import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreditWidget extends StatelessWidget {
  final bool isDrawer;
  const CreditWidget({super.key, this.isDrawer = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCreditItem(
          'Methodology by',
          '吉島 豊録',
          '(Toyoroku Yoshijima) - 関係性ダイアグラムメソッド考案・著作者',
          isDrawer,
        ),
        SizedBox(height: isDrawer ? 16 : 24),
        _buildCreditItem(
          'App Developed by',
          'AXLINK',
          '',
          isDrawer,
        ),
      ],
    );
  }

  Widget _buildCreditItem(String label, String name, String description, bool isDrawer) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: isDrawer ? 9 : 10,
            color: Colors.grey[400],
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          name,
          style: GoogleFonts.notoSansJp(
            fontSize: isDrawer ? 16 : 18,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (description.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansJp(
              fontSize: isDrawer ? 8 : 10,
              color: Colors.grey[500],
            ),
          ),
        ],
      ],
    );
  }
}
