// Lokasi: lib/features/program/models/agenda_model.dart

class AgendaModel {
  final String? id; // FIX: Opsional untuk sinkronisasi insert DB
  final String lembagaId;
  final String? tahunAjaranId; // FIX: Opsional sesuai skema DB
  final String namaAgenda;
  final DateTime tanggalMulai;
  final DateTime tanggalBerakhir;
  final String statusHariBelajar; // EFEKTIF atau LIBUR
  final String scope; // GLOBAL atau PROG_SPESIFIK
  final String? programId;
  final String? keterangan;
  final bool isSiswaLibur;
  final bool isGuruMasuk;

  AgendaModel({
    this.id, // FIX: Tidak lagi required
    required this.lembagaId,
    this.tahunAjaranId, // FIX: Tidak lagi required
    required this.namaAgenda,
    required this.tanggalMulai,
    required this.tanggalBerakhir,
    required this.statusHariBelajar,
    required this.scope,
    this.programId,
    this.keterangan,
    this.isSiswaLibur = false, // DEFAULT sesuai DB
    this.isGuruMasuk = true, // DEFAULT sesuai DB
  });

  factory AgendaModel.fromJson(Map<String, dynamic> json) => AgendaModel(
    // FIX: Gunakan pengecekan string 'null' untuk UUID safety
    id: (json['id'] == null || json['id'].toString() == 'null') ? null : json['id'].toString(),
    lembagaId: (json['lembaga_id'] ?? json['organization_id'])?.toString() ?? '',
    tahunAjaranId: ((json['tahun_ajaran_id'] ?? json['academic_year_id']) == null || (json['tahun_ajaran_id'] ?? json['academic_year_id']).toString() == 'null')
        ? null
        : (json['tahun_ajaran_id'] ?? json['academic_year_id']).toString(),
    namaAgenda: (json['nama_agenda'] ?? json['title'])?.toString() ?? '',
    // Parsing tanggal aman
    tanggalMulai: DateTime.tryParse((json['tanggal_mulai'] ?? json['start_date'])?.toString() ?? '') ?? DateTime.now(),
    tanggalBerakhir: DateTime.tryParse((json['tanggal_berakhir'] ?? json['end_date'])?.toString() ?? '') ?? DateTime.now(),
    statusHariBelajar: (json['status_hari_belajar'] ?? json['learning_status'])?.toString() ?? 'EFEKTIF',
    scope: json['scope']?.toString() ?? 'GLOBAL',
    programId: json['program_id']?.toString(),
    keterangan: (json['keterangan'] ?? json['description'])?.toString(),
    isSiswaLibur: (json['is_siswa_libur'] ?? json['is_student_holiday']) == true,
    isGuruMasuk: (json['is_guru_masuk'] ?? json['is_teacher_attendance']) ?? true,
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id, // FIX: Kirim ID hanya jika tidak null
    'lembaga_id': lembagaId,
    'tahun_ajaran_id': tahunAjaranId,
    'nama_agenda': namaAgenda,
    // FIX: Format YYYY-MM-DD agar sinkron dengan tipe 'date' di DB
    'tanggal_mulai': tanggalMulai.toIso8601String().split('T')[0],
    'tanggal_berakhir': tanggalBerakhir.toIso8601String().split('T')[0],
    'status_hari_belajar': statusHariBelajar,
    'scope': scope,
    'program_id': programId,
    'keterangan': keterangan,
    'is_siswa_libur': isSiswaLibur,
    'is_guru_masuk': isGuruMasuk,
  };

  AgendaModel copyWith({
    String? id,
    String? lembagaId,
    String? tahunAjaranId,
    String? namaAgenda,
    DateTime? tanggalMulai,
    DateTime? tanggalBerakhir,
    String? statusHariBelajar,
    String? scope,
    String? programId,
    String? keterangan,
    bool? isSiswaLibur,
    bool? isGuruMasuk,
  }) {
    return AgendaModel(
      id: id ?? this.id,
      lembagaId: lembagaId ?? this.lembagaId,
      tahunAjaranId: tahunAjaranId ?? this.tahunAjaranId,
      namaAgenda: namaAgenda ?? this.namaAgenda,
      tanggalMulai: tanggalMulai ?? this.tanggalMulai,
      tanggalBerakhir: tanggalBerakhir ?? this.tanggalBerakhir,
      statusHariBelajar: statusHariBelajar ?? this.statusHariBelajar,
      scope: scope ?? this.scope,
      programId: programId ?? this.programId,
      keterangan: keterangan ?? this.keterangan,
      isSiswaLibur: isSiswaLibur ?? this.isSiswaLibur,
      isGuruMasuk: isGuruMasuk ?? this.isGuruMasuk,
    );
  }
}