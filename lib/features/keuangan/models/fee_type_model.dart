class FeeTypeModel {
  final String? id;
  final String organizationId;
  final String name;
  final String code;
  final String? description;
  final double amount;
  final String period;
  final bool isActive;

  FeeTypeModel({
    this.id,
    required this.organizationId,
    required this.name,
    required this.code,
    this.description,
    required this.amount,
    required this.period,
    this.isActive = true,
  });

  factory FeeTypeModel.fromJson(Map<String, dynamic> json) {
    return FeeTypeModel(
      id: json['id']?.toString(),
      organizationId: (json['organization_id'] ?? json['lembaga_id'] ?? '').toString(),
      name: json['name'] ?? json['nama'] ?? '',
      code: json['code'] ?? json['kode'] ?? '',
      description: json['description'] ?? json['keterangan'],
      amount: (json['amount'] ?? json['nominal'] ?? 0).toDouble(),
      period: json['period'] ?? json['periode'] ?? 'monthly',
      isActive: json['is_active'] ?? json['is_aktif'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'organization_id': organizationId,
      'name': name,
      'code': code,
      'description': description,
      'amount': amount,
      'period': period,
      'is_active': isActive,
    };
  }
}