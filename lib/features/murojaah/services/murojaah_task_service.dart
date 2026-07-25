import '../../../core/services/base_service.dart';
import '../../akademik/kurikulum/models/kurikulum_model.dart';

class MurojaahTaskService extends BaseService {

  /// 2. MENGHITUNG PORSI MANZIL (DINAMIS)
  /// Logika: Menghitung porsi hafalan lama agar khatam dalam siklus tertentu
  Future<Map<String, dynamic>> calculateManzilRange({
    required String studentId,
    required double amount,
    required String type, // 'fixed' atau 'percentage'
    int? totalLinesMemorized,
  }) async {
    int lines = totalLinesMemorized ?? 0;

    if (lines <= 0 && studentId.isNotEmpty) {
      final siswaData = await supabase
          .from('siswa')
          .select('total_juz_hafalan')
          .eq('id', studentId)
          .maybeSingle();

      final double totalJuz = (siswaData?['total_juz_hafalan'] as num?)?.toDouble() ?? 0.0;
      lines = (totalJuz * 300).round(); // 1 Juz = 20 hal = 300 baris
    }

    int targetLines;

    if (type == 'percentage') {
      // Rumus 4% (atau amount %): (Total Baris Hafalan * Persentase) / 100
      double pct = amount > 0 ? amount : 4.0;
      targetLines = ((lines * pct) / 100).round();
    } else {
      // Jika fixed, asumsi input adalah Halaman (1 Hal = 15 Baris)
      targetLines = (amount * 15).toInt();
    }

    // Untuk sementara, Manzil mengambil 'porsi' secara acak atau berurutan
    // dari database record mutabaah lama (bisa dikembangkan lebih lanjut)
    return {
      "type": "MANZIL",
      "target_lines": targetLines,
      "target_pages": (targetLines / 15).toStringAsFixed(1),
    };
  }

  /// 3. HELPER: KONVERSI BARIS ABSOLUT KE SURAH/ayah
  /// Rumus Posisi: $$AbsoluteLine = (Page - 1) \times 15 + Line$$
  Future<Map<String, dynamic>> _getCoordFromAbsolute(int absoluteLine) async {
    try {
      // Hitung Page dan Line
      int page = ((absoluteLine - 1) / 15).floor() + 1;
      int line = (absoluteLine - 1) % 15 + 1;

      final data = await supabase
          .from('data_mushaf')
          .select('surah_number, ayah_start, surah_name')
          .match({'page_number': page, 'line_number': line})
          .limit(1)
          .single();

      return {
        "surah": data['surah_number'],
        "ayah": data['ayah_start'],
        "surah_name": data['surah_name'],
        "page": page,
      };
    } catch (e) {
      return {"surah": 1, "ayah": 1, "surah_name": "Al-Fatihah", "page": 1};
    }
  }

  /// 4. GENERATE DAILY CHECKLIST
  /// Fungsi utama yang akan dipanggil oleh Dashboard Santri
  Future<List<Map<String, dynamic>>> getTodayTasks(String studentId, ModulModel modul) async {
    // 1. Ambil record mutabaah MANZIL terakhir untuk menentukan titik mulai Baris Absolut (1-9060)
    final lastManzilRecord = await supabase
        .from('mutabaah_records')
        .select('data_payload, absolute_line_end')
        .eq('siswa_id', studentId)
        .eq('tipe_modul', 'MANZIL')
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    int startLine = 1;
    if (lastManzilRecord != null) {
      startLine = (int.tryParse(lastManzilRecord['absolute_line_end']?.toString() ?? '0') ?? 0) + 1;
      if (startLine > 9060) startLine = 1;
    }

    // 2. Hitung Manzil berbasis data riil total_juz_hafalan profil siswa
    final manzil = await calculateManzilRange(
      studentId: studentId,
      amount: modul.manzilAmount,
      type: modul.manzilType,
    );

    int targetLines = manzil['target_lines'] as int;
    int endLine = startLine + targetLines - 1;
    if (endLine > 9060) endLine = 9060;

    final startCoord = await _getCoordFromAbsolute(startLine);
    final endCoord = await _getCoordFromAbsolute(endLine);

    return [
      {
        "title": "Murojaah Manzil",
        "desc": "Target hari ini: ${manzil['target_pages']} Halaman (${startCoord['surah_name']} : ${startCoord['ayah']} s/d ${endCoord['surah_name']} : ${endCoord['ayah']})",
        "is_done": false,
        "start_coord": startCoord,
        "end_coord": endCoord,
        "start_line": startLine,
        "end_line": endLine,
      }
    ];
  }
}