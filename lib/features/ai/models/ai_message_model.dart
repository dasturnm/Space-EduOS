class AiMessageModel {
  final String id;
  final String conversationId;
  final String role; // 'user' atau 'assistant'
  final String content;
  final DateTime createdAt;

  AiMessageModel({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory AiMessageModel.fromJson(Map<String, dynamic> json) {
    return AiMessageModel(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'role': role,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class AiConversationModel {
  final String id;
  final String organizationId;
  final String userId;
  final String title;
  final String model;
  final DateTime createdAt;
  final DateTime updatedAt;

  AiConversationModel({
    required this.id,
    required this.organizationId,
    required this.userId,
    required this.title,
    this.model = 'gemini-1.5-pro',
    required this.createdAt,
    required this.updatedAt,
  });

  factory AiConversationModel.fromJson(Map<String, dynamic> json) {
    return AiConversationModel(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      model: json['model'] as String? ?? 'gemini-1.5-pro',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}