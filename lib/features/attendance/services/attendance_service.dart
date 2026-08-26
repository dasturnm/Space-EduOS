import 'dart:math' show cos, pi, sin, sqrt;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/attendance_session_model.dart';
import '../models/attendance_record_model.dart';

class AttendanceService {
  final SupabaseClient _supabase;

  AttendanceService([SupabaseClient? client])
      : _supabase = client ?? Supabase.instance.client;

  // --- SESSIONS ---
  Future<AttendanceSessionModel> createSession(AttendanceSessionModel session) async {
    final response = await _supabase
        .from('attendance_sessions')
        .insert(session.toJson())
        .select()
        .single();
    return AttendanceSessionModel.fromJson(response);
  }

  Future<List<AttendanceSessionModel>> fetchSessions(String organizationId, String classId) async {
    final response = await _supabase
        .from('attendance_sessions')
        .select()
        .eq('organization_id', organizationId)
        .eq('class_id', classId)
        .order('date', ascending: false);
    return (response as List).map((json) => AttendanceSessionModel.fromJson(json)).toList();
  }

  // --- RECORDS ---
  Future<void> submitAttendance(AttendanceRecordModel record) async {
    await _supabase.from('attendance_records').upsert(record.toJson());
  }

  Future<List<AttendanceRecordModel>> fetchRecordsForSession(String sessionId) async {
    final response = await _supabase
        .from('attendance_records')
        .select()
        .eq('session_id', sessionId);
    return (response as List).map((json) => AttendanceRecordModel.fromJson(json)).toList();
  }

  // --- DYNAMIC QR TOKEN (Anti-Spam 10 Detik) ---
  Future<String> generateQrToken(String sessionId) async {
    final token = '${sessionId}_${DateTime.now().millisecondsSinceEpoch}';
    final expiresAt = DateTime.now().add(const Duration(seconds: 10)).toUtc();

    await _supabase.from('attendance_qr_tokens').insert({
      'session_id': sessionId,
      'token': token,
      'expires_at': expiresAt.toIso8601String(),
    });

    return token;
  }

  Future<bool> validateQrToken(String token) async {
    final response = await _supabase
        .from('attendance_qr_tokens')
        .select('expires_at')
        .eq('token', token)
        .maybeSingle();

    if (response == null) return false;

    final expiresAt = DateTime.parse(response['expires_at'] as String);
    return DateTime.now().toUtc().isBefore(expiresAt);
  }

  // --- GEOFENCING VALIDATION (FR-PRS-002: Radius Maksimum 100 Meter) ---
  bool isWithinGeofence(
      double userLat,
      double userLng,
      double targetLat,
      double targetLng, {
        double maxDistanceMeters = 100.0,
      }) {
    const double earthRadius = 6371000; // Dalam meter

    final double dLat = (targetLat - userLat) * pi / 180;
    final double dLng = (targetLng - userLng) * pi / 180;

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(userLat * pi / 180) *
            cos(targetLat * pi / 180) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final double c = 2 * sqrt(a);
    final double distance = earthRadius * c;

    return distance <= maxDistanceMeters;
  }
}