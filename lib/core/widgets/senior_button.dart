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
    if (isSecondary) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppTheme.minTouchTarget),
          side: BorderSide(
            color: isDanger ? AppTheme.dangerOverdue : AppTheme.accentLime,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 24, color: isDanger ? AppTheme.dangerOverdue : AppTheme.accentLime),
              const SizedBox(width: 10),
            ],
            Text(
              label.toUpperCase(),
              style: GoogleFonts.syne(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: isDanger ? AppTheme.dangerOverdue : AppTheme.accentLime,
              ),
            ),
          ],
        ),
      );
    }

    final bgColor = isDanger ? AppTheme.dangerOverdue : AppTheme.accentLime;
    final fgColor = isDanger ? Colors.white : Colors.black;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        minimumSize: const Size.fromHeight(AppTheme.minTouchTarget),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 24, color: fgColor),
            const SizedBox(width: 10),
          ],
          Text(
            label.toUpperCase(),
            style: GoogleFonts.syne(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: fgColor,
            ),
          ),
        ],
      ),
    );
  }
}
