// Lokasi: lib/core/layout/sidebar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:space_eduos/features/auth/providers/auth_provider.dart';
import 'package:space_eduos/core/constants/app_routes.dart';
import 'package:space_eduos/core/providers/app_context_provider.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final appContext = ref.watch(appContextProvider);

    final bool canManageLembaga = appContext.hasPermission('organization.manage') || appContext.hasPermission('organization.read') || appContext.hasPermission('lembaga_manage');
    final bool canManageStaf = appContext.hasPermission('staf_manage') || appContext.hasPermission('staf_read');
    final bool canManageAkademik = appContext.hasPermission('academic.program.manage') || appContext.hasPermission('academic.curriculum.manage') || appContext.hasPermission('student.manage') || appContext.hasPermission('class.manage') || appContext.hasPermission('tahfidz.write') || appContext.hasPermission('tahfidz.read') || appContext.hasPermission('akademik_program_manage') || appContext.hasPermission('akademik_kurikulum_manage') || appContext.hasPermission('siswa_manage') || appContext.hasPermission('kelas_manage') || appContext.hasPermission('mutabaah_input') || appContext.hasPermission('mutabaah_view_all');
    final bool canManageKeuangan = appContext.hasPermission('finance.spp.manage') || appContext.hasPermission('finance.spp.view') || appContext.hasPermission('keuangan_spp_manage') || appContext.hasPermission('finance.payroll.view') || appContext.hasPermission('keuangan_payroll_view');

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF10B981)),
            child: Text('Tahfidz Core', style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          _buildItem(context, 'Dashboard', AppRouteNames.dashboard, Icons.dashboard_outlined),

          if (canManageLembaga || canManageStaf) ...[
            const Divider(),
            if (canManageLembaga) _buildItem(context, 'Profil Lembaga', AppRouteNames.profilLembaga, Icons.business_outlined),
            if (canManageStaf) _buildItem(context, 'Guru & Staff', AppRouteNames.staf, Icons.people_alt_outlined),
          ],

          if (canManageAkademik) ...[
            const Divider(),
            if (appContext.hasPermission('academic.program.manage') || appContext.hasPermission('akademik_program_manage'))
              _buildItem(context, 'Program Pendidikan', AppRouteNames.program, Icons.menu_book_outlined),
            if (appContext.hasPermission('academic.curriculum.manage') || appContext.hasPermission('academic.curriculum.read') || appContext.hasPermission('akademik_kurikulum_manage'))
              _buildItem(context, 'Kurikulum & Jenjang', AppRouteNames.kurikulum, Icons.assignment_outlined),
            const Divider(),
            if (appContext.hasPermission('student.manage') || appContext.hasPermission('student.read') || appContext.hasPermission('siswa_manage'))
              _buildItem(context, 'Data Siswa', AppRouteNames.siswa, Icons.people_outline),
            if (appContext.hasPermission('class.manage') || appContext.hasPermission('class.read') || appContext.hasPermission('kelas_manage'))
              _buildItem(context, 'Manajemen Kelas', AppRouteNames.kelas, Icons.meeting_room_outlined),
            // FIX: Mengarahkan ke Hub agar user bisa mengakses Monitoring & Ranking, bukan hanya Input
            if (appContext.hasPermission('tahfidz.write') || appContext.hasPermission('tahfidz.read') || appContext.hasPermission('mutabaah_input') || appContext.hasPermission('mutabaah_view_all'))
              _buildItem(context, 'Mutabaah Tahfidz', AppRouteNames.mutabaahHub, Icons.history_edu_rounded),
            _buildItem(context, 'Mushaf Digital', AppRouteNames.mushafIndex, Icons.menu_book_rounded),
          ],

          if (canManageKeuangan) ...[
            const Divider(),
            // FIX: Menampilkan menu Keuangan yang sebelumnya belum terdaftar
            _buildItem(context, 'Manajemen Keuangan', AppRouteNames.keuanganHub, Icons.payments_outlined),
          ],
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, String title, String route, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => context.go(route),
    );
  }
}
