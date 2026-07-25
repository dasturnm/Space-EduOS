// Lokasi: lib/features/akademik/kurikulum/screens/components/modul_estimation_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../program/providers/program_provider.dart';
import '../../../../program/providers/agenda_provider.dart';
// FIX PATH: Menyesuaikan kedalaman folder dari /screens/components/ ke /providers/
import '../../providers/kurikulum_provider.dart';
import '../../../../../core/providers/app_context_provider.dart';
import '../../../../program/providers/calendar_summary_provider.dart';

class ModulEstimationCard extends ConsumerWidget {
  final String levelId;
  final String programIdFromLevel;
  final String targetPertemuan;
  final VoidCallback onRefresh;

  const ModulEstimationCard({
    super.key,
    required this.levelId,
    required this.programIdFromLevel,
    required this.targetPertemuan,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String totalMeetings = targetPertemuan.isEmpty ? "0" : targetPertemuan;

    // 1. Ambil Data Context (Tahun Ajaran & Lembaga)
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

    // 2. Cari Program ID yang Tepat
    final lembagaId = appContext.lembaga?.id ?? '';
    final kurikulumList = ref.watch(kurikulumListProvider(lembagaId)).value ?? [];
    String? targetProgramId;

    for (var k in kurikulumList) {
      if (k.jenjang.any((j) => j.level.any((l) => l.id == levelId))) {
        targetProgramId = k.programId;
        break;
      }
    }

    final String finalProgramId = targetProgramId ?? programIdFromLevel;

    // 3. Panggil calendarSummaryProvider untuk data Efektif & Estimasi
    String totalHariEfektifStr = "-";
    String totalHariLiburStr = "-";
    String estimatedDate = "-";
    bool showWarningAlert = false;
    String? warningText;

    if (finalProgramId.isNotEmpty && finalProgramId != 'null') {
      final summaryAsync = ref.watch(calendarSummaryProvider(finalProgramId));

      summaryAsync.when(
        data: (summary) {
          totalHariEfektifStr = summary.netHariEfektif > 0 ? "${summary.netHariEfektif}" : "-";
          totalHariLiburStr = "${summary.totalHariLiburAgenda}";

          int meetingsNeeded = int.tryParse(targetPertemuan) ?? 0;
          if (meetingsNeeded <= 0) {
            estimatedDate = "-";
          } else if (summary.daftarHariBelajar.isEmpty) {
            estimatedDate = "Jadwal Belum Diatur";
          } else if (meetingsNeeded <= summary.daftarHariBelajar.length) {
            final targetDate = summary.daftarHariBelajar[meetingsNeeded - 1];
            estimatedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(targetDate);
          } else {
            int remaining = meetingsNeeded - summary.daftarHariBelajar.length;
            DateTime current = summary.daftarHariBelajar.last;
            final activeWeekdays = summary.daftarHariBelajar.map((d) => d.weekday).toSet();
            if (activeWeekdays.isEmpty) activeWeekdays.addAll([1, 2, 3, 4, 5]);

            while (remaining > 0) {
              current = current.add(const Duration(days: 1));
              if (activeWeekdays.contains(current.weekday)) {
                remaining--;
              }
            }

            estimatedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(current);
            showWarningAlert = true;
            final taEndStr = tahunAjaran?.tanggalSelesai != null
                ? DateFormat('dd MMM yyyy', 'id_ID').format(tahunAjaran!.tanggalSelesai!)
                : "Tahun Ajaran";
            warningText = "Modul ini diperkirakan selesai melebihi rentang Tahun Ajaran aktif ($taEndStr). Silakan sesuaikan kembali target pertemuan atau volume materi.";
          }
        },
        loading: () {
          totalHariEfektifStr = "...";
          totalHariLiburStr = "...";
          estimatedDate = "Menghitung...";
        },
        error: (_, __) {
          totalHariEfektifStr = "-";
          totalHariLiburStr = "-";
          estimatedDate = "Jadwal Belum Diatur";
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue[100]!)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics_outlined, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                const Text("RINGKASAN AKADEMIK", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.blue, letterSpacing: 1)),
                const Spacer(),
                IconButton(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh_rounded, size: 20, color: Colors.blue),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const Divider(color: Colors.white, height: 24, thickness: 2),
            _buildRow("Tahun Ajaran", labelTahun),
            const SizedBox(height: 8),
            _buildRow("Periode", periodeStr),
            const SizedBox(height: 8),
            _buildRow("Bulan Belajar", bulanBelajarStr),
            const SizedBox(height: 8),
            _buildRow("Total Hari Efektif", totalHariEfektifStr),
            const SizedBox(height: 8),
            _buildRow("Total Hari Libur", totalHariLiburStr),
            const Divider(color: Colors.white, height: 24, thickness: 2),
            _buildRow("Target Pertemuan", "$totalMeetings Kali"),
            const SizedBox(height: 8),
            _buildRow("Estimasi Lulus", estimatedDate),
            if (showWarningAlert && warningText != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber[300]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.amber[900], size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        warningText!,
                        style: TextStyle(fontSize: 12, color: Colors.amber[900], fontWeight: FontWeight.w600, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.blueGrey, fontWeight: FontWeight.w600)),
        // FIX: Tampilkan "-" jika belum ada input agar tidak terlihat seperti loading terus menerus (Poin 3)
        Text((value == "0 Kali" || value == "0" || value == "-") ? "-" : value, style: const TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.w900)),
      ],
    );
  }
}