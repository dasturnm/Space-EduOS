import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/program_model.dart';
import '../screens/program_detail_screen.dart';
import '../screens/program_form_screen.dart'; // Baru
import '../providers/agenda_provider.dart';
import '../providers/program_provider.dart'; // Tambahan untuk fungsi hapus
import '../services/effective_day_service.dart';
import '../../../core/providers/app_context_provider.dart';
import '../providers/calendar_summary_provider.dart';
// Baru

class ProgramCard extends ConsumerWidget {
  final ProgramModel program;
  final VoidCallback? onTap;

  const ProgramCard({super.key, required this.program, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- LOGIKA HITUNG HARI EFEKTIF (Berdasarkan Tahun Ajaran Aktif) ---
    final activeTA = ref.watch(appContextProvider).currentTahunAjaran;
    final agendaAsync = ref.watch(agendaProvider(activeTA?.id, null));
    int effectiveDays = 0;

    if (activeTA != null && activeTA.tanggalMulai != null && activeTA.tanggalSelesai != null) {
      agendaAsync.whenData((agendas) {
        effectiveDays = EffectiveDayService.calculateEffectiveDays(
          startDate: activeTA.tanggalMulai!,
          endDate: activeTA.tanggalSelesai!,
          hariAktifProgram: program.hariAktif,
          allAgendas: agendas,
          targetProgramId: program.id,
        );
      });
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, ref, effectiveDays), // Ditambahkan ref
                  const SizedBox(height: 12),
                  Text(
                    program.deskripsi ?? '',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildInvestasiSection()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildJadwalSection(effectiveDays)), // Menambahkan parameter
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildRingkasanKaldikSection(ref),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildFooterAction(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, int effectiveDays) { // Signature diubah (tambah ref)
    // 🔥 FIX: Menggunakan hasil relasi dari backend (hasKurikulum) tanpa perlu watch provider lain yang salah ID
    final bool hasKurikulum = program.hasKurikulum;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFF10B981), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.auto_stories_outlined, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                program.namaProgram,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  // INDIKATOR STATUS KURIKULUM (Otomatis dari Database Relational)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: hasKurikulum
                          ? const Color(0xFF10B981).withValues(alpha: 0.1)
                          : Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      hasKurikulum ? "KURIKULUM AKTIF" : "KURIKULUM BELUM DIATUR",
                      style: TextStyle(
                        color: hasKurikulum ? const Color(0xFF10B981) : Colors.orange,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            // PERBAIKAN: InkWell ikon edit dengan navigasi yang berfungsi
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProgramFormScreen(program: program),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.edit_outlined, color: Colors.grey, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _showDeleteConfirmation(context, ref),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Program Pendidikan?", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text("Anda yakin ingin menghapus program pendidikan '${program.namaProgram}'? Data yang sudah dihapus tidak dapat dikembalikan."),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);

              final success = await ref
                  .read(programProvider.notifier)
                  .deleteProgram(program.id);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Program pendidikan berhasil dihapus'
                        : 'Gagal menghapus program pendidikan. Pastikan tidak ada data siswa atau kelas yang terhubung.'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, elevation: 0),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestasiSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("BIAYA PROGRAM PENDIDIKAN", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
        const SizedBox(height: 12),
        _buildPriceRow("Pendaftaran", program.biayaPendaftaran),
        _buildPriceRow("SPP / Bulan", program.biayaSpp),
      ],
    );
  }

  Widget _buildPriceRow(String label, double price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          Text("Rp ${price.toInt()}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
        ],
      ),
    );
  }

  Widget _buildJadwalSection(int effectiveDays) {
    final listHari = ['S', 'S', 'R', 'K', 'J', 'S', 'M'];
    final mappingHari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("TEMPLATE JADWAL", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: List.generate(listHari.length, (i) {
            bool isActive = program.hariAktif.contains(mappingHari[i]);
            return Container(
              width: 28, height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF10B981) : Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(listHari[i], style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
            );
          }),
        ),
        const SizedBox(height: 12),
        // HARI EFEKTIF: Menggunakan FittedBox untuk mencegah overflow piksel
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.flash_on, size: 14, color: Colors.orange),
                const SizedBox(width: 4),
                Text(
                  "$effectiveDays HARI EFEKTIF",
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRingkasanKaldikSection(WidgetRef ref) {
    final appContext = ref.watch(appContextProvider);
    final tahunAjaran = appContext.currentTahunAjaran;
    final String labelTahun = tahunAjaran?.labelTahun ?? '-';

    String periodeStr = '-';
    String bulanBelajarStr = '-';

    if (tahunAjaran != null && tahunAjaran.tanggalMulai != null && tahunAjaran.tanggalSelesai != null) {
      final tMulai = tahunAjaran.tanggalMulai!;
      final tSelesai = tahunAjaran.tanggalSelesai!;
      periodeStr = "${DateFormat('dd MMM yyyy', 'id_ID').format(tMulai)} - ${DateFormat('dd MMM yyyy', 'id_ID').format(tSelesai)}";

      int months = ((tSelesai.year - tMulai.year) * 12) + tSelesai.month - tMulai.month + 1;
      if (months > 0) {
        bulanBelajarStr = "$months Bulan";
      }
    }

    final summaryAsync = ref.watch(calendarSummaryProvider(program.id));

    String totalHariEfektifStr = "-";
    String totalHariLiburStr = "-";

    summaryAsync.whenData((summary) {
      totalHariEfektifStr = summary.netHariEfektif > 0 ? "${summary.netHariEfektif}" : "-";
      totalHariLiburStr = "${summary.totalHariLiburAgenda}";
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_outlined, color: Colors.blue, size: 18),
              const SizedBox(width: 8),
              const Text(
                "RINGKASAN KALDIK",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.blue, letterSpacing: 0.5),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  ref.invalidate(calendarSummaryProvider(program.id));
                },
                icon: const Icon(Icons.refresh_rounded, size: 18, color: Colors.blue),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const Divider(color: Colors.white, height: 20, thickness: 1.5),
          _buildKaldikRow("Tahun Ajaran", labelTahun),
          const SizedBox(height: 6),
          _buildKaldikRow("Periode", periodeStr),
          const SizedBox(height: 6),
          _buildKaldikRow("Bulan Belajar", bulanBelajarStr),
          const SizedBox(height: 6),
          _buildKaldikRow("Total Hari Efektif", totalHariEfektifStr),
          const SizedBox(height: 6),
          _buildKaldikRow("Total Hari Libur", totalHariLiburStr),
        ],
      ),
    );
  }

  Widget _buildKaldikRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.w600)),
        Text(value, style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _buildFooterAction(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProgramDetailScreen(program: program),
          ),
        );
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("Detail Program Pendidikan", style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(width: 4),
          Icon(Icons.arrow_forward, color: Color(0xFF10B981), size: 16),
        ],
      ),
    );
  }
}
