class BackupHistoryModel {
  final String id;
  final String organizationId;
  final String backupType;
  final String fileUrl;
  final int fileSize;
  final String status;
  final bool encrypted;
  final String? notes;
  final String? createdBy;
  final DateTime createdAt;

  BackupHistoryModel({
    required this.id,
    required this.organizationId,
    required this.backupType,
    required this.fileUrl,
    required this.fileSize,
    required this.status,
    this.encrypted = true,
    this.notes,
    this.createdBy,
    required this.createdAt,
  });

  factory BackupHistoryModel.fromJson(Map<String, dynamic> json) {
    return BackupHistoryModel(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      backupType: json['backup_type'] as String,
      fileUrl: json['file_url'] as String,
      fileSize: json['file_size'] is int
          ? json['file_size'] as int
          : int.parse(json['file_size'].toString()),
      status: json['status'] as String,
      encrypted: json['encrypted'] as bool? ?? true,
      notes: json['notes'] as String?,
      createdBy: json['created_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'backup_type': backupType,
      'file_url': fileUrl,
      'file_size': fileSize,
      'status': status,
      'encrypted': encrypted,
      'notes': notes,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }
}