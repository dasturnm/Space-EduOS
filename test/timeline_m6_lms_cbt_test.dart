import 'package:flutter_test/flutter_test.dart';

// Mocking some of the model structures to allow tests to run cleanly in isolation
// while reflecting the exact specifications of the Space EduOS SDD Bab 7.4 (LMS Tables) and Bab 6.5 (LMS Business Rules)

class CourseMock {
  final String id;
  final String name;
  final String subjectId;
  final String classId;
  final String teacherId;

  CourseMock({
    required this.id,
    required this.name,
    required this.subjectId,
    required this.classId,
    required this.teacherId,
  });

  factory CourseMock.fromJson(Map<String, dynamic> json) {
    return CourseMock(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      subjectId: json['subject_id'] as String? ?? '',
      classId: json['class_id'] as String? ?? '',
      teacherId: json['teacher_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subject_id': subjectId,
      'class_id': classId,
      'teacher_id': teacherId,
    };
  }
}

class AssignmentMock {
  final String id;
  final String title;
  final DateTime dueDate;
  final double maxScore;

  AssignmentMock({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.maxScore,
  });

  // Business Rule BR-LMS-001: Check if submission is allowed based on due date
  bool isSubmissionAllowed(DateTime submitTime) {
    return submitTime.isBefore(dueDate) || submitTime.isAtSameMomentAs(dueDate);
  }
}

class QuestionMock {
  final String id;
  final String type; // 'pg', 'essay', 'isian'
  final String questionText;
  final List<String>? options; // For MCQs (PG)
  final String correctAnswer;
  final double score;

  QuestionMock({
    required this.id,
    required this.type,
    required this.questionText,
    this.options,
    required this.correctAnswer,
    required this.score,
  });
}

class QuizAttemptMock {
  final String id;
  final String quizId;
  final DateTime startTime;
  final int durationMinutes;

  QuizAttemptMock({
    required this.id,
    required this.quizId,
    required this.startTime,
    required this.durationMinutes,
  });

  // Business Rule BR-LMS-002: Check if quiz attempt has timed out
  bool isTimedOut(DateTime currentTime) {
    final limitTime = startTime.add(Duration(minutes: durationMinutes));
    return currentTime.isAfter(limitTime);
  }

