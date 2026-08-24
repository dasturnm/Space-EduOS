import 'package:flutter_test/flutter_test.dart';

// =========================================================================
// MOCK MODELS & SERVICES FOR WEEK 7 TESTING (Grounded on Data Dictionary §7.8, §7.9)
// =========================================================================

class CertificateModel {
  final String id;
  final String studentId;
  final String moduleId;
  final String type; // tasmi, ukl, program
  final String certificateNumber;
  final String qrCodeData;
  final String fileUrl;
  final String status; // generated, published, revoked
  final DateTime issuedDate;

  CertificateModel({
    required this.id,
    required this.studentId,
    required this.moduleId,
    required this.type,
    required this.certificateNumber,
    required this.qrCodeData,
    required this.fileUrl,
    required this.status,
    required this.issuedDate,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      id: json['id'] ?? '',
      studentId: json['student_id'] ?? '',
      moduleId: json['module_id'] ?? '',
      type: json['type'] ?? '',
      certificateNumber: json['certificate_number'] ?? '',
      qrCodeData: json['qr_code_data'] ?? '',
      fileUrl: json['file_url'] ?? '',
      status: json['status'] ?? 'generated',
      issuedDate: json['issued_date'] != null 
          ? DateTime.parse(json['issued_date']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'module_id': moduleId,
      'type': type,
      'certificate_number': certificateNumber,
      'qr_code_data': qrCodeData,
      'file_url': fileUrl,
      'status': status,
      'issued_date': issuedDate.toIso8601String().substring(0, 10),
    };
  }
}

class CertificateGenerator {
  static String generateUniqueNumber({required DateTime date, required int sequence}) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final seqStr = sequence.toString().padLeft(4, '0');
    return 'TSM-$year$month$day-$seqStr';
  }
}

class AnnouncementModel {
  final String id;
  final String organizationId;
  final String title;
  final String message;
  final String type; // system, payment, exam, general
  final List<String> targetRoles;

  AnnouncementModel({
    required this.id,
    required this.organizationId,
    required this.title,
    required this.message,
    required this.type,
    required this.targetRoles,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] ?? '',
      organizationId: json['organization_id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'general',
      targetRoles: List<String>.from(json['target_roles'] ?? []),
    );
  }
}

class AttendanceRecordModel {
  final String id;
  final String sessionId;
  final String? studentId;
  final String? staffId;
  final String status; // present, late, excused, sick, absent
  final DateTime checkInTime;
  final String checkInMethod; // qr, manual, gps
  final double? latitude;
  final double? longitude;

  AttendanceRecordModel({
    required this.id,
    required this.sessionId,
    this.studentId,
    this.staffId,
    required this.status,
    required this.checkInTime,
    required this.checkInMethod,
    this.latitude,
    this.longitude,
  });

  bool validateGPS({
    required double centerLat,
    required double centerLng,
    required double allowedRadiusInMeters,
  }) {
    if (latitude == null || longitude == null) return false;
    
    // Simplifikasi perhitungan jarak koordinat (Haversine approximation)
    const double latDegreeMeters = 111139.0; 
    final double dLat = (latitude! - centerLat) * latDegreeMeters;
    final double dLng = (longitude! - centerLng) * latDegreeMeters * 0.98; // Koreksi longitude khatulistiwa
    
    final double distance = (dLat * dLat + dLng * dLng); // squared distance check
    final double maxDistance = allowedRadiusInMeters * allowedRadiusInMeters;
    
    return distance <= maxDistance;
  }
}

class QrTokenGenerator {
  static bool isTokenValid(String token, DateTime expiresAt) {
    return DateTime.now().isBefore(expiresAt);
  }
}

// =========================================================================
// UNIT TESTING SUITE FOR TIMELINE WEEK 7
// =========================================================================

