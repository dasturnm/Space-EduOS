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
      // GROUP 1: PANEL UTAMA (DASHBOARD)
      // ==========================================
      const SidebarGroup(
        title: "Panel Utama",
        items: [
          SidebarItem(
            title: "Admin Dashboard",
            icon: Icons.dashboard,
            route: "/dashboard/admin",
            permission: "organization.read",
          ),
          SidebarItem(
            title: "Dashboard Guru",
            icon: Icons.dashboard_customize,
            route: "/dashboard/guru",
            permission: "tahfidz.write",
          ),
          SidebarItem(
            title: "Portal Wali Santri",
            icon: Icons.family_restroom,
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
            icon: Icons.business,
            route: "/management-lembaga/profile",
            permission: "organization.manage",
          ),
          SidebarItem(
            title: "Manajemen Cabang",
            icon: Icons.account_tree,
            route: "/management-lembaga/cabang",
            permission: "organization.manage",
          ),
          SidebarItem(
            title: "Tahun Ajaran",
            icon: Icons.calendar_today,
            route: "/management-lembaga/tahun-ajaran",
            permission: "organization.manage",
          ),
          SidebarItem(
            title: "Divisi & Unit Kerja",
            icon: Icons.groups,
            route: "/management-lembaga/divisi",
            permission: "organization.manage",
          ),
          SidebarItem(
            title: "Manajemen Jabatan",
            icon: Icons.work,
            route: "/management-lembaga/jabatan",
            permission: "organization.manage",
          ),
        ],
      ),

      // ==========================================
      // GROUP 3: AKADEMIK & KESISWAAN (MINGGU 2)
      // ==========================================
      const SidebarGroup(
        title: "Akademik",
        module: "akademik",
        items: [
          SidebarItem(
            title: "Manajemen Program",
            icon: Icons.book_online,
            route: "/akademik/program",
            permission: "academic.program.manage",
          ),
          SidebarItem(
            title: "Kurikulum & Level",
            icon: Icons.import_contacts,
            route: "/akademik/kurikulum",
            permission: "academic.curriculum.read",
          ),
          SidebarItem(
            title: "Daftar Kelas",
            icon: Icons.class_,
            route: "/kelas",
            permission: "class.read",
          ),
          SidebarItem(
            title: "Daftar Siswa",
            icon: Icons.people,
            route: "/siswa",
            permission: "student.read",
          ),
        ],
      ),

      // ==========================================
      // GROUP 4: KETAHFIDZAN & SETORAN (MINGGU 2 & 3)
      // ==========================================
      const SidebarGroup(
        title: "Ketahfidzan",
        module: "tahfidz",
        items: [
          SidebarItem(
            title: "Input Setoran",
            icon: Icons.draw,
            route: "/mutabaah/input",
            permission: "tahfidz.write",
          ),
          SidebarItem(
            title: "Riwayat Mutaba'ah",
            icon: Icons.history,
            route: "/mutabaah/history",
            permission: "tahfidz.read",
          ),
          SidebarItem(
            title: "Mushaf Al-Qur'an",
            icon: Icons.menu_book,
            route: "/mushaf",
            permission: "tahfidz.read",
          ),
          SidebarItem(
            title: "Pendaftaran Ujian",
            icon: Icons.assignment_turned_in,
            route: "/akademik/evaluasi",
            permission: "tahfidz.assess",
          ),
        ],
      ),

      // ==========================================
      // GROUP 5: PENERIMAAN SISWA (MINGGU 4)
      // ==========================================
      const SidebarGroup(
        title: "Penerimaan Baru",
        module: "admission",
        items: [
          SidebarItem(
            title: "Form Pendaftaran",
            icon: Icons.app_registration,
            route: "/admission/register",
            permission: "admission.view",
          ),
          SidebarItem(
            title: "Verifikasi & Seleksi",
            icon: Icons.admin_panel_settings,
            route: "/admission/dashboard",
            permission: "admission.manage",
          ),
        ],
      ),

      // ==========================================
      // GROUP 6: KEUANGAN & SPP (MINGGU 5)
      // ==========================================
      const SidebarGroup(
        title: "Keuangan SPP",
        module: "finance",
        items: [
          SidebarItem(
            title: "Kelola Tagihan SPP",
            icon: Icons.receipt_long,
            route: "/keuangan/spp",
            permission: "finance.spp.view",
          ),
          SidebarItem(
            title: "Pencatatan Bayar",
            icon: Icons.payment,
            route: "/keuangan/bayar",
            permission: "spp.process",
          ),
          SidebarItem(
            title: "Pengeluaran Sekolah",
            icon: Icons.outbox,
            route: "/keuangan/expense",
            permission: "expense.manage",
          ),
          SidebarItem(
            title: "Laporan Keuangan",
            icon: Icons.analytics,
            route: "/keuangan/report",
            permission: "finance.spp.manage",
          ),
        ],
      ),

      // ==========================================
      // GROUP 7: KEPEGAWAIAN (PAYROLL - MINGGU 3 & 5)
      // ==========================================
      const SidebarGroup(
        title: "SDM & Payroll",
        module: "hr",
        items: [
          SidebarItem(
            title: "Manajemen Staf",
            icon: Icons.badge,
            route: "/guru-staff",
            permission: "student.manage",
          ),
          SidebarItem(
            title: "Payroll Slip Gaji",
            icon: Icons.payments,
            route: "/keuangan/payroll",
            permission: "finance.payroll.view",
          ),
          SidebarItem(
            title: "Absensi Staf",
            icon: Icons.co_present,
            route: "/guru-staff/attendance",
            permission: "attendance.read",
          ),
        ],
      ),
    ];
  }
}