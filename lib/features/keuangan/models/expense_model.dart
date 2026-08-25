class ExpenseModel {
  final String? id;
  final String organizationId;
  final String category;
  final String description;
  final double amount;
  final DateTime date;
  final String? proofUrl;

  ExpenseModel({
    this.id,
    required this.organizationId,
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
    this.proofUrl,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id']?.toString(),
      organizationId: (json['organization_id'] ?? json['lembaga_id'] ?? '').toString(),
      category: json['category'] ?? json['kategori'] ?? 'Operasional',
      description: json['description'] ?? json['keterangan'] ?? '',
      amount: (json['amount'] ?? json['nominal'] ?? 0).toDouble(),
      date: json['date'] != null
          ? DateTime.parse(json['date'].toString())
          : DateTime.now(),
      proofUrl: json['proof_url'] ?? json['bukti_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'organization_id': organizationId,
      'category': category,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String().split('T')[0],
      'proof_url': proofUrl,
    };
  }
}