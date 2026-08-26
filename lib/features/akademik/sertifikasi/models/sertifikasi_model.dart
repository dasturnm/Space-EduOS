class SertifikasiModel {
  final String id;
  final String organizationId;
  final String studentId;
  final String? moduleId;
  final String type; // 'tasmi', 'ukl', 'program'
  final String certificateNumber;
  final String qrCodeData;
  final String? fileUrl;
  final String status; // 'generated', 'published', 'revoked'
  final DateTime issuedDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SertifikasiModel({
    required this.id,
    required this.organizationId,
    required this.studentId,
    this.moduleId,
    required this.type,
    required this.certificateNumber,
    required this.qrCodeData,
    this.fileUrl,
    this.status = 'generated',
    required this.issuedDate,
    this.createdAt,
    this.updatedAt,
  });

  factory SertifikasiModel.fromJson(Map<String, dynamic> json) {
    return SertifikasiModel(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      studentId: json['student_id'] as String,
      moduleId: json['module_id'] as String?,
      type: json['type'] as String,
      certificateNumber: json['certificate_number'] as String,
      qrCodeData: json['qr_code_data'] as String,
      fileUrl: json['file_url'] as String?,
      status: json['status'] as String? ?? 'generated',
      issuedDate: json['issued_date'] != null
          ? DateTime.parse(json['issued_date'] as String)
          : DateTime.now(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'student_id': studentId,
      'module_id': moduleId,
      'type': type,
      'certificate_number': certificateNumber,
      'qr_code_data': qrCodeData,
      'file_url': fileUrl,
      'status': status,
      'issued_date': issuedDate.toIso8601String().split('T').first,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}