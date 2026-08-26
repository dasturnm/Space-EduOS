import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/announcement_model.dart';
import '../models/notification_model.dart';
import '../services/communication_service.dart';

part 'communication_provider.g.dart';

@riverpod
CommunicationService communicationService(Ref ref) {
  return CommunicationService();
}

@riverpod
class AnnouncementNotifier extends _$AnnouncementNotifier {
  @override
  Future<List<AnnouncementModel>> build(String organizationId) async {
    return ref.read(communicationServiceProvider).fetchAnnouncements(organizationId);
  }

  Future<void> createAnnouncement(AnnouncementModel announcement) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(communicationServiceProvider).createAnnouncement(announcement);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

@riverpod
Stream<List<NotificationModel>> inboxStream(Ref ref, String userId) {
  return ref.read(communicationServiceProvider).streamInbox(userId);
}