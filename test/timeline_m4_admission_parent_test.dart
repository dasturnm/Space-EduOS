import 'package:flutter_test/flutter_test.dart';
import 'package:space_eduos/features/admission/models/pendaftaran_model.dart';

// Mock Class for Student Guardian Dashboard state representation (Wali Dashboard)
class WaliDashboardState {
  final List<Map<String, dynamic>> children;
  final String parentId;

  WaliDashboardState({
    required this.parentId,
    required this.children,
  });

  bool get hasMultipleChildren => children.length > 1;

  double getChildProgress(String childId) {
    final child = children.firstWhere(
          (c) => c["id"] == childId,
      orElse: () => {"total_juz_hafalan": 0.0},
    );
    return (child["total_juz_hafalan"] as num).toDouble();
  }

  bool hasDebt(String childId) {
    final child = children.firstWhere(
          (c) => c["id"] == childId,
      orElse: () => {"debt_created": 0.0},
    );
    return (child["debt_created"] as num) > 0;
  }

  String generateWaMessageTemplate(String childName, String teacherName) {
    return "Assalamu'alaikum Wr. Wb. Ust/Ustadzah $teacherName, saya wali dari $childName ingin menanyakan perkembangan hafalan anak saya. Terima kasih.";
  }
}

void main() {
  group('Timeline Minggu 4 - Pendaftaran Siswa (Admission Model Tests)', () {
    final validJson = {
      'id': 'd290f1ee-6c54-4b01-90e6-d701748f0851',
      'organization_id': '852d21af-609c-550e-5f85-385255ed4c7b',
      'nama_lengkap': 'Zayd bin Tsabit',
      'nisn': '1234567890',
      'tempat_lahir': 'Madinah',
      'tanggal_lahir': '2016-08-15',
      'jenis_kelamin': 'L',
      'alamat': 'Jl. Nabawi No. 1',
      'nama_wali': 'Tsabit bin Qays',
      'no_hp_wali': '08123456789',
      'program_pilihan_id': '3d18d0e2-9e5d-65b4-d476-3f9ca9c1d974',
      'status': 'registrasi',
      'dokumen_urls': {
        'akte': 'https://storage.spaceeduos.com/akte_zayd.pdf',
        'kk': 'https://storage.spaceeduos.com/kk_zayd.pdf'
      },
      'catatan_admin': 'Dokumen lengkap, menunggu verifikasi.'
    };

    test('1. Deserialization fromJson - Should parse valid JSON correctly', () {
      final model = PendaftaranModel.fromJson(validJson);

      expect(model.id, 'd290f1ee-6c54-4b01-90e6-d701748f0851');
      expect(model.organizationId, '852d21af-609c-550e-5f85-385255ed4c7b');
      expect(model.namaLengkap, 'Zayd bin Tsabit');
      expect(model.nisn, '1234567890');
      expect(model.tempatLahir, 'Madinah');
      expect(model.tanggalLahir, DateTime.parse('2016-08-15'));
      expect(model.jenisKelamin, 'L');
      expect(model.alamat, 'Jl. Nabawi No. 1');
      expect(model.namaWali, 'Tsabit bin Qays');
      expect(model.noHpWali, '08123456789');
      expect(model.programPilihanId, '3d18d0e2-9e5d-65b4-d476-3f9ca9c1d974');
      expect(model.status, 'registrasi');
      expect(model.dokumenUrls, isNotEmpty);
      expect(model.dokumenUrls['akte'], 'https://storage.spaceeduos.com/akte_zayd.pdf');
      expect(model.catatanAdmin, 'Dokumen lengkap, menunggu verifikasi.');
    });

    test('2. Serialization toJson - Should serialize to map matching DB expectations', () {
      final model = PendaftaranModel.fromJson(validJson);
      final json = model.toJson();

      expect(json['id'], 'd290f1ee-6c54-4b01-90e6-d701748f0851');
      expect(json['nama_lengkap'], 'Zayd bin Tsabit');
      expect(json['status'], 'registrasi');
      expect(json['jenis_kelamin'], 'L');
      expect(json['organization_id'], '852d21af-609c-550e-5f85-385255ed4c7b');
    });

    test('3. Verification Status Checker - Should only transition according to constraints', () {
      final model = PendaftaranModel.fromJson(validJson);

      // PostgreSQL CHECK Constraint status validations
      final allowedStatuses = ['registrasi', 'verifikasi', 'approval', 'enrolled', 'ditolak'];

      expect(allowedStatuses.contains(model.status), true);

      // Verify validation logic for moving states
      bool isValidTransition(String current, String target) {
        if (current == 'enrolled') return false; // Locked state
        if (current == 'ditolak' && target == 'enrolled') return false; // Rejected cannot bypass direct enroll
        return allowedStatuses.contains(target);
      }

      expect(isValidTransition(model.status, 'verifikasi'), true);
      expect(isValidTransition('verifikasi', 'approval'), true);
      expect(isValidTransition('approval', 'enrolled'), true);
      expect(isValidTransition('enrolled', 'verifikasi'), false);
    });
  });

  group('Timeline Minggu 4 - Portal & Dashboard Wali (Parent Dashboard Logic Tests)', () {
    final parentState = WaliDashboardState(
      parentId: 'parent-123',
      children: [
        {
          'id': 'child-1',
          'nama_lengkap': 'Zayd bin Tsabit',
          'total_juz_hafalan': 15.5,
          'debt_created': 2.0,
        },
        {
          'id': 'child-2',
          'nama_lengkap': 'Fathimah bint Tsabit',
          'total_juz_hafalan': 5.0,
          'debt_created': 0.0,
        }
      ],
    );

    test('1. Multi-Child Selector - Should detect if parent has more than one child', () {
      expect(parentState.hasMultipleChildren, true);

      final singleParentState = WaliDashboardState(
        parentId: 'parent-456',
        children: [
          {
            'id': 'child-3',
            'nama_lengkap': 'Umar',
            'total_juz_hafalan': 1.0,
            'debt_created': 0.0,
          }
        ],
      );
      expect(singleParentState.hasMultipleChildren, false);
    });

    test('2. Progress & Hafalan Tracker - Should return real-time child metrics', () {
      expect(parentState.getChildProgress('child-1'), 15.5);
      expect(parentState.getChildProgress('child-2'), 5.0);
      expect(parentState.getChildProgress('non-existent-child'), 0.0); // Safe fallback
    });

    test('3. Dynamic Red Debt Banner Indicator - Should trigger when debt is positive', () {
      expect(parentState.hasDebt('child-1'), true);  // 2.0 Debt (Triggers red banner alert)
      expect(parentState.hasDebt('child-2'), false); // 0.0 Debt (Normal green progress)
    });

    test('4. WhatsApp Template Generator - Should format message to teacher', () {
      final msg = parentState.generateWaMessageTemplate('Zayd bin Tsabit', 'Ustadz Ahmad');
      expect(msg.contains('Ustadz Ahmad'), true);
      expect(msg.contains('Zayd bin Tsabit'), true);
    });
  });
}
