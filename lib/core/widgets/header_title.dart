import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mymanager/app/theme/app_theme.dart';

class HeaderTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const HeaderTitle({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.syne(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
            color: AppTheme.accentLime,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
