class QuestionBankModel {
  final String id;
  final String organizationId;
  final String name;
  final String? description;
  final String subjectId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  QuestionBankModel({
    required this.id,
    required this.organizationId,
    required this.name,
    this.description,
    required this.subjectId,
    this.createdAt,
    this.updatedAt,
  });

  factory QuestionBankModel.fromJson(Map<String, dynamic> json) {
    return QuestionBankModel(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      subjectId: json['subject_id'] as String,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'name': name,
      'description': description,
      'subject_id': subjectId,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}

class QuestionModel {
  final String id;
  final String bankId;
  final String type;
  final String text;
  final List<dynamic> options;
  final String? correctAnswer;
  final double score;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  QuestionModel({
    required this.id,
    required this.bankId,
    required this.type,
    required this.text,
    this.options = const [],
    this.correctAnswer,
    this.score = 1.00,
    this.createdAt,
    this.updatedAt,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String,
      bankId: json['bank_id'] as String,
      type: json['type'] as String,
      text: json['text'] as String,
      options: json['options'] != null ? List<dynamic>.from(json['options'] as List) : [],
      correctAnswer: json['correct_answer'] as String?,
      score: (json['score'] as num?)?.toDouble() ?? 1.00,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bank_id': bankId,
      'type': type,
      'text': text,
      'options': options,
      'correct_answer': correctAnswer,
      'score': score,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}

class QuizModel {
  final String id;
  final String courseId;
  final String name;
  final String? description;
  final int durationMinutes;
  final int attemptLimit;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final Map<String, dynamic>? config;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  QuizModel({
    required this.id,
    required this.courseId,
    required this.name,
    this.description,
    this.durationMinutes = 60,
    this.attemptLimit = 1,
    required this.startDate,
    required this.endDate,
    this.status = 'draft',
    this.config,
    this.createdAt,
    this.updatedAt,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] as String,
      courseId: json['course_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      durationMinutes: json['duration_minutes'] as int? ?? 60,
      attemptLimit: json['attempt_limit'] as int? ?? 1,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      status: json['status'] as String? ?? 'draft',
      config: json['config'] as Map<String, dynamic>?,
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
      'duration_minutes': durationMinutes,
      'attempt_limit': attemptLimit,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'status': status,
      'config': config ?? {},
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}

class QuizQuestionModel {
  final String id;
  final String quizId;
  final String questionId;
  final int order;

  QuizQuestionModel({
    required this.id,
    required this.quizId,
    required this.questionId,
    this.order = 0,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      id: json['id'] as String,
      quizId: json['quiz_id'] as String,
      questionId: json['question_id'] as String,
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz_id': quizId,
      'question_id': questionId,
      'order': order,
    };
  }
}

class QuizAttemptModel {
  final String id;
  final String quizId;
  final String studentId;
  final DateTime startTime;
  final DateTime? endTime;
  final double? score;
  final String status;
  final Map<String, dynamic> answers;

  QuizAttemptModel({
    required this.id,
    required this.quizId,
    required this.studentId,
    required this.startTime,
    this.endTime,
    this.score,
    this.status = 'in_progress',
    this.answers = const {},
  });

  factory QuizAttemptModel.fromJson(Map<String, dynamic> json) {
    return QuizAttemptModel(
      id: json['id'] as String,
      quizId: json['quiz_id'] as String,
      studentId: json['student_id'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] != null ? DateTime.parse(json['end_time'] as String) : null,
      score: (json['score'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'in_progress',
      answers: json['answers'] != null ? Map<String, dynamic>.from(json['answers'] as Map) : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz_id': quizId,
      'student_id': studentId,
      'start_time': startTime.toIso8601String(),
      if (endTime != null) 'end_time': endTime!.toIso8601String(),
      if (score != null) 'score': score,
      'status': status,
      'answers': answers,
    };
  }
}