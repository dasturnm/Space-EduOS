// Lokasi: lib/features/keuangan/services/keuangan_service.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/base_service.dart';
import '../models/salary_settings_model.dart';
import '../../mutabaah/models/mutabaah_model.dart';
import '../models/invoice_model.dart';
import '../models/payment_model.dart';
import '../models/expense_model.dart';

class KeuanganService extends BaseService {

  /// 1. READ SETTINGS: Mengambil konfigurasi gaji lembaga
  Future<SalarySettingsModel?> getSettings(dynamic ref) async {
    try {
      final lembagaId = getLembagaId(ref);
      final response = await supabase
          .from('salary_settings')
          .select()
          .eq('lembaga_id', lembagaId)
          .maybeSingle();

      if (response == null) return null;
      return SalarySettingsModel.fromJson(response);
    } catch (e) {
      throw Exception(handleError(e));
    }
  }

  /// 2. UPDATE SETTINGS: Menyimpan/Update konfigurasi gaji
  Future<void> saveSettings(SalarySettingsModel settings) async {
    try {
      final data = cleanData(settings.toJson());
      if (settings.id == null) data.remove('id');

      await supabase.from('salary_settings').upsert(data);
    } catch (e) {
      throw Exception(handleError(e));
    }
  }

  /// 3. THE CALCULATOR: Menghitung rincian gaji guru berdasarkan data mutabaah
  Future<Map<String, dynamic>> calculateMonthlyPayroll(
      dynamic ref,
      String guruId,
      DateTime month
      ) async {
    try {
      final settings = await getSettings(ref);
      if (settings == null) throw Exception("Konfigurasi gaji belum diatur oleh admin.");

      // Rentang waktu bulan ini
      final firstDay = DateTime(month.year, month.month, 1).toIso8601String();
      final lastDay = DateTime(month.year, month.month + 1, 0, 23, 59, 59).toIso8601String();

      // Ambil semua record mutabaah yang diinput oleh guru ini bulan ini
      final response = await supabase
          .from('mutabaah_records')
          .select()
          .eq('guru_id', guruId)
          .gte('created_at', firstDay)
          .lte('created_at', lastDay);

      final records = (response as List).map((json) => MutabaahRecord.fromJson(json)).toList();

      // LOGIKA: Grouping per Siswa per Tanggal (Agar bonus dihitung per kepala siswa, bukan per record)
      // Key: "yyyy-MM-dd_siswaId"
      final Set<String> uniqueStudentWork = {};
      final Set<String> uniqueDelegationWork = {};
      final Set<String> uniqueDaysActive = {};

      for (var r in records) {
        final dateKey = r.createdAt.toIso8601String().split('T')[0];
        final workKey = "${dateKey}_${r.siswaId}";

        // BR-HR-002: Bonus delegasi hanya diberikan jika penginput (guruId) != guru tetap (originalGuruId)
        final bool isSubstitute = r.isDelegasi && (r.originalGuruId != null && r.originalGuruId != guruId);

        if (isSubstitute) {
          uniqueDelegationWork.add(workKey);
          // Hanya catat hari substitusi untuk mode fixed (BR-HR-002)
          uniqueDaysActive.add(dateKey);
        } else {
          uniqueStudentWork.add(workKey);
        }
      }

      // KALKULASI NOMINAL
      double totalBonusReguler = uniqueStudentWork.length * settings.perStudentBonus;
      double totalBonusDelegasi = 0;

      if (settings.substituteBonusMode == 'per_student') {
        totalBonusDelegasi = uniqueDelegationWork.length * settings.substituteBonusAmount;
      } else {
        // Mode Fixed: Dihitung berapa hari dia menjadi pengganti (bukan berapa siswa)
        totalBonusDelegasi = uniqueDaysActive.length * settings.substituteBonusAmount;
      }

      // Potongan Guru Tetap (Jika diaktifkan)
      // Logic: Mencari record di mana guruId ini adalah 'originalGuruId' tapi diinput orang lain (delegasi keluar)
      double totalPotongan = 0;
      if (settings.isOriginalTeacherDeducted) {
        final outResponse = await supabase
            .from('mutabaah_records')
            .select('id')
            .eq('original_guru_id', guruId)
            .neq('guru_id', guruId)
            .eq('is_delegasi', true)
            .gte('created_at', firstDay)
            .lte('created_at', lastDay);

        // Sesuai diskusi: Potongan dihitung per kepala siswa yang didelegasikan keluar
        totalPotongan = (outResponse as List).length * settings.deductionAmount;
      }

      final double grandTotal = settings.baseSalary + totalBonusReguler + totalBonusDelegasi - totalPotongan;

      return {
        'base_salary': settings.baseSalary,
        'count_reguler_students': uniqueStudentWork.length,
        'bonus_reguler': totalBonusReguler,
        'count_delegasi_work': (settings.substituteBonusMode == 'per_student')
            ? uniqueDelegationWork.length
            : uniqueDaysActive.length,
        'bonus_delegasi': totalBonusDelegasi,
        'potongan': totalPotongan,
        'grand_total': grandTotal,
        'period': month,
      };
    } catch (e) {
      throw Exception(handleError(e));
    }
  }

