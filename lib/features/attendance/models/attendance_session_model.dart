class AttendanceSessionModel {
  final String id;
  final String organizationId;
  final String classId;
  final DateTime date;
  final DateTime? createdAt;

  AttendanceSessionModel({
    required this.id,
    required this.organizationId,
    required this.classId,
    required this.date,
    this.createdAt,
  });

  factory AttendanceSessionModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSessionModel(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      classId: json['class_id'] as String,
      date: DateTime.parse(json['date'] as String),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'class_id': classId,
      'date': date.toIso8601String().split('T').first,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}