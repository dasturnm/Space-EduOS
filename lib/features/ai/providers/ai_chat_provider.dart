import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/ai_message_model.dart';

part 'ai_chat_provider.g.dart';

class AiChatState {
  final String? conversationId;
  final List<AiMessageModel> messages;
  final bool isSending;

  AiChatState({
    this.conversationId,
    this.messages = const [],
    this.isSending = false,
  });

  AiChatState copyWith({
    String? conversationId,
    List<AiMessageModel>? messages,
    bool? isSending,
  }) {
    return AiChatState(
      conversationId: conversationId ?? this.conversationId,
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
    );
  }
}

@riverpod
class AiChatNotifier extends _$AiChatNotifier {
  late final SupabaseClient _supabase;

  @override
  FutureOr<AiChatState> build(String organizationId) async {
    _supabase = Supabase.instance.client;
    return AiChatState();
  }

  Future<void> sendMessage(String userPrompt) async {
    if (userPrompt.trim().isEmpty) return;

    final currentState = state.value ?? AiChatState();
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    // 1. Tambahkan pesan user ke UI secara lokal terlebih dahulu
    final userMsgLocal = AiMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: currentState.conversationId ?? '',
      role: 'user',
      content: userPrompt,
      createdAt: DateTime.now(),
    );

    state = AsyncValue.data(
      currentState.copyWith(
        messages: [...currentState.messages, userMsgLocal],
        isSending: true,
      ),
    );

    try {
      String convId = currentState.conversationId ?? '';

      // 2. Buat percakapan baru di Supabase jika belum ada
      if (convId.isEmpty) {
        final convRes = await _supabase.from('ai_conversations').insert({
          'organization_id': organizationId,
          'user_id': user.id,
          'title': userPrompt.length > 30 ? '${userPrompt.substring(0, 30)}...' : userPrompt,
          'model': 'gemini-1.5-pro',
        }).select().single();

        convId = convRes['id'] as String;
      }

      // 3. Simpan pesan pengguna ke database
      await _supabase.from('ai_messages').insert({
        'conversation_id': convId,
        'role': 'user',
        'content': userPrompt,
      });

      // 4. Panggil Edge Function / Gemini Service
      // Simulasi/Response Assistant (bisa dihubungkan ke Supabase Edge Function 'ai-assistant')
      final String assistantReply = await _generateResponse(userPrompt);

      // 5. Simpan balasan AI ke database
      final aiMsgRes = await _supabase.from('ai_messages').insert({
        'conversation_id': convId,
        'role': 'assistant',
        'content': assistantReply,
      }).select().single();

      final aiMsgModel = AiMessageModel.fromJson(aiMsgRes);

      final updatedMessages = state.value?.messages
          .where((m) => m.id != userMsgLocal.id)
          .toList() ??
          [];

      // Tambahkan pesan user yang tersimpan & balasan AI
      state = AsyncValue.data(
        AiChatState(
          conversationId: convId,
          messages: [
            ...updatedMessages,
            userMsgLocal,
            aiMsgModel,
          ],
          isSending: false,
        ),
      );
    } catch (e) {
      state = AsyncValue.data(
        state.value?.copyWith(isSending: false) ?? AiChatState(),
      );
    }
  }

  Future<String> _generateResponse(String prompt) async {
    // Simulasi respon asisten pintar akademis & kurikulum
    await Future.delayed(const Duration(seconds: 1));
    final lower = prompt.toLowerCase();
    if (lower.contains('kuis') || lower.contains('soal')) {
      return "Berikut adalah draf kuis 3 soal yang disesuaikan:\n\n1. Sebutkan rukun wudhu secara berurutan!\n2. Apa hukum membasuh telinga saat berwudhu?\n3. Pembatal wudhu apa yang sering tidak disadari saat beribadah?";
    } else if (lower.contains('rapor') || lower.contains('deskripsi')) {
      return "Draf Deskripsi Rapor:\n'Ananda menunjukkan peningkatan signifikan pada hafalan Juz 30. Tajwid dan makhraj huruf sudah membaik, disarankan memperkuat murojaah harian di rumah.'";
    }
    return "Saya adalah Asisten AI Space EduOS. Saya dapat membantu Anda menyusun draf deskripsi rapor, kuis CBT, dan analisis perkembangan santri.";
  }
}