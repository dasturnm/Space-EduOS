import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/attendance_session_model.dart';
import '../services/attendance_service.dart';

part 'attendance_provider.g.dart';

@riverpod
AttendanceService attendanceService(Ref ref) {
  return AttendanceService();
}

@riverpod
class AttendanceSessionNotifier extends _$AttendanceSessionNotifier {
  @override
  Future<List<AttendanceSessionModel>> build(
      String organizationId, String classId) async {
    return ref
        .read(attendanceServiceProvider)
        .fetchSessions(organizationId, classId);
  }

  Future<AttendanceSessionModel> createSession(
      AttendanceSessionModel session) async {
    state = const AsyncValue.loading();
    try {
      final newSession =
      await ref.read(attendanceServiceProvider).createSession(session);
      ref.invalidateSelf();
      return newSession;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}