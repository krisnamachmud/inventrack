import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({
    required this.onOpenGoodsReceipt,
    required this.onOpenAuditLog,
    super.key,
  });

  final VoidCallback onOpenGoodsReceipt;
  final VoidCallback onOpenAuditLog;

  @override
  Widget build(BuildContext context) {
    final inventory = [
      ('Optical Sensor T-45', '412 units', 'Safe', Colors.green),
      ('Titanium Fastener M8', '45 units', 'Low', Colors.orange),
      ('Carbon Fiber 3K Weave', '0 units', 'Out', Colors.red),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Inventory',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onOpenGoodsReceipt,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Goods Receipt'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onOpenAuditLog,
                icon: const Icon(Icons.history),
                label: const Text('Audit Log'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...inventory.map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text(item.$2, style: const TextStyle(color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                ),
                Chip(
                  label: Text(item.$3),
                  backgroundColor: (item.$4 as Color).withValues(alpha: 0.15),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
