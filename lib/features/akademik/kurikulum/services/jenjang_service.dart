// Lokasi: lib/features/akademik/kurikulum/services/jenjang_service.dart

import 'package:space_eduos/core/services/base_service.dart';
// Gunakan kurikulum_model.dart karena class JenjangModel sekarang digabung di sana
import 'package:space_eduos/features/akademik/kurikulum/models/kurikulum_model.dart';

class JenjangService extends BaseService {
  // --- JENJANG ---
  Future<List<JenjangModel>> fetchJenjang(String kurikulumId) async {
    try {
      final response = await supabase
          .from('jenjang_kurikulum')
          .select('*, level:kurikulum_level(*, modul:modul_kurikulum(*))')
          .eq('kurikulum_id', kurikulumId)
          .order('urutan', ascending: true); // FIX: Diurutkan berdasarkan kolom urutan
      return (response as List).map((e) => JenjangModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception(handleError(e));
    }
  }

  Future<void> saveJenjang(JenjangModel jenjang) async {
    try {
      final data = cleanData(jenjang.toJson())..remove('level');
      if (jenjang.id == null) {
        await supabase.from('jenjang_kurikulum').insert(data..remove('id'));
      } else {
        await supabase.from('jenjang_kurikulum').update(data).eq('id', jenjang.id!);
      }
    } catch (e) {
      throw Exception(handleError(e));
    }
  }

  Future<void> deleteJenjang(String id) async {
    try {
      await supabase.from('jenjang_kurikulum').delete().eq('id', id);
    } catch (e) {
      throw Exception(handleError(e));
    }
  }
}