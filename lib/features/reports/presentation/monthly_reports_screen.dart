import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mymanager/app/theme/app_theme.dart';
import 'package:mymanager/core/widgets/header_title.dart';
import 'package:mymanager/core/widgets/metric_card.dart';
import 'package:mymanager/core/widgets/senior_button.dart';

class MonthlyReportsScreen extends StatefulWidget {
  const MonthlyReportsScreen({super.key});

  @override
  State<MonthlyReportsScreen> createState() => _MonthlyReportsScreenState();
}

class _MonthlyReportsScreenState extends State<MonthlyReportsScreen> {
  bool _autoEmailOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.accentLime, size: 28),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderTitle(
                title: 'MONTHLY PDF REPORTS',
                subtitle: 'August 2026 - Green Residency',
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      label: 'EXPECTED',
                      value: '₹33,000',
                      icon: Icons.account_balance_wallet,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MetricCard(
                      label: 'COLLECTED',
                      value: '₹18,000',
                      accentColor: AppTheme.accentEmerald,
                      icon: Icons.check_circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AUTOMATIC EMAIL REPORTS',
                            style: GoogleFonts.syne(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Email PDF on 1st of every month',
                            style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                      Switch(
                        value: _autoEmailOn,
                        activeThumbColor: AppTheme.accentLime,
                        onChanged: (val) => setState(() => _autoEmailOn = val),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SeniorButton(
                label: 'GENERATE & DOWNLOAD PDF',
                icon: Icons.picture_as_pdf,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Monthly PDF report generated & sent to your email!'),
                      backgroundColor: AppTheme.accentEmerald,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
