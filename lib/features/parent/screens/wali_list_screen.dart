import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/providers/app_context_provider.dart';
import '../models/wali_model.dart';
import '../services/parent_service.dart';

final parentServiceProvider = Provider<ParentService>((ref) => ParentService());
final parentSearchQueryProvider = StateProvider<String>((ref) => '');

final waliListProvider = FutureProvider.autoDispose<List<WaliModel>>((ref) async {
  final service = ref.watch(parentServiceProvider);
  final appContext = ref.watch(appContextProvider);
  final query = ref.watch(parentSearchQueryProvider);

  final lembagaId = appContext.lembaga?.id ?? '';
  if (lembagaId.isEmpty) return [];

  return await service.getWaliList(lembagaId, searchQuery: query);
});

class WaliListScreen extends ConsumerWidget {
  const WaliListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waliListAsync = ref.watch(waliListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Wali Santri'),
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari nama wali...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF10B981)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                ref.read(parentSearchQueryProvider.notifier).state = value;
              },
            ),
          ),
          Expanded(
            child: waliListAsync.when(
              data: (list) {
                if (list.isEmpty) {
                  return const Center(child: Text('Data wali tidak ditemukan.'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final wali = list[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF10B981),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(wali.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('No HP: ${wali.phone}'),
                            if (wali.anakList.isNotEmpty)
                              Text(
                                'Anak: ${wali.anakList.join(", ")}',
                                style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w500),
                              )
                            else
                              const Text('Anak: Belum terhubung', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
