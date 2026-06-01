import 'package:flutter/material.dart';

import '../models/purchase_request.dart';
import '../services/api_service.dart';
import '../theme/app_colors.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({
    required this.onOpenApprovals,
    required this.onOpenPoTracking,
    super.key,
  });

  final VoidCallback onOpenApprovals;
  final VoidCallback onOpenPoTracking;

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  late Future<List<PurchaseRequest>> _futureRequests;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _futureRequests = ApiService.getApprovals();
  }

  void _refresh() {
    setState(() {
      _futureRequests = ApiService.getApprovals();
    });
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'disetujui':
        return Colors.green;
      case 'pending':
      case 'menunggu':
        return Colors.orange;
      case 'rejected':
      case 'ditolak':
        return Colors.red;
      case 'draft':
        return Colors.grey;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
              icon: const Icon(Icons.tune),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase();
            });
          },
        ),
        const SizedBox(height: 18),
        FutureBuilder<List<PurchaseRequest>>(
          future: _futureRequests,
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
                        'Gagal memuat data requests.\n${snapshot.error}',
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
            final allItems = snapshot.data ?? [];
            final items = _searchQuery.isEmpty
                ? allItems
                : allItems.where((r) {
                    return r.prNumber.toLowerCase().contains(_searchQuery) ||
                        r.department.toLowerCase().contains(_searchQuery) ||
                        r.requesterName.toLowerCase().contains(_searchQuery);
                  }).toList();

            if (items.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: Text('Tidak ada data request.')),
              );
            }
            return Column(
              children: [
                ...items.map(
                  (item) => Card(
                    color: AppColors.surfaceLowest,
                    child: ListTile(
                      title: Text(item.prNumber),
                      subtitle: Text('${item.department} • ${item.requesterName}'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusColor(item.status).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.status,
                          style: TextStyle(
                            color: _statusColor(item.status),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      onTap: widget.onOpenApprovals,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: widget.onOpenPoTracking,
          icon: const Icon(Icons.local_shipping),
          label: const Text('Open Active PO Tracking'),
        ),
      ],
    );
  }
}
