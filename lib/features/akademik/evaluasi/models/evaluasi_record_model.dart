// Lokasi: lib/features/akademik/evaluasi/models/evaluasi_record_model.dart

class EvaluasiRecordModel {
  final String? id;
  final String lembagaId;
  final String siswaId;
  final String guruId;
  final String modulId;
  final String tipeEvaluasi; // Contoh: 'TASMI', 'UKL'
  final double nilaiAkhir;
  final bool isLulus;
  final DateTime? tanggalEvaluasi;
  final String? catatan;

  // Untuk menyimpan detail dinamis seperti jumlah pinalti STT, skor Itqon, dsb
  final Map<String, dynamic> detailPenilaian;

  // Field Relasi (Opsional untuk tampilan UI)
  final String? namaSiswa;
  final String? namaGuru;
  final String? namaModul;

  EvaluasiRecordModel({
    this.id,
    required this.lembagaId,
    required this.siswaId,
    required this.guruId,
    required this.modulId,
    required this.tipeEvaluasi,
    required this.nilaiAkhir,
    required this.isLulus,
    this.tanggalEvaluasi,
    this.catatan,
    this.detailPenilaian = const {},
    this.namaSiswa,
    this.namaGuru,
    this.namaModul,
  });

  factory EvaluasiRecordModel.fromJson(Map<String, dynamic> json) {
    final lId = json['lembaga_id'] ?? json['organization_id'];
    final sId = json['siswa_id'] ?? json['student_id'];
    final gId = json['guru_id'] ?? json['teacher_id'];
    final mId = json['modul_id'] ?? json['module_id'];
    final tEval = json['tipe_evaluasi'] ?? json['evaluation_type'];
    final score = json['nilai_akhir'] ?? json['final_score'];
    final passed = json['is_lulus'] ?? json['is_passed'];
    final evalDate = json['tanggal_evaluasi'] ?? json['evaluation_date'];
    final notes = json['catatan'] ?? json['notes'];
    final details = json['detail_penilaian'] ?? json['assessment_detail'];

    final studentObj = json['siswa'] ?? json['student'];
    final teacherObj = json['guru'] ?? json['teacher'];
    final moduleObj = json['modul'] ?? json['module'];

    return EvaluasiRecordModel(
      id: (json['id'] == null || json['id'].toString() == 'null') ? null : json['id'].toString(),
      lembagaId: (lId == null || lId.toString() == 'null') ? '' : lId.toString(),
      siswaId: (sId == null || sId.toString() == 'null') ? '' : sId.toString(),
      guruId: (gId == null || gId.toString() == 'null') ? '' : gId.toString(),
      modulId: (mId == null || mId.toString() == 'null') ? '' : mId.toString(),
      tipeEvaluasi: (tEval ?? 'TASMI').toString(),
      // Explicit Casting sesuai AGENTS.md
      nilaiAkhir: (score as num?)?.toDouble() ?? 0.0,
      isLulus: passed == true, // Boolean mapping
      // Safe Date Parsing
      tanggalEvaluasi: evalDate != null
          ? DateTime.tryParse(evalDate.toString())
          : null,
      catatan: notes?.toString(),
      detailPenilaian: details as Map<String, dynamic>? ?? {},

      // Relasi (jika di-join dengan tabel lain)
      namaSiswa: (studentObj is Map ? (studentObj['nama_lengkap'] ?? studentObj['full_name']) : null)?.toString(),
      namaGuru: (teacherObj is Map ? (teacherObj['nama_lengkap'] ?? teacherObj['full_name']) : null)?.toString(),
      namaModul: (moduleObj is Map ? (moduleObj['nama_modul'] ?? moduleObj['name']) : null)?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'lembaga_id': lembagaId,
      'siswa_id': siswaId,
      'guru_id': guruId,
      'modul_id': modulId,
      'tipe_evaluasi': tipeEvaluasi,
      'nilai_akhir': nilaiAkhir,
      'is_lulus': isLulus,
      'tanggal_evaluasi': tanggalEvaluasi?.toIso8601String(),
      'catatan': catatan,
      'detail_penilaian': detailPenilaian,
    };
  }

  EvaluasiRecordModel copyWith({
    String? id,
    String? lembagaId,
    String? siswaId,
    String? guruId,
    String? modulId,
    String? tipeEvaluasi,
    double? nilaiAkhir,
    bool? isLulus,
    DateTime? tanggalEvaluasi,
    String? catatan,
    Map<String, dynamic>? detailPenilaian,
    String? namaSiswa,
    String? namaGuru,
    String? namaModul,
  }) {
    return EvaluasiRecordModel(
      id: id ?? this.id,
      lembagaId: lembagaId ?? this.lembagaId,
      siswaId: siswaId ?? this.siswaId,
      guruId: guruId ?? this.guruId,
      modulId: modulId ?? this.modulId,
      tipeEvaluasi: tipeEvaluasi ?? this.tipeEvaluasi,
      nilaiAkhir: nilaiAkhir ?? this.nilaiAkhir,
      isLulus: isLulus ?? this.isLulus,
      tanggalEvaluasi: tanggalEvaluasi ?? this.tanggalEvaluasi,
      catatan: catatan ?? this.catatan,
      detailPenilaian: detailPenilaian ?? this.detailPenilaian,
      namaSiswa: namaSiswa ?? this.namaSiswa,
      namaGuru: namaGuru ?? this.namaGuru,
      namaModul: namaModul ?? this.namaModul,
    );
  }
}