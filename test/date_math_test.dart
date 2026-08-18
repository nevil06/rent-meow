import 'package:flutter_test/flutter_test.dart';
import 'package:mymanager/core/utils/date_math.dart';

void main() {
  group('Agreement Date Math (§22)', () {
    test('Jan 31 + 11 months => Dec 31 of same year', () {
      final start = DateTime(2025, 1, 31);
      final end = calculateAgreementEndDate(start, durationMonths: 11);
      expect(formatDateToISO(end), equals('2025-12-31'));
    });

    test('Jan 31 + 1 month in non-leap year (2025) => Feb 28', () {
      final start = DateTime(2025, 1, 31);
      final end = calculateAgreementEndDate(start, durationMonths: 1);
      expect(formatDateToISO(end), equals('2025-02-28'));
    });

    test('Jan 31 + 1 month in leap year (2024) => Feb 29', () {
      final start = DateTime(2024, 1, 31);
      final end = calculateAgreementEndDate(start, durationMonths: 1);
      expect(formatDateToISO(end), equals('2024-02-29'));
    });

    test('Standard date: March 15 + 11 months => Feb 15 of next year', () {
      final start = DateTime(2025, 3, 15);
      final end = calculateAgreementEndDate(start, durationMonths: 11);
      expect(formatDateToISO(end), equals('2026-02-15'));
    });

    test('March 31 + 11 months in leap year => Feb 29 of next year', () {
      final start = DateTime(2023, 3, 31);
      final end = calculateAgreementEndDate(start, durationMonths: 11);
      expect(formatDateToISO(end), equals('2024-02-29'));
    });

    test('August 31 + 6 months in non-leap year => Feb 28', () {
      final start = DateTime(2024, 8, 31);
      final end = calculateAgreementEndDate(start, durationMonths: 6);
      expect(formatDateToISO(end), equals('2025-02-28'));
    });
  });
}
