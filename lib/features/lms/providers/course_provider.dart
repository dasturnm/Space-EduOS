import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/course_model.dart';
import '../services/lms_service.dart';

part 'course_provider.g.dart';

@riverpod
LmsService lmsService(Ref ref) {
  return LmsService();
}

@riverpod
class CourseNotifier extends _$CourseNotifier {
  @override
  Future<List<CourseModel>> build(String organizationId) async {
    return ref.watch(lmsServiceProvider).fetchCourses(organizationId);
  }

  Future<void> createCourse(CourseModel course) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(lmsServiceProvider).saveCourse(course);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteCourse(String courseId) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(lmsServiceProvider).deleteCourse(courseId);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}