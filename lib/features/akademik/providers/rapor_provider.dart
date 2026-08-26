import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/rapor_model.dart';
import '../services/rapor_engine_service.dart';

part 'rapor_provider.g.dart';

@riverpod
RaporEngineService raporEngineService(Ref ref) {
  return RaporEngineService();
}

@riverpod
class RaporNotifier extends _$RaporNotifier {
  @override
  Future<RaporModel> build(String studentId, String termId) async {
    return ref
        .read(raporEngineServiceProvider)
        .calculateRaporForStudent(studentId: studentId, termId: termId);
  }
}