import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:mymanager/app/theme/app_theme.dart';
import 'package:mymanager/core/widgets/header_title.dart';
import 'package:mymanager/core/widgets/senior_button.dart';
import 'package:mymanager/core/widgets/senior_chip_selector.dart';
import 'package:mymanager/features/rent/data/app_store.dart';

class TenantDashboardScreen extends ConsumerStatefulWidget {
  const TenantDashboardScreen({super.key});

  @override
  ConsumerState<TenantDashboardScreen> createState() => _TenantDashboardScreenState();
}

class _TenantDashboardScreenState extends ConsumerState<TenantDashboardScreen> {
  final TextEditingController _maintDescController = TextEditingController();
  String _selectedCategory = 'Plumbing';

  @override
  Widget build(BuildContext context) {
    final maintenanceList = ref.watch(maintenanceProvider);

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
                    title: 'Tenant Portal',
                    subtitle: 'Green Residency · Unit 101',
                  ),
                  InkWell(
                    onTap: () {
                      ref.read(activeRoleProvider.notifier).state = UserRole.owner;
                      context.go('/owner');
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
                            'Owner View',
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

              // Rent Payment Breakdown Card
              Card(
                color: AppTheme.cardBg,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'August 2026 Rent',
                            style: GoogleFonts.syne(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.dangerOverdue.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppTheme.dangerOverdue.withValues(alpha: 0.4)),
                            ),
                            child: Text(
                              'Due Aug 05',
                              style: GoogleFonts.syne(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.dangerOverdue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Base Rent', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
                          Text('₹15,000', style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Gateway Fee (Disclosed)', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
                          Text('₹300', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
                        ],
                      ),
                      const Divider(color: AppTheme.cardBorder, height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Due', style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700)),
                          Text(
                            '₹15,300',
                            style: GoogleFonts.syne(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.accentLime,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SeniorButton(
                        label: 'Pay Rent Now (₹15,300)',
                        icon: Icons.bolt,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Payment gateway simulation complete! Rent marked as paid.'),
                              backgroundColor: AppTheme.accentEmerald,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Maintenance Section
              Text(
                'Report an Issue',
                style: GoogleFonts.syne(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SeniorChipSelector<String>(
                        label: 'Category',
                        options: const [
                          SeniorChipOption(label: '🚰 Plumbing', value: 'Plumbing'),
                          SeniorChipOption(label: '⚡ Electricity', value: 'Electricity'),
                          SeniorChipOption(label: '💧 Water', value: 'Water'),
                          SeniorChipOption(label: '🔌 Appliance', value: 'Appliance'),
                        ],
                        selectedValue: _selectedCategory,
                        onSelected: (val) => setState(() => _selectedCategory = val),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _maintDescController,
                        maxLines: 2,
                        decoration: const InputDecoration(hintText: 'Briefly describe the issue...'),
                      ),
                      const SizedBox(height: 12),
                      SeniorButton(
                        label: 'Submit Request',
                        icon: Icons.send_rounded,
                        isSecondary: true,
                        onPressed: () {
                          if (_maintDescController.text.isNotEmpty) {
                            ref.read(maintenanceProvider.notifier).addRequest(
                                  MaintenanceRequestModel(
                                    id: 'maint-${DateTime.now().millisecondsSinceEpoch}',
                                    title: '$_selectedCategory Issue',
                                    category: _selectedCategory,
                                    description: _maintDescController.text,
                                    date: DateTime.now().toString().substring(0, 10),
                                    status: 'open',
                                  ),
                                );
                            _maintDescController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Maintenance request submitted to Landlord!'),
                                backgroundColor: AppTheme.accentEmerald,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Active Maintenance Tickets List
              if (maintenanceList.isNotEmpty) ...[
                Text(
                  'Active Requests',
                  style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 8),
                ...maintenanceList.map(
                  (m) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.accentLime.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.build_outlined, color: AppTheme.accentLime, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  m.title,
                                  style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${m.description} · ${m.date}',
                                  style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.accentLime.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              m.status.toUpperCase(),
                              style: GoogleFonts.syne(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.accentLime),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