  // Automating MCQs scoring
  double calculateScore(List<QuestionMock> questions, Map<String, String> studentAnswers) {
    double totalScore = 0.0;
    for (final question in questions) {
      if (question.type == 'pg') {
        final studentAnswer = studentAnswers[question.id];
        if (studentAnswer != null && studentAnswer.trim().toLowerCase() == question.correctAnswer.trim().toLowerCase()) {
          totalScore += question.score;
        }
      }
    }
    return totalScore;
  }
}

void main() {
  group('LMS Core & CBT Tests (Timeline Week 6)', () {
    
    group('1. Course Model Serialization Tests (Bab 7.4.1)', () {
      test('Should correctly parse CourseModel from JSON', () {
        final json = {
          'id': 'c1-uuid',
          'name': 'Fiqih Ibadah',
          'subject_id': 'sub-1',
          'class_id': 'class-A',
          'teacher_id': 'teacher-g1',
        };

        final course = CourseMock.fromJson(json);

        expect(course.id, 'c1-uuid');
        expect(course.name, 'Fiqih Ibadah');
        expect(course.subjectId, 'sub-1');
        expect(course.classId, 'class-A');
        expect(course.teacherId, 'teacher-g1');
      });

      test('Should correctly serialize CourseModel to JSON map', () {
        final course = CourseMock(
          id: 'c2-uuid',
          name: 'Siroh Nabawiyah',
          subjectId: 'sub-2',
          classId: 'class-B',
          teacherId: 'teacher-g2',
        );

        final json = course.toJson();

        expect(json['id'], 'c2-uuid');
        expect(json['name'], 'Siroh Nabawiyah');
        expect(json['subject_id'], 'sub-2');
        expect(json['class_id'], 'class-B');
        expect(json['teacher_id'], 'teacher-g2');
      });
    });

    group('2. BR-LMS-001: Due Date Assignment Validation', () {
      final dueDate = DateTime(2026, 9, 15, 23, 59, 59);
      final assignment = AssignmentMock(
        id: 'assign-1',
        title: 'Resume Juz 30',
        dueDate: dueDate,
        maxScore: 100.0,
      );

      test('Should ALLOW submission before the due date', () {
        final submitTime = DateTime(2026, 9, 15, 20, 0, 0); // 3h 59m remaining
        final allowed = assignment.isSubmissionAllowed(submitTime);
        expect(allowed, isTrue);
      });

      test('Should ALLOW submission exactly at the due date', () {
        final submitTime = dueDate;
        final allowed = assignment.isSubmissionAllowed(submitTime);
        expect(allowed, isTrue);
      });

      test('Should BLOCK submission after the due date (LATE)', () {
        final submitTime = DateTime(2026, 9, 16, 0, 0, 1); // 1 second late
        final allowed = assignment.isSubmissionAllowed(submitTime);
        expect(allowed, isFalse);
      });
    });

    group('3. BR-LMS-002: CBT Duration & Timeout Limits', () {
      final startTime = DateTime(2026, 9, 17, 08, 0, 0); // Starts at 08:00 AM
      final attempt = QuizAttemptMock(
        id: 'attempt-1',
        quizId: 'quiz-fiqih-1',
        startTime: startTime,
        durationMinutes: 60, // 1 hour duration
      );

      test('Should NOT mark as timed out before duration limits', () {
        final checkTime = DateTime(2026, 9, 17, 08, 59, 59); // 59 minutes elapsed
        final hasTimedOut = attempt.isTimedOut(checkTime);
        expect(hasTimedOut, isFalse);
      });

      test('Should NOT mark as timed out exactly at duration limit', () {
        final checkTime = startTime.add(const Duration(minutes: 60)); // Exactly 60 minutes
        final hasTimedOut = attempt.isTimedOut(checkTime);
        expect(hasTimedOut, isFalse);
      });

      test('Should MARK as timed out when exceeding duration limits (AUTO-SUBMIT trigger)', () {
        final checkTime = DateTime(2026, 9, 17, 09, 0, 1); // 1 second over limit
        final hasTimedOut = attempt.isTimedOut(checkTime);
        expect(hasTimedOut, isTrue);
      });
    });

    group('4. CBT Multiple Choice (PG) Auto-Scoring Engine', () {
      final questions = [
        QuestionMock(
          id: 'q1',
          type: 'pg',
          questionText: 'Siapakah Khalifah pertama?',
          options: ['Abu Bakar', 'Umar', 'Utsman', 'Ali'],
          correctAnswer: 'Abu Bakar',
          score: 25.0,
        ),
        QuestionMock(
          id: 'q2',
          type: 'pg',
          questionText: 'Berapakah jumlah rakaat shalat Shubuh?',
          options: ['1', '2', '3', '4'],
          correctAnswer: '2',
          score: 25.0,
        ),
        QuestionMock(
          id: 'q3',
          type: 'pg',
          questionText: 'Kota kelahiran Nabi Muhammad SAW?',
          options: ['Madinah', 'Makkah', 'Riyadh', 'Thaif'],
          correctAnswer: 'Makkah',
          score: 50.0,
        ),
      ];

      final attempt = QuizAttemptMock(
        id: 'attempt-2',
        quizId: 'quiz-basic-islam',
        startTime: DateTime.now(),
        durationMinutes: 30,
      );

      test('Should calculate 100% correct score matching correct answers', () {
        final studentAnswers = {
          'q1': 'Abu Bakar',
          'q2': '2',
          'q3': 'Makkah',
        };

        final score = attempt.calculateScore(questions, studentAnswers);
        expect(score, 100.0);
      });

      test('Should calculate partial score when some answers are incorrect', () {
        final studentAnswers = {
          'q1': 'Abu Bakar', // +25.0
          'q2': '4',         // Wrong (0.0)
          'q3': 'Makkah',    // +50.0
        };

        final score = attempt.calculateScore(questions, studentAnswers);
        expect(score, 75.0);
      });

      test('Should support case-insensitive and trimmed spaces string match', () {
        final studentAnswers = {
          'q1': '  abu bakar  ', // Case insensitive + trailing spaces
          'q2': '2',
          'q3': 'MAKKAH',
        };

        final score = attempt.calculateScore(questions, studentAnswers);
        expect(score, 100.0);
      });

      test('Should return 0.0 score if all answers are wrong or missing', () {
        final studentAnswers = {
          'q1': 'Umar',
          'q2': '3',
          'q3': 'Madinah',
        };

        final score = attempt.calculateScore(questions, studentAnswers);
        expect(score, 0.0);
      });
    });
  });
}
