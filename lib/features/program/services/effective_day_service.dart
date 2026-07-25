// Lokasi: lib/features/program/services/effective_day_service.dart

import '../../../../core/services/base_service.dart';
import '../models/agenda_model.dart';

/// Model Ringkasan Output untuk Konsumsi UI & Modul Estimasi Lulus
class AcademicSummaryModel {
  final int totalHariKalender;
  final int totalHariLiburAgenda;
  final int totalHariNonAktifProgram;
  final int netHariEfektif;
  final List<DateTime> daftarHariBelajar;

  AcademicSummaryModel({
    required this.totalHariKalender,
    required this.totalHariLiburAgenda,
    required this.totalHariNonAktifProgram,
    required this.netHariEfektif,
    required this.daftarHariBelajar,
  });

  factory AcademicSummaryModel.empty() {
    return AcademicSummaryModel(
      totalHariKalender: 0,
      totalHariLiburAgenda: 0,
      totalHariNonAktifProgram: 0,
      netHariEfektif: 0,
      daftarHariBelajar: const [],
    );
  }
}

class EffectiveDayService extends BaseService {
  /// 1. PUSAT KALKULASI UTAMA (Menerima Data Memori / In-Memory)
  /// Menggabungkan logika scope agenda dan mengembalikan AcademicSummaryModel terstruktur.
  static AcademicSummaryModel calculateEffectiveSummaryFromData({
    required DateTime startDate,
    required DateTime endDate,
    required List<String> hariAktifProgram,
    required List<AgendaModel> allAgendas,
    required String targetProgramId,
  }) {
    int totalKalender = 0;
    int totalNonAktifProgram = 0;
    int totalLiburAgenda = 0;
    int netEfektif = 0;
    final List<DateTime> daftarHariBelajar = [];

    // Normalisasi jam agar perbandingan tanggal akurat (set ke 00:00:00)
    DateTime current = DateTime(startDate.year, startDate.month, startDate.day);
    final limit = DateTime(endDate.year, endDate.month, endDate.day);

    // Normalisasi nama hari aktif ke huruf kecil
    final List<String> normalizedActiveDays = hariAktifProgram.map((d) => d.trim().toLowerCase()).toList();

    while (current.isBefore(limit) || current.isAtSameMomentAs(limit)) {
      totalKalender++;
      final dateOnly = DateTime(current.year, current.month, current.day);

      // 1. Cek apakah hari ini masuk dalam jadwal rutin Program?
      String dayName = _getIndonesianDayName(current.weekday).toLowerCase();
      bool isScheduled = normalizedActiveDays.contains(dayName) ||
          normalizedActiveDays.contains(current.weekday.toString());

      if (!isScheduled) {
        totalNonAktifProgram++;
      } else {
        // 2. Cek apakah ada agenda LIBUR yang menimpa hari ini? (Mempertahankan Logika Scope)
        bool isHoliday = allAgendas.any((agenda) {
          if (agenda.statusHariBelajar != 'LIBUR') return false;

          // Cek Scope: GLOBAL atau spesifik untuk program ini
          bool isRelevantScope = agenda.scope == 'GLOBAL' ||
              (agenda.scope == 'PROG_SPESIFIK' && agenda.programId == targetProgramId);

          if (!isRelevantScope) return false;

          final startAg = DateTime(agenda.tanggalMulai.year, agenda.tanggalMulai.month, agenda.tanggalMulai.day);
          final endAg = DateTime(agenda.tanggalBerakhir.year, agenda.tanggalBerakhir.month, agenda.tanggalBerakhir.day);

          return (dateOnly.isAtSameMomentAs(startAg) || dateOnly.isAtSameMomentAs(endAg)) ||
              (dateOnly.isAfter(startAg) && dateOnly.isBefore(endAg));
        });

        if (isHoliday) {
          totalLiburAgenda++;
        } else {
          // 3. Jika jadwal masuk DAN bukan hari libur -> Hari Efektif Belajar
          netEfektif++;
          daftarHariBelajar.add(dateOnly);
        }
      }

      current = current.add(const Duration(days: 1));
    }

    return AcademicSummaryModel(
      totalHariKalender: totalKalender,
      totalHariLiburAgenda: totalLiburAgenda,
      totalHariNonAktifProgram: totalNonAktifProgram,
      netHariEfektif: netEfektif,
      daftarHariBelajar: daftarHariBelajar,
    );
  }

