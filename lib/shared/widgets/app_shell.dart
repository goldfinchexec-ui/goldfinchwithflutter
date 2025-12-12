
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _isCollapsed ? 70 : 250,
            color: AppTheme.slate900,
            child: Column(
              children: [
                // Header
                Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: _isCollapsed
                      ? const Icon(Icons.account_balance_wallet, color: Colors.white)
                      : const Text(
                          'Goldfinch CRM',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                ),
                const Divider(color: Colors.white24),
                // Menu Items
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    children: [
                      _SidebarItem(
                        icon: Icons.dashboard,
                        label: 'Dashboard',
                        path: '/',
                        isCollapsed: _isCollapsed,
                      ),
                      _SidebarGroup(
                        title: 'Drivers Group',
                        children: [
                          _SidebarItem(
                            icon: Icons.drive_eta,
                            label: 'All Drivers',
                            path: '/drivers',
                            isCollapsed: _isCollapsed,
                          ),
                          _SidebarItem(
                            icon: Icons.receipt_long,
                            label: 'Driver Invoices',
                            path: '/driver-invoices',
                            isCollapsed: _isCollapsed,
                          ),
                        ],
                        isCollapsed: _isCollapsed,
                      ),
                      _SidebarGroup(
                        title: 'Clients Group',
                        children: [
                          _SidebarItem(
                            icon: Icons.business,
                            label: 'All Clients',
                            path: '/clients',
                            isCollapsed: _isCollapsed,
                          ),
                          _SidebarItem(
                            icon: Icons.description,
                            label: 'Client Invoices',
                            path: '/client-invoices',
                            isCollapsed: _isCollapsed,
                          ),
                        ],
                        isCollapsed: _isCollapsed,
                      ),
                      _SidebarGroup(
                        title: 'Finance Group',
                        children: [
                          _SidebarItem(
                            icon: Icons.monetization_on,
                            label: 'General Finance',
                            path: '/finance-general',
                            isCollapsed: _isCollapsed,
                          ),
                          _SidebarItem(
                            icon: Icons.inventory_2,
                            label: 'Receipt Vault',
                            path: '/receipt-vault',
                            isCollapsed: _isCollapsed,
                          ),
                        ],
                        isCollapsed: _isCollapsed,
                      ),
                    ],
                  ),
                ),
                // Collapse Toggle
                IconButton(
                  icon: Icon(
                    _isCollapsed ? Icons.keyboard_double_arrow_right : Icons.keyboard_double_arrow_left,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    setState(() {
                      _isCollapsed = !_isCollapsed;
                    });
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          // Content
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool isCollapsed;

  const _SidebarGroup({
    required this.title,
    required this.children,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context) {
    if (isCollapsed) return Column(children: children);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String path;
  final bool isCollapsed;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.path,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context) {
    final GoRouterState state = GoRouterState.of(context);
    final bool isActive = state.uri.toString() == path;

    return InkWell(
      onTap: () => context.go(path),
      child: Container(
        height: 50,
        color: isActive ? Colors.white10 : Colors.transparent,
        child: Row(
          children: [
            const SizedBox(width: 20),
            Icon(icon, color: isActive ? Colors.white : Colors.white70, size: 20),
            if (!isCollapsed) ...[
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
