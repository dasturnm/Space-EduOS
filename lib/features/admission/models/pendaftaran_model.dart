class PendaftaranModel {
  final String id;
  final String organizationId;
  final String namaLengkap;
  final String? nisn;
  final String? tempatLahir;
  final DateTime? tanggalLahir;
  final String? jenisKelamin; // 'L' atau 'P'
  final String? alamat;
  final String namaWali;
  final String noHpWali;
  final String? programPilihanId;
  final String status; // 'registrasi', 'verifikasi', 'approval', 'enrolled', 'ditolak'
  final Map<String, dynamic> dokumenUrls;
  final String? catatanAdmin;
  final DateTime createdAt;

  PendaftaranModel({
    required this.id,
    required this.organizationId,
    required this.namaLengkap,
    this.nisn,
    this.tempatLahir,
    this.tanggalLahir,
    this.jenisKelamin,
    this.alamat,
    required this.namaWali,
    required this.noHpWali,
    this.programPilihanId,
    required this.status,
    this.dokumenUrls = const {},
    this.catatanAdmin,
    required this.createdAt,
  });

  factory PendaftaranModel.fromJson(Map<String, dynamic> json) {
    return PendaftaranModel(
      id: json['id'] ?? '',
      organizationId: json['organization_id'] ?? json['lembaga_id'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? json['nama_siswa'] ?? '',
      nisn: json['nisn'],
      tempatLahir: json['tempat_lahir'],
      tanggalLahir: json['tanggal_lahir'] != null
          ? DateTime.parse(json['tanggal_lahir'])
          : null,
      jenisKelamin: json['jenis_kelamin'],
      alamat: json['alamat'],
      namaWali: json['nama_wali'] ?? '',
      noHpWali: json['no_hp_wali'] ?? '',
      programPilihanId: json['program_pilihan_id'] ?? json['program_id'],
      status: json['status'] ?? 'registrasi',
      dokumenUrls: json['dokumen_urls'] is Map<String, dynamic>
          ? json['dokumen_urls']
          : {},
      catatanAdmin: json['catatan_admin'] ?? json['catatan'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'organization_id': organizationId,
      'nama_lengkap': namaLengkap,
      'nisn': nisn,
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': tanggalLahir?.toIso8601String().split('T')[0],
      'jenis_kelamin': jenisKelamin,
      'alamat': alamat,
      'nama_wali': namaWali,
      'no_hp_wali': noHpWali,
      'program_pilihan_id': programPilihanId,
      'status': status,
      'dokumen_urls': dokumenUrls,
      'catatan_admin': catatanAdmin,
    };
  }
}