  /// Helper bawaan dari kode Anda (Backward Compatibility)
  static int calculateEffectiveDays({
    required DateTime startDate,
    required DateTime endDate,
    required List<String> hariAktifProgram,
    required List<AgendaModel> allAgendas,
    required String targetProgramId,
  }) {
    final summary = calculateEffectiveSummaryFromData(
      startDate: startDate,
      endDate: endDate,
      hariAktifProgram: hariAktifProgram,
      allAgendas: allAgendas,
      targetProgramId: targetProgramId,
    );
    return summary.netHariEfektif;
  }

  /// 2. INTEGRASI SUPABASE (Mencari & Mengambil Data Otomatis dari Database)
  Future<AcademicSummaryModel> calculateAcademicSummary({
    required String lembagaId,
    required String programId,
    String? tahunAjaranId,
  }) async {
    try {
      if (lembagaId.isEmpty || programId.isEmpty) {
        return AcademicSummaryModel.empty();
      }

      // Ambil Tahun Ajaran Aktif
      Map<String, dynamic>? taData;
      if (tahunAjaranId != null && tahunAjaranId.isNotEmpty && tahunAjaranId != 'null') {
        taData = await supabase.from('tahun_ajaran').select('*').eq('id', tahunAjaranId).maybeSingle();
      } else {
        taData = await supabase.from('tahun_ajaran').select('*').eq('lembaga_id', lembagaId).eq('is_active', true).maybeSingle();
      }

      if (taData == null || taData['tanggal_mulai'] == null || taData['tanggal_selesai'] == null) {
        return AcademicSummaryModel.empty();
      }

      final DateTime startDate = DateTime.parse(taData['tanggal_mulai'].toString());
      final DateTime endDate = DateTime.parse(taData['tanggal_selesai'].toString());

      // Ambil Hari Aktif Program
      final programData = await supabase.from('program').select('hari_aktif').eq('id', programId).maybeSingle();
      List<String> hariAktif = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];
      if (programData != null && programData['hari_aktif'] != null) {
        final raw = programData['hari_aktif'];
        if (raw is List) {
          hariAktif = raw.map((e) => e.toString()).toList();
        }
      }

      // Ambil Agenda Akademik
      var agendaQuery = supabase.from('agenda_akademik').select('*').eq('lembaga_id', lembagaId);
      if (tahunAjaranId != null && tahunAjaranId.isNotEmpty && tahunAjaranId != 'null') {
        agendaQuery = agendaQuery.eq('tahun_ajaran_id', tahunAjaranId);
      }
      final List<dynamic> rawAgendas = await agendaQuery;
      final List<AgendaModel> allAgendas = rawAgendas.map((e) => AgendaModel.fromJson(e)).toList();

      // Jalankan Kalkulator Utama
      return calculateEffectiveSummaryFromData(
        startDate: startDate,
        endDate: endDate,
        hariAktifProgram: hariAktif,
        allAgendas: allAgendas,
        targetProgramId: programId,
      );
    } catch (e) {
      return AcademicSummaryModel.empty();
    }
  }

  /// Helper konversi angka hari (1-7) ke Nama Hari Indonesia
  static String _getIndonesianDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday: return 'Senin';
      case DateTime.tuesday: return 'Selasa';
      case DateTime.wednesday: return 'Rabu';
      case DateTime.thursday: return 'Kamis';
      case DateTime.friday: return 'Jumat';
      case DateTime.saturday: return 'Sabtu';
      case DateTime.sunday: return 'Minggu';
      default: return '';
    }
  }
}