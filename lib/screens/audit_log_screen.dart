import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AuditLogScreen extends StatelessWidget {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = [
      (
        '14:22',
        'Marcus Thorne',
        'Updated stock level for Titanium Alloy G-42 in Warehouse Section B.',
      ),
      (
        '11:05',
        'Security System',
        'New API key generated for MES Integration Module.',
      ),
      (
        '09:15',
        'Elena Rodriguez',
        'Flagged Batch #9921 as non-compliant after quality check.',
      ),
      (
        'Yesterday',
        'Logistics Hub',
        'Inbound shipment verified: 4,500 components arrived.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('System Audit Log')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: logs.length,
        itemBuilder: (_, index) {
          final item = logs[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.$2,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    Text(
                      item.$1,
                      style: const TextStyle(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(item.$3),
              ],
            ),
          );
        },
      ),
    );
  }
}
