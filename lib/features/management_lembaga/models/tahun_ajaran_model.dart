// Lokasi: lib/features/management_lembaga/models/tahun_ajaran_model.dart

class TahunAjaranModel {
  final String id;
  final String lembagaId;
  final String labelTahun; // Contoh: 2023/2024
  final String semester; // Ganjil atau Genap
  final bool isAktif;
  final DateTime tanggalMulai;
  final DateTime tanggalSelesai;

  TahunAjaranModel({
    required this.id,
    required this.lembagaId,
    required this.labelTahun,
    required this.semester,
    this.isAktif = false,
    required this.tanggalMulai,
    required this.tanggalSelesai,
  });

  factory TahunAjaranModel.fromJson(Map<String, dynamic> json) => TahunAjaranModel(
    id: json['id'],
    lembagaId: json['organization_id'] ?? json['lembaga_id'] ?? '',
    labelTahun: json['label'] ?? json['label_tahun'] ?? '',
    semester: json['semester'] ?? 'Ganjil',
    isAktif: json['is_active'] ?? json['is_aktif'] ?? false,
    tanggalMulai: DateTime.parse(json['start_date'] ?? json['tanggal_mulai']),
    tanggalSelesai: DateTime.parse(json['end_date'] ?? json['tanggal_selesai']),
  );

  Map<String, dynamic> toJson() => {
    'organization_id': lembagaId,
    'lembaga_id': lembagaId,
    'label': labelTahun,
    'label_tahun': labelTahun,
    'semester': semester,
    'is_active': isAktif,
    'is_aktif': isAktif,
    'start_date': tanggalMulai.toIso8601String(),
    'tanggal_mulai': tanggalMulai.toIso8601String(),
    'end_date': tanggalSelesai.toIso8601String(),
    'tanggal_selesai': tanggalSelesai.toIso8601String(),
  };
}