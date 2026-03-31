import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class PoTrackingScreen extends StatelessWidget {
  const PoTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('PO-88295', 'Precision Steel Co.', r'$12,400', 'Ordered'),
      ('PO-88291', 'Global Hydraulics', r'$8,920', 'Shipped'),
      ('PO-88288', 'Alpha Tooling', r'$5,600', 'Completed'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Purchase Order Tracking')),
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
                Text('PO-88294', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                SizedBox(height: 8),
                Text('Vendor: Industrial Dynamics Ltd.'),
                Text('Value: \$42,850.00', style: TextStyle(color: AppColors.primary)),
                SizedBox(height: 10),
                LinearProgressIndicator(value: 0.66),
                SizedBox(height: 6),
                Text('Status: In Transit'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('All Active Orders', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ...items.map(
            (item) => ListTile(
              tileColor: AppColors.surfaceLow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              title: Text(item.$2),
              subtitle: Text(item.$1),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(item.$3, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(item.$4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
