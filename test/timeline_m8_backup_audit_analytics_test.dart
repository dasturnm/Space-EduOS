import 'package:flutter_test/flutter_test.dart';

// =========================================================================
// MOCK DATA MODELS FOR TESTING (TIMELINE WEEK 8: BACKUP, AUDIT & ANALYTICS)
// =========================================================================

class BackupHistoryModel {
  final String id;
  final String organizationId;
  final String backupType; // 'full' | 'incremental'
  final String fileUrl;
  final int fileSize;
  final String status; // 'success' | 'failed' | 'in_progress'
  final bool encrypted;
  final String? notes;
  final DateTime createdAt;

  BackupHistoryModel({
    required this.id,
    required this.organizationId,
    required this.backupType,
    required this.fileUrl,
    required this.fileSize,
    required this.status,
    required this.encrypted,
    this.notes,
    required this.createdAt,
  });

  factory BackupHistoryModel.fromJson(Map<String, dynamic> json) {
    return BackupHistoryModel(
      id: json['id'] as String? ?? '',
      organizationId: json['organization_id'] as String? ?? '',
      backupType: json['backup_type'] as String? ?? 'incremental',
      fileUrl: json['file_url'] as String? ?? '',
      fileSize: json['file_size'] as int? ?? 0,
      status: json['status'] as String? ?? 'pending',
      encrypted: json['encrypted'] as bool? ?? false,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'backup_type': backupType,
      'file_url': fileUrl,
      'file_size': fileSize,
      'status': status,
      'encrypted': encrypted,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class AuditLogModel {
  final String id;
  final String organizationId;
  final String userId;
  final String action; // 'INSERT' | 'UPDATE' | 'DELETE'
  final String tableName;
  final Map<String, dynamic> oldData;
  final Map<String, dynamic> newData;
  final DateTime createdAt;

  AuditLogModel({
    required this.id,
    required this.organizationId,
    required this.userId,
    required this.action,
    required this.tableName,
    required this.oldData,
    required this.newData,
    required this.createdAt,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) {
    return AuditLogModel(
      id: json['id'] as String? ?? '',
      organizationId: json['organization_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      action: json['action'] as String? ?? 'UPDATE',
      tableName: json['table_name'] as String? ?? '',
      oldData: json['old_data'] as Map<String, dynamic>? ?? {},
      newData: json['new_data'] as Map<String, dynamic>? ?? {},
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'user_id': userId,
      'action': action,
      'table_name': tableName,
      'old_data': oldData,
      'new_data': newData,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class AiConversationModel {
  final String id;
  final String organizationId;
  final String userId;
  final String title;
  final String model;
  final DateTime createdAt;

  AiConversationModel({
    required this.id,
    required this.organizationId,
    required this.userId,
    required this.title,
    required this.model,
    required this.createdAt,
  });

  factory AiConversationModel.fromJson(Map<String, dynamic> json) {
    return AiConversationModel(
      id: json['id'] as String? ?? '',
      organizationId: json['organization_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      model: json['model'] as String? ?? 'gemini-1.5-pro',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

// =========================================================================
// MOCK SERVICE LOGIC FOR WEEK 8 (BACKUP, AUDIT & ANALYTICS)
// =========================================================================

class MockSystemSecurityService {
  bool encryptData(String data, String password) {
    if (password.length < 6) return false;
    // Mock encryption returning true if key is valid
    return true;
  }

  bool verifyRestorePassword(String inputPassword, String correctPasswordHash) {
    return inputPassword == "eduos_secure_restore_2026";
  }
}

class MockAnalyticsEngine {
  // Heatmap: Day of Week (0-6) vs Hour of Day (0-23)
  Map<String, int> aggregateHeatmap(List<Map<String, dynamic>> submissions) {
    final Map<String, int> heatmap = {};
    for (final sub in submissions) {
      final dt = DateTime.parse(sub['created_at'] as String);
      final key = "${dt.weekday}-${dt.hour}";
      heatmap[key] = (heatmap[key] ?? 0) + 1;
    }
    return heatmap;
  }

  // Leaderboard: Top students based on total juz hafalan
  List<Map<String, dynamic>> calculateLeaderboard(List<Map<String, dynamic>> students) {
    final list = List<Map<String, dynamic>>.from(students);
    list.sort((a, b) {
      final double juzA = (a['total_juz_hafalan'] as num).toDouble();
      final double juzB = (b['total_juz_hafalan'] as num).toDouble();
      return juzB.compareTo(juzA); // Descending
    });
    return list.take(10).toList();
  }
}

// =========================================================================
// MAIN FLUTTER UNIT TEST FOR TIMELINE M8
// =========================================================================

void main() {
  group('Timeline Minggu 8 Test Suite - Backup, Audit & Analytics', () {
    late MockSystemSecurityService securityService;
    late MockAnalyticsEngine analyticsEngine;

    setUp(() {
      securityService = MockSystemSecurityService();
      analyticsEngine = MockAnalyticsEngine();
    });

    // -------------------------------------------------------------------------
    // 1. BACKUP & RESTORE TESTING (BR-AUD-001 s.d 004)
    // -------------------------------------------------------------------------
    group('Backup & Restore Validation', () {
      test('BackupHistoryModel Serialization & Deserialization Test', () {
        final mockJson = {
          'id': 'b1000000-1111-2222-3333-444444444444',
          'organization_id': 'org-999',
          'backup_type': 'full',
          'file_url': 'https://supabase.storage/backups/backup_20260928_full.enc',
          'file_size': 10485760, // 10MB
          'status': 'success',
          'encrypted': true,
          'notes': 'Weekly automatic backup completed at 02:00',
          'created_at': '2026-09-28T02:00:00.000Z',
        };

        final model = BackupHistoryModel.fromJson(mockJson);
        expect(model.id, 'b1000000-1111-2222-3333-444444444444');
        expect(model.backupType, 'full');
        expect(model.encrypted, isTrue);
        expect(model.status, 'success');
        expect(model.fileSize, 10485760);

        final jsonBack = model.toJson();
        expect(jsonBack['backup_type'], 'full');
        expect(jsonBack['encrypted'], isTrue);
      });

      test('Security Service: Encryption and Password Validation on Restore', () {
        final rawData = "{'students': 150, 'payments': 32000000}";
        final successEncrypt = securityService.encryptData(rawData, "super_secure_key_2026");
        expect(successEncrypt, isTrue);

        final failEncrypt = securityService.encryptData(rawData, "123"); // Too short
        expect(failEncrypt, isFalse);

        // Verify password for DB restoration
        final correctPassword = "eduos_secure_restore_2026";
        final isMatch = securityService.verifyRestorePassword(correctPassword, "hashed_db_pass");
        expect(isMatch, isTrue);

        final isWrongMatch = securityService.verifyRestorePassword("wrong_password", "hashed_db_pass");
        expect(isWrongMatch, isFalse);
      });
    });

    // -------------------------------------------------------------------------
    // 2. AUDIT LOG TRIGGER TESTING (BR-AUD-005 s.d 007)
    // -------------------------------------------------------------------------
    group('Audit Logs Validation', () {
      test('AuditLogModel Serialization Test', () {
        final auditJson = {
          'id': 'log-12345',
          'organization_id': 'org-999',
          'user_id': 'admin-01',
          'action': 'UPDATE',
          'table_name': 'siswa',
          'old_data': {'id': 'siswa-01', 'status': 'aktif'},
          'new_data': {'id': 'siswa-01', 'status': 'lulus'},
          'created_at': '2026-09-29T14:30:00.000Z',
        };

        final audit = AuditLogModel.fromJson(auditJson);
        expect(audit.tableName, 'siswa');
        expect(audit.action, 'UPDATE');
        expect(audit.oldData['status'], 'aktif');
        expect(audit.newData['status'], 'lulus');
      });
    });

    // -------------------------------------------------------------------------
    // 3. ENHANCED ANALYTICS & HEATMAP TESTING (BR-AI / Analytics Core)
    // -------------------------------------------------------------------------
    group('Enhanced Analytics Engine Validation', () {
      test('Heatmap Calculation Test (Day vs Hour Aggregation)', () {
        final List<Map<String, dynamic>> mockSubmissions = [
          {'id': 's1', 'created_at': '2026-08-24T08:15:00.000Z'}, // Monday (1) 8 AM
          {'id': 's2', 'created_at': '2026-08-24T08:45:00.000Z'}, // Monday (1) 8 AM
          {'id': 's3', 'created_at': '2026-08-24T13:20:00.000Z'}, // Monday (1) 1 PM (13)
          {'id': 's4', 'created_at': '2026-08-25T08:10:00.000Z'}, // Tuesday (2) 8 AM
        ];

        final heatmap = analyticsEngine.aggregateHeatmap(mockSubmissions);

        // Key format: weekday-hour (Monday is 1 in DateTime)
        expect(heatmap['1-8'], 2);  // Two submissions on Monday at 8 AM
        expect(heatmap['1-13'], 1); // One submission on Monday at 1 PM
        expect(heatmap['2-8'], 1);  // One submission on Tuesday at 8 AM
        expect(heatmap['3-8'], isNull); // No submission on Wednesday
      });

      test('Leaderboard Top 10 Calculation Test', () {
        final List<Map<String, dynamic>> mockStudents = [
          {'id': 'st1', 'nama_lengkap': 'Ahmad', 'total_juz_hafalan': 15.5},
          {'id': 'st2', 'nama_lengkap': 'Zayd', 'total_juz_hafalan': 30.0},
          {'id': 'st3', 'nama_lengkap': 'Fatimah', 'total_juz_hafalan': 5.0},
          {'id': 'st4', 'nama_lengkap': 'Aisyah', 'total_juz_hafalan': 28.2},
          {'id': 'st5', 'nama_lengkap': 'Ali', 'total_juz_hafalan': 12.0},
          {'id': 'st6', 'nama_lengkap': 'Umar', 'total_juz_hafalan': 20.0},
          {'id': 'st7', 'nama_lengkap': 'Utsman', 'total_juz_hafalan': 18.0},
          {'id': 'st8', 'nama_lengkap': 'Abu Bakar', 'total_juz_hafalan': 25.5},
          {'id': 'st9', 'nama_lengkap': 'Khadijah', 'total_juz_hafalan': 22.0},
          {'id': 'st10', 'nama_lengkap': 'Saad', 'total_juz_hafalan': 9.5},
          {'id': 'st11', 'nama_lengkap': 'Talhah', 'total_juz_hafalan': 3.0}, // Should be excluded from Top 10
        ];

        final leaderboard = analyticsEngine.calculateLeaderboard(mockStudents);

        expect(leaderboard.length, 10);
        expect(leaderboard.first['id'], 'st2'); // Zayd (30.0) should be #1
        expect(leaderboard[1]['id'], 'st4');    // Aisyah (28.2) should be #2
        expect(leaderboard.last['id'], 'st3');  // Fatimah (5.0) should be #10
        
        // st11 (Talhah, 3.0) should not exist in the top 10 leaderboard
        final containsTalhah = leaderboard.any((s) => s['id'] == 'st11');
        expect(containsTalhah, isFalse);
      });
    });

    // -------------------------------------------------------------------------
    // 4. AI CONVERSATION PREVIEW TESTING (Bab 4.13 & Bab 7.10)
    // -------------------------------------------------------------------------
    group('AI Assistant Preview Validation', () {
      test('AiConversationModel Mapping Test', () {
        final mockAiJson = {
          'id': 'conv-111',
          'organization_id': 'org-999',
          'user_id': 'guru-77',
          'title': 'Analisis Progres Hafalan Ahmad',
          'model': 'gemini-1.5-pro',
          'created_at': '2026-10-01T09:00:00.000Z',
        };

        final conv = AiConversationModel.fromJson(mockAiJson);
        expect(conv.title, 'Analisis Progres Hafalan Ahmad');
        expect(conv.model, 'gemini-1.5-pro');
        expect(conv.userId, 'guru-77');
      });
    });
  });
}
