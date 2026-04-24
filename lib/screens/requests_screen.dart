import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({
    required this.onOpenPoTracking,
    super.key,
  });

  final VoidCallback onOpenPoTracking;

  @override
  Widget build(BuildContext context) {
    final requests = [
      ('PR-2024-0892', 'Precision Milling Bits', 'Pending'),
      ('PR-2024-0888', 'High-Grade Lubricant X-9', 'In Progress'),
      ('PR-2024-0875', 'Replacement Sensors S4', 'Completed'),
      ('PR-2024-0870', 'Safety Equipment Refill', 'Draft'),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Requests',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            hintText: 'Search PR number or department...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              tooltip: 'Filter requests',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Filter request dibuka')),
                );
              },
              icon: const Icon(Icons.tune),
            ),
          ),
        ),
        const SizedBox(height: 18),
        ...requests.map(
          (item) => Card(
            color: AppColors.surfaceLowest,
            child: ListTile(
              title: Text(item.$1),
              subtitle: Text(item.$2),
              trailing: Text(item.$3),
            ),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onOpenPoTracking,
          icon: const Icon(Icons.local_shipping),
          label: const Text('Open Active PO Tracking'),
        ),
      ],
    );
  }
}
