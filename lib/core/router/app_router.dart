
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/drivers/drivers_screen.dart';
import '../../features/drivers/driver_invoices_screen.dart';
import '../../features/clients/clients_screen.dart';
import '../../features/clients/client_invoices_screen.dart';
import '../../features/finance/general_finance_screen.dart';
import '../../features/finance/receipt_vault_screen.dart';
import '../../shared/widgets/app_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/drivers',
          builder: (context, state) => const DriversScreen(),
        ),
        GoRoute(
          path: '/driver-invoices',
          builder: (context, state) => const DriverInvoicesScreen(),
        ),
        GoRoute(
          path: '/clients',
          builder: (context, state) => const ClientsScreen(),
        ),
        GoRoute(
          path: '/client-invoices',
          builder: (context, state) => const ClientInvoicesScreen(),
        ),
        GoRoute(
          path: '/finance-general',
          builder: (context, state) => const GeneralFinanceScreen(),
        ),
        GoRoute(
          path: '/receipt-vault',
          builder: (context, state) => const ReceiptVaultScreen(),
        ),
      ],
    ),
  ],
);
