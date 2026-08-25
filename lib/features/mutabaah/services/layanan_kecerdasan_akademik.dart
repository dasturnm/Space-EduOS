part of 'mutabaah_service.dart';

class LayananKecerdasanAkademik {
  final MutabaahTahfidzService _mainService;
  LayananKecerdasanAkademik(this._mainService);

  SupabaseClient get supabase => _mainService.supabase;

  Map<String, dynamic> evaluateExamReadiness({
    required bool isExamRequired,
    required bool volumeAchieved,
    required String currentAcademicState,
  }) {
    if (!volumeAchieved) {
      return {
        'academic_state': currentAcademicState,
        'is_ready_for_exam': false,
      };
    }
    if (isExamRequired) {
      return {
        'academic_state': 'tasmi_mode',
        'is_ready_for_exam': true,
      };
    } else {
      return {
        'academic_state': currentAcademicState,
        'is_ready_for_exam': false,
        'trigger_promotion': true,
      };
    }
  }

  Future<void> _evaluateExamReadiness(String siswaId, String? modulId) async {
    if (modulId == null) return;
    try {
      final modulData = await supabase
          .from('modul_kurikulum')
          .select('*, level:level_id(kurikulum_id, urutan)')
          .eq('id', modulId)
          .single();

      final modul = ModulModel.fromJson(modulData);

      // GUNAKAN HELPER STATUS (KOORDINAT BASED)
      final isPhysicalDone = await LayananStatusModul().isContentCompleted(siswaId, modul);

      if (isPhysicalDone) {
        if (modul.isExamRequired == true) {
          // DUAL/TRIPLE UPDATE: Ubah academic_state, is_ready_for_exam, dan ready_modul_id
          await supabase.from('siswa').update({
            'academic_state': 'tasmi_mode',
            'is_ready_for_exam': true,
            'ready_modul_id': modulId,
          }).eq('id', siswaId);
        } else {
          // Reset flag exam terlebih dahulu sebelum promosi
          await supabase.from('siswa').update({
            'is_ready_for_exam': false,
            'ready_modul_id': null,
            'academic_state': 'daily',
          }).eq('id', siswaId);
          // Jika tidak wajib ujian, langsung pemicu promosi ke modul berikutnya
          await _evaluateStudentPromotion(siswaId);
        }
      } else {
        // Jika belum selesai, pastikan flag exam di-reset (mencegah status mengambang)
        await supabase.from('siswa').update({
          'is_ready_for_exam': false,
          'ready_modul_id': null,
          'academic_state': 'daily',
        }).eq('id', siswaId);
      }
    } catch (e) {
      print("Error _evaluateExamReadiness: $e");
    }
  }

  Future<void> _evaluateStudentPromotion(String siswaId) async {
    try {
      final siswaData = await supabase.from('siswa').select('level_id').eq('id', siswaId).single();
      final currentLevelId = siswaData['level_id'];
      if (currentLevelId == null) return;

      final currentLevelData = await supabase.from('kurikulum_level').select('kurikulum_id, urutan').eq('id', currentLevelId).single();
      final kurikulumId = currentLevelData['kurikulum_id'];
      final currentUrutan = currentLevelData['urutan'];

      final modulsInLevel = await supabase.from('modul_kurikulum').select('*').eq('level_id', currentLevelId);
      if (modulsInLevel.isEmpty) return;

      bool allPassed = true;
      for (var m in modulsInLevel as List) {
        final modul = ModulModel.fromJson(m);
        if (modul.tipe.trim().toUpperCase() == 'TASMI\'') continue;

        if (modul.isExamRequired) {
          final evaluasiLulus = await supabase
              .from('siswa_evaluasi_nilai')
              .select('id')
              .match({'siswa_id': siswaId, 'modul_id': modul.id!, 'is_lulus': true})
              .limit(1)
              .maybeSingle();

          if (evaluasiLulus == null) {
            allPassed = false;
            break;
          }
        } else {
          final isCompleted = await LayananStatusModul().isContentCompleted(siswaId, modul);
          if (!isCompleted) {
            allPassed = false;
            break;
          }
        }
      }

      if (allPassed) {
        final nextLevelData = await supabase
            .from('kurikulum_level')
            .select('id')
            .eq('kurikulum_id', kurikulumId)
            .gt('urutan', currentUrutan)
            .order('urutan', ascending: true)
            .limit(1)
            .maybeSingle();

        if (nextLevelData != null) {
          final nextLevelId = nextLevelData['id'];
          await supabase.from('siswa').update({
            'level_id': nextLevelId,
            'current_level_id': nextLevelId,
          }).eq('id', siswaId);
        }
      }
    } catch (e) {
      print("Error Auto-Promotion: $e");
    }
  }

