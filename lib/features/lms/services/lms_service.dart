import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/subject_model.dart';
import '../models/course_model.dart';
import '../models/assignment_model.dart';
import '../models/quiz_model.dart';

class LmsService {
  final SupabaseClient _supabase;

  LmsService([SupabaseClient? client])
      : _supabase = client ?? Supabase.instance.client;

  // --- SUBJECTS ---
  Future<List<SubjectModel>> fetchSubjects(String organizationId) async {
    final response = await _supabase
        .from('subjects')
        .select()
        .eq('organization_id', organizationId)
        .filter('deleted_at', 'is', null)
        .order('name', ascending: true);
    return (response as List).map((json) => SubjectModel.fromJson(json)).toList();
  }

  Future<void> saveSubject(SubjectModel subject) async {
    await _supabase.from('subjects').upsert(subject.toJson());
  }

  // --- COURSES ---
  Future<List<CourseModel>> fetchCourses(String organizationId) async {
    final response = await _supabase
        .from('courses')
        .select()
        .eq('organization_id', organizationId)
        .filter('deleted_at', 'is', null)
        .order('created_at', ascending: false);
    return (response as List).map((json) => CourseModel.fromJson(json)).toList();
  }

  Future<void> saveCourse(CourseModel course) async {
    await _supabase.from('courses').upsert(course.toJson());
  }

  Future<void> deleteCourse(String courseId) async {
    await _supabase.from('courses').update({
      'deleted_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', courseId);
  }

  // --- MODULES ---
  Future<List<ModuleModel>> fetchModules(String courseId) async {
    final response = await _supabase
        .from('course_modules')
        .select()
        .eq('course_id', courseId)
        .order('order', ascending: true);
    return (response as List).map((json) => ModuleModel.fromJson(json)).toList();
  }

  Future<void> saveModule(ModuleModel module) async {
    await _supabase.from('course_modules').upsert(module.toJson());
  }

  // --- LESSONS ---
  Future<List<LessonModel>> fetchLessons(String moduleId) async {
    final response = await _supabase
        .from('course_lessons')
        .select()
        .eq('module_id', moduleId)
        .order('order', ascending: true);
    return (response as List).map((json) => LessonModel.fromJson(json)).toList();
  }

  Future<void> saveLesson(LessonModel lesson) async {
    await _supabase.from('course_lessons').upsert(lesson.toJson());
  }

  // --- ASSIGNMENTS ---
  Future<List<AssignmentModel>> fetchAssignments(String courseId) async {
    final response = await _supabase
        .from('assignments')
        .select()
        .eq('course_id', courseId)
        .order('due_date', ascending: true);
    return (response as List).map((json) => AssignmentModel.fromJson(json)).toList();
  }

  Future<void> saveAssignment(AssignmentModel assignment) async {
    await _supabase.from('assignments').upsert(assignment.toJson());
  }

  // --- SUBMISSIONS & STORAGE ---
  Future<String> uploadAssignmentFile({
    required String fileName,
    required Uint8List bytes,
  }) async {
    final path = 'submissions/$fileName';
    await _supabase.storage.from('assignments').uploadBinary(
      path,
      bytes,
      fileOptions: const FileOptions(upsert: true),
    );
    return _supabase.storage.from('assignments').getPublicUrl(path);
  }

  Future<void> submitAssignment(SubmissionModel submission) async {
    await _supabase.from('assignment_submissions').upsert(submission.toJson());
  }

  // --- QUESTION BANKS & QUESTIONS ---
  Future<List<QuestionBankModel>> fetchQuestionBanks(String organizationId) async {
    final response = await _supabase
        .from('question_banks')
        .select()
        .eq('organization_id', organizationId);
    return (response as List).map((json) => QuestionBankModel.fromJson(json)).toList();
  }

  Future<void> saveQuestionBank(QuestionBankModel bank) async {
    await _supabase.from('question_banks').upsert(bank.toJson());
  }

  Future<List<QuestionModel>> fetchQuestions(String bankId) async {
    final response = await _supabase
        .from('questions')
        .select()
        .eq('bank_id', bankId);
    return (response as List).map((json) => QuestionModel.fromJson(json)).toList();
  }

  Future<void> saveQuestion(QuestionModel question) async {
    await _supabase.from('questions').upsert(question.toJson());
  }

  // --- QUIZZES ---
  Future<List<QuizModel>> fetchQuizzes(String courseId) async {
    final response = await _supabase
        .from('quizzes')
        .select()
        .eq('course_id', courseId);
    return (response as List).map((json) => QuizModel.fromJson(json)).toList();
  }

  Future<void> saveQuiz(QuizModel quiz) async {
    await _supabase.from('quizzes').upsert(quiz.toJson());
  }

  // --- QUIZ ATTEMPTS ---
  Future<QuizAttemptModel> startQuizAttempt(QuizAttemptModel attempt) async {
    final response = await _supabase
        .from('quiz_attempts')
        .insert(attempt.toJson())
        .select()
        .single();
    return QuizAttemptModel.fromJson(response);
  }

  Future<void> updateQuizAnswers({
    required String attemptId,
    required Map<String, dynamic> answers,
    String status = 'in_progress',
    double? score,
  }) async {
    final data = <String, dynamic>{
      'answers': answers,
      'status': status,
      if (status == 'submitted' || status == 'timed_out')
        'end_time': DateTime.now().toUtc().toIso8601String(),
      if (score != null) 'score': score,
    };
    await _supabase.from('quiz_attempts').update(data).eq('id', attemptId);
  }
}