import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/invoice_model.dart';
import '../models/expense_model.dart';
import '../models/salary_settings_model.dart';
import '../services/keuangan_service.dart';

/// Provider Instance untuk Service Keuangan
final keuanganServiceProvider = Provider<KeuanganService>((ref) => KeuanganService());

/// Provider untuk Mengambil Konfigurasi Gaji (Salary Settings)
final salarySettingsProvider = FutureProvider<SalarySettingsModel?>((ref) async {
  final service = ref.watch(keuanganServiceProvider);
  return await service.getSettings(ref);
});

/// Notifier untuk Aksi Keuangan (Save/Update Settings)
class KeuanganNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> updateSettings(SalarySettingsModel settings) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(keuanganServiceProvider);
      await service.saveSettings(settings);
      ref.invalidate(salarySettingsProvider);
    });
  }
}

final keuanganProvider = AsyncNotifierProvider<KeuanganNotifier, void>(KeuanganNotifier.new);

/// Notifier Filter Status Tagihan SPP ('', 'issued', 'partial', 'paid', 'overdue')
class SppStatusFilterNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setStatus(String status) => state = status;
}

final sppStatusFilterProvider =
NotifierProvider<SppStatusFilterNotifier, String>(SppStatusFilterNotifier.new);

/// Provider mengambil daftar Invoice SPP berdasarkan filter status
final invoiceListProvider = FutureProvider<List<InvoiceModel>>((ref) async {
  final filter = ref.watch(sppStatusFilterProvider);
  final supabase = Supabase.instance.client;

  final user = supabase.auth.currentUser;
  if (user == null) return [];

  final profileData = await supabase
      .from('profiles')
      .select('organization_id, lembaga_id')
      .eq('id', user.id)
      .maybeSingle();

  final orgId = (profileData?['organization_id'] ?? profileData?['lembaga_id'] ?? '').toString();

  var query = supabase.from('invoices').select();

  if (orgId.isNotEmpty) {
    query = query.eq('organization_id', orgId);
  }

  if (filter.isNotEmpty) {
    query = query.eq('status', filter);
  }

  final response = await query.order('issue_date', ascending: false);
  return (response as List).map((json) => InvoiceModel.fromJson(json)).toList();
});

/// Provider mengambil daftar Pengeluaran Operasional (Expenses)
final expenseListProvider = FutureProvider<List<ExpenseModel>>((ref) async {
  final service = ref.watch(keuanganServiceProvider);
  return await service.getExpenses(ref);
});

/// Notifier Tahun Laporan Keuangan Eksekutif
class SelectedFinanceYearNotifier extends Notifier<int> {
  @override
  int build() => DateTime.now().year;

  void setYear(int year) => state = year;
}

final selectedFinanceYearProvider =
NotifierProvider<SelectedFinanceYearNotifier, int>(SelectedFinanceYearNotifier.new);

/// Provider data grafik Laporan Keuangan Eksekutif (Income vs Expense)
final financeReportProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final year = ref.watch(selectedFinanceYearProvider);
  final service = ref.watch(keuanganServiceProvider);
  return await service.getFinanceReportData(ref, year: year);
});

/// Provider Kalkulasi Slip Gaji Guru (Payroll)
final monthlyPayrollProvider =
FutureProvider.family<Map<String, dynamic>, ({String guruId, DateTime month})>((ref, arg) async {
  final service = ref.watch(keuanganServiceProvider);
  return await service.calculateMonthlyPayroll(ref, arg.guruId, arg.month);
});