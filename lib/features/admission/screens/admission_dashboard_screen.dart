import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pendaftaran_model.dart';
import '../providers/admission_provider.dart';
import '../../siswa/widgets/enroll_kurikulum_dialog.dart';
import '../../siswa/models/siswa_model.dart';

class AdmissionDashboardScreen extends ConsumerWidget {
  const AdmissionDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(admissionStatusFilterProvider);
    final pendaftarAsync = ref.watch(admissionListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Penerimaan Santri Baru (Admission)'),
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filter Chips Status
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildFilterChip(ref, label: 'Semua', value: '', selectedValue: selectedFilter),
                _buildFilterChip(ref, label: 'Registrasi', value: 'registrasi', selectedValue: selectedFilter),
                _buildFilterChip(ref, label: 'Verifikasi', value: 'verifikasi', selectedValue: selectedFilter),
                _buildFilterChip(ref, label: 'Approval', value: 'approval', selectedValue: selectedFilter),
                _buildFilterChip(ref, label: 'Enrolled', value: 'enrolled', selectedValue: selectedFilter),
                _buildFilterChip(ref, label: 'Ditolak', value: 'ditolak', selectedValue: selectedFilter),
              ],
            ),
          ),

          const Divider(height: 1),

          // Daftar Pendaftar
          Expanded(
            child: pendaftarAsync.when(
              data: (list) {
                if (list.isEmpty) {
                  return const Center(
                    child: Text('Belum ada data pendaftar.'),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return _PendaftarCard(pendaftar: item);
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

  Widget _buildFilterChip(
      WidgetRef ref, {
        required String label,
        required String value,
        required String selectedValue,
      }) {
    final isSelected = value == selectedValue;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: const Color(0xFF10B981).withValues(alpha: 0.2),
        checkmarkColor: const Color(0xFF10B981),
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFF10B981) : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        onSelected: (_) {
          ref.read(admissionStatusFilterProvider.notifier).setStatus(value);
        },
      ),
    );
  }
}

class _PendaftarCard extends ConsumerWidget {
  final PendaftaranModel pendaftar;

  const _PendaftarCard({required this.pendaftar});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'registrasi':
        return Colors.orange;
      case 'verifikasi':
        return Colors.blue;
      case 'approval':
        return Colors.purple;
      case 'enrolled':
        return const Color(0xFF10B981);
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _updateStatus(BuildContext context, WidgetRef ref, String newStatus, {String? keterangan}) async {
    try {
      final service = ref.read(admissionServiceProvider);
      await service.updateStatus(pendaftar.id, newStatus, catatanAdmin: keterangan);
      ref.invalidate(admissionListProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status berhasil diubah ke $newStatus')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengupdate status: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _handleEnroll(BuildContext context, WidgetRef ref) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final service = ref.read(admissionServiceProvider);
      final studentId = await service.enrollStudentFromAdmission(pendaftar);

      if (context.mounted) {
        Navigator.pop(context); // Tutup dialog loading
        ref.invalidate(admissionListProvider);

        final siswaSut = SiswaModel(
          id: studentId,
          lembagaId: pendaftar.organizationId,
          namaLengkap: pendaftar.namaLengkap,
          jenisKelamin: pendaftar.jenisKelamin ?? 'L',
          alamat: pendaftar.alamat,
        );

        // Panggil EnrollKurikulumDialog untuk plotting kurikulum awal
        showDialog(
          context: context,
          builder: (ctx) => EnrollKurikulumDialog(siswa: siswaSut),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal Enroll: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showRejectDialog(BuildContext context, WidgetRef ref) {
    final catatanController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Tolak Pendaftaran'),
            content: Form(
              key: formKey,
              child: TextFormField(
                controller: catatanController,
                decoration: const InputDecoration(
                  labelText: 'Catatan Penolakan *',
                  hintText: 'Alasan penolakan pendaftaran...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (val) => val == null || val.trim().isEmpty ? 'Catatan penolakan wajib diisi' : null,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    final reason = catatanController.text.trim();
                    Navigator.pop(dialogCtx);
                    _updateStatus(context, ref, 'ditolak', keterangan: reason);
                  }
                },
                child: const Text('Tolak', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _getStatusColor(pendaftar.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    pendaftar.namaLengkap,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    pendaftar.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Wali: ${pendaftar.namaWali} (${pendaftar.noHpWali})', style: const TextStyle(color: Colors.black87)),
            if (pendaftar.alamat != null)
              Text('Alamat: ${pendaftar.alamat}', style: const TextStyle(color: Colors.grey)),
            if (pendaftar.catatanAdmin != null && pendaftar.catatanAdmin!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text('Catatan: ${pendaftar.catatanAdmin}', style: const TextStyle(color: Colors.red, fontStyle: FontStyle.italic)),
            ],
            const SizedBox(height: 12),

            // Tombol Aksi berdasarkan Status
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (pendaftar.status == 'registrasi') ...[
                  OutlinedButton(
                    onPressed: () => _updateStatus(context, ref, 'verifikasi'),
                    child: const Text('Verifikasi'),
                  ),
                ],
                if (pendaftar.status == 'verifikasi') ...[
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: () => _showRejectDialog(context, ref),
                    child: const Text('Tolak'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
                    onPressed: () => _updateStatus(context, ref, 'approval'),
                    child: const Text('Setujui', style: TextStyle(color: Colors.white)),
                  ),
                ],
                if (pendaftar.status == 'approval') ...[
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
                    onPressed: () => _handleEnroll(context, ref),
                    icon: const Icon(Icons.school, color: Colors.white, size: 18),
                    label: const Text('Proses Enroll', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}