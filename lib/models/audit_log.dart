class AuditLog {
  final int id;
  final String action;
  final String title;
  final String description;
  final String category;
  final String level;
  final String actorName;
  final String? ipAddress;
  final String? entityType;
  final int? entityId;
  final dynamic metadata;
  final String? createdAt;

  AuditLog({
    required this.id,
    required this.action,
    required this.title,
    required this.description,
    required this.category,
    required this.level,
    required this.actorName,
    this.ipAddress,
    this.entityType,
    this.entityId,
    this.metadata,
    this.createdAt,
  });

  factory AuditLog.fromJson(Map<String, dynamic> json) {
    return AuditLog(
      id: _toInt(json['id']),
      action: json['action']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      level: json['level']?.toString() ?? '',
      actorName: json['actor_name']?.toString() ?? '',
      ipAddress: json['ip_address']?.toString(),
      entityType: json['entity_type']?.toString(),
      entityId: json['entity_id'] != null ? _toInt(json['entity_id']) : null,
      metadata: json['metadata'],
      createdAt: json['created_at']?.toString(),
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
