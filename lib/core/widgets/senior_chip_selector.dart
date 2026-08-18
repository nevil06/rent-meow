import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mymanager/app/theme/app_theme.dart';

class SeniorChipOption<T> {
  final String label;
  final T value;

  const SeniorChipOption({required this.label, required this.value});
}

class SeniorChipSelector<T> extends StatelessWidget {
  final String label;
  final List<SeniorChipOption<T>> options;
  final T selectedValue;
  final ValueChanged<T> onSelected;

  const SeniorChipSelector({
    super.key,
    required this.label,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: options.map((opt) {
            final isSelected = opt.value == selectedValue;
            return InkWell(
              onTap: () => onSelected(opt.value),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                constraints: const BoxConstraints(minHeight: 52, minWidth: 70),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.accentLime : const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppTheme.accentLime : AppTheme.cardBorder,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    opt.label,
                    style: GoogleFonts.syne(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: isSelected ? Colors.black : AppTheme.textPrimary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
