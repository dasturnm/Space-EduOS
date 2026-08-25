class PaymentModel {
  final String? id;
  final String invoiceId;
  final double amount;
  final String method;
  final String? proofUrl;
  final DateTime paymentDate;
  final String status;
  final String? notes;

  PaymentModel({
    this.id,
    required this.invoiceId,
    required this.amount,
    required this.method,
    this.proofUrl,
    required this.paymentDate,
    this.status = 'success',
    this.notes,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id']?.toString(),
      invoiceId: (json['invoice_id'] ?? json['tagihan_id'] ?? '').toString(),
      amount: (json['amount'] ?? json['nominal'] ?? 0).toDouble(),
      method: json['method'] ?? json['metode'] ?? 'cash',
      proofUrl: json['proof_url'] ?? json['bukti_url'],
      paymentDate: json['payment_date'] != null
          ? DateTime.parse(json['payment_date'].toString())
          : DateTime.now(),
      status: json['status'] ?? 'success',
      notes: json['notes'] ?? json['catatan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'invoice_id': invoiceId,
      'amount': amount,
      'method': method,
      'proof_url': proofUrl,
      'payment_date': paymentDate.toIso8601String(),
      'status': status,
      'notes': notes,
    };
  }
}