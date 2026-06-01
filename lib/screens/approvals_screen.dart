import 'package:flutter/material.dart';

import '../models/purchase_request.dart';
import '../services/api_service.dart';
import '../theme/app_colors.dart';

class ApprovalsScreen extends StatefulWidget {
  const ApprovalsScreen({required this.onOpenAuditLog, super.key});

  final VoidCallback onOpenAuditLog;

  @override
  State<ApprovalsScreen> createState() => _ApprovalsScreenState();
}

class _ApprovalsScreenState extends State<ApprovalsScreen> {
  late Future<List<PurchaseRequest>> _futureApprovals;

  @override
  void initState() {
    super.initState();
    _futureApprovals = _fetchPendingApprovals();
  }

  Future<List<PurchaseRequest>> _fetchPendingApprovals() async {
    final all = await ApiService.getApprovals();
    // Filter hanya yang statusnya pending
    return all.where((r) => r.status.toLowerCase() == 'pending').toList();
  }

  void _refresh() {
    setState(() {
      _futureApprovals = _fetchPendingApprovals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Pending Approvals',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 14),
        FutureBuilder<List<PurchaseRequest>>(
          future: _futureApprovals,
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
                        'Gagal memuat data approvals.\n${snapshot.error}',
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
            final pending = snapshot.data ?? [];
            if (pending.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.check_circle_outline, size: 48, color: Colors.green),
                      SizedBox(height: 12),
                      Text('Tidak ada approval yang pending.'),
                    ],
                  ),
                ),
              );
            }
            return Column(
              children: pending.map((item) {
                // Buat ringkasan item yang di-request
                final itemSummary = item.items.isNotEmpty
                    ? item.items.map((i) => i.namaBarang).join(', ')
                    : item.department;

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
                      Text(item.prNumber,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(itemSummary),
                      const SizedBox(height: 4),
                      Text('Oleh: ${item.requesterName}',
                          style: const TextStyle(color: AppColors.primary)),
                      if (item.notes != null && item.notes!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text('Catatan: ${item.notes}',
                            style: const TextStyle(
                                color: AppColors.onSurfaceVariant, fontSize: 12)),
                      ],
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: null,
                              child: const Text('Reject'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: null,
                              child: const Text('Approve'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
        TextButton.icon(
          onPressed: widget.onOpenAuditLog,
          icon: const Icon(Icons.history),
          label: const Text('Open System Audit Log'),
        ),
      ],
    );
  }
}
