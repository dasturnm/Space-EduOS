import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/announcement_model.dart';
import '../models/notification_model.dart';

class CommunicationService {
  final SupabaseClient _supabase;

  CommunicationService([SupabaseClient? client])
      : _supabase = client ?? Supabase.instance.client;

  // --- ANNOUNCEMENTS ---
  Future<List<AnnouncementModel>> fetchAnnouncements(String organizationId) async {
    final response = await _supabase
        .from('announcements')
        .select()
        .eq('organization_id', organizationId)
        .order('created_at', ascending: false);
    return (response as List).map((json) => AnnouncementModel.fromJson(json)).toList();
  }

  Future<void> createAnnouncement(AnnouncementModel announcement) async {
    await _supabase.from('announcements').insert(announcement.toJson());
  }

  // --- INBOX & NOTIFICATIONS ---
  Stream<List<NotificationModel>> streamInbox(String userId) {
    return _supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('sent_at', ascending: false)
        .map((maps) => maps.map((json) => NotificationModel.fromJson(json)).toList());
  }

  Future<List<NotificationModel>> fetchNotifications(String userId) async {
    final response = await _supabase
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('sent_at', ascending: false);
    return (response as List).map((json) => NotificationModel.fromJson(json)).toList();
  }

  Future<void> markAsRead(String notificationId, String userId) async {
    await _supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);

    // Rekam jejak baca lintas perangkat di notification_reads
    await _supabase.from('notification_reads').upsert({
      'notification_id': notificationId,
      'user_id': userId,
      'read_at': DateTime.now().toUtc().toIso8601String(),
    });
  }
}