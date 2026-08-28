// Lokasi: lib/features/akademik/evaluasi/services/ukl_engine_service.dart

import '../../../../core/services/base_service.dart';

class UklEngineService extends BaseService {

  /// 1. EVALUASI KELAYAKAN: Mengecek apakah siswa sudah menyelesaikan seluruh modul
  /// prasyarat di levelnya dan berhak mengikuti Ujian Kenaikan Level (UKL).
  Future<bool> checkUklEligibility(String siswaId) async {
    try {
      // Ambil level siswa saat ini
      Map<String, dynamic>? siswaData;
      try {
        siswaData = await supabase.from('siswa').select('level_id').eq('id', siswaId).maybeSingle();
      } catch (_) {}
      if (siswaData == null) {
        try {
          siswaData = await supabase.from('students').select('level_id').eq('id', siswaId).maybeSingle();
        } catch (_) {}
      }
      final currentLevelId = siswaData?['level_id'];
      if (currentLevelId == null) return false;

      // Ambil seluruh modul di level tersebut
      List<dynamic> modulsInLevel = [];
      try {
        modulsInLevel = await supabase.from('modul_kurikulum').select('id').eq('level_id', currentLevelId);
      } catch (_) {}
      if (modulsInLevel.isEmpty) {
        try {
          modulsInLevel = await supabase.from('modules').select('id').eq('level_id', currentLevelId);
        } catch (_) {}
      }
      if (modulsInLevel.isEmpty) return false;

      final modulIds = (modulsInLevel as List).map((m) => m['id'].toString()).toList();

      // Cek kelulusan di mutabaah harian untuk modul-modul tersebut
      List<dynamic> passedRecords = [];
      try {
        passedRecords = await supabase
            .from('mutabaah_records')
            .select('modul_id')
            .match({'siswa_id': siswaId, 'is_passed_target': true});
      } catch (_) {}
      if (passedRecords.isEmpty) {
        try {
          passedRecords = await supabase
              .from('tahfidz_submissions')
              .select('module_id')
              .match({'student_id': siswaId, 'passed_target': true});
        } catch (_) {}
      }

      final passedModulIds = (passedRecords as List).map((m) => (m['modul_id'] ?? m['module_id']).toString()).toSet();

      // Validasi apakah seluruh modul di level ini ada di dalam daftar modul yang sudah lulus
      bool isEligible = true;
      for (var id in modulIds) {
        if (!passedModulIds.contains(id)) {
          isEligible = false;
          break;
        }
      }

      return isEligible;
    } catch (e) {
      print("Error Check Eligibility: $e");
      return false; // Fail-safe
    }
  }

