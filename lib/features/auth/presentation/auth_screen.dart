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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppTheme.accentLime.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.accentLime.withValues(alpha: 0.3)),
                    ),
                    child: const Icon(Icons.home_work_outlined, color: AppTheme.accentLime, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'MyManager',
                    style: GoogleFonts.syne(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const HeaderTitle(
                title: 'Welcome Back',
                subtitle: 'Manage rent, properties, and payments effortlessly.',
              ),
              const SizedBox(height: 28),
              SeniorChipSelector<UserRole>(
                label: 'Choose your role',
                options: const [
                  SeniorChipOption(label: '🏠 Landlord / Owner', value: UserRole.owner),
                  SeniorChipOption(label: '🔑 Tenant / Renter', value: UserRole.tenant),
                ],
                selectedValue: activeRole,
                onSelected: (role) {
                  ref.read(activeRoleProvider.notifier).state = role;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Mobile Phone Number',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: GoogleFonts.syne(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone_android_outlined, color: AppTheme.accentLime, size: 20),
                  hintText: 'Enter 10-digit mobile number',
                ),
              ),
              const Spacer(),
              SeniorButton(
                label: 'Get OTP & Continue',
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  if (activeRole == UserRole.owner) {
                    context.go('/owner');
                  } else {
                    context.go('/tenant');
                  }
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
