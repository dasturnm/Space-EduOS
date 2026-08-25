import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/parent_provider.dart';
import '../../siswa/models/siswa_model.dart';

class WaliChildSelector extends ConsumerWidget {
  const WaliChildSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childrenAsync = ref.watch(parentChildrenProvider);
    final selectedChild = ref.watch(selectedChildProvider);

    return childrenAsync.when(
      data: (children) {
        if (children.isEmpty) {
          return const SizedBox.shrink();
        }

        // Auto-select anak pertama jika belum ada yang dipilih
        if (selectedChild == null && children.isNotEmpty) {
          Future.microtask(() {
            ref.read(selectedChildProvider.notifier).selectChild(children.first);
          });
        }

        final currentSelection = selectedChild ?? children.first;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.child_care, color: Color(0xFF10B981)),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<SiswaModel>(
                    value: children.any((c) => c.id == currentSelection.id)
                        ? children.firstWhere((c) => c.id == currentSelection.id)
                        : children.first,
                    isExpanded: true,
                    items: children.map((child) {
                      return DropdownMenuItem<SiswaModel>(
                        value: child,
                        child: Text(
                          child.namaLengkap,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (newChild) {
                      if (newChild != null) {
                        ref.read(selectedChildProvider.notifier).selectChild(newChild);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(
        height: 40,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}