  /// 2. PROSES KENAIKAN LEVEL: Memindahkan siswa ke level berikutnya
  /// Akan dipanggil otomatis oleh EvaluasiService / Controller setelah UKL dinyatakan 'Lulus'.
  Future<void> processPromotion(String siswaId) async {
    try {
      // Ambil data level saat ini
      Map<String, dynamic>? siswaData;
      try {
        siswaData = await supabase.from('siswa').select('level_id').eq('id', siswaId).maybeSingle();
      } catch (_) {}
      if (siswaData == null) {
        try {
          siswaData = await supabase.from('students').select('level_id').eq('id', siswaId).maybeSingle();
        } catch (_) {}
      }
      final currentLevelId = siswaData?['level_id'];
      if (currentLevelId == null) return;

      // Ambil kurikulum_id dan urutan saat ini
      Map<String, dynamic>? currentLevelData;
      try {
        currentLevelData = await supabase
            .from('kurikulum_level')
            .select('kurikulum_id, urutan')
            .eq('id', currentLevelId)
            .maybeSingle();
      } catch (_) {}
      if (currentLevelData == null) {
        try {
          currentLevelData = await supabase
              .from('levels')
              .select('curriculum_id, order_index')
              .eq('id', currentLevelId)
              .maybeSingle();
        } catch (_) {}
      }

      if (currentLevelData == null) return;

      final kurikulumId = currentLevelData['kurikulum_id'] ?? currentLevelData['curriculum_id'];
      final currentUrutan = currentLevelData['urutan'] ?? currentLevelData['order_index'];

      // Cari level berikutnya (berdasarkan urutan yang lebih besar)
      Map<String, dynamic>? nextLevelData;
      try {
        nextLevelData = await supabase
            .from('kurikulum_level')
            .select('id')
            .eq('kurikulum_id', kurikulumId)
            .gt('urutan', currentUrutan)
            .order('urutan', ascending: true)
            .limit(1)
            .maybeSingle();
      } catch (_) {}
      if (nextLevelData == null) {
        try {
          nextLevelData = await supabase
              .from('levels')
              .select('id')
              .eq('curriculum_id', kurikulumId)
              .gt('order_index', currentUrutan)
              .order('order_index', ascending: true)
              .limit(1)
              .maybeSingle();
        } catch (_) {}
      }

      // Jika ada level berikutnya pada kurikulum yang sama, lakukan update profil siswa
      if (nextLevelData != null) {
        final nextLevelId = nextLevelData['id'];

        try {
          await supabase.from('siswa').update({
            'level_id': nextLevelId,
            'current_level_id': nextLevelId, // Menyesuaikan dengan schema db
            'academic_state': 'daily',
            'is_ready_for_exam': false,
            'ready_modul_id': null,
          }).eq('id', siswaId);
        } catch (_) {
          await supabase.from('students').update({
            'level_id': nextLevelId,
            'current_level_id': nextLevelId,
            'academic_state': 'daily',
            'is_ready_for_exam': false,
            'ready_modul_id': null,
          }).eq('id', siswaId);
        }
      } else {
        // PROMOSI LINTAS JENJANG: Jika level di kurikulum saat ini sudah habis,
        // cari kurikulum/jenjang berikutnya dalam program yang sama berdasarkan urutan.
        Map<String, dynamic>? currentKurikulum;
        try {
          currentKurikulum = await supabase
              .from('kurikulum')
              .select('id, program_id, urutan')
              .eq('id', kurikulumId)
              .maybeSingle();
        } catch (_) {}
        if (currentKurikulum == null) {
          try {
            currentKurikulum = await supabase
                .from('curricula')
                .select('id, program_id, order_index')
                .eq('id', kurikulumId)
                .maybeSingle();
          } catch (_) {}
        }

        if (currentKurikulum != null) {
          final programId = currentKurikulum['program_id'];
          final kurikulumUrutan = currentKurikulum['urutan'] ?? currentKurikulum['order_index'] ?? 0;

          Map<String, dynamic>? nextKurikulum;
          try {
            nextKurikulum = await supabase
                .from('kurikulum')
                .select('id')
                .eq('program_id', programId)
                .gt('urutan', kurikulumUrutan)
                .order('urutan', ascending: true)
                .limit(1)
                .maybeSingle();
          } catch (_) {}
          if (nextKurikulum == null) {
            try {
              nextKurikulum = await supabase
                  .from('curricula')
                  .select('id')
                  .eq('program_id', programId)
                  .gt('order_index', kurikulumUrutan)
                  .order('order_index', ascending: true)
                  .limit(1)
                  .maybeSingle();
            } catch (_) {}
          }

          if (nextKurikulum != null) {
            final nextKurikulumId = nextKurikulum['id'];
            Map<String, dynamic>? firstLevelInNextKurikulum;
            try {
              firstLevelInNextKurikulum = await supabase
                  .from('kurikulum_level')
                  .select('id')
                  .eq('kurikulum_id', nextKurikulumId)
                  .order('urutan', ascending: true)
                  .limit(1)
                  .maybeSingle();
            } catch (_) {}
            if (firstLevelInNextKurikulum == null) {
              try {
                firstLevelInNextKurikulum = await supabase
                    .from('levels')
                    .select('id')
                    .eq('curriculum_id', nextKurikulumId)
                    .order('order_index', ascending: true)
                    .limit(1)
                    .maybeSingle();
              } catch (_) {}
            }

            if (firstLevelInNextKurikulum != null) {
              final nextLevelId = firstLevelInNextKurikulum['id'];
              try {
                await supabase.from('siswa').update({
                  'level_id': nextLevelId,
                  'current_level_id': nextLevelId,
                  'academic_state': 'daily',
                  'is_ready_for_exam': false,
                  'ready_modul_id': null,
                }).eq('id', siswaId);
              } catch (_) {
                await supabase.from('students').update({
                  'level_id': nextLevelId,
                  'current_level_id': nextLevelId,
                  'academic_state': 'daily',
                  'is_ready_for_exam': false,
                  'ready_modul_id': null,
                }).eq('id', siswaId);
              }
            } else {
              // Poin 4 BR-TAH-006: Jika tidak ada level di jenjang berikutnya -> status graduated
              try {
                await supabase.from('siswa').update({
                  'academic_state': 'daily',
                  'status': 'lulus',
                  'is_ready_for_exam': false,
                  'ready_modul_id': null,
                }).eq('id', siswaId);
              } catch (_) {
                await supabase.from('students').update({
                  'academic_state': 'daily',
                  'status': 'lulus',
                  'is_ready_for_exam': false,
                  'ready_modul_id': null,
                }).eq('id', siswaId);
              }
            }
          } else {
            // Poin 4 BR-TAH-006: Jika tidak ada jenjang berikutnya -> status graduated
            try {
              await supabase.from('siswa').update({
                'academic_state': 'daily',
                'status': 'lulus',
                'is_ready_for_exam': false,
                'ready_modul_id': null,
              }).eq('id', siswaId);
            } catch (_) {
              await supabase.from('students').update({
                'academic_state': 'daily',
                'status': 'lulus',
                'is_ready_for_exam': false,
                'ready_modul_id': null,
              }).eq('id', siswaId);
            }
          }
        }
      }
    } catch (e) {
      throw Exception(handleError(e));
    }
  }
}