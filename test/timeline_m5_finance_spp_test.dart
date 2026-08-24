import 'package:flutter_test/flutter_test.dart';

// Mock Models & Services for Testing SPP & Keuangan (Week 5)
class StudentMock {
  final String id;
  final String name;
  final String status; // 'aktif', 'nonaktif', 'lulus', 'pindah'
  final double monthlySppFee;

  StudentMock({
    required this.id,
    required this.name,
    required this.status,
    required this.monthlySppFee,
  });
}

class InvoiceMock {
  final String id;
  final String studentId;
  final String invoiceNumber;
  final DateTime issueDate;
  final DateTime dueDate;
  final double subtotal;
  final double discount;
  final double charges; // Denda
  final double total;
  final double outstanding;
  final String status; // 'issued', 'partial', 'paid', 'overdue'
  final bool isImmutable;

  InvoiceMock({
    required this.id,
    required this.studentId,
    required this.invoiceNumber,
    required this.issueDate,
    required this.dueDate,
    required this.subtotal,
    this.discount = 0.0,
    this.charges = 0.0,
    required this.total,
    required this.outstanding,
    required this.status,
    this.isImmutable = true,
  });

  InvoiceMock copyWith({
    double? charges,
    double? total,
    double? outstanding,
    String? status,
  }) {
    return InvoiceMock(
      id: id,
      studentId: studentId,
      invoiceNumber: invoiceNumber,
      issueDate: issueDate,
      dueDate: dueDate,
      subtotal: subtotal,
      discount: discount,
      charges: charges ?? this.charges,
      total: total ?? this.total,
      outstanding: outstanding ?? this.outstanding,
      status: status ?? this.status,
      isImmutable: isImmutable,
    );
  }
}

class PaymentMock {
  final String id;
  final String invoiceId;
  final double amount;
  final DateTime paymentDate;
  final String status; // 'pending', 'paid', 'failed'

  PaymentMock({
    required this.id,
    required this.invoiceId,
    required this.amount,
    required this.paymentDate,
    required this.status,
  });
}

class ExpenseMock {
  final String id;
  final String category;
  final String description;
  final double amount;
  final DateTime date;

  ExpenseMock({
    required this.id,
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
  });
}

// Service Engine under test
class FinanceEngineService {
  // BR-FIN-001: Generate tagihan otomatis untuk siswa aktif
  List<InvoiceMock> generateMonthlyInvoices(List<StudentMock> students, DateTime issueDate) {
    final List<InvoiceMock> generated = [];
    final activeStudents = students.where((s) => s.status == 'aktif').toList();

    for (var student in activeStudents) {
      final String monthStr = "${issueDate.year}${issueDate.month.toString().padLeft(2, '0')}";
      final String invNum = "INV/SPP/$monthStr/${student.id.substring(0, 4).toUpperCase()}";
      
      final DateTime dueDate = DateTime(issueDate.year, issueDate.month, 10); // Jatuh tempo tanggal 10

      generated.add(
        InvoiceMock(
          id: "inv_${student.id}",
          studentId: student.id,
          invoiceNumber: invNum,
          issueDate: issueDate,
          dueDate: dueDate,
          subtotal: student.monthlySppFee,
          total: student.monthlySppFee,
          outstanding: student.monthlySppFee,
          status: 'issued',
        ),
      );
    }
    return generated;
  }

  // BR-FIN-002: Denda Otomatis jika tanggal bayar melewati tanggal jatuh tempo (10% dari total)
  InvoiceMock processPayment(InvoiceMock invoice, PaymentMock payment) {
    double updatedCharges = invoice.charges;
    double updatedTotal = invoice.total;

    // Jika tgl bayar melewati jatuh tempo dan belum didenda sebelumnya
    if (payment.paymentDate.isAfter(invoice.dueDate) && invoice.charges == 0.0) {
      updatedCharges = invoice.subtotal * 0.10; // Denda 10%
      updatedTotal = invoice.subtotal + updatedCharges - invoice.discount;
    }

    final double newOutstanding = updatedTotal - payment.amount;
    String newStatus = 'partial';
    if (newOutstanding <= 0.0) {
      newStatus = 'paid';
    } else if (payment.paymentDate.isAfter(invoice.dueDate)) {
      newStatus = 'overdue';
    }

    return invoice.copyWith(
      charges: updatedCharges,
      total: updatedTotal,
      outstanding: newOutstanding < 0.0 ? 0.0 : newOutstanding,
      status: newStatus,
    );
  }

