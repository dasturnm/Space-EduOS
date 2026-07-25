// Lokasi: lib/features/program/providers/calendar_summary_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/effective_day_service.dart'; // FIX: Mengarah ke EffectiveDayService
import '../../../core/providers/app_context_provider.dart';

part 'calendar_summary_provider.g.dart';

/// Provider reaktif untuk mengambil ringkasan kalkulasi hari efektif akademik.
/// UI dapat melakukan watch pada provider ini agar mendapatkan update data secara otomatis.
@riverpod
Future<AcademicSummaryModel> calendarSummary(
    CalendarSummaryRef ref,
    String programId, {
      String? tahunAjaranId,
    }) async {
  final appContext = ref.watch(appContextProvider);
  final lembagaId = appContext.lembaga?.id ?? '';
  final selectedTahunAjaranId = tahunAjaranId ?? appContext.currentTahunAjaran?.id;

  final service = EffectiveDayService(); // FIX: Menggunakan EffectiveDayService
  return await service.calculateAcademicSummary(
    lembagaId: lembagaId,
    programId: programId,
    tahunAjaranId: selectedTahunAjaranId,
  );
}