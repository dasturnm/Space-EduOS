class CourseModel {
  final String id;
  final String organizationId;
  final String subjectId;
  final String classId;
  final String teacherId;
  final String termId;
  final String name;
  final String? code;
  final String? description;
  final String status;
  final Map<String, dynamic>? config;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  CourseModel({
    required this.id,
    required this.organizationId,
    required this.subjectId,
    required this.classId,
    required this.teacherId,
    required this.termId,
    required this.name,
    this.code,
    this.description,
    this.status = 'draft',
    this.config,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      subjectId: json['subject_id'] as String,
      classId: json['class_id'] as String,
      teacherId: json['teacher_id'] as String,
      termId: json['term_id'] as String,
      name: json['name'] as String,
      code: json['code'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'draft',
      config: json['config'] as Map<String, dynamic>?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'subject_id': subjectId,
      'class_id': classId,
      'teacher_id': teacherId,
      'term_id': termId,
      'name': name,
      'code': code,
      'description': description,
      'status': status,
      'config': config ?? {},
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      if (deletedAt != null) 'deleted_at': deletedAt!.toIso8601String(),
    };
  }
}

class ModuleModel {
  final String id;
  final String courseId;
  final String name;
  final String? description;
  final int order;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ModuleModel({
    required this.id,
    required this.courseId,
    required this.name,
    this.description,
    this.order = 0,
    this.status = 'draft',
    this.createdAt,
    this.updatedAt,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['id'] as String,
      courseId: json['course_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      order: json['order'] as int? ?? 0,
      status: json['status'] as String? ?? 'draft',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'name': name,
      'description': description,
      'order': order,
      'status': status,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}

class LessonModel {
  final String id;
  final String moduleId;
  final String name;
  final String? description;
  final String contentType;
  final String? contentUrl;
  final int durationMinutes;
  final int order;
  final bool isFree;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LessonModel({
    required this.id,
    required this.moduleId,
    required this.name,
    this.description,
    required this.contentType,
    this.contentUrl,
    this.durationMinutes = 0,
    this.order = 0,
    this.isFree = false,
    this.createdAt,
    this.updatedAt,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      moduleId: json['module_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      contentType: json['content_type'] as String,
      contentUrl: json['content_url'] as String?,
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      order: json['order'] as int? ?? 0,
      isFree: json['is_free'] as bool? ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'module_id': moduleId,
      'name': name,
      'description': description,
      'content_type': contentType,
      'content_url': contentUrl,
      'duration_minutes': durationMinutes,
      'order': order,
      'is_free': isFree,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}