  // BR-FIN-003: Transaksi keuangan bersifat immutable (tidak bisa didelete/edit langsung, wajib rollback/adjustment)
  bool attemptDirectDelete(InvoiceMock invoice) {
    if (invoice.isImmutable) {
      throw Exception("Transaksi tidak bisa diubah atau dihapus secara langsung. Lakukan koreksi via Adjustment!");
    }
    return true;
  }

  // Reminder Notification Logic (H-7 dan H-1)
  String? generatePaymentReminder(InvoiceMock invoice, DateTime checkDate) {
    final difference = invoice.dueDate.difference(checkDate).inDays;
    if (invoice.outstanding <= 0.0) return null;

    if (difference == 7) {
      return "Pemberitahuan H-7: Tagihan SPP dengan nomor ${invoice.invoiceNumber} sebesar Rp ${invoice.outstanding.toInt()} akan jatuh tempo pada tanggal 10. Mohon segera melakukan pembayaran.";
    } else if (difference == 1) {
      return "Pemberitahuan H-1: Tagihan SPP ${invoice.invoiceNumber} akan jatuh tempo BESOK. Segera lakukan pelunasan untuk menghindari denda keterlambatan.";
    } else if (difference < 0) {
      final double penalty = invoice.subtotal * 0.10;
      return "Pemberitahuan Terlambat: Tagihan SPP ${invoice.invoiceNumber} telah melewati jatuh tempo. Denda 10% (Rp ${penalty.toInt()}) telah ditambahkan.";
    }
    return null;
  }
}

