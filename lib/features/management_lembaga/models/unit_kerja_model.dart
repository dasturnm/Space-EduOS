// Lokasi: lib/features/management_lembaga/models/unit_kerja_model.dart

class UnitKerjaModel {
  final String id;
  final String lembagaId;
  final String divisiId;
  final String namaUnitKerja;
  final String? kodeUnit;
  final String? deskripsi;
  final String status;

  UnitKerjaModel({
    required this.id,
    required this.lembagaId,
    required this.divisiId,
    required this.namaUnitKerja,
    this.kodeUnit,
    this.deskripsi,
    this.status = 'aktif',
  });

  UnitKerjaModel copyWith({
    String? id,
    String? lembagaId,
    String? divisiId,
    String? namaUnitKerja,
    String? kodeUnit,
    String? deskripsi,
    String? status,
  }) {
    return UnitKerjaModel(
      id: id ?? this.id,
      lembagaId: lembagaId ?? this.lembagaId,
      divisiId: divisiId ?? this.divisiId,
      namaUnitKerja: namaUnitKerja ?? this.namaUnitKerja,
      kodeUnit: kodeUnit ?? this.kodeUnit,
      deskripsi: deskripsi ?? this.deskripsi,
      status: status ?? this.status,
    );
  }

  factory UnitKerjaModel.fromJson(Map<String, dynamic> json) => UnitKerjaModel(
    id: json['id'],
    lembagaId: json['lembaga_id'] ?? '',
    divisiId: json['divisi_id'] ?? '',
    namaUnitKerja: json['nama_unit_kerja'] ?? '',
    kodeUnit: json['kode_unit'],
    deskripsi: json['deskripsi'],
    status: json['status'] ?? 'aktif',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'lembaga_id': lembagaId,
    'divisi_id': divisiId,
    'nama_unit_kerja': namaUnitKerja,
    'kode_unit': kodeUnit,
    'deskripsi': deskripsi,
    'status': status,
  };
}