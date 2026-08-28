// Lokasi: lib/features/lms/models/course_model.dart

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
    final orgId = json['organization_id'] ?? json['lembaga_id'];
    final sId = json['subject_id'] ?? json['mata_pelajaran_id'];
    final cId = json['class_id'] ?? json['kelas_id'];
    final tId = json['teacher_id'] ?? json['guru_id'];
    final trmId = json['term_id'] ?? json['semester_id'];
    final n = json['name'] ?? json['nama_course'] ?? json['nama_kelas'];

    return CourseModel(
      id: (json['id'] == null || json['id'].toString() == 'null') ? '' : json['id'].toString(),
      organizationId: (orgId == null || orgId.toString() == 'null') ? '' : orgId.toString(),
      subjectId: (sId == null || sId.toString() == 'null') ? '' : sId.toString(),
      classId: (cId == null || cId.toString() == 'null') ? '' : cId.toString(),
      teacherId: (tId == null || tId.toString() == 'null') ? '' : tId.toString(),
      termId: (trmId == null || trmId.toString() == 'null') ? '' : trmId.toString(),
      name: (n == null || n.toString() == 'null') ? '' : n.toString(),
      code: json['code']?.toString(),
      description: (json['description'] ?? json['deskripsi'])?.toString(),
      status: json['status']?.toString() ?? 'draft',
      config: json['config'] as Map<String, dynamic>?,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at'].toString()) : null,
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
      id: (json['id'] == null || json['id'].toString() == 'null') ? '' : json['id'].toString(),
      courseId: (json['course_id'] == null || json['course_id'].toString() == 'null') ? '' : json['course_id'].toString(),
      name: (json['name'] == null || json['name'].toString() == 'null') ? '' : json['name'].toString(),
      description: json['description']?.toString(),
      order: (json['order'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? 'draft',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
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
      id: (json['id'] == null || json['id'].toString() == 'null') ? '' : json['id'].toString(),
      moduleId: (json['module_id'] == null || json['module_id'].toString() == 'null') ? '' : json['module_id'].toString(),
      name: (json['name'] == null || json['name'].toString() == 'null') ? '' : json['name'].toString(),
      description: json['description']?.toString(),
      contentType: json['content_type']?.toString() ?? '',
      contentUrl: json['content_url']?.toString(),
      durationMinutes: (json['duration_minutes'] as num?)?.toInt() ?? 0,
      order: (json['order'] as num?)?.toInt() ?? 0,
      isFree: json['is_free'] == true,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
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