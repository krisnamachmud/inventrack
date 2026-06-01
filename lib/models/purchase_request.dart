class PurchaseRequest {
  final int id;
  final String prNumber;
  final String department;
  final String requesterName;
  final String status;
  final String? notes;
  final String? requestedAt;
  final String? approvedAt;
  final String? rejectedAt;
  final String? receivedAt;
  final List<RequestItem> items;
  final String? createdAt;
  final String? updatedAt;

  PurchaseRequest({
    required this.id,
    required this.prNumber,
    required this.department,
    required this.requesterName,
    required this.status,
    this.notes,
    this.requestedAt,
    this.approvedAt,
    this.rejectedAt,
    this.receivedAt,
    this.items = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory PurchaseRequest.fromJson(Map<String, dynamic> json) {
    return PurchaseRequest(
      id: _toInt(json['id']),
      prNumber: json['pr_number']?.toString() ?? '',
      department: json['department']?.toString() ?? '',
      requesterName: json['requester_name']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      notes: json['notes']?.toString(),
      requestedAt: json['requested_at']?.toString(),
      approvedAt: json['approved_at']?.toString(),
      rejectedAt: json['rejected_at']?.toString(),
      receivedAt: json['received_at']?.toString(),
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => RequestItem.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}

class RequestItem {
  final int id;
  final int barangId;
  final String namaBarang;
  final String kodeBarang;
  final int qtyRequested;
  final int? qtyReceived;
  final String? createdAt;
  final String? updatedAt;

  RequestItem({
    required this.id,
    required this.barangId,
    required this.namaBarang,
    required this.kodeBarang,
    required this.qtyRequested,
    this.qtyReceived,
    this.createdAt,
    this.updatedAt,
  });

  factory RequestItem.fromJson(Map<String, dynamic> json) {
    return RequestItem(
      id: _toInt(json['id']),
      barangId: _toInt(json['barang_id']),
      namaBarang: json['nama_barang']?.toString() ?? '',
      kodeBarang: json['kode_barang']?.toString() ?? '',
      qtyRequested: _toInt(json['qty_requested']),
      qtyReceived: json['qty_received'] != null ? _toInt(json['qty_received']) : null,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}

/// Helper: convert dynamic (String atau int) ke int dengan aman
int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is double) return value.toInt();
  return 0;
}
