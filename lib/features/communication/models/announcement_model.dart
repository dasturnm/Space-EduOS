class AnnouncementModel {
  final String id;
  final String organizationId;
  final String title;
  final String content;
  final String targetRole; // 'ALL', 'GURU', 'WALI', 'SISWA'
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AnnouncementModel({
    required this.id,
    required this.organizationId,
    required this.title,
    required this.content,
    this.targetRole = 'ALL',
    this.createdAt,
    this.updatedAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      targetRole: json['target_role'] as String? ?? 'ALL',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'title': title,
      'content': content,
      'target_role': targetRole,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}