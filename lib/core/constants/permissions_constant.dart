// Lokasi: lib/core/constants/permissions_constant.dart

class PermissionItem {
  final String code;
  final String title;
  final String feature;
  final String description;
  final String category;

  const PermissionItem({
    required this.code,
    required this.title,
    required this.feature,
    required this.description,
    required this.category,
  });
}

class PermissionsConstant {
  static const List<PermissionItem> allPermissions = [
    // --- KELEMBAGAAN & AKSES ---
    PermissionItem(
      code: 'lembaga_manage',
      title: 'Profil & Legalitas',
      feature: 'Setup Lembaga, Cabang, TA',
      description: 'Mengelola identitas dasar, profil, visi misi, dan tahun ajaran aktif lembaga.',
      category: 'Kelembagaan & Akses',
    ),
    PermissionItem(
      code: 'audit_log_view',
      title: 'Log Aktivitas',
      feature: 'Audit Log Screen',
      description: 'Melihat riwayat setiap perubahan data yang dilakukan oleh staf untuk keamanan internal.',
      category: 'Kelembagaan & Akses',
    ),
    PermissionItem(
      code: 'backup_manage',
      title: 'Manajemen Backup',
      feature: 'Backup/Restore Screen',
      description: 'Melakukan pencadangan data sistem secara berkala agar data lembaga tetap aman.',
      category: 'Kelembagaan & Akses',
    ),

    // --- AKADEMIK & KURIKULUM ---
    PermissionItem(
      code: 'akademik_program_manage',
      title: 'Manajemen Program',
      feature: 'CRUD Program, Agenda',
      description: 'Mengatur jenis program pendidikan (seperti Tahfidz/TPQ) dan kalender pendidikan.',
      category: 'Akademik & Kurikulum',
    ),
    PermissionItem(
      code: 'akademik_kurikulum_manage',
      title: 'Cetak Biru Akademik',
      feature: 'CRUD Kurikulum, Jenjang, Level, Modul',
      description: 'Menyusun struktur kurikulum detail dari tingkat dasar hingga unit modul terkecil.',
      category: 'Akademik & Kurikulum',
    ),
    PermissionItem(
      code: 'kelas_manage',
      title: 'Manajemen Unit Kelas',
      feature: 'CRUD Kelas, Plotting massal',
      description: 'Mengelola ruang kelas, kapasitas, dan pembagian guru wali kelas.',
      category: 'Akademik & Kurikulum',
    ),

    // --- KESISWAAN & PENDAFTARAN ---
    PermissionItem(
      code: 'siswa_manage',
      title: 'Database Siswa',
      feature: 'CRUD Siswa, Import/Export',
      description: 'Manajemen profil lengkap santri, termasuk fitur ekspor dan impor data massal via CSV.',
      category: 'Kesiswaan & Pendaftaran',
    ),
    PermissionItem(
      code: 'siswa_enroll',
      title: 'Registrasi Kurikulum Siswa',
      feature: 'Enroll Kurikulum, Plotting Kelas',
      description: 'Mendaftarkan santri ke dalam program belajar dan menempatkan mereka ke kelas yang sesuai.',
      category: 'Kesiswaan & Pendaftaran',
    ),
    PermissionItem(
      code: 'wali_manage',
      title: 'Data Orang Tua',
      feature: 'CRUD Wali Santri',
      description: 'Mengelola database orang tua santri dan menghubungkannya dengan data anak mereka.',
      category: 'Kesiswaan & Pendaftaran',
    ),
    PermissionItem(
      code: 'pendaftaran_view',
      title: 'Lihat Pendaftar',
      feature: 'Dashboard Admission (Read)',
      description: 'Melihat daftar calon santri baru yang sudah mendaftar melalui jalur online.',
      category: 'Kesiswaan & Pendaftaran',
    ),
    PermissionItem(
      code: 'pendaftaran_manage',
      title: 'Verifikasi Pendaftaran',
      feature: 'Verifikasi, Approve, Enroll',
      description: 'Memproses berkas pendaftaran, melakukan seleksi, hingga menyetujui calon santri baru.',
      category: 'Kesiswaan & Pendaftaran',
    ),

    // --- KETAHFIDZAN & EVALUASI ---
    PermissionItem(
      code: 'mutabaah_input',
      title: 'Input Mutabaah',
      feature: "Form Mutaba'ah, Monitoring",
      description: "Mencatat setoran hafalan harian (Ziyadah/Murojaah) dan progres santri secara berkala.",
      category: 'Ketahfidzan & Evaluasi',
    ),
    PermissionItem(
      code: 'mutabaah_view_all',
      title: 'Monitoring Mutabaah',
      feature: 'Mutabaah Hub, Log Pusat',
      description: 'Memantau seluruh aktivitas setoran santri di lembaga secara terpusat untuk kebutuhan evaluasi.',
      category: 'Ketahfidzan & Evaluasi',
    ),
    PermissionItem(
      code: 'evaluasi_input',
      title: 'Input Nilai Ujian',
      feature: "Form Tasmi'/UKL",
      description: "Mengisi rubrik penilaian ujian formal seperti Tasmi' hafalan atau Ujian Kenaikan Level.",
      category: 'Ketahfidzan & Evaluasi',
    ),
    PermissionItem(
      code: 'evaluasi_promote',
      title: 'Otorisasi Kenaikan',
      feature: 'UklEngineService',
      description: 'Memberikan persetujuan resmi untuk santri naik ke jenjang atau level berikutnya setelah lulus ujian.',
      category: 'Ketahfidzan & Evaluasi',
    ),
    PermissionItem(
      code: 'sertifikat_generate',
      title: 'Penerbitan Ijazah',
      feature: 'Generate PDF & QR',
      description: 'Mencetak sertifikat digital resmi yang dilengkapi dengan QR Code untuk verifikasi online.',
      category: 'Ketahfidzan & Evaluasi',
    ),

    // --- KEUANGAN & OPERASIONAL ---
    PermissionItem(
      code: 'keuangan_payroll_view',
      title: 'Slip Gaji Staf',
      feature: 'Teacher Payroll Dashboard',
      description: 'Melihat rincian gaji, bonus mengajar, dan potongan bagi guru maupun staf terkait.',
      category: 'Keuangan & Operasional',
    ),
    PermissionItem(
      code: 'keuangan_spp_manage',
      title: 'Dashboard Keuangan',
      feature: 'CRUD Tagihan, Laporan',
      description: 'Memantau ringkasan pendapatan SPP, tunggakan, dan laporan arus kas lembaga.',
      category: 'Keuangan & Operasional',
    ),
    PermissionItem(
      code: 'spp_generate',
      title: 'Tagihan SPP',
      feature: 'Generate Tagihan Massal',
      description: 'Membuat tagihan iuran bulanan untuk seluruh siswa aktif secara otomatis setiap awal bulan.',
      category: 'Keuangan & Operasional',
    ),
    PermissionItem(
      code: 'spp_process',
      title: 'Proses Pembayaran',
      feature: 'Input Bayar, Upload Bukti',
      description: 'Mencatat transaksi pembayaran SPP dan memvalidasi bukti transfer dari wali santri.',
      category: 'Keuangan & Operasional',
    ),
    PermissionItem(
      code: 'pengeluaran_manage',
      title: 'Input Pengeluaran',
      feature: 'CRUD Pengeluaran',
      description: 'Mencatat biaya operasional bulanan lembaga seperti listrik, air, sarpras, dan gaji.',
      category: 'Keuangan & Operasional',
    ),

    // --- LENGKAP & INFORMASI ---
    PermissionItem(
      code: 'notifikasi_send',
      title: 'Kirim Pengumuman',
      feature: 'WA/Email/In-App Blast',
      description: 'Mengirimkan pesan atau informasi massal kepada wali santri dan staf melalui berbagai kanal.',
      category: 'Laporan & Komunikasi',
    ),
    PermissionItem(
      code: 'laporan_cetak',
      title: 'Cetak Laporan PDF',
      feature: 'PDF, Excel',
      description: 'Menghasilkan dokumen laporan perkembangan belajar santri dalam format siap cetak.',
      category: 'Laporan & Komunikasi',
    ),
  ];

  /// Helper untuk mengambil data permission berdasarkan kodenya
  static PermissionItem? getByCode(String code) {
    try {
      return allPermissions.firstWhere((p) => p.code == code);
    } catch (_) {
      return null;
    }
  }

  /// Helper untuk mengelompokkan permission berdasarkan kategori
  static Map<String, List<PermissionItem>> getGroupedPermissions() {
    final Map<String, List<PermissionItem>> grouped = {};
    for (final permission in allPermissions) {
      if (!grouped.containsKey(permission.category)) {
        grouped[permission.category] = [];
      }
      grouped[permission.category]!.add(permission);
    }
    return grouped;
  }
}