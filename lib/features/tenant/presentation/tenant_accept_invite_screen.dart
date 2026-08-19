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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.accentLime, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderTitle(
                title: 'Tenancy Invitation',
                subtitle: 'Validated via secure invitation link',
              ),
              const SizedBox(height: 18),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Green Residency · Unit 103',
                        style: GoogleFonts.syne(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Landlord: Ramesh Kumar',
                        style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary),
                      ),
                      const Divider(color: AppTheme.cardBorder, height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Monthly Rent', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
                          Text('₹15,000', style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w800)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Security Deposit', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
                          Text('₹30,000', style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w800)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Agreement Term', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
                          Text('11 Months', style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SeniorButton(
                label: 'Accept Tenancy & Join',
                icon: Icons.check_circle_outline,
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
              const SizedBox(height: 10),
              SeniorButton(
                label: 'Decline Invitation',
                isSecondary: true,
                isDanger: true,
                onPressed: () => context.pop(),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
