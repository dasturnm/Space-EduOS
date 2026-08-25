class InvoiceModel {
  final String? id;
  final String organizationId;
  final String studentId;
  final String invoiceNumber;
  final DateTime issueDate;
  final DateTime dueDate;
  final double subtotal;
  final double discount;
  final double charges;
  final double total;
  final double outstanding;
  final String status;
  final String? notes;

  InvoiceModel({
    this.id,
    required this.organizationId,
    required this.studentId,
    required this.invoiceNumber,
    required this.issueDate,
    required this.dueDate,
    required this.subtotal,
    this.discount = 0.0,
    this.charges = 0.0,
    required this.total,
    required this.outstanding,
    this.status = 'issued',
    this.notes,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id']?.toString(),
      organizationId: (json['organization_id'] ?? json['lembaga_id'] ?? '').toString(),
      studentId: (json['student_id'] ?? json['siswa_id'] ?? '').toString(),
      invoiceNumber: json['invoice_number'] ?? json['nomor_tagihan'] ?? '',
      issueDate: json['issue_date'] != null
          ? DateTime.parse(json['issue_date'].toString())
          : DateTime.now(),
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'].toString())
          : DateTime.now(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      discount: (json['discount'] ?? json['diskon'] ?? 0).toDouble(),
      charges: (json['charges'] ?? json['denda'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      outstanding: (json['outstanding'] ?? json['sisa_tagihan'] ?? 0).toDouble(),
      status: json['status'] ?? 'issued',
      notes: json['notes'] ?? json['catatan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'organization_id': organizationId,
      'student_id': studentId,
      'invoice_number': invoiceNumber,
      'issue_date': issueDate.toIso8601String().split('T')[0],
      'due_date': dueDate.toIso8601String().split('T')[0],
      'subtotal': subtotal,
      'discount': discount,
      'charges': charges,
      'total': total,
      'outstanding': outstanding,
      'status': status,
      'notes': notes,
    };
  }
}