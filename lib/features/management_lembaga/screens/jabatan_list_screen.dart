// Lokasi: lib/features/management_lembaga/screens/jabatan_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/providers/app_context_provider.dart';
import '../../../core/constants/permissions_constant.dart';
import '../providers/lembaga_provider.dart';
import '../providers/unit_kerja_provider.dart';
import '../models/jabatan_model.dart';
import '../models/divisi_model.dart';
import '../models/unit_kerja_model.dart';

class JabatanListScreen extends ConsumerStatefulWidget {
  const JabatanListScreen({super.key});

  @override
  ConsumerState<JabatanListScreen> createState() => _JabatanListScreenState();
}

class _JabatanListScreenState extends ConsumerState<JabatanListScreen> {

  Future<void> _showJabatanDialog(String lembagaId, {JabatanModel? jabatan}) async {
    final divisiList = ref.read(divisiListProvider).value ?? [];

    if (divisiList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Buat divisi terlebih dahulu sebelum menambah jabatan.")),
      );
      return;
    }

    // AMBIL DATA UNIT KERJA LANGSUNG DARI SUPABASE (Bypass Provider)
    List<UnitKerjaModel> unitKerjaList = [];
    try {
      final supabase = Supabase.instance.client;
      final unitData = await supabase
          .from('unit_kerja')
          .select()
          .eq('lembaga_id', lembagaId)
          .order('nama_unit_kerja');

      unitKerjaList = (unitData as List).map((e) => UnitKerjaModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Gagal mengambil data unit kerja: $e");
    }

    if (!mounted) return;

    final isEdit = jabatan != null;
    final nameController = TextEditingController(text: jabatan?.namaJabatan ?? '');
    int selectedLevel = jabatan?.levelJabatan ?? 4;
    final catatanController = TextEditingController(text: jabatan?.catatanJabatan ?? '');
    String? selectedDivisiId = jabatan?.divisiId ?? (divisiList.isNotEmpty ? divisiList.first.id : null);

    // Otomatis pilih unit kerja pertama jika belum ada atau kosong
    String? selectedUnitKerjaId;
    if (jabatan?.unitKerjaId != null && unitKerjaList.any((u) => u.id == jabatan!.unitKerjaId && u.divisiId == selectedDivisiId)) {
      selectedUnitKerjaId = jabatan!.unitKerjaId;
    } else {
      final defaultUnits = unitKerjaList.where((u) => u.divisiId == selectedDivisiId).toList();
      selectedUnitKerjaId = defaultUnits.isNotEmpty ? defaultUnits.first.id : null;
    }

    String selectedRole = jabatan?.defaultRole ?? 'GURU';
    final formKey = GlobalKey<FormState>();

    // Load 23 Permission Unik dari PermissionsConstant
    final Map<String, bool> permissionStates = {
      for (var perm in PermissionsConstant.allPermissions) perm.code: false
    };

    if (jabatan?.permissions != null) {
      for (var perm in jabatan!.permissions!) {
        if (permissionStates.containsKey(perm)) {
          permissionStates[perm] = true;
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final filteredUnitKerja = unitKerjaList
              .where((u) => u.divisiId == selectedDivisiId)
              .toList();

          return AlertDialog(
            title: Text(isEdit ? "Edit Jabatan" : "Tambah Jabatan Baru", style: const TextStyle(fontWeight: FontWeight.bold)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: "Nama Jabatan", hintText: "cth: Musyrif Tahfidz"),
                        validator: (val) => val!.isEmpty ? "Nama jabatan wajib diisi" : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedDivisiId,
                        decoration: const InputDecoration(labelText: "Pilih Divisi *"),
                        items: divisiList.map((d) => DropdownMenuItem(
                          value: d.id,
                          child: Text(d.namaDivisi),
                        )).toList(),
                        onChanged: (val) {
                          setDialogState(() {
                            selectedDivisiId = val;
                            // Otomatis pilih unit kerja pertama dari divisi baru
                            final defaultUnits = unitKerjaList.where((u) => u.divisiId == val).toList();
                            selectedUnitKerjaId = defaultUnits.isNotEmpty ? defaultUnits.first.id : null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String?>(
                        value: selectedUnitKerjaId,
                        decoration: const InputDecoration(labelText: "Pilih Unit Kerja (Opsional)"),
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text("- Tanpa Unit Kerja -", style: TextStyle(color: Colors.grey)),
                          ),
                          ...filteredUnitKerja.map((u) => DropdownMenuItem<String?>(
                            value: u.id,
                            child: Text(u.namaUnitKerja),
                          )),
                        ],
                        onChanged: (val) => setDialogState(() => selectedUnitKerjaId = val),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        decoration: const InputDecoration(labelText: "Hak Akses Default (Role)"),
                        items: const [
                          DropdownMenuItem(value: 'ADMIN_PUSAT', child: Text("Admin Pusat")),
                          DropdownMenuItem(value: 'ADMIN_CABANG', child: Text("Admin Cabang")),
                          DropdownMenuItem(value: 'GURU', child: Text("Guru / Pengajar")),
                          DropdownMenuItem(value: 'STAFF', child: Text("Staff Administrasi")),
                        ],
                        onChanged: (val) => setDialogState(() => selectedRole = val!),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              isExpanded: true,
                              value: selectedLevel,
                              decoration: const InputDecoration(labelText: "Hierarki / Level Jabatan"),
                              items: const [
                                DropdownMenuItem(value: 1, child: Text("Level 1 (Pimpinan Pusat)")),
                                DropdownMenuItem(value: 2, child: Text("Level 2 (Pimpinan Unit/Cabang)")),
                                DropdownMenuItem(value: 3, child: Text("Level 3 (Staf Ahli/Koordinator)")),
                                DropdownMenuItem(value: 4, child: Text("Level 4 (Pelaksana Teknis)")),
                                DropdownMenuItem(value: 5, child: Text("Level 5 (Staf Pendukung)")),
                              ],
                              onChanged: (val) => setDialogState(() => selectedLevel = val!),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.info_outline, color: Colors.blue),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Keterangan Level Jabatan"),
                                  content: const Text(
                                    "• Level 1: Direktur, Ketua Yayasan, Mudir\n"
                                        "• Level 2: Kepala Cabang, Kepala Sekolah\n"
                                        "• Level 3: Kurikulum, Bendahara, Koordinator Guru\n"
                                        "• Level 4: Guru, Pengajar, Administrasi\n"
                                        "• Level 5: Keamanan, Kebersihan, Driver",
                                    style: TextStyle(fontSize: 13, height: 1.5),
                                  ),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Mengerti")),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: catatanController,
                        decoration: const InputDecoration(labelText: "Catatan Jabatan", hintText: "Tugas utama atau wewenang..."),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Daftar Izin & Wewenang (PBAC - Permissions):",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 260,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          children: PermissionsConstant.getGroupedPermissions().entries.map((group) {
                            return ExpansionTile(
                              dense: true,
                              initiallyExpanded: true,
                              title: Text(
                                group.key,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF10B981)),
                              ),
                              children: group.value.map((item) {
                                return CheckboxListTile(
                                  dense: true,
                                  title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Fitur: ${item.feature}", style: TextStyle(fontSize: 11, color: Colors.blue.shade700, fontWeight: FontWeight.w500)),
                                      Text(item.description, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                    ],
                                  ),
                                  value: permissionStates[item.code] ?? false,
                                  onChanged: (bool? val) {
                                    setDialogState(() {
                                      permissionStates[item.code] = val ?? false;
                                    });
                                  },
                                );
                              }).toList(),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;

                  final messenger = ScaffoldMessenger.of(context);
                  final navigator = Navigator.of(context);

                  final activePermissions = permissionStates.entries
                      .where((e) => e.value == true)
                      .map((e) => e.key)
                      .toList();

                  try {
                    final updatedJabatan = (jabatan ?? JabatanModel(
                      id: '',
                      lembagaId: lembagaId,
                      divisiId: selectedDivisiId!,
                      unitKerjaId: selectedUnitKerjaId,
                      namaJabatan: nameController.text.trim(),
                      defaultRole: selectedRole,
                      permissions: activePermissions,
                    )).copyWith(
                      divisiId: selectedDivisiId!,
                      unitKerjaId: selectedUnitKerjaId,
                      namaJabatan: nameController.text.trim(),
                      defaultRole: selectedRole,
                      levelJabatan: selectedLevel,
                      catatanJabatan: catatanController.text.trim(),
                      status: jabatan?.status ?? 'aktif',
                      permissions: activePermissions,
                    );

                    await ref.read(jabatanListProvider.notifier).saveJabatan(updatedJabatan);
                    ref.invalidate(jabatanListProvider);

                    if (!mounted) return;
                    navigator.pop();

                    messenger.showSnackBar(
                      SnackBar(content: Text(isEdit ? "Jabatan berhasil diupdate!" : "Jabatan berhasil ditambahkan!")),
                    );
                  } catch (e) {
                    if (!mounted) return;
                    messenger.showSnackBar(
                      SnackBar(content: Text("Gagal menyimpan: $e")),
                    );
                  }
                },
                child: Text(isEdit ? "Update" : "Simpan", style: const TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lembaga = ref.watch(appContextProvider).lembaga;
    if (lembaga == null) return const Center(child: CircularProgressIndicator());

    final jabatanAsync = ref.watch(jabatanListProvider);
    final divisiAsync = ref.watch(divisiListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: jabatanAsync.when(
        data: (jabatanList) => divisiAsync.when(
          data: (divisiList) => jabatanList.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: jabatanList.length,
            itemBuilder: (context, index) {
              final j = jabatanList[index];
              final namaDivisi = divisiList.firstWhere(
                    (d) => d.id == j.divisiId,
                orElse: () => DivisiModel(id: '', lembagaId: '', namaDivisi: 'N/A'),
              ).namaDivisi;

              return _buildJabatanCard(j, namaDivisi);
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text("Error Divisi: $err")),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error Jabatan: $err")),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: FloatingActionButton.extended(
          onPressed: () => _showJabatanDialog(lembaga.id),
          backgroundColor: const Color(0xFF10B981),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("Tambah Jabatan", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildJabatanCard(JabatanModel j, String namaDivisi) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.work_outline, color: Colors.blue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    j.namaJabatan,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          namaDivisi,
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.circle, size: 4, color: Colors.grey),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          j.defaultRole,
                          style: const TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (j.catatanJabatan != null && j.catatanJabatan!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        j.catatanJabatan!,
                        style: TextStyle(color: Colors.grey[500], fontSize: 12, fontStyle: FontStyle.italic),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onSelected: (value) async {
                final lembagaId = ref.read(appContextProvider).lembaga!.id;
                if (value == 'detail') {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(j.namaJabatan),
                      content: Text(j.catatanJabatan ?? "Tidak ada keterangan tambahan."),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Tutup")),
                      ],
                    ),
                  );
                } else if (value == 'edit') {
                  _showJabatanDialog(lembagaId, jabatan: j);
                } else if (value == 'delete') {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Hapus Jabatan?"),
                      content: Text("Anda yakin ingin menghapus jabatan ${j.namaJabatan}?"),
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
                    await ref.read(jabatanListProvider.notifier).deleteJabatan(j.id);
                  }
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'detail',
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text("Detail"),
                    ],
                  ),
                ),
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

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_history_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text("Belum ada jabatan terdaftar", style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}