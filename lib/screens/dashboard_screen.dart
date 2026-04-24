import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    required this.onOpenRequests,
    required this.onOpenPoTracking,
    super.key,
  });

  final VoidCallback onOpenRequests;
  final VoidCallback onOpenPoTracking;

  @override
  Widget build(BuildContext context) {
    final cards = [
      {
        'title': 'PR Pending',
        'value': '12',
        'icon': Icons.pending_actions,
        'color': Colors.amber,
      },
      {
        'title': 'PR Processed',
        'value': '45',
        'icon': Icons.verified,
        'color': Colors.green,
      },
      {
        'title': 'PO Aktif',
        'value': '08',
        'icon': Icons.shopping_cart,
        'color': AppColors.primary,
      },
      {
        'title': 'Stok Menipis',
        'value': '03',
        'icon': Icons.warning,
        'color': AppColors.error,
      },
    ];

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: const Text('Factory Dashboard'),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.notifications_outlined),
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        Icon(item['icon'] as IconData, color: item['color'] as Color),
                        const Spacer(),
                        Text(item['title'] as String, style: const TextStyle(fontSize: 12)),
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
              ),
              const SizedBox(height: 20),
              ListTile(
                tileColor: AppColors.surfaceLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                leading: const Icon(Icons.local_shipping, color: AppColors.primary),
                title: const Text('Track Purchase Orders'),
                subtitle: const Text('Open PO lifecycle and shipping status'),
                trailing: const Icon(Icons.chevron_right),
                onTap: onOpenPoTracking,
              ),
              const SizedBox(height: 12),
              ListTile(
                tileColor: AppColors.surfaceLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                leading: const Icon(Icons.request_page, color: AppColors.primary),
                title: const Text('Open Requests Queue'),
                subtitle: const Text('Review PR list and statuses'),
                trailing: const Icon(Icons.chevron_right),
                onTap: onOpenRequests,
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
