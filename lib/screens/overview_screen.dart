import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({required this.onOpenAuditLog, super.key});

  final VoidCallback onOpenAuditLog;

  @override
  Widget build(BuildContext context) {
    final requestOverview = [
      ('REQ-8829', 'Titanium Alloy Stock', r'$12,450'),
      ('REQ-8831', 'Electronic Sensors', r'$3,200'),
      ('REQ-8835', 'Packaging Supplies', r'$850'),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Request Overview',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 14),
        ...requestOverview.map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.$1, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(item.$2),
                const SizedBox(height: 4),
                Text(item.$3, style: const TextStyle(color: AppColors.primary)),
              ],
            ),
          ),
        ),
        TextButton.icon(
          onPressed: onOpenAuditLog,
          icon: const Icon(Icons.history),
          label: const Text('Open System Audit Log'),
        ),
      ],
    );
  }
}