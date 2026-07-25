// Lokasi: lib/features/management_lembaga/providers/unit_kerja_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/providers/app_context_provider.dart';
import '../models/unit_kerja_model.dart';

part 'unit_kerja_provider.g.dart';

@riverpod
class UnitKerjaList extends _$UnitKerjaList {
  final _supabase = Supabase.instance.client;

  @override
  Future<List<UnitKerjaModel>> build() async {
    final appContext = ref.watch(appContextProvider);
    final lembagaId = appContext.lembaga?.id;

    if (lembagaId == null) return [];

    final response = await _supabase
        .from('unit_kerja')
        .select()
        .eq('lembaga_id', lembagaId)
        .order('nama_unit_kerja');

    return (response as List).map((e) => UnitKerjaModel.fromJson(e)).toList();
  }

  Future<void> saveUnitKerja(UnitKerjaModel unitKerja) async {
    final appContext = ref.read(appContextProvider);
    final lembagaId = appContext.lembaga?.id;
    if (lembagaId == null) return;

    final data = unitKerja.toJson();
    data['lembaga_id'] = lembagaId;
    if (unitKerja.id.isEmpty) data.remove('id');

    await _supabase.from('unit_kerja').upsert(data);
    ref.invalidateSelf();
  }

  Future<void> deleteUnitKerja(String id) async {
    await _supabase.from('unit_kerja').delete().eq('id', id);
    ref.invalidateSelf();
  }
}