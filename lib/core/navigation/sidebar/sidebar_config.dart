// Lokasi: lib/core/navigation/sidebar/sidebar_config.dart

import 'package:flutter/material.dart';

class SidebarItem {
  final String title;
  final IconData icon;
  final String route;
  final String? permission;
  final String? module;

  const SidebarItem({
    required this.title,
    required this.icon,
    required this.route,
    this.permission,
    this.module,
  });
}

class SidebarGroup {
  final String title;
  final List<SidebarItem> items;
  final String? module;

  const SidebarGroup({
    required this.title,
    required this.items,
    this.module,
  });
}

class SidebarConfig {
  static List<SidebarGroup> getGroups() {
    return [
      // ==========================================
      // GROUP 1: PANEL UTAMA
      // ==========================================
      const SidebarGroup(
        title: "Panel Utama",
        items: [
          SidebarItem(
            title: "Admin Dashboard",
            icon: Icons.dashboard_outlined,
            route: "/dashboard/admin",
            permission: "organization.read",
          ),
          SidebarItem(
            title: "Dashboard Guru",
            icon: Icons.dashboard_customize_outlined,
            route: "/dashboard/guru",
            permission: "tahfidz.write",
          ),
          SidebarItem(
            title: "Portal Wali Santri",
            icon: Icons.family_restroom_outlined,
            route: "/dashboard/wali",
            permission: "parent.manage",
            module: "parent",
          ),
        ],
      ),

      // ==========================================
      // GROUP 2: KELEMBAGAAN (MINGGU 1)
      // ==========================================
      const SidebarGroup(
        title: "Kelembagaan",
        items: [
          SidebarItem(
            title: "Profil Lembaga",
            icon: Icons.business_outlined,
            route: "/management-lembaga/profile",
            permission: "organization.manage",
          ),
          SidebarItem(
            title: "Satuan Pendidikan",
            icon: Icons.account_tree_outlined,
            route: "/management-lembaga/cabang",
            permission: "organization.manage",
          ),
          SidebarItem(
            title: "Tahun Ajaran",
            icon: Icons.calendar_today_outlined,
            route: "/management-lembaga/tahun-ajaran",
            permission: "organization.manage",
          ),
          SidebarItem(
            title: "Struktur Organisasi",
            icon: Icons.corporate_fare_outlined,
            route: "/management-lembaga/organisasi",
            permission: "organization.manage",
          ),
        ],
      ),

      // ==========================================
      // GROUP 3: AKADEMIK (MINGGU 2)
      // ==========================================
      const SidebarGroup(
        title: "Akademik",
        module: "akademik",
        items: [
          SidebarItem(
            title: "Program Pendidikan",
            icon: Icons.book_online_outlined,
            route: "/akademik/program",
            permission: "academic.program.manage",
          ),
          SidebarItem(
            title: "Kurikulum & Jenjang",
            icon: Icons.import_contacts_outlined,
            route: "/akademik/kurikulum",
            permission: "academic.curriculum.read",
          ),
          SidebarItem(
            title: "Daftar Kelas",
            icon: Icons.meeting_room_outlined,
            route: "/kelas",
            permission: "class.read",
          ),
          SidebarItem(
            title: "Daftar Siswa",
            icon: Icons.people_outline_outlined,
            route: "/siswa",
            permission: "student.read",
          ),
        ],
      ),

      // ==========================================
      // GROUP 4: KETAHFIDZAN (MINGGU 2 & 3)
      // ==========================================
      const SidebarGroup(
        title: "Ketahfidzan",
        module: "tahfidz",
        items: [
          SidebarItem(
            title: "Penilaian Mutabaah Harian",
            icon: Icons.draw_outlined,
            route: "/mutabaah/input",
            permission: "tahfidz.write",
          ),
          SidebarItem(
            title: "Riwayat Mutaba'ah",
            icon: Icons.history_outlined,
            route: "/mutabaah/history",
            permission: "tahfidz.read",
          ),
          SidebarItem(
            title: "Mushaf Al-Qur'an",
            icon: Icons.menu_book_outlined,
            route: "/mushaf",
            permission: "tahfidz.read",
          ),
          SidebarItem(
            title: "Pendaftaran Ujian",
            icon: Icons.assignment_turned_in_outlined,
            route: "/akademik/evaluasi",
            permission: "tahfidz.assess",
          ),
        ],
      ),

      // ==========================================
      // GROUP 5: PENERIMAAN BARU (MINGGU 4)
      // ==========================================
      const SidebarGroup(
        title: "Penerimaan Baru",
        module: "admission",
        items: [
          SidebarItem(
            title: "Form Pendaftaran",
            icon: Icons.app_registration_outlined,
            route: "/admission/register",
            permission: "admission.view",
          ),
          SidebarItem(
            title: "Verifikasi & Seleksi",
            icon: Icons.admin_panel_settings_outlined,
            route: "/admission/dashboard",
            permission: "admission.manage",
          ),
        ],
      ),

      // ==========================================
      // GROUP 6: KEUANGAN SPP (MINGGU 5)
      // ==========================================
      const SidebarGroup(
        title: "Keuangan SPP",
        module: "finance",
        items: [
          SidebarItem(
            title: "Kelola Tagihan SPP",
            icon: Icons.receipt_long_outlined,
            route: "/keuangan/spp",
            permission: "finance.spp.view",
          ),
          SidebarItem(
            title: "Pencatatan Bayar",
            icon: Icons.payment_outlined,
            route: "/keuangan/bayar",
            permission: "spp.process",
          ),
          SidebarItem(
            title: "Pengeluaran Sekolah",
            icon: Icons.outbox_outlined,
            route: "/keuangan/expense",
            permission: "expense.manage",
          ),
          SidebarItem(
            title: "Laporan Keuangan",
            icon: Icons.analytics_outlined,
            route: "/keuangan/report",
            permission: "finance.spp.manage",
          ),
        ],
      ),

      // ==========================================
      // GROUP 7: SDM & PAYROLL
      // ==========================================
      const SidebarGroup(
        title: "SDM & Payroll",
        module: "hr",
        items: [
          SidebarItem(
            title: "Manajemen Staf",
            icon: Icons.badge_outlined,
            route: "/guru-staff",
            permission: "student.manage",
          ),
          SidebarItem(
            title: "Payroll Slip Gaji",
            icon: Icons.payments_outlined,
            route: "/keuangan/payroll",
            permission: "finance.payroll.view",
          ),
          SidebarItem(
            title: "Absensi Staf",
            icon: Icons.co_present_outlined,
            route: "/guru-staff/attendance",
            permission: "attendance.read",
          ),
        ],
      ),
    ];
  }
}
