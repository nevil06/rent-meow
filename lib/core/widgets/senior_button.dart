import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mymanager/app/theme/app_theme.dart';

class SeniorButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isSecondary;
  final bool isDanger;

  const SeniorButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isSecondary = false,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDanger ? AppTheme.dangerOverdue : AppTheme.accentLime;

    if (isSecondary) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppTheme.buttonHeight),
          side: BorderSide(
            color: isDanger ? AppTheme.dangerOverdue : AppTheme.cardBorder,
            width: 1.0,
          ),
          backgroundColor: AppTheme.surfaceSubtle,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: isDanger ? AppTheme.dangerOverdue : AppTheme.textPrimary),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: GoogleFonts.syne(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
                color: isDanger ? AppTheme.dangerOverdue : AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      );
    }

    final fgColor = isDanger ? Colors.white : const Color(0xFF080C14);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: fgColor,
        minimumSize: const Size.fromHeight(AppTheme.buttonHeight),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: fgColor),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: GoogleFonts.syne(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
              color: fgColor,
            ),
          ),
        ],
      ),
    );
  }
}