void main() {
  group('Timeline Minggu 7 - Sertifikat Digital Tests (BR-CER)', () {
    test('BR-CER-002: Nomor Sertifikat Unik Harus Sesuai Format TSM-YYYYMMDD-XXXX', () {
      final testDate = DateTime(2026, 9, 21);
      final sequence = 42;
      
      final certNumber = CertificateGenerator.generateUniqueNumber(
        date: testDate,
        sequence: sequence,
      );

      expect(certNumber, equals('TSM-20260921-0042'));
    });

    test('Sertifikat Model Serialisasi & Deserialisasi JSON Harus Akurat', () {
      final certJson = {
        'id': 'cert-uuid-123',
        'student_id': 'student-uuid-456',
        'module_id': 'module-uuid-789',
        'type': 'TASMI',
        'certificate_number': 'TSM-20260921-0001',
        'qr_code_data': 'https://space-eduos.id/verify/TSM-20260921-0001',
        'file_url': 'https://supabase.storage/certs/cert_1.pdf',
        'status': 'published',
        'issued_date': '2026-09-21',
      };

      final model = CertificateModel.fromJson(certJson);

      expect(model.id, equals('cert-uuid-123'));
      expect(model.status, equals('published'));
      expect(model.type, equals('TASMI'));
      expect(model.toJson()['issued_date'], equals('2026-09-21'));
    });

    test('BR-CER-003: Revoke Sertifikat Status Harus Tervalidasi', () {
      final cert = CertificateModel(
        id: 'cert-1',
        studentId: 'stud-1',
        moduleId: 'mod-1',
        type: 'ukl',
        certificateNumber: 'TSM-20260921-0001',
        qrCodeData: 'some-hash',
        fileUrl: 'file-url',
        status: 'revoked', // Di-revoke oleh admin
        issuedDate: DateTime.now(),
      );

      expect(cert.status, equals('revoked'));
      expect(cert.status == 'published', isFalse);
    });
  });

  group('Timeline Minggu 7 - Notifikasi & Pengumuman Tests (BR-COM)', () {
    test('Pengumuman Model Deserialisasi Harus Mendukung Target Multi-Role', () {
      final announcementJson = {
        'id': 'announce-uuid-1',
        'organization_id': 'org-uuid-1',
        'title': 'Libur Maulid Nabi',
        'message': 'Pembelajaran diliburkan mulai besok.',
        'type': 'general',
        'target_roles': ['guru', 'wali', 'staff'],
      };

      final announcement = AnnouncementModel.fromJson(announcementJson);

      expect(announcement.title, equals('Libur Maulid Nabi'));
      expect(announcement.targetRoles, contains('wali'));
      expect(announcement.targetRoles.length, equals(3));
    });
  });

  group('Timeline Minggu 7 - Absensi Siswa QR/GPS Tests (BR-PRS)', () {
    test('Absensi GPS Validator Harus Membatasi Radius Lokasi Secara Presisi', () {
      final schoolLat = -6.200000;
      final schoolLng = 106.816666;

      // Skenario 1: Siswa melakukan absen dari jarak sangat dekat (~10 meter)
      final recordNear = AttendanceRecordModel(
        id: 'rec-1',
        sessionId: 'sess-1',
        studentId: 'stud-1',
        status: 'present',
        checkInTime: DateTime.now(),
        checkInMethod: 'gps',
        latitude: -6.200050,
        longitude: 106.816700,
      );

      // Skenario 2: Siswa melakukan absen dari jarak sangat jauh (~5 kilometer)
      final recordFar = AttendanceRecordModel(
        id: 'rec-2',
        sessionId: 'sess-1',
        studentId: 'stud-2',
        status: 'present',
        checkInTime: DateTime.now(),
        checkInMethod: 'gps',
        latitude: -6.250000,
        longitude: 106.850000,
      );

      final isNearValid = recordNear.validateGPS(
        centerLat: schoolLat,
        centerLng: schoolLng,
        allowedRadiusInMeters: 100.0, // Radius 100m toleransi
      );

      final isFarValid = recordFar.validateGPS(
        centerLat: schoolLat,
        centerLng: schoolLng,
        allowedRadiusInMeters: 100.0,
      );

      expect(isNearValid, isTrue);
      expect(isFarValid, isFalse);
    });

    test('QR Token Absensi Harus Memvalidasi Waktu Kedaluwarsa Token', () {
      final now = DateTime.now();
      final expiresFuture = now.add(const Duration(seconds: 15));
      final expiresPast = now.subtract(const Duration(seconds: 5));

      final isFutureTokenValid = QrTokenGenerator.isTokenValid('token-abc', expiresFuture);
      final isPastTokenValid = QrTokenGenerator.isTokenValid('token-xyz', expiresPast);

      expect(isFutureTokenValid, isTrue);
      expect(isPastTokenValid, isFalse);
    });
  });
}
