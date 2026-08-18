import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:mymanager/app/theme/app_theme.dart';
import 'package:mymanager/core/widgets/header_title.dart';
import 'package:mymanager/core/widgets/senior_button.dart';

class TenantAcceptInviteScreen extends StatelessWidget {
  const TenantAcceptInviteScreen({super.key});

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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderTitle(
                title: 'TENANCY INVITATION',
                subtitle: 'Token Validated via Secure Link',
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GREEN RESIDENCY - UNIT 103',
                        style: GoogleFonts.syne(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.accentLime,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Landlord: Ramesh Kumar',
                        style: GoogleFonts.inter(fontSize: 16, color: AppTheme.textSecondary),
                      ),
                      const Divider(color: AppTheme.cardBorder, height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Monthly Rent', style: GoogleFonts.inter(fontSize: 16)),
                          Text('₹15,000', style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w900)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Security Deposit', style: GoogleFonts.inter(fontSize: 16)),
                          Text('₹30,000', style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w900)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Agreement Term', style: GoogleFonts.inter(fontSize: 16)),
                          Text('11 Months', style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SeniorButton(
                label: 'ACCEPT TENANCY & JOIN',
                icon: Icons.check_circle,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tenancy accepted successfully! Welcome to MyManager.'),
                      backgroundColor: AppTheme.accentEmerald,
                    ),
                  );
                  context.go('/tenant');
                },
              ),
              const SizedBox(height: 14),
              SeniorButton(
                label: 'DECLINE INVITATION',
                isSecondary: true,
                isDanger: true,
                onPressed: () => context.pop(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
