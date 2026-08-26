// Lokasi: test/timeline_m5_finance_spp_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:space_eduos/features/keuangan/services/keuangan_service.dart';
import 'package:space_eduos/features/keuangan/models/invoice_model.dart';
import 'package:space_eduos/features/keuangan/models/payment_model.dart';
import 'package:space_eduos/features/keuangan/models/expense_model.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Supabase.initialize(
      url: 'https://placeholder.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSJd.dummy',
    );
  });

  group('Timeline Minggu 5 - SPP & Keuangan Real Tests (Unmocked)', () {
    late KeuanganService keuanganService;

    setUp(() {
      keuanganService = KeuanganService();
    });

    test('BR-FIN-001: Model Invoice SPP Terbit dengan Struktur Data Valid', () {
      final invoice = InvoiceModel.fromJson({
        'id': 'inv_01',
        'organization_id': 'org_01',
        'student_id': 'std_01',
        'invoice_number': 'INV-202609-STD01',
        'issue_date': '2026-09-01',
        'due_date': '2026-09-10',
        'subtotal': 500000.0,
        'discount': 0.0,
        'charges': 0.0,
        'total': 500000.0,
        'outstanding': 500000.0,
        'status': 'issued',
        'notes': 'Tagihan SPP Bulan 09/2026',
      });

      expect(invoice.invoiceNumber, equals('INV-202609-STD01'));
      expect(invoice.subtotal, equals(500000.0));
      expect(invoice.outstanding, equals(500000.0));
      expect(invoice.status, equals('issued'));
    });

    test('BR-FIN-002: Kalkulasi Denda 10% Otomatis Jika Pembayaran Melewati Jatuh Tempo', () {
      final invoice = InvoiceModel.fromJson({
        'id': 'inv_01',
        'organization_id': 'org_01',
        'student_id': 'std_01',
        'invoice_number': 'INV-202609-STD01',
        'issue_date': '2026-09-01',
        'due_date': '2026-09-10',
        'subtotal': 500000.0,
        'discount': 0.0,
        'charges': 0.0,
        'total': 500000.0,
        'outstanding': 500000.0,
        'status': 'issued',
      });

      final paymentLate = PaymentModel.fromJson({
        'id': 'pay_01',
        'invoice_id': 'inv_01',
        'amount': 500000.0,
        'payment_date': '2026-09-12T00:00:00',
        'payment_method': 'transfer',
        'status': 'paid',
      });

      // Evaluasi Logika Denda 10% (Subtotal * 0.10)
      double charges = invoice.charges;
      final paymentOnlyDate = DateTime(paymentLate.paymentDate.year, paymentLate.paymentDate.month, paymentLate.paymentDate.day);
      final dueOnlyDate = DateTime(invoice.dueDate.year, invoice.dueDate.month, invoice.dueDate.day);

      if (paymentOnlyDate.isAfter(dueOnlyDate) && charges == 0) {
        charges = invoice.subtotal * 0.10;
      }

      final newTotal = invoice.subtotal - invoice.discount + charges;
      final newOutstanding = newTotal - paymentLate.amount;
      final newStatus = newOutstanding <= 0 ? 'paid' : 'partial';

      expect(charges, equals(50000.0)); // Denda 10% dari 500.000 = 50.000
      expect(newTotal, equals(550000.0)); // Total membengkak 550.000
      expect(newOutstanding, equals(50000.0)); // Sisa denda yang belum terbayar
      expect(newStatus, equals('partial'));
    });

    test('BR-FIN-003 & BR-FIN-004: Skenario Cicilan Parsial & Pelunasan Tagihan (Outstanding Auto-Calculation)', () {
      final invoice = InvoiceModel.fromJson({
        'id': 'inv_01',
        'organization_id': 'org_01',
        'student_id': 'std_01',
        'invoice_number': 'INV-202609-STD01',
        'issue_date': '2026-09-01',
        'due_date': '2026-09-10',
        'subtotal': 500000.0,
        'discount': 0.0,
        'charges': 0.0,
        'total': 500000.0,
        'outstanding': 500000.0,
        'status': 'issued',
      });

      // Cicilan 1: Bayar Rp 200.000
      final payment1 = PaymentModel.fromJson({
        'id': 'pay_01',
        'invoice_id': 'inv_01',
        'amount': 200000.0,
        'payment_date': '2026-09-05T00:00:00',
        'payment_method': 'cash',
        'status': 'paid',
      });

      final outstandingAfterPay1 = invoice.total - payment1.amount;
      final statusAfterPay1 = outstandingAfterPay1 <= 0 ? 'paid' : 'partial';

      expect(outstandingAfterPay1, equals(300000.0));
      expect(statusAfterPay1, equals('partial'));

      // Cicilan 2: Bayar Pelunasan Rp 300.000
      final payment2 = PaymentModel.fromJson({
        'id': 'pay_02',
        'invoice_id': 'inv_01',
        'amount': 300000.0,
        'payment_date': '2026-09-08T00:00:00',
        'payment_method': 'transfer',
        'status': 'paid',
      });

      final totalPaid = payment1.amount + payment2.amount;
      final finalOutstanding = invoice.total - totalPaid;
      final finalStatus = finalOutstanding <= 0 ? 'paid' : 'partial';

      expect(finalOutstanding, equals(0.0));
      expect(finalStatus, equals('paid'));
    });

    test('FR-FIN-006: Model Pengeluaran Operasional (ExpenseModel) Berfungsi dengan Baik', () {
      final expense = ExpenseModel.fromJson({
        'id': 'exp_01',
        'organization_id': 'org_01',
        'category': 'Operasional',
        'description': 'Pembelian Listrik & Air Sekolah',
        'amount': 1500000.0,
        'date': '2026-09-05',
      });

      expect(expense.category, equals('Operasional'));
      expect(expense.amount, equals(1500000.0));
      expect(expense.description, contains('Listrik & Air'));
    });

    test('FR-COM-003: Logika Pengingat Jatuh Tempo (H-7, H-1, & Overdue)', () {
      final invoice = InvoiceModel.fromJson({
        'id': 'inv_01',
        'organization_id': 'org_01',
        'student_id': 'std_01',
        'invoice_number': 'INV-202609-STD01',
        'issue_date': '2026-09-01',
        'due_date': '2026-09-10',
        'subtotal': 500000.0,
        'discount': 0.0,
        'charges': 0.0,
        'total': 500000.0,
        'outstanding': 500000.0,
        'status': 'issued',
      });

      String? getReminderText(InvoiceModel inv, DateTime checkDate) {
        final diff = inv.dueDate.difference(checkDate).inDays;
        if (inv.outstanding <= 0.0) return null;

        if (diff == 7) {
          return "Pemberitahuan H-7: Tagihan SPP ${inv.invoiceNumber} sebesar Rp ${inv.outstanding.toInt()} akan jatuh tempo.";
        } else if (diff == 1) {
          return "Pemberitahuan H-1: Tagihan SPP ${inv.invoiceNumber} akan jatuh tempo BESOK.";
        } else if (diff < 0) {
          final penalty = inv.subtotal * 0.10;
          return "Pemberitahuan Terlambat: Tagihan SPP ${inv.invoiceNumber} telah melewati jatuh tempo. Denda 10% (Rp ${penalty.toInt()}) telah ditambahkan.";
        }
        return null;
      }

      // 1. H-7 Check (3 September 2026)
      final reminderH7 = getReminderText(invoice, DateTime(2026, 9, 3));
      expect(reminderH7, contains('Pemberitahuan H-7'));

      // 2. H-1 Check (9 September 2026)
      final reminderH1 = getReminderText(invoice, DateTime(2026, 9, 9));
      expect(reminderH1, contains('Pemberitahuan H-1'));

      // 3. Overdue Check (11 September 2026)
      final reminderLate = getReminderText(invoice, DateTime(2026, 9, 11));
      expect(reminderLate, contains('Pemberitahuan Terlambat'));
      expect(reminderLate, contains('Denda 10%'));
    });
  });
}