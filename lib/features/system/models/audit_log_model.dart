class AuditLogModel {
  final String id;
  final String organizationId;
  final String? actorId;
  final String? actorName;
  final String action;
  final String tableName;
  final String recordId;
  final Map<String, dynamic>? oldData;
  final Map<String, dynamic>? newData;
  final String? ipAddress;
  final DateTime createdAt;

  AuditLogModel({
    required this.id,
    required this.organizationId,
    this.actorId,
    this.actorName,
    required this.action,
    required this.tableName,
    required this.recordId,
    this.oldData,
    this.newData,
    this.ipAddress,
    required this.createdAt,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) {
    final actorJson = json['actor'] as Map<String, dynamic>?;
    return AuditLogModel(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      actorId: json['actor_id'] as String?,
      actorName: actorJson != null
          ? actorJson['nama_lengkap'] as String? ?? actorJson['name'] as String?
          : null,
      action: json['action'] as String,
      tableName: json['table_name'] as String,
      recordId: json['record_id'] as String,
      oldData: json['old_data'] != null
          ? Map<String, dynamic>.from(json['old_data'] as Map)
          : null,
      newData: json['new_data'] != null
          ? Map<String, dynamic>.from(json['new_data'] as Map)
          : null,
      ipAddress: json['ip_address'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'actor_id': actorId,
      'action': action,
      'table_name': tableName,
      'record_id': recordId,
      'old_data': oldData,
      'new_data': newData,
      'ip_address': ipAddress,
      'created_at': createdAt.toIso8601String(),
    };
  }
}