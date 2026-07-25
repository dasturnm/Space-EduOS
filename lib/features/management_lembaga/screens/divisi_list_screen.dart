// Lokasi: lib/features/management_lembaga/screens/divisi_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_context_provider.dart';
import '../providers/lembaga_provider.dart'; // Ditambahkan: Import provider baru
import '../providers/unit_kerja_provider.dart';
import '../services/lembaga_seeding_service.dart';
import '../models/divisi_model.dart';

class DivisiListScreen extends ConsumerStatefulWidget {
  const DivisiListScreen({super.key});

  @override
  ConsumerState<DivisiListScreen> createState() => _DivisiListScreenState();
}

class _DivisiListScreenState extends ConsumerState<DivisiListScreen> {
  // FIX: _isLoading dan _divisiList dihapus karena sudah dikelola oleh DivisiListProvider

  void _showDivisiDialog(String lembagaId, {DivisiModel? divisi}) {
    final isEdit = divisi != null;
    final nameController = TextEditingController(text: divisi?.namaDivisi ?? '');
    final descController = TextEditingController(text: divisi?.deskripsi ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? "Edit Divisi" : "Tambah Divisi Baru", style: const TextStyle(fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Divisi",
                  hintText: "cth: Akademik, Tahfidz, SDM",
                ),
                validator: (val) => val!.isEmpty ? "Nama divisi wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: "Deskripsi",
                  hintText: "Jelaskan fungsi divisi ini",
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              final messenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);

              try {
                // UPDATE: Menggunakan DivisiModel dan Provider Notifier
                final updatedDivisi = (divisi ?? DivisiModel(
                  id: '',
                  lembagaId: lembagaId,
                  namaDivisi: nameController.text.trim(),
                )).copyWith(
                  namaDivisi: nameController.text.trim(),
                  deskripsi: descController.text.trim(),
                  status: divisi?.status ?? 'aktif',
                );

                // FIX: Akses notifier tanpa parameter (Auto AppContext)
                await ref.read(divisiListProvider.notifier).saveDivisi(updatedDivisi);

                if (!mounted) return; // FIX: use_build_context_synchronously
                navigator.pop();

                messenger.showSnackBar(
                  SnackBar(content: Text(isEdit ? "Divisi berhasil diupdate!" : "Divisi berhasil ditambahkan!")),
                );
              } catch (e) {
                if (!mounted) return;
                messenger.showSnackBar(
                  SnackBar(content: Text("Gagal menyimpan: $e")),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
            child: Text(isEdit ? "Update" : "Simpan", style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddOptionsDialog(String lembagaId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Opsi Penambahan Divisi",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Pilih cara menambahkan divisi dan struktur organisasi Anda.",
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 20),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFF1F5F9),
                  child: Icon(Icons.edit_note, color: Color(0xFF10B981)),
                ),
                title: const Text("Tambah Divisi Manual", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text("Buat 1 divisi baru secara mandiri."),
                onTap: () {
                  Navigator.pop(ctx);
                  _showDivisiDialog(lembagaId);
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: const Color(0xFF10B981).withValues(alpha: 0.5)),
                ),
                tileColor: const Color(0xFFECFDF5),
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF10B981),
                  child: Icon(Icons.auto_awesome, color: Colors.white),
                ),
                title: const Text("Gunakan Template Standar (Golden Seed)", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text("Otomatis generate 8 Divisi, Unit Kerja, & Jabatan SDD v3.1."),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmAndApplyDefaultSeed(lembagaId);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmAndApplyDefaultSeed(String lembagaId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Terapkan Template Standar?"),
        content: const Text(
          "Sistem akan menambahkan 8 Divisi standar (Pimpinan, Akademik, Kesiswaan, Keuangan, PPDB, Inventaris, Administrasi, IT) beserta Unit Kerja dan Jabatannya secara otomatis.\n\nDivisi yang sudah ada tidak akan terhapus.",
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Ya, Terapkan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!mounted) return;

      final messenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context, rootNavigator: true);
      final lembaga = ref.read(appContextProvider).lembaga;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator(color: Color(0xFF10B981))),
      );

      try {
        await LembagaSeedingService().seedUniversalOrganization(lembagaId);

        navigator.pop();

        await ref.read(appContextProvider.notifier).initContext(forceRefresh: true);
        ref.invalidate(divisiListProvider);
        ref.invalidate(unitKerjaListProvider);
        ref.invalidate(jabatanListProvider);

        if (!mounted) return;

        // Dialog Sukses dengan Tombol OK
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Berhasil", style: TextStyle(fontWeight: FontWeight.bold)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: Text("Berhasil menerapkan Template Organisasi Standar untuk lembaga: ${lembaga?.namaLembaga ?? 'Lembaga'}"),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
                onPressed: () => Navigator.pop(ctx),
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      } catch (e) {
        navigator.pop();

        if (!mounted) return;
        messenger.showSnackBar(
          SnackBar(content: Text("Gagal mengaplikasikan seed: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lembaga = ref.watch(appContextProvider).lembaga;
    if (lembaga == null) return const Center(child: CircularProgressIndicator());

    // Memantau data divisi secara reaktif
    // FIX: DivisiListProvider sekarang tidak menerima parameter
    final divisiAsync = ref.watch(divisiListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: divisiAsync.when(
        data: (divisiList) => divisiList.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: divisiList.length,
          itemBuilder: (context, index) {
            final d = divisiList[index];
            return _buildDivisiCard(d);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: FloatingActionButton.extended(
          onPressed: () => _showAddOptionsDialog(lembaga.id),
          backgroundColor: const Color(0xFF10B981),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("Tambah Divisi", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildDivisiCard(DivisiModel d) {
    final bool isAktif = d.status == 'aktif';

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
          child: Icon(Icons.account_tree_outlined, color: isAktif ? const Color(0xFF10B981) : Colors.grey),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                d.namaDivisi,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            _buildStatusChip(d.status ?? 'aktif'),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            d.deskripsi ?? "Tidak ada deskripsi",
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
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
              tooltip: isAktif ? "Nonaktifkan Divisi" : "Aktifkan Divisi",
              onPressed: () async {
                final updatedStatus = isAktif ? 'nonaktif' : 'aktif';
                final updated = d.copyWith(status: updatedStatus);
                await ref.read(divisiListProvider.notifier).saveDivisi(updated);
              },
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onSelected: (value) async {
                final lembagaId = ref.read(appContextProvider).lembaga!.id;
                if (value == 'edit') {
                  _showDivisiDialog(lembagaId, divisi: d);
                } else if (value == 'delete') {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Hapus Divisi?"),
                      content: Text("Anda yakin ingin menghapus divisi ${d.namaDivisi}?"),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Batal")),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true) {
                    await ref.read(divisiListProvider.notifier).deleteDivisi(d.id);
                  }
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
  }

  Widget _buildStatusChip(String status) {
    final bool isActive = status == 'aktif';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF10B981).withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? "AKTIF" : "NONAKTIF",
        style: TextStyle(
          color: isActive ? const Color(0xFF10B981) : Colors.grey,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_tree_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("Belum ada divisi terdaftar",
              style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}