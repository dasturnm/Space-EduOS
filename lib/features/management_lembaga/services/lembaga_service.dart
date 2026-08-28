// Lokasi: lib/features/management_lembaga/services/lembaga_service.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/base_service.dart';
import '../models/cabang_model.dart';
import '../models/divisi_model.dart';
import '../models/jabatan_model.dart';
import '../models/unit_kerja_model.dart';

class LembagaService extends BaseService {
  // --- CABANG ---
  Future<List<CabangModel>> getCabang(Ref ref, String lembagaId) async {
    try {
      final response = await supabase
          .from('organizational_units')
          .select()
          .eq('organization_id', lembagaId)
          .order('name');
      return (response as List).map((e) => CabangModel.fromJson(e)).toList();
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<void> saveCabang(Ref ref, CabangModel cabang) async {
    try {
      final data = cleanData(cabang.toJson());
      data['organization_id'] = getLembagaId(ref);
      data['lembaga_id'] = getLembagaId(ref); // Inject otomatis
      if (cabang.id.isEmpty) data.remove('id');
      await supabase.from('organizational_units').upsert(data);
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<void> deleteCabang(String id) async {
    try {
      await supabase.from('organizational_units').delete().eq('id', id);
    } catch (e) {
      throw handleError(e);
    }
  }

  // --- DIVISI ---
  Future<List<DivisiModel>> getDivisi(Ref ref, String lembagaId) async {
    try {
      final response = await supabase
          .from('departments')
          .select()
          .eq('organization_id', lembagaId)
          .order('name');
      return (response as List).map((e) => DivisiModel.fromJson(e)).toList();
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<void> saveDivisi(Ref ref, DivisiModel divisi) async {
    try {
      final data = cleanData(divisi.toJson());
      data['organization_id'] = getLembagaId(ref);
      data['lembaga_id'] = getLembagaId(ref);
      if (divisi.id.isEmpty) data.remove('id');
      await supabase.from('departments').upsert(data);
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<void> deleteDivisi(String id) async {
    try {
      await supabase.from('departments').delete().eq('id', id);
    } catch (e) {
      throw handleError(e);
    }
  }

  // --- UNIT KERJA ---
  Future<List<UnitKerjaModel>> getUnitKerja(Ref ref, String lembagaId) async {
    try {
      final response = await supabase
          .from('work_units')
          .select('*, department:departments!inner(*)')
          .eq('department.organization_id', lembagaId)
          .order('name');
      return (response as List).map((e) => UnitKerjaModel.fromJson(e)).toList();
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<void> saveUnitKerja(Ref ref, UnitKerjaModel unitKerja) async {
    try {
      final data = cleanData(unitKerja.toJson());
      data['lembaga_id'] = getLembagaId(ref);
      if (unitKerja.id.isEmpty) data.remove('id');
      await supabase.from('work_units').upsert(data);
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<void> deleteUnitKerja(String id) async {
    try {
      await supabase.from('work_units').delete().eq('id', id);
    } catch (e) {
      throw handleError(e);
    }
  }

  // --- JABATAN ---
  Future<List<JabatanModel>> getJabatan(Ref ref, String lembagaId) async {
    try {
      final response = await supabase
          .from('job_positions')
          .select('*, unit_kerja:work_units(*, divisi:departments(*))')
          .eq('organization_id', lembagaId)
          .order('title');
      return (response as List).map((e) => JabatanModel.fromJson(e)).toList();
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<void> saveJabatan(Ref ref, JabatanModel jabatan) async {
    try {
      final data = cleanData(jabatan.toJson());
      data['organization_id'] = getLembagaId(ref);
      data['lembaga_id'] = getLembagaId(ref);
      if (jabatan.id.isEmpty) data.remove('id');
      await supabase.from('job_positions').upsert(data);
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<void> deleteJabatan(String id) async {
    try {
      await supabase.from('job_positions').delete().eq('id', id);
    } catch (e) {
      throw handleError(e);
    }
  }
}