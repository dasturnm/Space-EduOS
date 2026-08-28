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
      code: 'tenant.manage',
      title: 'Kelola Tenant',
      feature: 'Setup Tenant, Subscription',
      description: 'Mengelola konfigurasi multi-tenant dan langganan.',
      category: 'Kelembagaan & Akses',
    ),
    PermissionItem(
      code: 'organization.manage',
      title: 'Kelola Organisasi',
      feature: 'Profil Lembaga, Satuan Pendidikan, TA',
      description: 'Mengelola profil lembaga, satuan pendidikan, dan tahun ajaran.',
      category: 'Kelembagaan & Akses',
    ),
    PermissionItem(
      code: 'organization.read',
      title: 'Lihat Organisasi',
      feature: 'View profil',
      description: 'Melihat detail profil dan struktur organisasi lembaga.',
      category: 'Kelembagaan & Akses',
    ),
    PermissionItem(
      code: 'lembaga_manage',
      title: 'Profil & Legalitas',
      feature: 'Setup Lembaga, Satuan Pendidikan, TA',
      description: 'Mengelola identitas dasar, profil, visi misi, dan tahun ajaran aktif lembaga.',
      category: 'Kelembagaan & Akses',
    ),
    PermissionItem(
      code: 'staf_manage',
      title: 'Manajemen Staf',
      feature: 'CRUD Staf & Penugasan',
      description: 'Mengelola data staf, SDM, dan penugasan jabatan.',
      category: 'Kelembagaan & Akses',
    ),
    PermissionItem(
      code: 'staf_read',
      title: 'Lihat Data Staf',
      feature: 'Daftar Staf',
      description: 'Melihat daftar data staf dan SDM lembaga.',
      category: 'Kelembagaan & Akses',
    ),
    PermissionItem(
      code: 'audit.view',
      title: 'Lihat Audit Log',
      feature: 'Audit Log Screen',
      description: 'Melihat jejak perubahan data oleh pengguna.',
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
      code: 'backup.manage',
      title: 'Kelola Backup',
      feature: 'Backup/Restore Screen',
      description: 'Melakukan pencadangan dan pemulihan data sistem.',
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
      code: 'academic.program.manage',
      title: 'Kelola Program Pendidikan & Kaldik',
      feature: 'CRUD Program, Agenda',
      description: 'Mengatur jenis program pendidikan dan kalender akademik.',
      category: 'Akademik & Kurikulum',
    ),
    PermissionItem(
      code: 'akademik_program_manage',
      title: 'Program Pendidikan',
      feature: 'CRUD Program, Agenda',
      description: 'Mengatur jenis program pendidikan (seperti Tahfidz/TPQ) dan kalender pendidikan.',
      category: 'Akademik & Kurikulum',
    ),
    PermissionItem(
      code: 'academic.curriculum.manage',
      title: 'Kelola Blueprint Akademik',
      feature: 'CRUD Kurikulum, Jenjang, Jenjang, Modul',
      description: 'Menyusun struktur kurikulum detail dari tingkat dasar hingga unit modul.',
      category: 'Akademik & Kurikulum',
    ),
    PermissionItem(
      code: 'academic.curriculum.read',
      title: 'Lihat Blueprint Akademik',
      feature: 'View kurikulum',
      description: 'Melihat struktur kurikulum, jenjang, jenjang, dan modul.',
      category: 'Akademik & Kurikulum',
    ),
    PermissionItem(
      code: 'akademik_kurikulum_manage',
      title: 'Cetak Biru Akademik',
      feature: 'CRUD Kurikulum, Jenjang, Jenjang, Modul',
      description: 'Menyusun struktur kurikulum detail dari tingkat dasar hingga unit modul terkecil.',
      category: 'Akademik & Kurikulum',
    ),
    PermissionItem(
      code: 'class.manage',
      title: 'Kelola Unit Kelas',
      feature: 'CRUD Kelas, Plotting massal',
      description: 'Mengelola kelas, kapasitas, dan plotting santri.',
      category: 'Akademik & Kurikulum',
    ),
    PermissionItem(
      code: 'class.read',
      title: 'Lihat Kelas',
      feature: 'View kelas',
      description: 'Melihat informasi daftar kelas dan pembagian santri.',
      category: 'Akademik & Kurikulum',
    ),
    PermissionItem(
      code: 'kelas_manage',
      title: 'Manajemen Unit Kelas',
      feature: 'CRUD Kelas, Plotting massal',
      description: 'Mengelola ruang kelas, kapasitas, and pembagian guru wali kelas.',
      category: 'Akademik & Kurikulum',
    ),

    // --- KESISWAAN & PENDAFTARAN ---
    PermissionItem(
      code: 'student.manage',
      title: 'Kelola Data Siswa',
      feature: 'CRUD Siswa, Import/Export',
      description: 'Manajemen profil lengkap santri, impor dan ekspor data.',
      category: 'Kesiswaan & Pendaftaran',
    ),
    PermissionItem(
      code: 'student.enroll',
      title: 'Daftarkan ke Kurikulum',
      feature: 'Enroll Kurikulum, Plotting Kelas',
      description: 'Mendaftarkan santri ke kurikulum dan menempatkan ke kelas.',
      category: 'Kesiswaan & Pendaftaran',
    ),
    PermissionItem(
      code: 'student.read',
      title: 'Lihat Data Siswa',
      feature: 'View siswa',
      description: 'Melihat daftar dan profil detail santri.',
      category: 'Kesiswaan & Pendaftaran',
    ),
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
      code: 'parent.manage',
      title: 'Kelola Data Wali',
      feature: 'CRUD Wali Santri',
      description: 'Mengelola data orang tua/wali santri.',
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
      code: 'admission.view',
      title: 'Lihat Pendaftar',
      feature: 'Dashboard Admission (Read)',
      description: 'Melihat daftar pendaftar santri baru.',
      category: 'Kesiswaan & Pendaftaran',
    ),
    PermissionItem(
      code: 'admission.manage',
      title: 'Kelola Pendaftaran',
      feature: 'Verifikasi, Approve, Enroll',
      description: 'Memproses dan memverifikasi berkas pendaftaran santri baru.',
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
      code: 'attendance.manage',
      title: 'Kelola Presensi',
      feature: 'QR, GPS, Rekap',
      description: 'Mengelola pencatatan dan rekapitulasi kehadiran.',
      category: 'Ketahfidzan & Evaluasi',
    ),
    PermissionItem(
      code: 'attendance.read',
      title: 'Lihat Presensi',
      feature: 'View presensi',
      description: 'Melihat data dan rekap presensi.',
      category: 'Ketahfidzan & Evaluasi',
    ),
    PermissionItem(
      code: 'presensi_input',
      title: 'Input Presensi',
      feature: 'Form Presensi Harian',
      description: 'Mencatat kehadiran harian santri dan staf.',
      category: 'Ketahfidzan & Evaluasi',
    ),
    PermissionItem(
      code: 'presensi_read',
      title: 'Lihat Presensi',
      feature: 'Rekap Presensi',
      description: 'Melihat riwayat dan rekapitulasi presensi.',
      category: 'Ketahfidzan & Evaluasi',
    ),
    PermissionItem(
      code: 'tahfidz.write',
      title: 'Penilaian Mutabaah Harian',
      feature: "Form Mutaba'ah, Monitoring",
      description: 'Mencatat setoran hafalan harian dan perkembangan mutabaah.',
      category: 'Ketahfidzan & Evaluasi',
    ),
    PermissionItem(
      code: 'tahfidz.read',
      title: 'Lihat Riwayat Tahfidz',
      feature: 'Mutabaah Hub, Log Pusat',
      description: 'Melihat seluruh catatan dan log mutabaah hafalan.',
      category: 'Ketahfidzan & Evaluasi',
    ),
    PermissionItem(
      code: 'mutabaah_input',
      title: 'Penilaian Mutabaah Harian',
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
      code: 'tahfidz.assess',
      title: 'Input Nilai Ujian Tahfidz',
      feature: "Form Tasmi'/UKL",
      description: 'Memasukkan nilai dan evaluasi ujian hafalan.',
      category: 'Ketahfidzan & Evaluasi',
    ),
    PermissionItem(
      code: 'evaluasi_input',
      title: 'Input Nilai Ujian',
      feature: "Form Tasmi'/UKL",
      description: "Mengisi rubrik penilaian ujian formal seperti Tasmi' hafalan atau Ujian Kenaikan Jenjang.",
      category: 'Ketahfidzan & Evaluasi',
    ),
    PermissionItem(
      code: 'tahfidz.promote',
      title: 'Kenaikan Kelas Otomatis',
      feature: 'UklEngineService',
      description: 'Otorisasi promosi kenaikan jenjang hafalan santri.',
      category: 'Ketahfidzan & Evaluasi',
    ),
    PermissionItem(
      code: 'evaluasi_promote',
      title: 'Otorisasi Kenaikan',
      feature: 'UklEngineService',
      description: 'Memberikan persetujuan resmi untuk santri naik ke jenjang atau jenjang berikutnya setelah lulus ujian.',
      category: 'Ketahfidzan & Evaluasi',
    ),
    PermissionItem(
      code: 'certificate.generate',
      title: 'Cetak Sertifikat/Ijazah',
      feature: 'Generate PDF & QR',
      description: 'Menerbitkan sertifikat digital dengan verifikasi QR code.',
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
      code: 'finance.payroll.view',
      title: 'Lihat Slip Gaji',
      feature: 'Teacher Payroll Dashboard',
      description: 'Melihat rincian dan riwayat slip gaji staf.',
      category: 'Keuangan & Operasional',
    ),
    PermissionItem(
      code: 'keuangan_payroll_view',
      title: 'Slip Gaji Staf',
      feature: 'Teacher Payroll Dashboard',
      description: 'Melihat rincian gaji, bonus mengajar, dan potongan bagi guru maupun staf terkait.',
      category: 'Keuangan & Operasional',
    ),
    PermissionItem(
      code: 'finance.spp.manage',
      title: 'Kelola SPP & Pengeluaran',
      feature: 'CRUD Tagihan, Laporan',
      description: 'Mengatur seluruh operasional tagihan SPP dan laporan keuangan.',
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
      code: 'finance.spp.view',
      title: 'Lihat Tagihan SPP',
      feature: 'View SPP',
      description: 'Melihat daftar tagihan dan status pembayaran SPP.',
      category: 'Keuangan & Operasional',
    ),
    PermissionItem(
      code: 'spp.generate',
      title: 'Generate Tagihan SPP',
      feature: 'Generate Tagihan Massal',
      description: 'Proses pembuataan tagihan bulanan secara otomatis.',
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
      code: 'spp.process',
      title: 'Proses Pembayaran SPP',
      feature: 'Input Bayar, Upload Bukti',
      description: 'Memproses transaksi dan verifikasi pembayaran SPP.',
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
      code: 'expense.manage',
      title: 'Kelola Pengeluaran',
      feature: 'CRUD Pengeluaran',
      description: 'Mencatat dan mengelola pengeluaran operasional.',
      category: 'Keuangan & Operasional',
    ),
    PermissionItem(
      code: 'pengeluaran_manage',
      title: 'Input Pengeluaran',
      feature: 'CRUD Pengeluaran',
      description: 'Mencatat biaya operasional bulanan lembaga seperti listrik, air, sarpras, dan gaji.',
      category: 'Keuangan & Operasional',
    ),

    // --- LAPORAN & KOMUNIKASI ---
    PermissionItem(
      code: 'communication.send',
      title: 'Kirim Pengumuman Massal',
      feature: 'WA/Email/In-App Blast',
      description: 'Mengirimkan pengumuman blast ke siswa dan wali.',
      category: 'Laporan & Komunikasi',
    ),
    PermissionItem(
      code: 'communication.read',
      title: 'Lihat Pengumuman',
      feature: 'View notifikasi',
      description: 'Melihat riwayat pengumuman dan notifikasi terkirim.',
      category: 'Laporan & Komunikasi',
    ),
    PermissionItem(
      code: 'notifikasi_send',
      title: 'Kirim Pengumuman',
      feature: 'WA/Email/In-App Blast',
      description: 'Mengirimkan pesan atau informasi massal kepada wali santri dan staf melalui berbagai kanal.',
      category: 'Laporan & Komunikasi',
    ),
    PermissionItem(
      code: 'report.print',
      title: 'Cetak Semua Laporan',
      feature: 'PDF, Excel',
      description: 'Menghasilkan ekspor laporan dalam bentuk PDF/Excel.',
      category: 'Laporan & Komunikasi',
    ),
    PermissionItem(
      code: 'laporan_cetak',
      title: 'Cetak Laporan PDF',
      feature: 'PDF, Excel',
      description: 'Menghasilkan dokumen laporan perkembangan belajar santri dalam format siap cetak.',
      category: 'Laporan & Komunikasi',
    ),

    // --- LMS & PEMBELAJARAN DIGITAL ---
    PermissionItem(
      code: 'lms.course.manage',
      title: 'Kelola Pembelajaran LMS',
      feature: 'CRUD Pembelajaran, Module, Lesson',
      description: 'Menyusun dan mengelola materi serta modul kursus digital.',
      category: 'Pembelajaran & Pembelajaran Digital',
    ),
    PermissionItem(
      code: 'lms.assignment.manage',
      title: 'Kelola Tugas',
      feature: 'CRUD Assignment, Submission',
      description: 'Membuat tugas, menerima kiriman tugas, dan memberi penilaian.',
      category: 'Pembelajaran & Pembelajaran Digital',
    ),
    PermissionItem(
      code: 'lms.quiz.manage',
      title: 'Kelola Ujian CBT',
      feature: 'CRUD Quiz, Bank Soal',
      description: 'Mengelola kuis online, ujian CBT, dan bank soal.',
      category: 'Pembelajaran & Pembelajaran Digital',
    ),
    PermissionItem(
      code: 'lms.grade.manage',
      title: 'Kelola Nilai Pembelajaran',
      feature: 'Gradebook, Rapor',
      description: 'Mengolah rekap nilai pembelajaran online dan gradebook.',
      category: 'Pembelajaran & Pembelajaran Digital',
    ),

    // --- KECERDASAN BUATAN (AI) ---
    PermissionItem(
      code: 'ai.use',
      title: 'Gunakan AI',
      feature: 'Generator Soal & Analisis',
      description: 'Menggunakan fitur-fitur pembantu AI dalam aplikasi.',
      category: 'Kecerdasan Buatan (AI)',
    ),
    PermissionItem(
      code: 'ai.manage',
      title: 'Kelola Konfigurasi AI',
      feature: 'Setup Provider AI & Prompt',
      description: 'Mengatur provider, prompt, dan batasan penggunaan AI.',
      category: 'Kecerdasan Buatan (AI)',
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
