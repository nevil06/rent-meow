import 'package:go_router/go_router.dart';
import 'package:mymanager/features/auth/presentation/auth_screen.dart';
import 'package:mymanager/features/owner/presentation/owner_dashboard_screen.dart';
import 'package:mymanager/features/properties/presentation/add_property_wizard_screen.dart';
import 'package:mymanager/features/reports/presentation/monthly_reports_screen.dart';
import 'package:mymanager/features/tenancies/presentation/invite_tenant_screen.dart';
import 'package:mymanager/features/tenant/presentation/tenant_accept_invite_screen.dart';
import 'package:mymanager/features/tenant/presentation/tenant_dashboard_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/owner',
      builder: (context, state) => const OwnerDashboardScreen(),
    ),
    GoRoute(
      path: '/tenant',
      builder: (context, state) => const TenantDashboardScreen(),
    ),
    GoRoute(
      path: '/add-property',
      builder: (context, state) => const AddPropertyWizardScreen(),
    ),
    GoRoute(
      path: '/invite-tenant',
      builder: (context, state) => const InviteTenantScreen(),
    ),
    GoRoute(
      path: '/accept-invite',
      builder: (context, state) => const TenantAcceptInviteScreen(),
    ),
    GoRoute(
      path: '/reports',
      builder: (context, state) => const MonthlyReportsScreen(),
    ),
  ],
);
