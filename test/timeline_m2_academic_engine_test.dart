import 'package:flutter_test/flutter_test.dart';

// Mock Classes to simulate Space EduOS domain logic without requiring a live Supabase connection
class MockModul {
  final String id;
  final bool isExamRequired;
  final Map<String, int> targetCoordinate;

  MockModul({
    required this.id,
    required this.isExamRequired,
    required this.targetCoordinate,
  });
}

class MockSiswa {
  String id;
  String status; // CHECK constraint: ['aktif', 'nonaktif', 'lulus', 'pindah']
  String academicState; // CHECK constraint: ['daily', 'tasmi_mode', 'exam_ready']
  bool isReadyForExam;
  String? readyModulId;
  String currentLevelId;

  MockSiswa({
    required this.id,
    this.status = 'aktif',
    this.academicState = 'daily',
    this.isReadyForExam = false,
    this.readyModulId,
    required this.currentLevelId,
  });
}

class MockLevel {
  final String id;
  final String jenjangId;
  final int urutan;

  MockLevel({
    required this.id,
    required this.jenjangId,
    required this.urutan,
  });
}

class MockJenjang {
  final String id;
  final int urutan;

  MockJenjang({
    required this.id,
    required this.urutan,
  });
}

// Layanan Status Modul (BR-TAH-005)
class LayananStatusModul {
  bool isContentCompleted({
    required Map<String, int> currentCoordinate,
    required Map<String, int> targetCoordinate,
    required int lastStatusKeputusan,
  }) {
    // Cek apakah koordinat fisik (surah/ayat) mencapai atau melampaui target
    final reachedTarget = (currentCoordinate['surah']! > targetCoordinate['surah']!) ||
        (currentCoordinate['surah']! == targetCoordinate['surah']! &&
            currentCoordinate['ayat']! >= targetCoordinate['ayat']!);

    // Syarat Tuntas Mutlak (BR-TAH-005): Hanya tuntas jika koordinat tercapai DAN keputusan terakhir == 1 (Lanjut)
    if (reachedTarget && lastStatusKeputusan == 1) {
      return true;
    }
    return false;
  }
}

// Layanan Kecerdasan Akademik (BR-TAH-004)
class LayananKecerdasanAkademik {
  void evaluateExamReadiness({
    required MockSiswa siswa,
    required MockModul modul,
    required bool isPhysicalDone,
    required Function(MockSiswa) onBypassPromotion,
  }) {
    if (isPhysicalDone) {
      if (modul.isExamRequired) {
        siswa.academicState = 'tasmi_mode';
        siswa.isReadyForExam = true;
        siswa.readyModulId = modul.id;
      } else {
        // Bypass tasmi_mode dan langsung panggil promosi
        siswa.isReadyForExam = false;
        siswa.readyModulId = null;
        siswa.academicState = 'daily';
        onBypassPromotion(siswa);
      }
    }
  }
}

// UKL Engine Service (BR-TAH-006)
class UklEngineService {
  final List<MockLevel> mockLevelsDb;
  final List<MockJenjang> mockJenjangDb;

  UklEngineService({required this.mockLevelsDb, required this.mockJenjangDb});

