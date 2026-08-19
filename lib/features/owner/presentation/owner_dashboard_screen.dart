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
                    title: 'GREEN RESIDENCY',
                    subtitle: 'Landlord Dashboard',
                  ),
                  IconButton(
                    icon: const Icon(Icons.swap_horiz, color: AppTheme.accentLime, size: 32),
                    onPressed: () {
                      ref.read(activeRoleProvider.notifier).state = UserRole.tenant;
                      context.go('/tenant');
                    },
                    tooltip: 'Switch to Tenant View',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Metric Cards
              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      label: 'COLLECTED',
                      value: '₹18,000',
                      accentColor: AppTheme.accentEmerald,
                      icon: Icons.check_circle_outline,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MetricCard(
                      label: 'PENDING',
                      value: '₹15,000',
                      accentColor: AppTheme.dangerOverdue,
                      icon: Icons.warning_amber_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Needs Attention Section
              Text(
                'NEEDS ATTENTION',
                style: GoogleFonts.syne(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  color: AppTheme.accentLime,
                ),
              ),
              const SizedBox(height: 12),

              // Overdue Card
              if (overdueRecord != null) ...[
              Card(
                color: const Color(0xFF24141E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: AppTheme.dangerOverdue, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.error, color: AppTheme.dangerOverdue, size: 28),
                          const SizedBox(width: 10),
                          Text(
                            'OVERDUE RENT ALERT',
                            style: GoogleFonts.syne(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.dangerOverdue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${overdueRecord.tenantName} - Unit 101\n₹${overdueRecord.amountDue.toInt()} due on ${overdueRecord.dueDate}',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (overdueRecord.status == 'overdue')
                        SeniorButton(
                          label: 'MARK AS PAID (MANUAL)',
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
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppTheme.accentEmerald.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, color: AppTheme.accentEmerald),
                              const SizedBox(width: 10),
                              Text(
                                'MARKED AS PAID',
                                style: GoogleFonts.syne(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
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
              const SizedBox(height: 16),
              ],

              // Expiring Agreement Alert
              Card(
                color: const Color(0xFF241F14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: AppTheme.warningExpiring, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: AppTheme.warningExpiring, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AGREEMENT EXPIRING',
                              style: GoogleFonts.syne(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.warningExpiring,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Unit 102 (Priya Patel) expires on Dec 31, 2026',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Quick Actions Header
              Text(
                'QUICK ACTIONS',
                style: GoogleFonts.syne(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  color: AppTheme.accentLime,
                ),
              ),
              const SizedBox(height: 14),

              SeniorButton(
                label: '+ ADD NEW PROPERTY',
                icon: Icons.add_business,
                onPressed: () => context.push('/add-property'),
              ),
              const SizedBox(height: 14),
              SeniorButton(
                label: '+ INVITE NEW TENANT',
                icon: Icons.qr_code,
                isSecondary: true,
                onPressed: () => context.push('/invite-tenant'),
              ),
              const SizedBox(height: 14),
              SeniorButton(
                label: 'VIEW MONTHLY PDF REPORTS',
                icon: Icons.picture_as_pdf,
                isSecondary: true,
                onPressed: () => context.push('/reports'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