  /// 4. SPP GENERATOR: Generating batch monthly invoices for active students
  Future<List<InvoiceModel>> generateInvoices(dynamic ref, {DateTime? month}) async {
    try {
      final targetMonth = month ?? DateTime.now();
      final lembagaId = getLembagaId(ref);

      final year = targetMonth.year;
      final monthStr = targetMonth.month.toString().padLeft(2, '0');
      final firstDayStr = '$year-$monthStr-01';
      final lastDayOfMonth = DateTime(year, targetMonth.month + 1, 0).day;
      final lastDayStr = '$year-$monthStr-$lastDayOfMonth';

      final studentsResponse = await supabase
          .from('siswa')
          .select('*, programs(monthly_fee)')
          .eq('lembaga_id', lembagaId)
          .or('status.eq.aktif,status.eq.AKTIF');

      final students = studentsResponse as List;
      if (students.isEmpty) return [];

      final existingInvoicesResponse = await supabase
          .from('invoices')
          .select('student_id')
          .eq('organization_id', lembagaId)
          .gte('issue_date', firstDayStr)
          .lte('issue_date', lastDayStr);

      final existingStudentIds = (existingInvoicesResponse as List)
          .map((e) => e['student_id'].toString())
          .toSet();

      final issueDate = DateTime(year, targetMonth.month, 1);
      final dueDate = DateTime(year, targetMonth.month, 10);

      final List<Map<String, dynamic>> newInvoicesData = [];

      for (var s in students) {
        final studentId = s['id'].toString();
        if (existingStudentIds.contains(studentId)) continue;

        final nisn = s['nisn'] != null && s['nisn'].toString().isNotEmpty
            ? s['nisn'].toString()
            : studentId.substring(0, studentId.length > 6 ? 6 : studentId.length);

        final invoiceNumber = 'INV-$year$monthStr-$nisn';

        double monthlyFee = 0.0;
        if (s['programs'] != null && s['programs']['monthly_fee'] != null) {
          monthlyFee = (s['programs']['monthly_fee'] as num).toDouble();
        } else if (s['monthly_fee'] != null) {
          monthlyFee = (s['monthly_fee'] as num).toDouble();
        } else {
          monthlyFee = 250000.0;
        }

        newInvoicesData.add({
          'organization_id': lembagaId,
          'student_id': studentId,
          'invoice_number': invoiceNumber,
          'issue_date': issueDate.toIso8601String().split('T')[0],
          'due_date': dueDate.toIso8601String().split('T')[0],
          'subtotal': monthlyFee,
          'discount': 0.0,
          'charges': 0.0,
          'total': monthlyFee,
          'outstanding': monthlyFee,
          'status': 'issued',
          'notes': 'Tagihan SPP Bulan $monthStr/$year',
        });
      }

      if (newInvoicesData.isEmpty) return [];

      final inserted = await supabase
          .from('invoices')
          .insert(newInvoicesData)
          .select();

      return (inserted as List)
          .map((json) => InvoiceModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception(handleError(e));
    }
  }

  /// 5. PROCESS PAYMENT & PENALTY (BR-FIN-002 & BR-FIN-003)
  Future<void> processPayment(dynamic ref, PaymentModel payment) async {
    try {
      final invoiceResponse = await supabase
          .from('invoices')
          .select()
          .eq('id', payment.invoiceId)
          .single();

      final invoice = InvoiceModel.fromJson(invoiceResponse);

      double charges = invoice.charges;
      final paymentOnlyDate = DateTime(payment.paymentDate.year, payment.paymentDate.month, payment.paymentDate.day);
      final dueOnlyDate = DateTime(invoice.dueDate.year, invoice.dueDate.month, invoice.dueDate.day);

      // BR-FIN-002: Denda 10% jika pembayaran > due_date
      if (paymentOnlyDate.isAfter(dueOnlyDate) && charges == 0) {
        charges = invoice.subtotal * 0.10;
      }

      final newTotal = invoice.subtotal - invoice.discount + charges;

      // Hitung total terbayar sebelumnya
      final existingPaymentsResponse = await supabase
          .from('payments')
          .select('amount')
          .eq('invoice_id', payment.invoiceId);

      double previousPaid = 0.0;
      for (var p in existingPaymentsResponse as List) {
        previousPaid += (p['amount'] as num).toDouble();
      }

      final totalPaidAfterThis = previousPaid + payment.amount;
      final newOutstanding = newTotal - totalPaidAfterThis;

      final newStatus = newOutstanding <= 0 ? 'paid' : 'partial';

      // Insert payment (Immutable)
      final paymentData = payment.toJson();
      if (paymentData['id'] == null) paymentData.remove('id');
      await supabase.from('payments').insert(paymentData);

      // Update invoice record
      await supabase.from('invoices').update({
        'charges': charges,
        'total': newTotal,
        'outstanding': newOutstanding < 0 ? 0.0 : newOutstanding,
        'status': newStatus,
      }).eq('id', payment.invoiceId);
    } catch (e) {
      throw Exception(handleError(e));
    }
  }

  /// 6. OPERATIONAL EXPENSES MANAGEMENT
  Future<List<ExpenseModel>> getExpenses(dynamic ref) async {
    try {
      final lembagaId = getLembagaId(ref);
      final response = await supabase
          .from('expenses')
          .select()
          .eq('organization_id', lembagaId)
          .order('date', ascending: false);

      return (response as List)
          .map((json) => ExpenseModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception(handleError(e));
    }
  }

  Future<void> addExpense(dynamic ref, ExpenseModel expense) async {
    try {
      final data = expense.toJson();
      if (data['id'] == null) data.remove('id');
      await supabase.from('expenses').insert(data);
    } catch (e) {
      throw Exception(handleError(e));
    }
  }

  /// 7. EXECUTIVE REPORT DATA (INCOME VS EXPENSE AGGREGATION)
  Future<Map<String, dynamic>> getFinanceReportData(dynamic ref, {int? year}) async {
    try {
      final lembagaId = getLembagaId(ref);
      final targetYear = year ?? DateTime.now().year;

      final startDate = '$targetYear-01-01T00:00:00';
      final endDate = '$targetYear-12-31T23:59:59';

      final invoicesResponse = await supabase
          .from('invoices')
          .select('id')
          .eq('organization_id', lembagaId);

      final invoiceIds = (invoicesResponse as List).map((i) => i['id'].toString()).toList();

      List<double> monthlyIncome = List.filled(12, 0.0);
      if (invoiceIds.isNotEmpty) {
        final paymentsResponse = await supabase
            .from('payments')
            .select('amount, payment_date')
            .inFilter('invoice_id', invoiceIds)
            .gte('payment_date', startDate)
            .lte('payment_date', endDate);

        for (var p in paymentsResponse as List) {
          final pDate = DateTime.parse(p['payment_date'].toString());
          final monthIndex = pDate.month - 1;
          monthlyIncome[monthIndex] += (p['amount'] as num).toDouble();
        }
      }

      final expensesResponse = await supabase
          .from('expenses')
          .select('amount, date')
          .eq('organization_id', lembagaId)
          .gte('date', '$targetYear-01-01')
          .lte('date', '$targetYear-12-31');

      List<double> monthlyExpenses = List.filled(12, 0.0);
      for (var e in expensesResponse as List) {
        final eDate = DateTime.parse(e['date'].toString());
        final monthIndex = eDate.month - 1;
        monthlyExpenses[monthIndex] += (e['amount'] as num).toDouble();
      }

      return {
        'year': targetYear,
        'income': monthlyIncome,
        'expense': monthlyExpenses,
      };
    } catch (e) {
      throw Exception(handleError(e));
    }
  }
}