  void processPromotion({
    required MockSiswa siswa,
    required String currentModuleId,
  }) {
    // 1. Dapatkan level aktif siswa
    final currentLevel = mockLevelsDb.firstWhere((l) => l.id == siswa.currentLevelId);
    final currentJenjangId = currentLevel.jenjangId;

    // 2. Cari apakah ada level berikutnya di jenjang yang sama (urutan lebih tinggi)
    final levelsInSameJenjang = mockLevelsDb
        .where((l) => l.jenjangId == currentJenjangId)
        .toList()
      ..sort((a, b) => a.urutan.compareTo(b.urutan));

    final currentIndex = levelsInSameJenjang.indexWhere((l) => l.id == currentLevel.id);

    if (currentIndex != -1 && currentIndex < levelsInSameJenjang.length - 1) {
      // Promosi ke level berikutnya dalam jenjang yang sama
      siswa.currentLevelId = levelsInSameJenjang[currentIndex + 1].id;
      siswa.academicState = 'daily';
      siswa.isReadyForExam = false;
      return;
    }

    // 3. Jika level terakhir di jenjang ini sudah habis, cari jenjang berikutnya
    final currentJenjang = mockJenjangDb.firstWhere((j) => j.id == currentJenjangId);
    final sortedJenjangs = mockJenjangDb.toList()..sort((a, b) => a.urutan.compareTo(b.urutan));
    
    final currentJenjangIndex = sortedJenjangs.indexWhere((j) => j.id == currentJenjang.id);

    if (currentJenjangIndex != -1 && currentJenjangIndex < sortedJenjangs.length - 1) {
      // Dapatkan jenjang berikutnya
      final nextJenjang = sortedJenjangs[currentJenjangIndex + 1];

      // Ambil level pertama (urutan terkecil) di jenjang berikutnya tersebut
      final nextJenjangLevels = mockLevelsDb
          .where((l) => l.jenjangId == nextJenjang.id)
          .toList()
        ..sort((a, b) => a.urutan.compareTo(b.urutan));

      if (nextJenjangLevels.isNotEmpty) {
        siswa.currentLevelId = nextJenjangLevels.first.id;
        siswa.academicState = 'daily';
        siswa.isReadyForExam = false;
      }
    } else {
      // Selesai seluruh jenjang kurikulum (Tamat Kurikulum)
      // MITIGASI BUG: Menggunakan string lowercase 'lulus' agar sesuai dengan PostgreSQL CHECK Constraint
      siswa.status = 'lulus';
      siswa.academicState = 'daily';
      siswa.isReadyForExam = false;
      siswa.readyModulId = null;
    }
  }
}

