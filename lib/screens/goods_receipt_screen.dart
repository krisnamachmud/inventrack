import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GoodsReceiptScreen extends StatelessWidget {
  const GoodsReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lineItems = [
      ('Turbine Hub Z-12', 'TH-901-X', '24 / 24', true),
      ('Titanium Fastener 5mm', 'TF-005-B', '485 / 500', false),
      ('Composite Sealant G3', 'CS-G3-88', '-- / 12', null),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Goods Receipt Entry')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PO-99284', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                SizedBox(height: 6),
                Text('Incoming shipment from Global Aerospace Dynamics'),
                SizedBox(height: 14),
                Row(
                  children: [
                    Icon(Icons.qr_code_scanner, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text('Auto-detect enabled'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...lineItems.map(
            (item) => Card(
              child: ListTile(
                leading: const Icon(Icons.widgets_outlined),
                title: Text(item.$1),
                subtitle: Text('SKU: ${item.$2} • Received/Ordered: ${item.$3}'),
                trailing: item.$4 == null
                    ? const Icon(Icons.remove_circle_outline)
                    : Icon(
                        item.$4! ? Icons.check_circle : Icons.warning,
                        color: item.$4! ? Colors.green : AppColors.error,
                      ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Goods receipt submitted')),
              );
            },
            icon: const Icon(Icons.done_all),
            label: const Text('Submit Receipt'),
          ),
        ),
      ),
    );
  }
}
