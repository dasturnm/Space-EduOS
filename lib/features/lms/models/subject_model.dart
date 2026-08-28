class SubjectModel {
  final String id;
  final String organizationId;
  final String name;
  final String code;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  SubjectModel({
    required this.id,
    required this.organizationId,
    required this.name,
    required this.code,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    final orgId = json['organization_id'] ?? json['lembaga_id'];
    final n = json['name'] ?? json['nama_pelajaran'];
    final c = json['code'] ?? json['kode'];

    return SubjectModel(
      id: (json['id'] == null || json['id'].toString() == 'null') ? '' : json['id'].toString(),
      organizationId: (orgId == null || orgId.toString() == 'null') ? '' : orgId.toString(),
      name: (n == null || n.toString() == 'null') ? '' : n.toString(),
      code: (c == null || c.toString() == 'null') ? '' : c.toString(),
      description: (json['description'] ?? json['deskripsi'])?.toString(),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'name': name,
      'code': code,
      'description': description,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      if (deletedAt != null) 'deleted_at': deletedAt!.toIso8601String(),
    };
  }
}