void main() {
  group('Timeline Minggu 2 - Mesin Akademik Tahfidz Tests', () {
    late LayananStatusModul layananStatusModul;
    late LayananKecerdasanAkademik layananKecerdasanAkademik;

    setUp(() {
      layananStatusModul = LayananStatusModul();
      layananKecerdasanAkademik = LayananKecerdasanAkademik();
    });

    // ==========================================
    // TASK 1: DETEKSI AKHIR MODUL (BR-TAH-005)
    // ==========================================
    group('Task 1: Deteksi Akhir Modul (BR-TAH-005)', () {
      final targetCoordinate = {'surah': 78, 'ayat': 40}; // Akhir An-Naba

      test('Harus tuntas jika koordinat fisik tercapai DAN keputusan adalah Lanjut (1)', () {
        final currentCoordinate = {'surah': 78, 'ayat': 40};
        final isCompleted = layananStatusModul.isContentCompleted(
          currentCoordinate: currentCoordinate,
          targetCoordinate: targetCoordinate,
          lastStatusKeputusan: 1, // Lanjut
        );
        expect(isCompleted, isTrue);
      });

      test('Harus TIDAK tuntas jika koordinat fisik tercapai namun keputusan adalah Ulang (-1)', () {
        final currentCoordinate = {'surah': 78, 'ayat': 40};
        final isCompleted = layananStatusModul.isContentCompleted(
          currentCoordinate: currentCoordinate,
          targetCoordinate: targetCoordinate,
          lastStatusKeputusan: -1, // Ulang
        );
        expect(isCompleted, isFalse);
      });

      test('Harus TIDAK tuntas jika koordinat fisik tercapai namun keputusan adalah Off (0)', () {
        final currentCoordinate = {'surah': 78, 'ayat': 40};
        final isCompleted = layananStatusModul.isContentCompleted(
          currentCoordinate: currentCoordinate,
          targetCoordinate: targetCoordinate,
          lastStatusKeputusan: 0, // Off / Libur
        );
        expect(isCompleted, isFalse);
      });

      test('Harus TIDAK tuntas jika koordinat fisik belum tercapai meskipun keputusan Lanjut (1)', () {
        final currentCoordinate = {'surah': 78, 'ayat': 30};
        final isCompleted = layananStatusModul.isContentCompleted(
          currentCoordinate: currentCoordinate,
          targetCoordinate: targetCoordinate,
          lastStatusKeputusan: 1, // Lanjut
        );
        expect(isCompleted, isFalse);
      });
    });

    // ==========================================
    // TASK 2: TRANSISI TASMI MODE (BR-TAH-004)
    // ==========================================
    group('Task 2: Transisi Tasmi Mode (BR-TAH-004)', () {
      test('Harus masuk ke tasmi_mode dan siap ujian jika isExamRequired == true', () {
        final siswa = MockSiswa(id: 'student_01', currentLevelId: 'lvl_1');
        final modul = MockModul(id: 'mod_1', isExamRequired: true, targetCoordinate: {'surah': 78, 'ayat': 40});
        
        bool bypassTriggered = false;

        layananKecerdasanAkademik.evaluateExamReadiness(
          siswa: siswa,
          modul: modul,
          isPhysicalDone: true,
          onBypassPromotion: (s) {
            bypassTriggered = true;
          },
        );

        expect(siswa.academicState, equals('tasmi_mode'));
        expect(siswa.isReadyForExam, isTrue);
        expect(siswa.readyModulId, equals('mod_1'));
        expect(bypassTriggered, isFalse);
      });

      test('Harus bypass tasmi_mode dan langsung panggil promosi jika isExamRequired == false', () {
        final siswa = MockSiswa(id: 'student_01', currentLevelId: 'lvl_1');
        final modul = MockModul(id: 'mod_2', isExamRequired: false, targetCoordinate: {'surah': 78, 'ayat': 40});
        
        bool bypassTriggered = false;

        layananKecerdasanAkademik.evaluateExamReadiness(
          siswa: siswa,
          modul: modul,
          isPhysicalDone: true,
          onBypassPromotion: (s) {
            bypassTriggered = true;
          },
        );

        expect(siswa.academicState, equals('daily'));
        expect(siswa.isReadyForExam, isFalse);
        expect(siswa.readyModulId, isNull);
        expect(bypassTriggered, isTrue);
      });
    });

    // ==========================================
    // TASK 3: PROMOSI LEVEL HIERARKIS & LULUS DB (BR-TAH-006)
    // ==========================================
    group('Task 3: Promosi Level Hierarkis & Lulus DB (BR-TAH-006)', () {
      // Setup database palsu untuk simulasi
      final mockJenjangs = [
        MockJenjang(id: 'jenjang_muda', urutan: 1),
        MockJenjang(id: 'jenjang_madya', urutan: 2),
      ];

      final mockLevels = [
        MockLevel(id: 'lvl_muda_1', jenjangId: 'jenjang_muda', urutan: 1),
        MockLevel(id: 'lvl_muda_2', jenjangId: 'jenjang_muda', urutan: 2),
        MockLevel(id: 'lvl_madya_1', jenjangId: 'jenjang_madya', urutan: 1),
      ];

      late UklEngineService uklEngineService;

      setUp(() {
        uklEngineService = UklEngineService(
          mockLevelsDb: mockLevels,
          mockJenjangDb: mockJenjangs,
        );
      });

      test('Harus naik level dalam jenjang yang sama jika level berikutnya tersedia', () {
        final siswa = MockSiswa(id: 'student_01', currentLevelId: 'lvl_muda_1');

        uklEngineService.processPromotion(siswa: siswa, currentModuleId: 'mod_any');

        expect(siswa.currentLevelId, equals('lvl_muda_2'));
        expect(siswa.status, equals('aktif'));
      });

      test('Harus naik ke level pertama jenjang berikutnya jika level terakhir di jenjang saat ini selesai', () {
        final siswa = MockSiswa(id: 'student_01', currentLevelId: 'lvl_muda_2');

        uklEngineService.processPromotion(siswa: siswa, currentModuleId: 'mod_any');

        expect(siswa.currentLevelId, equals('lvl_madya_1'));
        expect(siswa.status, equals('aktif'));
      });

      test('Harus mengubah status siswa menjadi lowercase lulus jika tamat kurikulum (level & jenjang terakhir habis)', () {
        final siswa = MockSiswa(id: 'student_01', currentLevelId: 'lvl_madya_1');

        uklEngineService.processPromotion(siswa: siswa, currentModuleId: 'mod_any');

        // Harus lowercase 'lulus' agar sesuai dengan CHECK Constraint database PostgreSQL
        expect(siswa.status, equals('lulus'));
        expect(siswa.academicState, equals('daily'));
        expect(siswa.isReadyForExam, isFalse);
      });
    });
  });
}
