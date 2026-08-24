// Lokasi: test/timeline_m3_payroll_mushaf_test.dart

import 'package:flutter_test/flutter_test.dart';

// Mocking the required models and interfaces for Week 3 Refactoring Tests
class StudentM3Mock {
  final String id;
  final String nama;
  final double totalJuzHafalan;

  StudentM3Mock({
    required this.id,
    required this.nama,
    required this.totalJuzHafalan,
  });
}

class MutabaahRecordM3Mock {
  final String id;
  final String studentId;
  final String teacherId;         // Penginput / Pengganti (guru_id)
  final String originalTeacherId; // Guru tetap (original_guru_id)
  final double achievedAmount;

  MutabaahRecordM3Mock({
    required this.id,
    required this.studentId,
    required this.teacherId,
    required this.originalTeacherId,
    required this.achievedAmount,
  });

  bool get isDelegated => teacherId != originalTeacherId;
}

class SalarySettingsM3Mock {
  final double baseSalary;
  final double perStudentBonus;
  final double substituteBonusAmount;
  final double deductionAmount;
  final bool isOriginalTeacherDeducted;

  SalarySettingsM3Mock({
    this.baseSalary = 2000000,
    this.perStudentBonus = 15000,
    this.substituteBonusAmount = 25000,
    this.deductionAmount = 20000,
    this.isOriginalTeacherDeducted = true,
  });
}

// 1. SERVICE MOCK: Murojaah Task Service (BR-TAH-009)
class MurojaahTaskServiceMock {
  // Hitung target 4% dari total hafalan siswa secara real-time
  double calculateManzilRange(double totalJuzHafalan) {
    if (totalJuzHafalan <= 0) return 0.0;
    // Rumus target harian Manzil adalah 4% dari total hafalan (Bab 6.3 SDD)
    return totalJuzHafalan * 0.04;
  }
}

// 2. SERVICE MOCK: Keuangan Service (BR-HR-002 & BR-HR-003)
class KeuanganServiceMock {
  Map<String, double> calculateMonthlyPayroll({
    required String teacherId,
    required List<MutabaahRecordM3Mock> allRecords,
    required SalarySettingsM3Mock settings,
  }) {
    double baseSalary = settings.baseSalary;
    double bonusReguler = 0.0;
    double bonusDelegasi = 0.0;
    double totalDeduction = 0.0;

    for (var record in allRecords) {
      // Skenario A: Guru bertindak sebagai penerima delegasi (guru_id != original_guru_id)
      // Guru pengganti mendapatkan substitute bonus (Bonus Delegasi)
      if (record.teacherId == teacherId && record.isDelegated) {
        bonusDelegasi += settings.substituteBonusAmount;
      }

      // Skenario B: Guru bertindak sebagai guru reguler (guru_id == original_guru_id)
      if (record.teacherId == teacherId && !record.isDelegated) {
        bonusReguler += settings.perStudentBonus;
      }

      // Skenario C: Guru tetap yang bimbingannya digantikan mengalami pemotongan (Deduction)
      // Jika diaktifkan isOriginalTeacherDeducted pada settings
      if (record.originalTeacherId == teacherId && record.isDelegated) {
        if (settings.isOriginalTeacherDeducted) {
          totalDeduction += settings.deductionAmount;
        }
      }
    }

    double grandTotal = baseSalary + bonusReguler + bonusDelegasi - totalDeduction;

    return {
      'base_salary': baseSalary,
      'bonus_reguler': bonusReguler,
      'bonus_delegasi': bonusDelegasi,
      'deduction': totalDeduction,
      'grand_total': grandTotal,
    };
  }
}

// 3. UI HELPER: Mushaf Page View Font Scaling (Bab 9.2.7 SDD)
class MushafUIHelperMock {
  // Ukuran font nomor ayat (WidgetSpan) harus scaling proporsional: dynamicFontSize * 0.7
  double getAyahNumberFontSize(double dynamicFontSize) {
    if (dynamicFontSize <= 0) return 0.0;
    return (dynamicFontSize * 7) / 10;
  }

  // Desain lingkaran hijau pembungkus nomor ayat ikut membesar proporsional
  double getAyahBadgeSize(double dynamicFontSize) {
    if (dynamicFontSize <= 0) return 0.0;
    return (dynamicFontSize * 12) / 10;
  }
}

