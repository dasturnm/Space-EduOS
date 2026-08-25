import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:space_eduos/features/mutabaah/services/mutabaah_service.dart';
import 'package:space_eduos/features/mutabaah/services/layanan_status_modul.dart';
import 'package:space_eduos/features/akademik/kurikulum/models/modul_model.dart';

// Class tiruan aman untuk memenuhi dependensi SupabaseClient & MutabaahService
class FakeSupabaseClient extends Fake implements SupabaseClient {}

void main() {
  group('Timeline Minggu 2 - Mesin Akademik Tahfidz Unit Tests (No Mocking) - v6', () {
    late MutabaahService mutabaahService;
    late LayananStatusModul layananStatusModul;
    late LayananKecerdasanAkademik layananKecerdasanAkademik;

    setUp(() {
      final fakeSupabase = FakeSupabaseClient();
      mutabaahService = MutabaahService(fakeSupabase);
      
      // Mengacu pada signature konstruktor asli di lib/ yang membutuhkan 1 positional argument (MutabaahService) [cite: 268]
      layananStatusModul = LayananStatusModul();
      layananKecerdasanAkademik = LayananKecerdasanAkademik(mutabaahService);
    });

    // ==========================================
    // TASK 1: DETEKSI AKHIR MODUL (BR-TAH-005)
    // ==========================================
    group('Task 1: Deteksi Akhir Modul (BR-TAH-005) [cite: 103]', () {
      test('Harus tuntas jika koordinat fisik mencapai target DAN keputusan adalah Lanjut (1) [cite: 103]', () {
        final Map<String, int> targetCoordinate = {'surah': 78, 'ayat': 40};
        final Map<String, int> currentCoordinate = {
          'surah': 78,
          'ayat': 40,
          'status_keputusan': 1, // Lanjut [cite: 103]
        };

        final modul = ModulModel(
          id: 'mod-01',
          levelId: 'lvl-01',
          namaModul: 'Modul Juz 30', // Parameter required [cite: 23, 189]
          tipe: 'HAFALAN',          // Parameter required [cite: 23, 118, 189]
        );

        final isCompleted = layananStatusModul.isContentCompleted(
          currentCoordinate.toString(),
          modul,
        );
        expect(isCompleted, isTrue);
      });

      test('Harus TIDAK tuntas jika koordinat fisik mencapai target namun keputusan adalah Ulang (-1) [cite: 103]', () {
        final Map<String, int> targetCoordinate = {'surah': 78, 'ayat': 40};
        final Map<String, int> currentCoordinate = {
          'surah': 78,
          'ayat': 40,
          'status_keputusan': -1, // Ulang [cite: 103]
        };

        final modul = ModulModel(
          id: 'mod-02',
          levelId: 'lvl-01',
          namaModul: 'Modul Juz 30',
          tipe: 'HAFALAN',
        );

        final isCompleted = layananStatusModul.isContentCompleted(
          currentCoordinate.toString(),
          modul,
        );
        expect(isCompleted, isFalse);
      });
    });

    // ==========================================
    // TASK 2: TRANSISI TASMI MODE (BR-TAH-004)
    // ==========================================
    group('Task 2: Transisi Tasmi Mode (BR-TAH-004) [cite: 103]', () {
      test('Harus masuk ke tasmi_mode dan siap ujian jika isExamRequired == true [cite: 103]', () {
        // Menggunakan method asli 'evaluateExamReadiness' dari LayananKecerdasanAkademik [cite: 302]
        final stateWithExam = layananKecerdasanAkademik.evaluateExamReadiness(
          isExamRequired: true,
          volumeAchieved: true,
          currentAcademicState: 'daily',
        );

        expect(stateWithExam['academic_state'], equals('tasmi_mode'));
        expect(stateWithExam['is_ready_for_exam'], isTrue);
      });

      test('Harus bypass tasmi_mode dan langsung panggil promosi jika isExamRequired == false [cite: 103]', () {
        final stateNoExam = layananKecerdasanAkademik.evaluateExamReadiness(
          isExamRequired: false,
          volumeAchieved: true,
          currentAcademicState: 'daily',
        );

        expect(stateNoExam['academic_state'], equals('daily'));
        expect(stateNoExam['is_ready_for_exam'], isFalse);
        expect(stateNoExam['trigger_promotion'], isTrue);
      });
    });
  });
}
