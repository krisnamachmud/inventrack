import 'package:flutter/material.dart';

import '../models/barang.dart';
import '../services/api_service.dart';
import '../theme/app_colors.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({
    required this.onOpenGoodsReceipt,
    required this.onOpenAuditLog,
    super.key,
  });

  final VoidCallback onOpenGoodsReceipt;
  final VoidCallback onOpenAuditLog;

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late Future<List<Barang>> _futureBarangs;

  @override
  void initState() {
    super.initState();
    _futureBarangs = ApiService.getBarangs();
  }

  void _refresh() {
    setState(() {
      _futureBarangs = ApiService.getBarangs();
    });
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'safe':
      case 'aman':
      case 'tersedia':
        return Colors.green;
      case 'low':
      case 'rendah':
      case 'menipis':
        return Colors.orange;
      case 'out':
      case 'habis':
      case 'kosong':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _statusLabel(String status, int stok) {
    if (stok == 0) return 'Habis';
    final s = status.toLowerCase();
    if (s == 'safe' || s == 'aman' || s == 'tersedia') return 'Aman';
    if (s == 'low' || s == 'rendah' || s == 'menipis') return 'Menipis';
    if (s == 'out' || s == 'habis' || s == 'kosong') return 'Habis';
    return status;
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: null,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Goods Receipt'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: widget.onOpenAuditLog,
                icon: const Icon(Icons.history),
                label: const Text('Audit Log'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<Barang>>(
          future: _futureBarangs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      const Icon(Icons.cloud_off, size: 48, color: AppColors.error),
                      const SizedBox(height: 12),
                      Text(
                        'Gagal memuat data inventory.\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _refresh,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }
            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: Text('Tidak ada data inventory.')),
              );
            }
            return Column(
              children: items.map((item) {
                final color = _statusColor(item.status);
                final label = _statusLabel(item.status, item.stok);
                return Container(
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
                            Text(item.namaBarang,
                                style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text('${item.stok} units • ${item.kodeBarang}',
                                style: const TextStyle(color: AppColors.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      Chip(
                        label: Text(label),
                        backgroundColor: color.withValues(alpha: 0.15),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
