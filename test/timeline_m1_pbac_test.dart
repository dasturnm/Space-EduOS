import 'package:flutter_test/flutter_test.dart';
import 'package:space_eduos/core/providers/app_context_provider.dart';
import 'package:space_eduos/features/management_lembaga/models/jabatan_model.dart';
import 'package:space_eduos/features/management_lembaga/models/lembaga_model.dart';

void main() {
  group('Timeline Minggu 1 - PBAC & Unit Kerja Tests', () {

    group('PBAC & Module Gating (AppContextState)', () {
      test('should bypass permission check for OWNER, ADMIN, SUPERADMIN, and SUPER_ADMIN roles', () {
        final rolesToBypass = ['OWNER', 'ADMIN', 'SUPERADMIN', 'SUPER_ADMIN'];

        for (final role in rolesToBypass) {
          final state = AppContextState(
            role: role,
            permissions: [],
          );
          expect(
              state.hasPermission('tahfidz.write'),
              isTrue,
              reason: 'Role $role should bypass permission checking.'
          );
          expect(
              state.hasPermission('finance.spp.manage'),
              isTrue,
              reason: 'Role $role should bypass permission checking.'
          );
        }
      });

      test('should strictly validate granular permission for other standard roles', () {
        final state = AppContextState(
          role: 'GURU',
          permissions: ['tahfidz.write', 'student.read'],
        );

        expect(state.hasPermission('tahfidz.write'), isTrue, reason: 'GURU has tahfidz.write permission.');
        expect(state.hasPermission('student.read'), isTrue, reason: 'GURU has student.read permission.');
        expect(state.hasPermission('finance.spp.manage'), isFalse, reason: 'GURU does not have finance.spp.manage permission.');
      });

      test('should return false for permissions when role is null and permission is not granted', () {
        final state = AppContextState(
          role: null,
          permissions: [],
        );
        expect(state.hasPermission('tahfidz.write'), isFalse);
      });

      test('should return default modules based on the baseline list', () {
        final stateNoLembaga = AppContextState(lembaga: null);
        expect(stateNoLembaga.hasModule('tahfidz'), isTrue);
        expect(stateNoLembaga.hasModule('attendance'), isTrue);
        expect(stateNoLembaga.hasModule('communication'), isTrue);
        expect(stateNoLembaga.hasModule('akademik'), isFalse);
        expect(stateNoLembaga.hasModule('keuangan'), isFalse);

        final stateEmptyConfig = AppContextState(
          lembaga: LembagaModel(
            id: 'lembaga-1',
            namaLembaga: 'Yayasan Al-Furqan',
            kodeLembaga: 'YAF-001',
          ),
        );
        expect(stateEmptyConfig.hasModule('tahfidz'), isTrue);
        expect(stateEmptyConfig.hasModule('attendance'), isTrue);
        expect(stateEmptyConfig.hasModule('communication'), isTrue);
        expect(stateEmptyConfig.hasModule('akademik'), isFalse);
      });
    });

    group('Unit Kerja & Jabatan Model Mapping', () {
      test('should serialize and deserialize JabatanModel correctly', () {
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
        expect(model.lembagaId, 'lembaga-uuid-456');
        expect(model.divisiId, 'divisi-uuid-789');
        expect(model.unitKerjaId, 'unit-kerja-uuid-999');
        expect(model.namaJabatan, 'Kepala Musyrif');
        expect(model.defaultRole, 'GURU');
        expect(model.levelJabatan, 2);
        expect(model.permissions, contains('tahfidz.assess'));

        final serialized = model.toJson();
        expect(serialized['unit_kerja_id'], 'unit-kerja-uuid-999');
        expect(serialized['permissions'], contains('tahfidz.write'));
      });

      test('should support copyWith for updates', () {
        final model = JabatanModel(
          id: '1',
          lembagaId: '10',
          divisiId: '100',
          namaJabatan: 'Guru Tahfidz',
          defaultRole: 'GURU',
        );

        final updated = model.copyWith(
          unitKerjaId: '200',
          permissions: ['tahfidz.write'],
        );

        expect(updated.id, '1');
        expect(updated.unitKerjaId, '200');
        expect(updated.permissions, contains('tahfidz.write'));
        expect(updated.namaJabatan, 'Guru Tahfidz');
      });
    });
  });
}
