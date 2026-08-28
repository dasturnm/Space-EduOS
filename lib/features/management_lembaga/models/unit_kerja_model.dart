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
    lembagaId: json['organization_id']?.toString() ?? json['lembaga_id']?.toString() ?? (json['department'] != null && json['department']['organization_id'] != null ? json['department']['organization_id'].toString() : ''),
    divisiId: json['department_id']?.toString() ?? json['divisi_id']?.toString() ?? '',
    namaUnitKerja: json['name']?.toString() ?? json['nama_unit_kerja']?.toString() ?? '',
    kodeUnit: json['kode_unit']?.toString(),
    deskripsi: json['description']?.toString() ?? json['deskripsi']?.toString(),
    status: json['status']?.toString() ?? 'aktif',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'organization_id': lembagaId,
    'lembaga_id': lembagaId,
    'department_id': divisiId,
    'divisi_id': divisiId,
    'name': namaUnitKerja,
    'nama_unit_kerja': namaUnitKerja,
    'kode_unit': kodeUnit,
    'description': deskripsi,
    'deskripsi': deskripsi,
    'status': status,
  };
}