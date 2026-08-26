class NotificationModel {
  final String id;
  final String organizationId;
  final String userId;
  final String? announcementId;
  final String title;
  final String message;
  final String type; // 'system', 'payment', 'exam', 'general'
  final bool isRead;
  final DateTime sentAt;
  final DateTime? createdAt;

  NotificationModel({
    required this.id,
    required this.organizationId,
    required this.userId,
    this.announcementId,
    required this.title,
    required this.message,
    this.type = 'general',
    this.isRead = false,
    required this.sentAt,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      userId: json['user_id'] as String,
      announcementId: json['announcement_id'] as String?,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String? ?? 'general',
      isRead: json['is_read'] as bool? ?? false,
      sentAt: json['sent_at'] != null
          ? DateTime.parse(json['sent_at'] as String)
          : DateTime.now(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'user_id': userId,
      'announcement_id': announcementId,
      'title': title,
      'message': message,
      'type': type,
      'is_read': isRead,
      'sent_at': sentAt.toIso8601String(),
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}