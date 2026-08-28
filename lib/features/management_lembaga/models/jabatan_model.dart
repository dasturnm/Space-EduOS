// Lokasi: lib/features/management_lembaga/models/jabatan_model.dart

class JabatanModel {
  final String id;
  final String lembagaId; // Ditambahkan agar data tidak jadi hantu
  final String divisiId;
  final String? unitKerjaId; // TAMBAHAN HARI 3: Unit Kerja
  final String namaJabatan;
  final String defaultRole; // ADMIN_PUSAT, ADMIN_CABANG, GURU, STAFF
  final String? status;
  final int? levelJabatan;
  final String? catatanJabatan;
  final List<String>? permissions; // FIX: Tambahkan permissions

  JabatanModel({
    required this.id,
    required this.lembagaId, // Wajib diisi
    required this.divisiId,
    this.unitKerjaId,
    required this.namaJabatan,
    required this.defaultRole,
    this.status,
    this.levelJabatan,
    this.catatanJabatan,
    this.permissions,
  });

  JabatanModel copyWith({
    String? id,
    String? lembagaId,
    String? divisiId,
    String? unitKerjaId,
    String? namaJabatan,
    String? defaultRole,
    String? status,
    int? levelJabatan,
    String? catatanJabatan,
    List<String>? permissions,
  }) {
    return JabatanModel(
      id: id ?? this.id,
      lembagaId: lembagaId ?? this.lembagaId,
      divisiId: divisiId ?? this.divisiId,
      unitKerjaId: unitKerjaId ?? this.unitKerjaId,
      namaJabatan: namaJabatan ?? this.namaJabatan,
      defaultRole: defaultRole ?? this.defaultRole,
      status: status ?? this.status,
      levelJabatan: levelJabatan ?? this.levelJabatan,
      catatanJabatan: catatanJabatan ?? this.catatanJabatan,
      permissions: permissions ?? this.permissions,
    );
  }

  factory JabatanModel.fromJson(Map<String, dynamic> json) => JabatanModel(
    id: json['id'],
    lembagaId: json['organization_id']?.toString() ?? json['lembaga_id']?.toString() ?? '',
    divisiId: json['department_id']?.toString() ?? json['divisi_id']?.toString() ?? '',
    unitKerjaId: json['work_unit_id']?.toString() ?? json['unit_kerja_id']?.toString(),
    namaJabatan: json['title']?.toString() ?? json['nama_jabatan']?.toString() ?? '',
    defaultRole: json['default_role']?.toString() ?? 'GURU',
    status: json['status']?.toString(),
    levelJabatan: json['level_jabatan'],
    catatanJabatan: json['catatan_jabatan']?.toString(),
    permissions: json['permissions'] != null ? List<String>.from(json['permissions']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'organization_id': lembagaId,
    'lembaga_id': lembagaId,
    'department_id': divisiId,
    'divisi_id': divisiId,
    'work_unit_id': unitKerjaId,
    'unit_kerja_id': unitKerjaId,
    'title': namaJabatan,
    'nama_jabatan': namaJabatan,
    'default_role': defaultRole,
    'status': status,
    'level_jabatan': levelJabatan,
    'catatan_jabatan': catatanJabatan,
    'permissions': permissions,
  };
}