// Lokasi: lib/features/management_lembaga/screens/unit_kerja_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_context_provider.dart';
import '../models/divisi_model.dart';
import '../models/unit_kerja_model.dart';
import '../providers/unit_kerja_provider.dart';
import '../providers/lembaga_provider.dart';

class UnitKerjaListScreen extends ConsumerStatefulWidget {
  const UnitKerjaListScreen({super.key});

  @override
  ConsumerState<UnitKerjaListScreen> createState() => _UnitKerjaListScreenState();
}

class _UnitKerjaListScreenState extends ConsumerState<UnitKerjaListScreen> {
  String _generateKodeUnit(String divisiId, String namaUnit, List<DivisiModel> divisiList) {
    final divisiName = _getDivisiName(divisiId, divisiList);
    final divPrefix = divisiName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();
    final unitPrefix = namaUnit.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();

    final p1 = divPrefix.isNotEmpty ? divPrefix[0] : 'U';
    final p2 = unitPrefix.length >= 3 ? unitPrefix.substring(0, 3) : unitPrefix.padRight(3, 'X');
    final rand = (DateTime.now().millisecondsSinceEpoch % 1000).toString().padLeft(3, '0');

    return '$p1-$p2-$rand';
  }

  Future<void> _toggleStatusUnit(UnitKerjaModel item) async {
    final newStatus = (item.status == 'aktif') ? 'nonaktif' : 'aktif';
    try {
      final updated = item.copyWith(status: newStatus);
      await ref.read(unitKerjaListProvider.notifier).saveUnitKerja(updated);
      ref.invalidate(unitKerjaListProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal mengubah status: $e")),
        );
      }
    }
  }

  void _showFormModal(String lembagaId, List<DivisiModel> divisiList, {UnitKerjaModel? item}) {
    final namaController = TextEditingController(text: item?.namaUnitKerja ?? '');
    final deskripsiController = TextEditingController(text: item?.deskripsi ?? '');
    String? selectedDivisiId = item?.divisiId ?? (divisiList.isNotEmpty ? divisiList.first.id : null);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text(item == null ? "Tambah Unit Kerja" : "Edit Unit Kerja"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedDivisiId,
                      decoration: const InputDecoration(labelText: "Divisi Induk *"),
                      items: divisiList.map((d) {
                        return DropdownMenuItem(
                          value: d.id,
                          child: Text(d.namaDivisi),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setModalState(() => selectedDivisiId = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: namaController,
                      decoration: const InputDecoration(
                        labelText: "Nama Unit Kerja *",
                        hintText: "Misal: Koordinator Akademik",
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: deskripsiController,
                      decoration: const InputDecoration(
                        labelText: "Deskripsi (Opsional)",
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
                  onPressed: () async {
                    if (namaController.text.trim().isEmpty || selectedDivisiId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Lengkapi bidang wajib (*)")),
                      );
                      return;
                    }

                    try {
                      final updatedUnit = (item ?? UnitKerjaModel(
                        id: '',
                        lembagaId: lembagaId,
                        divisiId: selectedDivisiId!,
                        namaUnitKerja: namaController.text.trim(),
                      )).copyWith(
                        divisiId: selectedDivisiId!,
                        namaUnitKerja: namaController.text.trim(),
                        deskripsi: deskripsiController.text.trim(),
                        status: item?.status ?? 'aktif',
                        kodeUnit: item == null ? _generateKodeUnit(selectedDivisiId!, namaController.text.trim(), divisiList) : item.kodeUnit,
                      );

                      await ref.read(unitKerjaListProvider.notifier).saveUnitKerja(updatedUnit);
                      ref.invalidate(unitKerjaListProvider);

                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Gagal menyimpan: $e")),
                        );
                      }
                    }
                  },
                  child: const Text("Simpan", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteUnit(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Unit Kerja"),
        content: const Text("Apakah Anda yakin ingin menghapus unit kerja ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ref.read(unitKerjaListProvider.notifier).deleteUnitKerja(id);
        ref.invalidate(unitKerjaListProvider);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal menghapus: $e")),
          );
        }
      }
    }
  }

  String _getDivisiName(String divisiId, List<DivisiModel> divisiList) {
    final div = divisiList.firstWhere(
          (d) => d.id == divisiId,
      orElse: () => DivisiModel(id: '', lembagaId: '', namaDivisi: 'Divisi Tidak Ditemukan'),
    );
    return div.namaDivisi;
  }

  @override
  Widget build(BuildContext context) {
    final lembaga = ref.watch(appContextProvider).lembaga;
    if (lembaga == null) return const Center(child: CircularProgressIndicator());

    final unitKerjaAsync = ref.watch(unitKerjaListProvider);
    final divisiAsync = ref.watch(divisiListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: FloatingActionButton.extended(
          onPressed: () => divisiAsync.whenData((divisiList) => _showFormModal(lembaga.id, divisiList)),
          backgroundColor: const Color(0xFF10B981),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("Tambah Unit Kerja", style: TextStyle(color: Colors.white)),
        ),
      ),
      body: unitKerjaAsync.when(
        data: (unitList) => divisiAsync.when(
          data: (divisiList) => unitList.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.corporate_fare_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                const Text("Belum ada unit kerja terdaftar", style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: unitList.length,
            itemBuilder: (context, index) {
              final item = unitList[index];
              final isAktif = item.status == 'aktif';
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isAktif ? const Color(0xFF10B981).withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.corporate_fare_outlined, color: isAktif ? const Color(0xFF10B981) : Colors.grey),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.namaUnitKerja,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isAktif ? const Color(0xFF10B981).withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isAktif ? "AKTIF" : "NONAKTIF",
                          style: TextStyle(
                            color: isAktif ? const Color(0xFF10B981) : Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Divisi: ${_getDivisiName(item.divisiId, divisiList)}",
                          style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.deskripsi ?? "Tidak ada deskripsi",
                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          isAktif ? Icons.toggle_on : Icons.toggle_off,
                          color: isAktif ? const Color(0xFF10B981) : Colors.grey,
                          size: 28,
                        ),
                        tooltip: isAktif ? "Nonaktifkan Unit" : "Aktifkan Unit",
                        onPressed: () => _toggleStatusUnit(item),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showFormModal(lembaga.id, divisiList, item: item);
                          } else if (value == 'delete') {
                            _deleteUnit(item.id);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined, color: Colors.grey, size: 20),
                                SizedBox(width: 8),
                                Text("Edit"),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                SizedBox(width: 8),
                                Text("Hapus", style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF10B981))),
          error: (err, _) => Center(child: Text("Error Divisi: $err")),
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF10B981))),
        error: (err, _) => Center(child: Text("Error Unit Kerja: $err")),
      ),
    );
  }
}