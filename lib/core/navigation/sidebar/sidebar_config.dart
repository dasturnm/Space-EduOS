import '../../providers/app_context_provider.dart';

class SidebarItemConfig {
  final String title;
  final String route;
  final String? requiredModule;
  final String? requiredPermission;
  final List<String>? requiredPermissionsAny;
  final bool isImplemented;

  const SidebarItemConfig({
    required this.title,
    required this.route,
    this.requiredModule,
    this.requiredPermission,
    this.requiredPermissionsAny,
    this.isImplemented = true,
  });
}

class SidebarSectionConfig {
  final String title;
  final String? requiredModule;
  final List<SidebarItemConfig> items;

  const SidebarSectionConfig({
    required this.title,
    this.requiredModule,
    required this.items,
  });
}

class SidebarMenuRegistry {
  static const List<SidebarSectionConfig> sections = [
    // 1. ORGANISASI (CORE)
    SidebarSectionConfig(
      title: 'ORGANISASI',
      items: [
        SidebarItemConfig(
          title: 'Profil Organisasi',
          route: '/organisasi',
          requiredPermission: 'organization.view',
        ),
        SidebarItemConfig(
          title: 'Cabang & Unit',
          route: '/cabang',
          requiredPermission: 'organization.branch.view',
        ),
        SidebarItemConfig(
          title: 'Tahun Ajaran',
          route: '/tahun-ajaran',
          requiredPermission: 'academic_year.view',
        ),
        SidebarItemConfig(
          title: 'Divisi',
          route: '/divisi',
          requiredPermission: 'department.view',
        ),
        SidebarItemConfig(
          title: 'Unit Kerja',
          route: '/unit-kerja',
          requiredPermission: 'work_unit.view',
        ),
        SidebarItemConfig(
          title: 'Jabatan & Permission',
          route: '/jabatan',
          requiredPermission: 'job_position.view',
        ),
      ],
    ),

    // 2. AKADEMIK (CORE)
    SidebarSectionConfig(
      title: 'AKADEMIK',
      items: [
        SidebarItemConfig(
          title: 'Program & Kaldik',
          route: '/program',
          requiredPermission: 'program.view',
        ),
        SidebarItemConfig(
          title: 'Kurikulum & Modul',
          route: '/kurikulum',
          requiredPermission: 'curriculum.view',
        ),
        SidebarItemConfig(
          title: 'Katalog Silabus',
          route: '/silabus',
          requiredPermission: 'curriculum.view',
        ),
      ],
    ),

    // 3. PESERTA DIDIK (CORE)
    SidebarSectionConfig(
      title: 'PESERTA DIDIK',
      items: [
        SidebarItemConfig(
          title: 'Siswa & Kelas',
          route: '/siswa',
          requiredPermission: 'student.view',
        ),
        SidebarItemConfig(
          title: 'Penerimaan Siswa',
          route: '/admission',
          requiredModule: 'admission',
          requiredPermission: 'admission.view',
        ),
        SidebarItemConfig(
          title: 'Wali Santri',
          route: '/wali',
          requiredModule: 'parent',
          requiredPermission: 'parent.view',
        ),
      ],
    ),

    // 4. TAHFIDZ (ACTIVE MODULE)
    SidebarSectionConfig(
      title: 'TAHFIDZ',
      requiredModule: 'tahfidz',
      items: [
        SidebarItemConfig(
          title: 'Mutaba\'ah Tahfidz',
          route: '/mutabaah',
          requiredModule: 'tahfidz',
          requiredPermission: 'tahfidz.mutabaah.view',
        ),
        SidebarItemConfig(
          title: 'Ujian Tasmi\' & UKL',
          route: '/tasmi',
          requiredModule: 'tahfidz',
          requiredPermission: 'tahfidz.exam.view',
        ),
        SidebarItemConfig(
          title: 'Mushaf Digital',
          route: '/mushaf',
          requiredModule: 'tahfidz',
        ),
      ],
    ),

    // 5. SDM & PAYROLL (HR)
    SidebarSectionConfig(
      title: 'SDM & PAYROLL',
      requiredModule: 'hr',
      items: [
        SidebarItemConfig(
          title: 'Guru & Staff',
          route: '/staf',
          requiredModule: 'hr',
          requiredPermission: 'hr.staff.view',
        ),
        SidebarItemConfig(
          title: 'Presensi Staff',
          route: '/presensi',
          requiredModule: 'hr',
          requiredPermission: 'hr.attendance.view',
        ),
        SidebarItemConfig(
          title: 'Pengaturan Gaji',
          route: '/keuangan/payroll-settings',
          requiredModule: 'hr',
          requiredPermission: 'payroll.manage',
        ),
      ],
    ),

    // 6. KEUANGAN (FINANCE - PARTIAL)
    SidebarSectionConfig(
      title: 'KEUANGAN',
      requiredModule: 'finance',
      items: [
        SidebarItemConfig(
          title: 'Manajemen Keuangan',
          route: '/keuangan',
          requiredModule: 'finance',
          requiredPermission: 'finance.view',
        ),
      ],
    ),
  ];

  /// Evaluasi Dual-Gate: Gate 1 (Active Modules) & Gate 2 (Permissions)
  static bool canAccessItem({
    required SidebarItemConfig item,
    required AppContextState contextState,
  }) {
    if (!item.isImplemented) return false;

    // Gate 1: Check Active Module
    if (item.requiredModule != null && item.requiredModule!.isNotEmpty) {
      if (!contextState.hasModule(item.requiredModule!)) {
        return false;
      }
    }

    // Gate 2: Check Permission
    if (item.requiredPermission != null && item.requiredPermission!.isNotEmpty) {
      if (!contextState.hasPermission(item.requiredPermission!)) {
        return false;
      }
    }

    if (item.requiredPermissionsAny != null && item.requiredPermissionsAny!.isNotEmpty) {
      final hasAny = item.requiredPermissionsAny!.any((p) => contextState.hasPermission(p));
      if (!hasAny) return false;
    }

    return true;
  }
}