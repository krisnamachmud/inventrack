import 'package:flutter/material.dart';

import '../models/barang.dart';
import '../models/purchase_request.dart';
import '../services/api_service.dart';
import '../theme/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    required this.onOpenRequests,
    required this.onOpenPoTracking,
    super.key,
  });

  final VoidCallback onOpenRequests;
  final VoidCallback onOpenPoTracking;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<_DashboardData> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = _loadDashboard();
  }

  Future<_DashboardData> _loadDashboard() async {
    final results = await Future.wait([
      ApiService.getApprovals(),
      ApiService.getBarangs(),
    ]);
    final approvals = results[0] as List<PurchaseRequest>;
    final barangs = results[1] as List<Barang>;

    final pending = approvals.where((r) => r.status.toLowerCase() == 'pending').length;
    final approved = approvals.where((r) => r.status.toLowerCase() == 'approved').length;
    final lowStock = barangs.where((b) {
      final s = b.status.toLowerCase();
      return s == 'low' || s == 'rendah' || s == 'menipis' || b.stok == 0;
    }).length;

    return _DashboardData(
      prPending: pending,
      prApproved: approved,
      totalBarang: barangs.length,
      stokMenipis: lowStock,
    );
  }

  void _refresh() {
    setState(() {
      _futureData = _loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: const Text('Factory Dashboard'),
          actions: [
            IconButton(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: () {
                // Navigate back to login screen and clear history
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              icon: const Icon(Icons.logout, color: AppColors.error),
              tooltip: 'Logout',
            ),
            const SizedBox(width: 8),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              FutureBuilder<_DashboardData>(
                future: _futureData,
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  final isLoading =
                      snapshot.connectionState == ConnectionState.waiting;

                  final cards = [
                    {
                      'title': 'PR Pending',
                      'value': isLoading ? '...' : '${data?.prPending ?? 0}',
                      'icon': Icons.pending_actions,
                      'color': Colors.amber,
                    },
                    {
                      'title': 'PR Approved',
                      'value': isLoading ? '...' : '${data?.prApproved ?? 0}',
                      'icon': Icons.verified,
                      'color': Colors.green,
                    },
                    {
                      'title': 'Total Barang',
                      'value': isLoading ? '...' : '${data?.totalBarang ?? 0}',
                      'icon': Icons.inventory,
                      'color': AppColors.primary,
                    },
                    {
                      'title': 'Stok Menipis',
                      'value': isLoading ? '...' : '${data?.stokMenipis ?? 0}',
                      'icon': Icons.warning,
                      'color': AppColors.error,
                    },
                  ];

                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.cloud_off,
                              size: 48, color: AppColors.error),
                          const SizedBox(height: 12),
                          Text(
                            'Gagal memuat dashboard.\n${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: AppColors.onSurfaceVariant),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: _refresh,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cards.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.25,
                    ),
                    itemBuilder: (_, index) {
                      final item = cards[index];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLowest,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(item['icon'] as IconData,
                                color: item['color'] as Color),
                            const Spacer(),
                            Text(item['title'] as String,
                                style: const TextStyle(fontSize: 12)),
                            Text(
                              item['value'] as String,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              ListTile(
                tileColor: AppColors.surfaceLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                leading:
                    const Icon(Icons.local_shipping, color: AppColors.primary),
                title: const Text('Track Purchase Orders'),
                subtitle:
                    const Text('Open PO lifecycle and shipping status'),
                trailing: const Icon(Icons.chevron_right),
                onTap: widget.onOpenPoTracking,
              ),
              const SizedBox(height: 12),
              ListTile(
                tileColor: AppColors.surfaceLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                leading:
                    const Icon(Icons.request_page, color: AppColors.primary),
                title: const Text('Open Requests Queue'),
                subtitle: const Text('Review PR list and statuses'),
                trailing: const Icon(Icons.chevron_right),
                onTap: widget.onOpenRequests,
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _DashboardData {
  final int prPending;
  final int prApproved;
  final int totalBarang;
  final int stokMenipis;

  _DashboardData({
    required this.prPending,
    required this.prApproved,
    required this.totalBarang,
    required this.stokMenipis,
  });
}
