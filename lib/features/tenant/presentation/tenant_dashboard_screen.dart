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
                    title: 'TENANT PORTAL',
                    subtitle: 'Green Residency - Unit 101',
                  ),
                  IconButton(
                    icon: const Icon(Icons.swap_horiz, color: AppTheme.accentLime, size: 32),
                    onPressed: () {
                      ref.read(activeRoleProvider.notifier).state = UserRole.owner;
                      context.go('/owner');
                    },
                    tooltip: 'Switch to Owner View',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Rent Payment Breakdown Card (Option A Disclosed Fee)
              Card(
                color: AppTheme.cardBg,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'AUGUST 2026 RENT',
                            style: GoogleFonts.syne(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.accentLime,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.dangerOverdue.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppTheme.dangerOverdue),
                            ),
                            child: Text(
                              'DUE AUG 05',
                              style: GoogleFonts.syne(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.dangerOverdue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Base Rent', style: GoogleFonts.inter(fontSize: 16, color: AppTheme.textSecondary)),
                          Text('₹15,000', style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w800)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Payment Gateway Fee (Disclosed)', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted)),
                          Text('₹300', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted)),
                        ],
                      ),
                      const Divider(color: AppTheme.cardBorder, height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('TOTAL AMOUNT', style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w900)),
                          Text('₹15,300', style: GoogleFonts.syne(fontSize: 26, fontWeight: FontWeight.w900, color: AppTheme.accentLime)),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SeniorButton(
                        label: 'PAY RENT NOW (₹15,300)',
                        icon: Icons.payment,
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
              const SizedBox(height: 24),

              // Maintenance Section
              Text(
                'REPORT A PROBLEM',
                style: GoogleFonts.syne(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.accentLime,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SeniorChipSelector<String>(
                        label: 'CATEGORY',
                        options: const [
                          SeniorChipOption(label: '🚰 Plumbing', value: 'Plumbing'),
                          SeniorChipOption(label: '⚡ Electricity', value: 'Electricity'),
                          SeniorChipOption(label: '💧 Water', value: 'Water'),
                          SeniorChipOption(label: '🔌 Appliance', value: 'Appliance'),
                        ],
                        selectedValue: _selectedCategory,
                        onSelected: (val) => setState(() => _selectedCategory = val),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _maintDescController,
                        maxLines: 2,
                        decoration: const InputDecoration(hintText: 'Describe the issue briefly...'),
                      ),
                      const SizedBox(height: 16),
                      SeniorButton(
                        label: 'SUBMIT MAINTENANCE REQUEST',
                        icon: Icons.send,
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
              const SizedBox(height: 20),

              // Active Maintenance Tickets List
              if (maintenanceList.isNotEmpty) ...[
                Text(
                  'YOUR ACTIVE REQUESTS',
                  style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 10),
                ...maintenanceList.map(
                  (m) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const Icon(Icons.build_circle, color: AppTheme.accentLime, size: 30),
                      title: Text(m.title, style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w800)),
                      subtitle: Text('${m.description} (${m.date})', style: GoogleFonts.inter(fontSize: 14)),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentLime.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          m.status.toUpperCase(),
                          style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w900, color: AppTheme.accentLime),
                        ),
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