  double calculateSertifikasiScore(Map<String, dynamic> sertifikasiSettings, Map<String, dynamic> penaltyCounts, Map<String, double> directScores) {
    double totalScore = 0.0;

    sertifikasiSettings.forEach((aspect, config) {
      if (config['active'] == true) {
        double bobot = (config['bobot'] as num?)?.toDouble() ?? 0.0;

        if (aspect == 'itqon' || aspect == 'tajwid' || aspect == 'makhraj') {
          double deductions = 0.0;
          if (aspect == 'itqon') {
            int countS = penaltyCounts['itqon_s'] ?? 0;
            int countT = penaltyCounts['itqon_t'] ?? 0;
            int countP = penaltyCounts['itqon_p'] ?? 0;
            deductions += countS * ((config['pinalti_stt'] as num?)?.toDouble() ?? 0.0);
            deductions += countT * ((config['pinalti_t'] as num?)?.toDouble() ?? 0.0);
            deductions += countP * ((config['pinalti_p'] as num?)?.toDouble() ?? 0.0);
          } else if (aspect == 'tajwid' || aspect == 'makhraj') {
            int countK = penaltyCounts['${aspect}_k'] ?? 0;
            int countS = penaltyCounts['${aspect}_s'] ?? 0;
            deductions += countK * ((config['pinalti_kurang'] as num?)?.toDouble() ?? 0.0);
            deductions += countS * ((config['pinalti_salah'] as num?)?.toDouble() ?? 0.0);
          }

          double aspectScore = bobot - deductions;
          if (aspectScore < 0) aspectScore = 0;
          totalScore += aspectScore;
        } else {
          double rawScore = directScores[aspect] ?? 0.0;
          totalScore += (rawScore / 100) * bobot;
        }
      }
    });

    return totalScore;
  }

  Future<MutabaahProjectionModel> getModuleProjection(String siswaId, ModulModel modul) async {
    try {
      final response = await supabase
          .from('mutabaah_records')
          .select('achieved_amount, status_keputusan')
          .match({'siswa_id': siswaId, 'modul_id': modul.id!});

      double currentAchieved = 0.0;
      final records = response as List;

      int acceptedRecordCount = 0;
      for (var record in records) {
        final int statusKeputusan = (record['status_keputusan'] as num?)?.toInt() ?? 0;
        if (statusKeputusan == 1) {
          currentAchieved += (record['achieved_amount'] as num?)?.toDouble() ?? 0.0;
          acceptedRecordCount++;
        }
      }

      double totalTarget = modul.targetAmount * modul.targetPertemuan;
      if (modul.totalBaris > 0) {
        if (modul.targetAmountUnit == 'JUZ') {
          totalTarget = modul.totalBaris / 300.0;
        } else if (modul.targetAmountUnit == 'HALAMAN') {
          totalTarget = modul.totalBaris / 15.0;
        } else if (modul.targetAmountUnit == 'SURAH') {
          totalTarget = (modul.totalSurah > 0) ? modul.totalSurah.toDouble() : (modul.totalBaris / 15.0);
        } else if (modul.targetAmountUnit == 'AYAH') {
          totalTarget = (modul.totalBaris > 0) ? totalTarget : 0.0;
        } else {
          totalTarget = modul.totalBaris.toDouble();
        }
      }

      if (totalTarget <= 0) totalTarget = 100.0;

      final bool isDone = await LayananStatusModul().isContentCompleted(siswaId, modul);

      double remainingVolume = totalTarget - currentAchieved;
      if (remainingVolume < 0 || isDone) remainingVolume = 0.0;

      double averageVelocity = modul.targetAmount;
      if (acceptedRecordCount > 0 && currentAchieved > 0) {
        averageVelocity = currentAchieved / acceptedRecordCount;
      }
      if (averageVelocity <= 0) averageVelocity = 1.0;

      int estimatedMeetingsLeft = (remainingVolume / averageVelocity).ceil();
      DateTime estimatedCompletionDate = DateTime.now().add(Duration(days: estimatedMeetingsLeft));

      return MutabaahProjectionModel(
        siswaId: siswaId,
        modulId: modul.id!,
        totalTarget: totalTarget,
        currentAchieved: currentAchieved,
        remainingVolume: remainingVolume,
        averageVelocity: averageVelocity,
        estimatedMeetingsLeft: estimatedMeetingsLeft,
        estimatedCompletionDate: estimatedCompletionDate,
        isCompleted: isDone || remainingVolume <= 0,
      );
    } catch (e) {
      throw Exception(_mainService.handleError(e));
    }
  }
}