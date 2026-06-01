import 'package:flutter/material.dart';

import '../app.dart';
import 'approvals_screen.dart';
import 'dashboard_screen.dart';
import 'inventory_screen.dart';
import 'requests_screen.dart';

class HomeShellScreen extends StatefulWidget {
  const HomeShellScreen({super.key});

  @override
  State<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends State<HomeShellScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      DashboardScreen(
        onOpenRequests: () => setState(() => _currentIndex = 1),
        onOpenPoTracking: () {
          Navigator.pushNamed(context, InvenTrackApp.poTrackingRoute);
        },
      ),
      RequestsScreen(
        onOpenApprovals: () => setState(() => _currentIndex = 2),
        onOpenPoTracking: () {
          Navigator.pushNamed(context, InvenTrackApp.poTrackingRoute);
        },
      ),
      ApprovalsScreen(
        onOpenAuditLog: () {
          Navigator.pushNamed(context, InvenTrackApp.auditLogRoute);
        },
      ),
      InventoryScreen(
        onOpenGoodsReceipt: () {
          Navigator.pushNamed(context, InvenTrackApp.goodsReceiptRoute);
        },
        onOpenAuditLog: () {
          Navigator.pushNamed(context, InvenTrackApp.auditLogRoute);
        },
      ),
    ];

    return Scaffold(
      body: SafeArea(child: tabs[_currentIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (value) => setState(() => _currentIndex = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.pending_actions_outlined),
            selectedIcon: Icon(Icons.pending_actions),
            label: 'Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.fact_check_outlined),
            selectedIcon: Icon(Icons.fact_check),
            label: 'Approvals',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
        ],
      ),
    );
  }
}
