class Barang {
  final int id;
  final String namaBarang;
  final String kodeBarang;
  final int stok;
  final String status;
  final String? createdAt;
  final String? updatedAt;

  Barang({
    required this.id,
    required this.namaBarang,
    required this.kodeBarang,
    required this.stok,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: _toInt(json['id']),
      namaBarang: json['nama_barang']?.toString() ?? '',
      kodeBarang: json['kode_barang']?.toString() ?? '',
      stok: _toInt(json['stok']),
      status: json['status']?.toString() ?? '',
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
