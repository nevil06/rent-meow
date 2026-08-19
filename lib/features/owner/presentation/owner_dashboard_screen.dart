import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:mymanager/app/theme/app_theme.dart';
import 'package:mymanager/core/widgets/header_title.dart';
import 'package:mymanager/core/widgets/metric_card.dart';
import 'package:mymanager/core/widgets/senior_button.dart';
import 'package:mymanager/features/rent/data/app_store.dart';

class OwnerDashboardScreen extends ConsumerWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rentRecords = ref.watch(rentRecordsProvider);

    final overdueRecord = rentRecords
        .where((r) => r.status == 'overdue')
        .followedBy(rentRecords)
        .firstOrNull;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const HeaderTitle(
                    title: 'Green Residency',
                    subtitle: 'Landlord Overview',
                  ),
                  InkWell(
                    onTap: () {
                      ref.read(activeRoleProvider.notifier).state = UserRole.tenant;
                      context.go('/tenant');
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceSubtle,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.swap_horiz, color: AppTheme.accentLime, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'Tenant View',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.accentLime,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Metric Cards
              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      label: 'Collected',
                      value: '₹18,000',
                      accentColor: AppTheme.accentEmerald,
                      icon: Icons.check_circle_outline,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MetricCard(
                      label: 'Pending',
                      value: '₹15,000',
                      accentColor: AppTheme.dangerOverdue,
                      icon: Icons.access_time_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Needs Attention Section
              Text(
                'Needs Attention',
                style: GoogleFonts.syne(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 10),

              // Overdue Card
              if (overdueRecord != null) ...[
                Card(
                  color: const Color(0xFF1C131A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                    side: BorderSide(color: AppTheme.dangerOverdue.withValues(alpha: 0.4), width: 1.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.error_outline, color: AppTheme.dangerOverdue, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Overdue Rent Alert',
                              style: GoogleFonts.syne(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.dangerOverdue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${overdueRecord.tenantName} · Unit 101\n₹${overdueRecord.amountDue.toInt()} due on ${overdueRecord.dueDate}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textPrimary,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (overdueRecord.status == 'overdue')
                          SeniorButton(
                            label: 'Mark as Paid (Manual)',
                            icon: Icons.check,
                            onPressed: () {
                              ref.read(rentRecordsProvider.notifier).markAsPaid(overdueRecord.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Rent marked as paid successfully!'),
                                  backgroundColor: AppTheme.accentEmerald,
                                ),
                              );
                            },
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.accentEmerald.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle, color: AppTheme.accentEmerald, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  'Marked as Paid',
                                  style: GoogleFonts.syne(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.accentEmerald,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],

              // Expiring Agreement Alert
              Card(
                color: const Color(0xFF1C1914),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  side: BorderSide(color: AppTheme.warningExpiring.withValues(alpha: 0.35), width: 1.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppTheme.warningExpiring, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Agreement Expiring Soon',
                              style: GoogleFonts.syne(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.warningExpiring,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Unit 102 (Priya Patel) · Expires Dec 31, 2026',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Quick Actions Header
              Text(
                'Quick Actions',
                style: GoogleFonts.syne(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 10),

              SeniorButton(
                label: 'Add New Property',
                icon: Icons.add_business_outlined,
                onPressed: () => context.push('/add-property'),
              ),
              const SizedBox(height: 10),
              SeniorButton(
                label: 'Invite New Tenant',
                icon: Icons.qr_code_2,
                isSecondary: true,
                onPressed: () => context.push('/invite-tenant'),
              ),
              const SizedBox(height: 10),
              SeniorButton(
                label: 'View Monthly PDF Reports',
                icon: Icons.picture_as_pdf_outlined,
                isSecondary: true,
                onPressed: () => context.push('/reports'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
