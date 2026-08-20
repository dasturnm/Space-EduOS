import '../../../core/services/base_service.dart';
import '../models/wali_model.dart';

class ParentService extends BaseService {
  Future<List<WaliModel>> getWaliList(String organizationId, {String? searchQuery}) async {
    try {
      var query = supabase
          .from('profiles')
          .select('*, student_guardians!fk_guardian_parent(siswa(nama_lengkap))')
          .or('role.eq.WALI,role.eq.wali')
          .or('organization_id.eq.$organizationId,lembaga_id.eq.$organizationId');

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.ilike('fullName', '%$searchQuery%');
      }

      final response = await query.order('fullName', ascending: true);
      return (response as List).map((json) => WaliModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception(handleError(e));
    }
  }
}
