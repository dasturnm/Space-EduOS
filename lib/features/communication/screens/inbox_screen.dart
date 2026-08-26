import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/communication_provider.dart';
import '../widgets/inbox_tile.dart';

class InboxScreen extends ConsumerWidget {
  final String userId;

  const InboxScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inboxAsync = ref.watch(inboxStreamProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan & Notifikasi'),
      ),
      body: inboxAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return const Center(
              child: Text('Belum ada pesan atau notifikasi.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final item = notifications[index];
              return InboxTile(
                notification: item,
                onTap: () async {
                  if (!item.isRead) {
                    await ref
                        .read(communicationServiceProvider)
                        .markAsRead(item.id, userId);
                  }
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(item.title),
                        content: SingleChildScrollView(
                          child: Text(item.message),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tutup'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Gagal memuat inbox: $err'),
          ),
        ),
      ),
    );
  }
}