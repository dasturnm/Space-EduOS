class AssignmentModel {
  final String id;
  final String courseId;
  final String teacherId;
  final String title;
  final String? description;
  final DateTime dueDate;
  final double maxScore;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AssignmentModel({
    required this.id,
    required this.courseId,
    required this.teacherId,
    required this.title,
    this.description,
    required this.dueDate,
    this.maxScore = 100.00,
    this.status = 'draft',
    this.createdAt,
    this.updatedAt,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] as String,
      courseId: json['course_id'] as String,
      teacherId: json['teacher_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: DateTime.parse(json['due_date'] as String),
      maxScore: (json['max_score'] as num?)?.toDouble() ?? 100.00,
      status: json['status'] as String? ?? 'draft',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'teacher_id': teacherId,
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'max_score': maxScore,
      'status': status,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}

class SubmissionModel {
  final String id;
  final String assignmentId;
  final String studentId;
  final String fileUrl;
  final DateTime submittedAt;
  final double? score;
  final String? feedback;
  final String status;

  SubmissionModel({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    required this.fileUrl,
    required this.submittedAt,
    this.score,
    this.feedback,
    this.status = 'submitted',
  });

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      id: json['id'] as String,
      assignmentId: json['assignment_id'] as String,
      studentId: json['student_id'] as String,
      fileUrl: json['file_url'] as String,
      submittedAt: DateTime.parse(json['submitted_at'] as String),
      score: (json['score'] as num?)?.toDouble(),
      feedback: json['feedback'] as String?,
      status: json['status'] as String? ?? 'submitted',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assignment_id': assignmentId,
      'student_id': studentId,
      'file_url': fileUrl,
      'submitted_at': submittedAt.toIso8601String(),
      'score': score,
      'feedback': feedback,
      'status': status,
    };
  }
}