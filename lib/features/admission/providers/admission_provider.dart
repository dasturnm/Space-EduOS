import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/app_context_provider.dart';
import '../models/pendaftaran_model.dart';
import '../services/admission_service.dart';

part 'admission_provider.g.dart';

/// Provider untuk AdmissionService
final admissionServiceProvider = Provider<AdmissionService>((ref) {
  return AdmissionService();
});

/// Filter status pendaftar ('', 'registrasi', 'verifikasi', 'approval', 'enrolled', 'ditolak')
@riverpod
class AdmissionStatusFilter extends _$AdmissionStatusFilter {
  @override
  String build() => '';

  void setStatus(String status) => state = status;
}

/// FutureProvider untuk membaca daftar pendaftar
final admissionListProvider = FutureProvider.autoDispose<List<PendaftaranModel>>((ref) async {
  final service = ref.watch(admissionServiceProvider);
  final appContext = ref.watch(appContextProvider);
  final status = ref.watch(admissionStatusFilterProvider);

  final lembagaId = appContext.lembaga?.id ?? '';
  if (lembagaId.isEmpty) return [];

  return await service.getPendaftarList(lembagaId, status: status);
});