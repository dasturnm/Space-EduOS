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
    lembagaId: json['lembaga_id'] ?? '',
    divisiId: json['divisi_id'] ?? '',
    unitKerjaId: json['unit_kerja_id'],
    namaJabatan: json['nama_jabatan'] ?? '',
    defaultRole: json['default_role'] ?? 'GURU',
    status: json['status'],
    levelJabatan: json['level_jabatan'],
    catatanJabatan: json['catatan_jabatan'],
    permissions: json['permissions'] != null ? List<String>.from(json['permissions']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'lembaga_id': lembagaId,
    'divisi_id': divisiId,
    'unit_kerja_id': unitKerjaId,
    'nama_jabatan': namaJabatan,
    'default_role': defaultRole,
    'status': status,
    'level_jabatan': levelJabatan,
    'catatan_jabatan': catatanJabatan,
    'permissions': permissions,
  };
}