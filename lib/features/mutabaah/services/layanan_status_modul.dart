// Lokasi: lib/features/mutabaah/services/layanan_status_modul.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tahfidz_core/features/akademik/kurikulum/models/modul_model.dart';

class LayananStatusModul {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Mengecek apakah konten materi di dalam modul sudah habis dipelajari secara fisik
  Future<bool> isContentCompleted(String siswaId, ModulModel modul) async {
    try {
      // 1. Ambil setoran terakhir
      final lastRecord = await _supabase
          .from('mutabaah_records')
          .select()
          .eq('siswa_id', siswaId)
          .eq('modul_id', modul.id ?? '')
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (lastRecord == null) return false;

      // Syarat Tuntas Mutlak (BR-TAH-005): Status keputusan terakhir harus LANJUT (1)
      final int statusKeputusan = int.tryParse(lastRecord['status_keputusan']?.toString() ?? '0') ?? 0;
      if (statusKeputusan != 1) return false;

      if (modul.silabusSource == 'mushaf') {
        final bool isReverse = modul.isReverseOrder;

        // PARSING COORDINATES (Disesuaikan dengan Arah Hafalan)
        int targetSurah = isReverse ? modul.surahIdStart : modul.surahIdEnd;
        int targetAyat = isReverse ? modul.ayahStart : modul.ayahEnd;

        // Fallback untuk data lama yang mungkin belum terisi kolom fisik
        if (targetSurah <= 0) {
          final String? rawCoord = isReverse ? modul.mulaiKoordinatJuz : modul.akhirKoordinatJuz;
          if (rawCoord != null && rawCoord.contains(':')) {
            final targetParts = rawCoord.split(':');
            if (targetParts.length >= 2) {
              targetSurah = int.tryParse(targetParts[0]) ?? 0;
              targetAyat = int.tryParse(targetParts[1]) ?? 0;
            }
          }
        }

        if (targetSurah > 0 && targetAyat <= 0) {
          targetAyat = 1;
        }

        // Jika target masih tidak terdefinisi, anggap selesai agar tidak looping
        if (targetSurah <= 0 || targetAyat <= 0) return true;

        // FIX: Mengambil koordinat kursor fisik acuan berdasarkan arah hafalan
        final int startSurahFromDb = int.tryParse(lastRecord['surah_id']?.toString() ?? '0') ?? 0;
        final int endSurahFromDb = int.tryParse(lastRecord['end_surah_id']?.toString() ?? '0') ?? 0;
        final int startAyahFromDb = int.tryParse(lastRecord['ayah_start']?.toString() ?? '0') ?? 0;
        final int endAyahFromDb = int.tryParse(lastRecord['ayah_end']?.toString() ?? '0') ?? 0;

        int currentSurah;
        int currentAyat;

        if (isReverse) {
          currentSurah = (endSurahFromDb > 0 && endSurahFromDb < startSurahFromDb) ? endSurahFromDb : startSurahFromDb;
          if (currentSurah == 0) currentSurah = endSurahFromDb;

          if (startSurahFromDb == endSurahFromDb && startSurahFromDb > 0) {
            currentAyat = endAyahFromDb > 0 ? endAyahFromDb : startAyahFromDb;
          } else if (currentSurah == endSurahFromDb) {
            currentAyat = endAyahFromDb > 0 ? endAyahFromDb : startAyahFromDb;
          } else {
            currentAyat = endAyahFromDb > 0 ? endAyahFromDb : startAyahFromDb;
          }
        } else {
          currentSurah = endSurahFromDb > 0 ? endSurahFromDb : startSurahFromDb;
          currentAyat = endAyahFromDb > 0 ? endAyahFromDb : startAyahFromDb;
        }

        // VALIDASI KOORDINAT FISIK
        if (isReverse) {
          // Mode Mundur: Tuntas jika kursor menyentuh/melewati target ke arah surah kecil
          if (currentSurah < targetSurah) return true;
          return (currentSurah == targetSurah && currentAyat >= targetAyat);
        } else {
          // Mode Maju: Tuntas jika kursor menyentuh/melewati target ke arah surah besar
          if (currentSurah > targetSurah) return true;
          return (currentSurah == targetSurah && currentAyat >= targetAyat);
        }
      } else {
        // VALIDASI INTERNAL
        if (modul.isPlottingActive) {
          // Floating: bandingkan nomor urut materi dengan total materi
          final int totalMateri = modul.extractedMateriList.length;
          if (totalMateri == 0) return false;
          final int currentIndex = int.tryParse(lastRecord['nomor_urut_materi']?.toString() ?? '0') ?? 0;
          // Indeks berbasis 0, jadi max index = totalMateri - 1
          return currentIndex >= totalMateri - 1;
        } else {
          // Non-floating: bandingkan internal_end dengan total cakupan (target_internal_akhir atau target pertemuan atau total baris)
          final int totalCakupan = modul.targetInternalAkhir > 0
              ? modul.targetInternalAkhir
              : (modul.targetPertemuan > 0
              ? modul.targetPertemuan
              : (modul.totalBaris > 0 ? modul.totalBaris : 100));

          final int currentInternalEnd = int.tryParse(lastRecord['internal_end']?.toString() ?? '0') ?? 0;
          return currentInternalEnd >= totalCakupan;
        }
      }
    } catch (_) {
      return false;
    }
  }

  /// Mengecek apakah siswa telah lulus ujian formal untuk modul terkait di tabel evaluasi nilai
  Future<bool> isExamPassed(String siswaId, String modulId) async {
    try {
      final response = await _supabase
          .from('siswa_evaluasi_nilai')
          .select()
          .eq('siswa_id', siswaId)
          .eq('modul_id', modulId)
          .eq('is_lulus', true)
          .maybeSingle();
      return response != null;
    } catch (_) {
      return false;
    }
  }

  /// Menentukan apakah modul benar-benar tuntas secara administratif and boleh ditinggalkan
  Future<bool> isFinalCompleted(String siswaId, ModulModel modul) async {
    final contentDone = await isContentCompleted(siswaId, modul);
    if (!contentDone) return false;

    // Jika modul mewajibkan ujian (UKL/Tasmi), harus lulus ujian terlebih dahulu
    if (modul.isExamRequired == true) {
      return await isExamPassed(siswaId, modul.id ?? '');
    }

    // Jika tidak wajib ujian, otomatis dianggap selesai final saat konten habis
    return true;
  }
}