void main() {
  group('M3 TESTING: SINKRONISASI MUROJAAH MANZIL (BR-TAH-009)', () {
    final murojaahService = MurojaahTaskServiceMock();

    test('Harus menghitung porsi target Manzil harian sebesar 4% secara realtime', () {
      // 30 Juz -> Target Manzil harus 1.2 Juz per hari
      final target30Juz = murojaahService.calculateManzilRange(30.0);
      expect(target30Juz, closeTo(1.2, 0.001));

      // 10 Juz -> Target Manzil harus 0.4 Juz per hari
      final target10Juz = murojaahService.calculateManzilRange(10.0);
      expect(target10Juz, closeTo(0.4, 0.001));

      // 5 Juz -> Target Manzil harus 0.2 Juz per hari
      final target5Juz = murojaahService.calculateManzilRange(5.0);
      expect(target5Juz, closeTo(0.2, 0.001));
    });

    test('Harus mengembalikan target 0.0 jika siswa belum memiliki hafalan', () {
      final target0Juz = murojaahService.calculateManzilRange(0.0);
      expect(target0Juz, equals(0.0));
    });
  });

  group('M3 TESTING: KALKULATOR PAYROLL & BONUS DELEGASI (BR-HR-002, BR-HR-003)', () {
    final keuanganService = KeuanganServiceMock();
    final settings = SalarySettingsM3Mock(
      baseSalary: 2000000,
      perStudentBonus: 15000,
      substituteBonusAmount: 25000,
      deductionAmount: 20000,
      isOriginalTeacherDeducted: true,
    );

    test('Harus menghitung payroll guru pengganti dengan bonus delegasi tambahan', () {
      final String guruPenggantiId = 'guru_b_pengganti';
      final String guruTetapId = 'guru_a_tetap';

      // Ada 2 bimbingan didelegasikan dari Guru A ke Guru B
      final listRecords = [
        MutabaahRecordM3Mock(
          id: 'rec_1',
          studentId: 'siswa_1',
          teacherId: guruPenggantiId, // Bimbingan diisi oleh Guru B
          originalTeacherId: guruTetapId,
          achievedAmount: 2.0,
        ),
        MutabaahRecordM3Mock(
          id: 'rec_2',
          studentId: 'siswa_2',
          teacherId: guruPenggantiId, // Bimbingan diisi oleh Guru B
          originalTeacherId: guruTetapId,
          achievedAmount: 2.5,
        ),
      ];

      final payrollB = keuanganService.calculateMonthlyPayroll(
        teacherId: guruPenggantiId,
        allRecords: listRecords,
        settings: settings,
      );

      // Verifikasi Guru B mendapatkan gaji pokok + bonus delegasi (2 x 25.000)
      expect(payrollB['base_salary'], equals(2000000));
      expect(payrollB['bonus_reguler'], equals(0.0));
      expect(payrollB['bonus_delegasi'], equals(50000.0)); // 2 x 25.000
      expect(payrollB['deduction'], equals(0.0));
      expect(payrollB['grand_total'], equals(2050000.0));
    });

    test('Harus memotong payroll guru tetap jika bimbingannya didelegasikan keluar', () {
      final String guruPenggantiId = 'guru_b_pengganti';
      final String guruTetapId = 'guru_a_tetap';

      // Guru A mendelegasikan 1 bimbingan ke Guru B
      final listRecords = [
        MutabaahRecordM3Mock(
          id: 'rec_1',
          studentId: 'siswa_1',
          teacherId: guruPenggantiId, // Diisi pengganti
          originalTeacherId: guruTetapId, // Guru tetap adalah Guru A
          achievedAmount: 2.0,
        ),
      ];

      final payrollA = keuanganService.calculateMonthlyPayroll(
        teacherId: guruTetapId,
        allRecords: listRecords,
        settings: settings,
      );

      // Verifikasi Guru A mengalami pemotongan 1 x 20.000
      expect(payrollA['base_salary'], equals(2000000));
      expect(payrollA['bonus_reguler'], equals(0.0));
      expect(payrollA['bonus_delegasi'], equals(0.0));
      expect(payrollA['deduction'], equals(20000.0)); // Potongan delegasi keluar
      expect(payrollA['grand_total'], equals(1980000.0));
    });

    test('Harus menghitung payroll normal untuk guru bimbingan reguler tanpa delegasi', () {
      final String guruId = 'guru_reguler';

      // 3 bimbingan diselesaikan sendiri oleh guru bersangkutan
      final listRecords = [
        MutabaahRecordM3Mock(
          id: 'rec_1',
          studentId: 'siswa_1',
          teacherId: guruId,
          originalTeacherId: guruId,
          achievedAmount: 2.0,
        ),
        MutabaahRecordM3Mock(
          id: 'rec_2',
          studentId: 'siswa_2',
          teacherId: guruId,
          originalTeacherId: guruId,
          achievedAmount: 2.0,
        ),
        MutabaahRecordM3Mock(
          id: 'rec_3',
          studentId: 'siswa_3',
          teacherId: guruId,
          originalTeacherId: guruId,
          achievedAmount: 2.0,
        ),
      ];

      final payroll = keuanganService.calculateMonthlyPayroll(
        teacherId: guruId,
        allRecords: listRecords,
        settings: settings,
      );

      // Verifikasi perhitungan bonus reguler (3 x 15.000) tanpa potongan
      expect(payroll['base_salary'], equals(2000000));
      expect(payroll['bonus_reguler'], equals(45000.0));
      expect(payroll['bonus_delegasi'], equals(0.0));
      expect(payroll['deduction'], equals(0.0));
      expect(payroll['grand_total'], equals(2045000.0));
    });
  });

  group('M3 TESTING: POLISHING UI/UX MUSHAF SCALING (Bab 9.2.7 SDD)', () {
    final uiHelper = MushafUIHelperMock();

    test('Harus mengembalikan ukuran font nomor ayat proporsional terhadap font tulisan', () {
      // Default font size 24.0 -> Font nomor ayat harus 16.8 (24 x 0.7)
      final size24 = uiHelper.getAyahNumberFontSize(24.0);
      expect(size24, equals(16.8));

      // Font size membesar 36.0 -> Font nomor ayat harus 25.2 (36 x 0.7)
      final size36 = uiHelper.getAyahNumberFontSize(36.0);
      expect(size36, equals(25.2));
    });

    test('Harus memastikan ukuran badge lingkaran ikut membesar proporsional', () {
      // Base font size 24.0 -> Ukuran badge pelindung lingkaran adalah 28.8 (24 x 1.2)
      final badge24 = uiHelper.getAyahBadgeSize(24.0);
      expect(badge24, equals(28.8));
    });
  });
}