void main() {
  group('Timeline Minggu 5 - SPP & Keuangan Tests', () {
    late FinanceEngineService financeService;
    late List<StudentMock> studentsDatabase;

    setUp(() {
      financeService = FinanceEngineService();
      studentsDatabase = [
        StudentMock(id: 'std_01', name: 'Zaid', status: 'aktif', monthlySppFee: 500000.0),
        StudentMock(id: 'std_02', name: 'Umar', status: 'aktif', monthlySppFee: 450000.0),
        StudentMock(id: 'std_03', name: 'Fatimah', status: 'nonaktif', monthlySppFee: 500000.0), // Harus dilewati
        StudentMock(id: 'std_04', name: 'Ali', status: 'lulus', monthlySppFee: 500000.0), // Harus dilewati
      ];
    });

    test('FR-FIN-002 / BR-FIN-001: Auto Generate Tagihan Tanggal 1 Hanya Untuk Siswa Aktif', () {
      final issueDate = DateTime(2026, 9, 1);
      final invoices = financeService.generateMonthlyInvoices(studentsDatabase, issueDate);

      // Verifikasi hanya siswa aktif yang mendapat invoice
      expect(invoices.length, equals(2));
      expect(invoices.any((inv) => inv.studentId == 'std_01'), isTrue);
      expect(invoices.any((inv) => inv.studentId == 'std_02'), isTrue);
      expect(invoices.any((inv) => inv.studentId == 'std_03'), isFalse);
      expect(invoices.any((inv) => inv.studentId == 'std_04'), isFalse);

      // Verifikasi format nomor invoice & tanggal jatuh tempo (tanggal 10)
      final zaidInvoice = invoices.firstWhere((inv) => inv.studentId == 'std_01');
      expect(zaidInvoice.invoiceNumber, equals('INV/SPP/202609/STD_'));
      expect(zaidInvoice.dueDate, equals(DateTime(2026, 9, 10)));
      expect(zaidInvoice.outstanding, equals(500000.0));
      expect(zaidInvoice.status, equals('issued'));
    });

    test('FR-FIN-005 / BR-FIN-002: Perhitungan Denda Otomatis 10% Jika Melewati Jatuh Tempo', () {
      final invoice = InvoiceMock(
        id: 'inv_01',
        studentId: 'std_01',
        invoiceNumber: 'INV/SPP/202609/STD_',
        issueDate: DateTime(2026, 9, 1),
        dueDate: DateTime(2026, 9, 10),
        subtotal: 500000.0,
        total: 500000.0,
        outstanding: 500000.0,
        status: 'issued',
      );

      // Kasus A: Pembayaran TEPAT WAKTU (sebelum atau pas tanggal 10) -> Tidak kena denda
      final paymentOnTime = PaymentMock(
        id: 'pay_01',
        invoiceId: 'inv_01',
        amount: 500000.0,
        paymentDate: DateTime(2026, 9, 9),
        status: 'paid',
      );

      final processedOnTime = financeService.processPayment(invoice, paymentOnTime);
      expect(processedOnTime.charges, equals(0.0)); // No denda
      expect(processedOnTime.total, equals(500000.0));
      expect(processedOnTime.outstanding, equals(0.0));
      expect(processedOnTime.status, equals('paid'));

      // Kasus B: Pembayaran TERLAMBAT (lewat tanggal 10) -> Denda 10% otomatis
      final paymentLate = PaymentMock(
        id: 'pay_02',
        invoiceId: 'inv_01',
        amount: 500000.0,
        paymentDate: DateTime(2026, 9, 12), // Terlambat 2 hari
        status: 'paid',
      );

      final processedLate = financeService.processPayment(invoice, paymentLate);
      expect(processedLate.charges, equals(50000.0)); // Denda 10% dari 500rb = 50rb
      expect(processedLate.total, equals(550000.0)); // Total tagihan membengkak jadi 550rb
      expect(processedLate.outstanding, equals(50000.0)); // Sisa hutang denda yg belum dibayar
      expect(processedLate.status, equals('overdue'));
    });

    test('FR-FIN-010 / BR-FIN-003: Verifikasi Aturan Mutlak Immutabilitas Transaksi SPP', () {
      final invoice = InvoiceMock(
        id: 'inv_01',
        studentId: 'std_01',
        invoiceNumber: 'INV/SPP/202609/STD_',
        issueDate: DateTime(2026, 9, 1),
        dueDate: DateTime(2026, 9, 10),
        subtotal: 500000.0,
        total: 500000.0,
        outstanding: 500000.0,
        status: 'issued',
        isImmutable: true,
      );

      // Coba lakukan penghapusan transaksi langsung secara ilegal
      expect(
        () => financeService.attemptDirectDelete(invoice),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Transaksi tidak bisa diubah atau dihapus secara langsung'),
        )),
      );
    });

    test('BR-FIN-004: Akurasi Hitung Sisa Tagihan SPP (Outstanding = Total - Paid)', () {
      final invoice = InvoiceMock(
        id: 'inv_01',
        studentId: 'std_01',
        invoiceNumber: 'INV/SPP/202609/STD_',
        issueDate: DateTime(2026, 9, 1),
        dueDate: DateTime(2026, 9, 10),
        subtotal: 500000.0,
        total: 500000.0,
        outstanding: 500000.0,
        status: 'issued',
      );

      // Cicilan 1 (Partial Payment): Bayar Rp 200,000
      final partialPayment = PaymentMock(
        id: 'pay_01',
        invoiceId: 'inv_01',
        amount: 200000.0,
        paymentDate: DateTime(2026, 9, 5),
        status: 'paid',
      );

      final step1 = financeService.processPayment(invoice, partialPayment);
      expect(step1.outstanding, equals(300000.0));
      expect(step1.status, equals('partial'));

      // Cicilan 2: Bayar Pelunasan Rp 300,000
      final finalPayment = PaymentMock(
        id: 'pay_02',
        invoiceId: 'inv_01',
        amount: 300000.0,
        paymentDate: DateTime(2026, 9, 6),
        status: 'paid',
      );

      final step2 = financeService.processPayment(step1, finalPayment);
      expect(step2.outstanding, equals(0.0));
      expect(step2.status, equals('paid'));
    });

    test('FR-COM-003 / FR-FIN-008: Integrasi Notifikasi Tagihan & Reminder Jatuh Tempo (H-7, H-1, Overdue)', () {
      final invoice = InvoiceMock(
        id: 'inv_01',
        studentId: 'std_01',
        invoiceNumber: 'INV/SPP/202609/STD_ZAID',
        issueDate: DateTime(2026, 9, 1),
        dueDate: DateTime(2026, 9, 10),
        subtotal: 500000.0,
        total: 500000.0,
        outstanding: 500000.0,
        status: 'issued',
      );

      // 1. Uji H-7 (Check pada tanggal 3 September)
      final reminderH7 = financeService.generatePaymentReminder(invoice, DateTime(2026, 9, 3));
      expect(reminderH7, contains('Pemberitahuan H-7'));
      expect(reminderH7, contains('INV/SPP/202609/STD_ZAID'));

      // 2. Uji H-1 (Check pada tanggal 9 September)
      final reminderH1 = financeService.generatePaymentReminder(invoice, DateTime(2026, 9, 9));
      expect(reminderH1, contains('Pemberitahuan H-1'));
      expect(reminderH1, contains('akan jatuh tempo BESOK'));

      // 3. Uji Overdue / Terlambat (Check pada tanggal 11 September)
      final reminderLate = financeService.generatePaymentReminder(invoice, DateTime(2026, 9, 11));
      expect(reminderLate, contains('Pemberitahuan Terlambat'));
      expect(reminderLate, contains('Denda 10%'));
    });
  });
}
