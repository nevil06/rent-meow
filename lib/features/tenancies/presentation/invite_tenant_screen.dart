import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mymanager/app/theme/app_theme.dart';
import 'package:mymanager/core/widgets/header_title.dart';
import 'package:mymanager/core/widgets/senior_button.dart';

class InviteTenantScreen extends StatefulWidget {
  const InviteTenantScreen({super.key});

  @override
  State<InviteTenantScreen> createState() => _InviteTenantScreenState();
}

class _InviteTenantScreenState extends State<InviteTenantScreen> {
  final String _token = 'mymanager-invite-token-998877';

  @override
  Widget build(BuildContext context) {
    final inviteUrl = 'https://mymanager.rent/invite?token=$_token';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.accentLime, size: 28),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const HeaderTitle(
                title: 'INVITE TENANT',
                subtitle: 'Green Residency - Unit 103',
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentLime.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: QrImageView(
                  data: inviteUrl,
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'POINT TENANT\'S CAMERA HERE',
                style: GoogleFonts.syne(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.accentLime,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Token: $_token',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              SeniorButton(
                label: 'SHARE INVITATION LINK / SMS',
                icon: Icons.share,
                onPressed: () {
                  Share.share(
                    'You are invited to join Green Residency Unit 103 on MyManager! Click to accept: $inviteUrl',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
