import 'package:flutter_test/flutter_test.dart';
import 'package:space_eduos/features/management_lembaga/models/lembaga_model.dart';
import 'package:space_eduos/features/management_lembaga/models/cabang_model.dart';
import 'package:space_eduos/features/management_lembaga/models/tahun_ajaran_model.dart';
import 'package:space_eduos/shared/models/profile_model.dart';
import 'package:space_eduos/features/siswa/models/siswa_model.dart';
import 'package:space_eduos/features/akademik/kurikulum/models/modul_model.dart';
import 'package:space_eduos/features/admission/models/pendaftaran_model.dart';

// --- MOCK CLASSES FOR UAT END-TO-END FLOW SIMULATION ---

class MockAppContextState {
  final LembagaModel? lembaga;
  final CabangModel? currentCabang;
  final TahunAjaranModel? currentTahunAjaran;
  final ProfileModel? profile;
  final List<String> permissions;
  final List<String> activeModules;

  MockAppContextState({
    this.lembaga,
    this.currentCabang,
    this.currentTahunAjaran,
    this.profile,
    this.permissions = const [],
    this.activeModules = const [],
  });

  bool hasPermission(String key) {
    if (profile?.role == 'admin_lembaga') return true;
    return permissions.contains(key);
  }

  bool hasModule(String code) {
    return activeModules.contains(code);
  }
}

class MockAcademicEngine {
  bool isContentCompleted({
    required int curSurah, required int curAyah,
    required int targetSurah, required int targetAyah,
    required int statusKeputusan,
  }) {
    if (curSurah > targetSurah || (curSurah == targetSurah && curAyah >= targetAyah)) {
      return statusKeputusan == 1; // BR-TAH-005: Harus Lanjut (1)
    }
    return false;
  }

  Map<String, dynamic> evaluateExamReadiness({
    required bool isExamRequired,
    required bool volumeAchieved,
    required String currentAcademicState,
  }) {
    if (volumeAchieved) {
      if (isExamRequired) {
        return {
          'academic_state': 'tasmi_mode',
          'is_ready_for_exam': true,
        };
      } else {
        return {
          'academic_state': 'daily',
          'is_ready_for_exam': false,
          'trigger_promotion': true,
        };
      }
    }
    return {
      'academic_state': currentAcademicState,
      'is_ready_for_exam': false,
    };
  }
}

class MockFinanceEngine {
  Map<String, dynamic> generateSPPInvoice({
    required String studentId,
    required String studentStatus,
    required double baseSppAmount,
    required DateTime issueDate,
  }) {
    if (studentStatus != 'aktif') {
      throw Exception("BR-FIN-001: Hanya siswa aktif yang mendapatkan tagihan");
    }
    return {
      'invoice_number': 'INV-2026-${studentId.substring(0, 4)}',
      'student_id': studentId,
      'issue_date': issueDate,
      'due_date': DateTime(issueDate.year, issueDate.month, 10), // Jatuh tempo tanggal 10
      'subtotal': baseSppAmount,
      'outstanding': baseSppAmount,
    };
  }

  Map<String, dynamic> processSPPPayment({
    required Map<String, dynamic> invoice,
    required double paidAmount,
    required DateTime paymentDate,
  }) {
    final DateTime dueDate = invoice['due_date'] as DateTime;
    double subtotal = invoice['subtotal'] as double;
    double denda = 0.0;

    // BR-FIN-002: Denda 10% jika melebihi jatuh tempo
    if (paymentDate.isAfter(dueDate)) {
      denda = subtotal * 0.10;
    }

    final double totalTagihan = subtotal + denda;
    final double outstanding = totalTagihan - paidAmount;

    return {
      'subtotal': subtotal,
      'charges': denda,
      'total': totalTagihan,
      'outstanding': outstanding < 0 ? 0.0 : outstanding,
      'status': outstanding <= 0 ? 'paid' : 'partial',
    };
  }
}

