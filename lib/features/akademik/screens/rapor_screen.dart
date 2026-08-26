import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/rapor_provider.dart';
import '../widgets/rapor_grade_card.dart';
import '../widgets/rapor_performance_chart.dart';

class RaporScreen extends ConsumerWidget {
  final String studentId;
  final String termId;

  const RaporScreen({
    super.key,
    required this.studentId,
    required this.termId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final raporAsync = ref.watch(raporProvider(studentId, termId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Rapor Akademik Teragregasi'),
      ),
      body: raporAsync.when(
        data: (rapor) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RaporGradeCard(
                  scoreTahfidz: rapor.scoreTahfidz,
                  scoreLms: rapor.scoreLms,
                  finalScore: rapor.finalScore,
                  gradeLetter: rapor.gradeLetter,
                ),
                const SizedBox(height: 16),
                RaporPerformanceChart(history: rapor.history),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Catatan Evaluasi Akademik',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          rapor.finalScore >= 80.0
                              ? 'Perkembangan hafalan Al-Qur\'an dan pencapaian akademik modul sangat baik. Pertahankan kedisiplinan dan konsistensi muraja\'ah.'
                              : 'Memerlukan bimbingan tambahan pada sesi muraja\'ah dan penyelesaian tugas LMS.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade800,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Gagal memuat E-Rapor: $err'),
          ),
        ),
      ),
    );
  }
}