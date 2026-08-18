import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:mymanager/app/theme/app_theme.dart';
import 'package:mymanager/core/widgets/header_title.dart';
import 'package:mymanager/core/widgets/senior_button.dart';
import 'package:mymanager/core/widgets/senior_chip_selector.dart';
import 'package:mymanager/features/rent/data/app_store.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '9876543210');

  @override
  Widget build(BuildContext context) {
    final activeRole = ref.watch(activeRoleProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const HeaderTitle(
                title: 'MYMANAGER',
                subtitle: 'Manage your rent. Manage your property. Simply.',
              ),
              const SizedBox(height: 40),
              SeniorChipSelector<UserRole>(
                label: 'I am an:',
                options: const [
                  SeniorChipOption(label: '🏠 LANDLORD / OWNER', value: UserRole.owner),
                  SeniorChipOption(label: '🔑 TENANT / RENTER', value: UserRole.tenant),
                ],
                selectedValue: activeRole,
                onSelected: (role) {
                  ref.read(activeRoleProvider.notifier).state = role;
                },
              ),
              const SizedBox(height: 32),
              Text(
                'MOBILE PHONE NUMBER'.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: GoogleFonts.syne(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone_android, color: AppTheme.accentLime, size: 28),
                  hintText: 'Enter 10-digit number',
                ),
              ),
              const Spacer(),
              SeniorButton(
                label: 'GET OTP & CONTINUE',
                icon: Icons.arrow_forward,
                onPressed: () {
                  if (activeRole == UserRole.owner) {
                    context.go('/owner');
                  } else {
                    context.go('/tenant');
                  }
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