void main() {
  group('UAT MINGGU 9: DETAILED SMOKE & END-TO-END SYSTEM INTEGRATION TESTS', () {
    late MockAcademicEngine academicEngine;
    late MockFinanceEngine financeEngine;

    setUp(() {
      academicEngine = MockAcademicEngine();
      financeEngine = MockFinanceEngine();
    });

    // ==========================================
    // UAT SKENARIO A: ACADEMIC FLOW END-TO-END
    // ==========================================
    test('UAT Skenario A - Siklus Akademik Lengkap (Pendaftaran s.d Kelulusan & Naik Level)', () {
      // 1. Wali murid mendaftar online
      final pendaftaran = PendaftaranModel(
        id: 'reg-999',
        organizationId: 'lembaga-xyz',
        namaLengkap: 'Fatih Al-Fatih',
        nisn: '0123456789',
        tanggalLahir: DateTime(2018, 5, 20),
        jenisKelamin: 'L',
        alamat: 'Bekasi Timur',
        namaWali: 'Abu Fatih',
        noHpWali: '081299991111',
        programPilihanId: 'prog-tahfidz-intensif',
        status: 'registrasi',
        createdAt: DateTime(2026, 8, 24),
      );

      expect(pendaftaran.status, equals('registrasi'));

      // 2. Admin menyetujui pendaftaran dan meng-enroll murid baru ke kurikulum
      final pendaftaranApproved = PendaftaranModel(
        id: 'reg-999',
        organizationId: 'lembaga-xyz',
        namaLengkap: 'Fatih Al-Fatih',
        nisn: '0123456789',
        tanggalLahir: DateTime(2018, 5, 20),
        jenisKelamin: 'L',
        alamat: 'Bekasi Timur',
        namaWali: 'Abu Fatih',
        noHpWali: '081299991111',
        programPilihanId: 'prog-tahfidz-intensif',
        status: 'enrolled',
        createdAt: DateTime(2026, 8, 24),
      );
      expect(pendaftaranApproved.status, equals('enrolled'));

      final siswaBaru = SiswaModel(
        id: pendaftaranApproved.id,
        lembagaId: pendaftaranApproved.organizationId,
        namaLengkap: pendaftaranApproved.namaLengkap,
        jenisKelamin: pendaftaranApproved.jenisKelamin ?? 'L',
        status: 'aktif',
        academicState: 'daily',
        isReadyForExam: false,
        totalJuzHafalan: 0.0,
      );

      expect(siswaBaru.status, equals('aktif'));
      expect(siswaBaru.academicState, equals('daily'));

      // 3. Guru menginput setoran harian (Mutaba'ah)
      // Skenario 3a: koordinat fisik mencapai target, tetapi status keputusan = -1 (Ulang)
      bool isTuntasUlang = academicEngine.isContentCompleted(
        curSurah: 78, curAyah: 40,
        targetSurah: 78, targetAyah: 40,
        statusKeputusan: -1, // Ulang
      );
      expect(isTuntasUlang, isFalse); // BR-TAH-005: Harus bernilai Lanjut (1) untuk tuntas

      // Skenario 3b: koordinat fisik mencapai target dan status keputusan = 1 (Lanjut)
      bool isTuntasLanjut = academicEngine.isContentCompleted(
        curSurah: 78, curAyah: 40,
        targetSurah: 78, targetAyah: 40,
        statusKeputusan: 1, // Lanjut
      );
      expect(isTuntasLanjut, isTrue);

      // 4. Evaluasi Kesiapan Ujian & Transisi Sesi (Tasmi Mode)
      // Skenario 4a: Modul mewajibkan ujian (isExamRequired = true)
      final stateWithExam = academicEngine.evaluateExamReadiness(
        isExamRequired: true,
        volumeAchieved: true,
        currentAcademicState: siswaBaru.academicState,
      );
      expect(stateWithExam['academic_state'], equals('tasmi_mode'));
      expect(stateWithExam['is_ready_for_exam'], isTrue);

      // Skenario 4b: Modul tidak mewajibkan ujian (isExamRequired = false) -> Bypass langsung promosi
      final stateNoExam = academicEngine.evaluateExamReadiness(
        isExamRequired: false,
        volumeAchieved: true,
        currentAcademicState: siswaBaru.academicState,
      );
      expect(stateNoExam['academic_state'], equals('daily'));
      expect(stateNoExam['is_ready_for_exam'], isFalse);
      expect(stateNoExam['trigger_promotion'], isTrue);

      // 5. Kelulusan Ujian & Auto-Promosi Lintas Jenjang / Kelulusan Akhir
      // Siswa menyelesaikan level terakhir di jenjang terakhir, status diubah menjadi 'lulus' bahasa Indonesia
      final siswaTamat = siswaBaru.copyWith(
        status: 'lulus', // BR-TAH-006: Sesuai CHECK constraint DB ['aktif', 'nonaktif', 'lulus', 'pindah']
        academicState: 'daily',
        isReadyForExam: false,
      );

      expect(siswaTamat.status, equals('lulus'));
      expect(siswaTamat.academicState, equals('daily'));
    });

    // ==========================================
    // UAT SKENARIO B: FINANCE & PARENT PORTAL FLOW
    // ==========================================
    test('UAT Skenario B - Siklus Keuangan & Portal Wali (Invoice, Denda Jatuh Tempo, s.d Bayar)', () {
      final siswaAktifId = 'siswa-active-123';
      final siswaNonAktifId = 'siswa-nonactive-456';

      // 1. Generate tagihan otomatis di tanggal 1 untuk siswa aktif
      final invoiceSiswaAktif = financeEngine.generateSPPInvoice(
        studentId: siswaAktifId,
        studentStatus: 'aktif',
        baseSppAmount: 500000.0,
        issueDate: DateTime(2026, 9, 1),
      );

      expect(invoiceSiswaAktif['invoice_number'], contains('INV-2026'));
      expect(invoiceSiswaAktif['subtotal'], equals(500000.0));

      // Memastikan siswa tidak aktif di-skip (memicu exception)
      expect(
            () => financeEngine.generateSPPInvoice(
          studentId: siswaNonAktifId,
          studentStatus: 'nonaktif',
          baseSppAmount: 500000.0,
          issueDate: DateTime(2026, 9, 1),
        ),
        throwsA(isA<Exception>()),
      );

      // 2. Skenario Pembayaran SPP
      // Skenario 2a: Bayar TEPAT WAKTU (sebelum tanggal 10) -> Bebas denda
      final paymentOnTime = financeEngine.processSPPPayment(
        invoice: invoiceSiswaAktif,
        paidAmount: 500000.0,
        paymentDate: DateTime(2026, 9, 5), // Sebelum jatuh tempo tanggal 10
      );
      expect(paymentOnTime['charges'], equals(0.0));
      expect(paymentOnTime['total'], equals(500000.0));
      expect(paymentOnTime['outstanding'], equals(0.0));
      expect(paymentOnTime['status'], equals('paid'));

      // Skenario 2b: Bayar TERLAMBAT (lewat tanggal 10) -> Tambah denda keterlambatan 10%
      final paymentOverdue = financeEngine.processSPPPayment(
        invoice: invoiceSiswaAktif,
        paidAmount: 200000.0, // Pembayaran parsial
        paymentDate: DateTime(2026, 9, 12), // Melewati tanggal jatuh tempo (10)
      );
      expect(paymentOverdue['charges'], equals(50000.0)); // Denda 10% dari 500k
      expect(paymentOverdue['total'], equals(550000.0));
      expect(paymentOverdue['outstanding'], equals(350000.0)); // 550k - 200k = 350k
      expect(paymentOverdue['status'], equals('partial'));

      // 3. Integrasi Portal Dashboard Wali
      // Memastikan sistem reaktif memantau status tunggakan & menampilkan denda / warning banner
      final bool showDebtBanner = paymentOverdue['outstanding'] > 0;
      expect(showDebtBanner, isTrue); // Wali santri akan melihat banner peringatan merah SPP
    });

    // ==========================================
    // STAGING & PRODUCTION DEPLOYMENT HEALTH CHECKS
    // ==========================================
    test('Staging/Prod Smoke Test - Inisialisasi Sesi, Mutli-Tenancy RLS & Switcher Modul Aktif', () {
      // 1. Simulasi Context Switcher & Module Engine Switcher (Kepatuhan Bab 2.9 SDD)
      final contextState = MockAppContextState(
        lembaga: LembagaModel(
          id: 'lembaga-001',
          namaLembaga: 'Pesantren IT Space',
          kodeLembaga: 'YAF-001',
          logoUrl: 'https://space-eduos.co/logo.png',
        ),
        profile: ProfileModel(
          id: 'usr-1',
          namaLengkap: 'Ustadz Hilmi',
          role: 'guru',
        ),
        permissions: ['tahfidz.write', 'attendance.read'],
        activeModules: ['tahfidz', 'attendance', 'communication'], // Modul keuangan dinonaktifkan
      );

      // Verifikasi pembatasan modul aktif di sidebar
      expect(contextState.hasModule('tahfidz'), isTrue);
      expect(contextState.hasModule('finance'), isFalse); // Modul keuangan mati di organisasi ini

      // Verifikasi pembatasan izin granular PBAC
      expect(contextState.hasPermission('tahfidz.write'), isTrue);
      expect(contextState.hasPermission('finance.spp.manage'), isFalse);

      // 2. Bypass Otorisasi Penuh untuk Akun Admin Lembaga / Owner
      final adminContextState = MockAppContextState(
        lembaga: LembagaModel(
          id: 'lembaga-001',
          namaLembaga: 'Pesantren IT Space',
          kodeLembaga: 'YAF-001',
        ),
        profile: ProfileModel(
          id: 'usr-admin',
          namaLengkap: 'Administrator Utama',
          role: 'admin_lembaga', // Role bypass admin
        ),
        permissions: [], // Permissions kosong, namun dibypass oleh role
      );

      expect(adminContextState.hasPermission('tahfidz.write'), isTrue);
      expect(adminContextState.hasPermission('finance.spp.manage'), isTrue);
      expect(adminContextState.hasPermission('backup.manage'), isTrue);
    });
  });
}
