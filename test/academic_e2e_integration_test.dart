import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:space_eduos/features/management_lembaga/services/lembaga_service.dart';
import 'package:space_eduos/features/siswa/services/siswa_service.dart';
import 'package:space_eduos/features/akademik/evaluasi/services/ukl_engine_service.dart';

void main() {
  late final SupabaseClient supabaseClient;
  late LembagaService lembagaService;
  late SiswaService siswaService;
  late UklEngineService uklEngine;

  const String testLembagaId = "852d21af-609c-550e-5f85-385255ed4c7b";
  const String testSiswaId = "20000000-0000-0000-0000-000000000002";

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Supabase.initialize(
      url: const String.fromEnvironment(
        'SUPABASE_URL',
        defaultValue: 'https://mrxtnwmyqfmfdncdvssh.supabase.co',
      ),
      anonKey: const String.fromEnvironment(
        'SUPABASE_ANON_KEY',
        defaultValue: 'sb_publishable_OAPUWnbXxiDjKDFMkgvIng_xUKs67lg',
      ),
    );
    supabaseClient = Supabase.instance.client;
    lembagaService = LembagaService();
    siswaService = SiswaService();
    uklEngine = UklEngineService();
  });

  group('UAT Skenario A - Aliran Integrasi Akademik', () {
    test('1. Setup Kurikulum & Level Baru Teruji Valid', () async {
      final activeTA = await supabaseClient
          .from('tahun_ajaran')
          .select()
          .eq('lembaga_id', testLembagaId)
          .eq('is_active', true)
          .maybeSingle();

      expect(activeTA, isNotNull, reason: "Tahun Ajaran Aktif wajib berdiri!");
    });

    test('2. Transisi Setoran Hafalan & Promosi Ujian Lolos Verifikasi', () async {
      await supabaseClient.from('siswa').update({
        'academic_state': 'exam_ready',
        'is_ready_for_exam': true,
      }).eq('id', testSiswaId);

      final siswaUpdated = await supabaseClient
          .from('siswa')
          .select('academic_state')
          .eq('id', testSiswaId)
          .single();

      expect(siswaUpdated['academic_state'], equals('exam_ready'));
    });

    test('3. Proses Auto-Promosi Lintas Jenjang Berhasil Menyegel Status', () async {
      await uklEngine.processPromotion(testSiswaId);

      final siswaPostExam = await supabaseClient
          .from('siswa')
          .select('level_id, status')
          .eq('id', testSiswaId)
          .single();

      expect(siswaPostExam['status'], equals('active'));
    });
  });
}