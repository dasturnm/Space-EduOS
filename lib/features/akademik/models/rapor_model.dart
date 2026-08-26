class RaporModel {
  final String studentId;
  final String termId;
  final String? studentName;
  final String? termName;
  final double scoreTahfidz;
  final double scoreLms;
  final double finalScore;
  final String gradeLetter;
  final List<RaporSemesterHistory> history;

  RaporModel({
    required this.studentId,
    required this.termId,
    this.studentName,
    this.termName,
    required this.scoreTahfidz,
    required this.scoreLms,
    required this.finalScore,
    required this.gradeLetter,
    this.history = const [],
  });

  factory RaporModel.fromJson(Map<String, dynamic> json) {
    return RaporModel(
      studentId: json['student_id'] as String,
      termId: json['term_id'] as String,
      studentName: json['student_name'] as String?,
      termName: json['term_name'] as String?,
      scoreTahfidz: (json['score_tahfidz'] as num?)?.toDouble() ?? 0.0,
      scoreLms: (json['score_lms'] as num?)?.toDouble() ?? 0.0,
      finalScore: (json['final_score'] as num?)?.toDouble() ?? 0.0,
      gradeLetter: json['grade_letter'] as String? ?? 'D',
      history: json['history'] != null
          ? (json['history'] as List)
          .map((e) => RaporSemesterHistory.fromJson(e as Map<String, dynamic>))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'term_id': termId,
      'student_name': studentName,
      'term_name': termName,
      'score_tahfidz': scoreTahfidz,
      'score_lms': scoreLms,
      'final_score': finalScore,
      'grade_letter': gradeLetter,
      'history': history.map((e) => e.toJson()).toList(),
    };
  }
}

class RaporSemesterHistory {
  final String semesterName;
  final double finalScore;

  RaporSemesterHistory({
    required this.semesterName,
    required this.finalScore,
  });

  factory RaporSemesterHistory.fromJson(Map<String, dynamic> json) {
    return RaporSemesterHistory(
      semesterName: json['semester_name'] as String,
      finalScore: (json['final_score'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'semester_name': semesterName,
      'final_score': finalScore,
    };
  }
}