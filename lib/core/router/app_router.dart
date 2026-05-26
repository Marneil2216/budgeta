import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/entry_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/fixed_expenses/presentation/screens/fixed_expense_form_screen.dart';
import '../../features/fixed_expenses/presentation/screens/fixed_expenses_list_screen.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/salary_setup_screen.dart';
import '../../features/variable_expenses/presentation/screens/variable_expense_form_screen.dart';
import '../../features/variable_expenses/presentation/screens/variable_expenses_list_screen.dart';
import 'route_names.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authStateProvider);
  final profileAsync = ref.watch(userProfileProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.dashboard,
    redirect: (context, state) {
      final isAuthenticated = authState.valueOrNull?.session != null;
      final isOnAuth = state.matchedLocation.startsWith('/auth');
      final isOnSetup = state.matchedLocation.startsWith('/setup');

      if (!isAuthenticated && !isOnAuth) return RouteNames.entry;
      if (isAuthenticated && isOnAuth) {
        final profile = profileAsync.valueOrNull;
        if (profile?.monthlySalary == null) return RouteNames.salarySetup;
        return RouteNames.dashboard;
      }
      if (isAuthenticated && !isOnAuth && !isOnSetup) {
        final profile = profileAsync.valueOrNull;
        if (profile != null && profile.monthlySalary == null) {
          return RouteNames.salarySetup;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/auth/entry',
        builder: (context, state) => const EntryScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/setup/salary',
        builder: (context, state) => const SalarySetupScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/app/dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(child: DashboardScreen()),
          ),
          GoRoute(
            path: '/app/fixed-expenses',
            pageBuilder: (context, state) => const NoTransitionPage(child: FixedExpensesListScreen()),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const FixedExpenseFormScreen(),
              ),
              GoRoute(
                path: ':id/edit',
                builder: (context, state) => FixedExpenseFormScreen(
                  expenseId: state.pathParameters['id'],
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/app/expenses',
            pageBuilder: (context, state) => const NoTransitionPage(child: VariableExpensesListScreen()),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const VariableExpenseFormScreen(),
              ),
              GoRoute(
                path: ':id/edit',
                builder: (context, state) => VariableExpenseFormScreen(
                  expenseId: state.pathParameters['id'],
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/app/profile',
            pageBuilder: (context, state) => const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),
    ],
  );
}

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;

    int selectedIndex = 0;
    if (location.startsWith('/app/fixed-expenses')) selectedIndex = 1;
    if (location.startsWith('/app/expenses')) selectedIndex = 2;
    if (location.startsWith('/app/profile')) selectedIndex = 3;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/app/dashboard');
            case 1:
              context.go('/app/fixed-expenses');
            case 2:
              context.go('/app/expenses');
            case 3:
              context.go('/app/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Fixed Bills',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
