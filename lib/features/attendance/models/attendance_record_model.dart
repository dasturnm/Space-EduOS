class AttendanceRecordModel {
  final String id;
  final String sessionId;
  final String? studentId;
  final String? staffId;
  final String status; // 'present', 'late', 'excused', 'sick', 'absent'
  final DateTime? checkInTime;
  final String checkInMethod; // 'qr', 'manual', 'gps'
  final double? latitude;
  final double? longitude;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AttendanceRecordModel({
    required this.id,
    required this.sessionId,
    this.studentId,
    this.staffId,
    required this.status,
    this.checkInTime,
    this.checkInMethod = 'manual',
    this.latitude,
    this.longitude,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      studentId: json['student_id'] as String?,
      staffId: json['staff_id'] as String?,
      status: json['status'] as String,
      checkInTime: json['check_in_time'] != null
          ? DateTime.parse(json['check_in_time'] as String)
          : null,
      checkInMethod: json['check_in_method'] as String? ?? 'manual',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
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
      'session_id': sessionId,
      'student_id': studentId,
      'staff_id': staffId,
      'status': status,
      if (checkInTime != null) 'check_in_time': checkInTime!.toIso8601String(),
      'check_in_method': checkInMethod,
      'latitude': latitude,
      'longitude': longitude,
      'notes': notes,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}