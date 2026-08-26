import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/sertifikasi_model.dart';
import '../services/sertifikasi_service.dart';

part 'sertifikasi_provider.g.dart';

@riverpod
SertifikasiService sertifikasiService(Ref ref) {
  return SertifikasiService();
}

@riverpod
class CertificateNotifier extends _$CertificateNotifier {
  @override
  Future<List<SertifikasiModel>> build(String organizationId) async {
    return ref.read(sertifikasiServiceProvider).fetchCertificates(organizationId);
  }

  Future<void> issueCertificate(SertifikasiModel certificate) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(sertifikasiServiceProvider).generateCertificate(certificate);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}