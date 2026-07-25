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
          .from('cabang')
          .select()
          .eq('lembaga_id', lembagaId)
          .order('nama_cabang');
      return (response as List).map((e) => CabangModel.fromJson(e)).toList();
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<void> saveCabang(Ref ref, CabangModel cabang) async {
    try {
      final data = cleanData(cabang.toJson());
      data['lembaga_id'] = getLembagaId(ref); // Inject otomatis
      if (cabang.id.isEmpty) data.remove('id');
      await supabase.from('cabang').upsert(data);
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<void> deleteCabang(String id) async {
    try {
      await supabase.from('cabang').delete().eq('id', id);
    } catch (e) {
      throw handleError(e);
    }
  }

  // --- DIVISI ---
  Future<List<DivisiModel>> getDivisi(Ref ref, String lembagaId) async {
    try {
      final response = await supabase
          .from('divisi')
          .select()
          .eq('lembaga_id', lembagaId)
          .order('nama_divisi');
      return (response as List).map((e) => DivisiModel.fromJson(e)).toList();
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<void> saveDivisi(Ref ref, DivisiModel divisi) async {
    try {
      final data = cleanData(divisi.toJson());
      data['lembaga_id'] = getLembagaId(ref);
      if (divisi.id.isEmpty) data.remove('id');
      await supabase.from('divisi').upsert(data);
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<void> deleteDivisi(String id) async {
    try {
      await supabase.from('divisi').delete().eq('id', id);
    } catch (e) {
      throw handleError(e);
    }
  }

  // --- UNIT KERJA ---
  Future<List<UnitKerjaModel>> getUnitKerja(Ref ref, String lembagaId) async {
    try {
      final response = await supabase
          .from('unit_kerja')
          .select()
          .eq('lembaga_id', lembagaId)
          .order('nama_unit_kerja');
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
      await supabase.from('unit_kerja').upsert(data);
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<void> deleteUnitKerja(String id) async {
    try {
      await supabase.from('unit_kerja').delete().eq('id', id);
    } catch (e) {
      throw handleError(e);
    }
  }

  // --- JABATAN ---
  Future<List<JabatanModel>> getJabatan(Ref ref, String lembagaId) async {
    try {
      final response = await supabase
          .from('jabatan')
          .select('*, unit_kerja(*, divisi(*))')
          .eq('lembaga_id', lembagaId)
          .order('nama_jabatan');
      return (response as List).map((e) => JabatanModel.fromJson(e)).toList();
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<void> saveJabatan(Ref ref, JabatanModel jabatan) async {
    try {
      final data = cleanData(jabatan.toJson());
      data['lembaga_id'] = getLembagaId(ref);
      if (jabatan.id.isEmpty) data.remove('id');
      await supabase.from('jabatan').upsert(data);
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<void> deleteJabatan(String id) async {
    try {
      await supabase.from('jabatan').delete().eq('id', id);
    } catch (e) {
      throw handleError(e);
    }
  }
}