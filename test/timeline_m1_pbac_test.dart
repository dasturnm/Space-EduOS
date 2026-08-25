import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:space_eduos/core/providers/app_context_provider.dart';
import 'package:space_eduos/features/management_lembaga/models/jabatan_model.dart';
import 'package:space_eduos/features/management_lembaga/models/lembaga_model.dart';

void main() {
  group('Timeline Minggu 1 - Real PBAC & Unit Kerja Tests', () {
    late ProviderContainer container;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      await Supabase.initialize(
        url: 'https://placeholder.supabase.co',
        anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBsYWNlaG9sZGVyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI1MTIwMDAsImV4cCI6MjAxODA4ODAwMH0.placeholder',
      );
    });

    setUp(() {
      // Inisialisasi ProviderContainer asli untuk membaca provider nyata (tanpa mocking)
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Menguji State Awal AppContext Melalui ProviderContainer (Tanpa Bypass)', () {
      // Membaca state asli dari app_context_provider.dart
      final contextState = container.read(appContextProvider);

      // State awal harus uninitialized, loading false, dan permissions kosong
      expect(contextState.isLoading, isFalse);
      expect(contextState.permissions, isEmpty);
      expect(contextState.lembaga, isNull);
    });

    test('Menguji Default Modules pada Real AppContextState (Tanpa Bypass)', () {
      final contextState = container.read(appContextProvider);

      // Sesuai dengan spesifikasi dan kode asli, default modules harus aktif saat lembaga null
      expect(contextState.hasModule('tahfidz'), isTrue);
      expect(contextState.hasModule('attendance'), isTrue);
      expect(contextState.hasModule('communication'), isTrue);
      expect(contextState.hasModule('akademik'), isTrue);
      expect(contextState.hasModule('keuangan'), isTrue);
      expect(contextState.hasModule('lms'), isFalse);
    });

    test('Menguji Verifikasi Izin Granular & Bypass Role Real AppContextState', () {
      // Kita uji hasPermission pada AppContextState dengan bypass role
      final adminState = AppContextState(
        role: 'OWNER',
        permissions: [],
      );
      expect(adminState.hasPermission('tahfidz.write'), isTrue);

      final guruState = AppContextState(
        role: 'GURU',
        permissions: ['tahfidz.write', 'student.read'],
      );
      expect(guruState.hasPermission('tahfidz.write'), isTrue);
      expect(guruState.hasPermission('finance.spp.manage'), isFalse);
    });

    test('Menguji Serialisasi & Deserialisasi Riil JabatanModel', () {
      final json = {
        'id': 'jabatan-uuid-123',
        'lembaga_id': 'lembaga-uuid-456',
        'divisi_id': 'divisi-uuid-789',
        'unit_kerja_id': 'unit-kerja-uuid-999',
        'nama_jabatan': 'Kepala Musyrif',
        'default_role': 'GURU',
        'status': 'aktif',
        'level_jabatan': 2,
        'catatan_jabatan': 'Mengkoordinir seluruh setoran',
        'permissions': ['tahfidz.write', 'tahfidz.read', 'tahfidz.assess']
      };

      final model = JabatanModel.fromJson(json);

      expect(model.id, 'jabatan-uuid-123');
      expect(model.unitKerjaId, 'unit-kerja-uuid-999');
      expect(model.permissions, contains('tahfidz.assess'));

      final serialized = model.toJson();
      expect(serialized['unit_kerja_id'], 'unit-kerja-uuid-999');
      expect(serialized['permissions'], contains('tahfidz.write'));
    });
  });
}