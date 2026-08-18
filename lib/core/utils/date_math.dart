/// Agreement Date Math Implementation (Spec §22)
/// Rule: "Same day-of-month as the start date; if that day doesn't exist in the target month, use the last day of the target month."
DateTime calculateAgreementEndDate(DateTime startDate, {int durationMonths = 11}) {
  final startYear = startDate.year;
  final startMonth = startDate.month - 1; // 0-indexed for calculation
  final startDay = startDate.day;

  final totalMonths = startMonth + durationMonths;
  final targetYear = startYear + (totalMonths ~/ 12);
  final targetMonth = (totalMonths % 12) + 1; // 1-indexed (1-12)

  // Get maximum number of days in the target month (e.g. Feb 2024 has 29, Feb 2025 has 28)
  final daysInTargetMonth = DateTime(targetYear, targetMonth + 1, 0).day;

  // Pick same day of month, or last day of target month if startDay exceeds month length
  final targetDay = startDay < daysInTargetMonth ? startDay : daysInTargetMonth;

  return DateTime(targetYear, targetMonth, targetDay);
}

String formatDateToISO(DateTime date) {
  final yyyy = date.year.toString();
  final mm = date.month.toString().padLeft(2, '0');
  final dd = date.day.toString().padLeft(2, '0');
  return '$yyyy-$mm-$dd';
}
