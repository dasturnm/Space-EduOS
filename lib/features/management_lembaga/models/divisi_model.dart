// Lokasi: lib/features/management_lembaga/models/divisi_model.dart

class DivisiModel {
  final String id;
  final String lembagaId;
  final String namaDivisi;
  final String? deskripsi;
  final String? status;

  DivisiModel({
    required this.id,
    required this.lembagaId,
    required this.namaDivisi,
    this.deskripsi,
    this.status,
  });

  DivisiModel copyWith({
    String? id,
    String? lembagaId,
    String? namaDivisi,
    String? deskripsi,
    String? status,
  }) {
    return DivisiModel(
      id: id ?? this.id,
      lembagaId: lembagaId ?? this.lembagaId,
      namaDivisi: namaDivisi ?? this.namaDivisi,
      deskripsi: deskripsi ?? this.deskripsi,
      status: status ?? this.status,
    );
  }

  factory DivisiModel.fromJson(Map<String, dynamic> json) => DivisiModel(
    id: json['id'],
    lembagaId: json['organization_id']?.toString() ?? json['lembaga_id']?.toString() ?? '',
    namaDivisi: json['name']?.toString() ?? json['nama_divisi']?.toString() ?? '',
    deskripsi: json['description']?.toString() ?? json['deskripsi']?.toString(),
    status: json['status']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'organization_id': lembagaId,
    'lembaga_id': lembagaId,
    'name': namaDivisi,
    'nama_divisi': namaDivisi,
    'description': deskripsi,
    'deskripsi': deskripsi,
    'status': status,
  };
}