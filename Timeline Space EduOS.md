
# 🔍 ANALISIS KODE EKSISTING (TAHFIDZ CORE) vs SDD SPACE EDUO

## ✅ FITUR YANG SUDAH ADA (KODE SIAP PAKAI / TINGGAL POLISHING)

| **Modul** | **Fitur** | **File/Folder** | **Status** |
|-----------|-----------|-----------------|------------|
| **Auth** | Login (Email/Phone + Google), Register Lembaga, Reset Password, Update Password | `features/auth/` | ✅ Selesai |
| **User Profile** | Profil pengguna, edit nama, email, avatar | `user_account_screen.dart` | ✅ Selesai |
| **App Context** | Multi-tenant state (lembaga, cabang, TA, role, permissions) | `core/providers/app_context_provider.dart` | ⚠️ Perlu ditambah `hasPermission()` |
| **Base Service** | CRUD helper, `applyLembagaFilter()`, `cleanData()`, cache | `core/services/base_service.dart` | ✅ Selesai |
| **Lembaga** | CRUD, upload logo, visi, misi | `management_lembaga/` | ✅ Selesai |
| **Cabang** | CRUD | `cabang_list_screen.dart` | ✅ Selesai |
| **Tahun Ajaran** | CRUD, set aktif, saran label otomatis | `tahun_ajaran_screen.dart` | ✅ Selesai |
| **Divisi** | CRUD | `divisi_list_screen.dart` | ✅ Selesai |
| **Unit Kerja** | CRUD (dropdown di form Jabatan) | `unit_kerja_list_screen.dart` | ✅ Selesai |
| **Jabatan** | CRUD dengan permissions (PBAC), level hierarki | `jabatan_list_screen.dart` | ✅ Selesai (tapi masih pakai `role` di UI) |
| **Program** | CRUD, biaya, hari aktif | `program_list_screen.dart` | ✅ Selesai |
| **Kurikulum** | CRUD, Linear/Hierarki, versioning (belum implement) | `kurikulum_screen.dart` | ✅ Selesai (versioning belum) |
| **Jenjang, Level, Modul** | CRUD, silabus mushaf/internal, target metrik, KKM, kebijakan | `akademik/kurikulum/` | ✅ Selesai |
| **Mushaf** | Page view 15 baris, Surah/Juz index, search, offline JSON | `mushaf/` | ⚠️ Scaling UI perlu dipoles |
| **Siswa** | CRUD, Import/Export CSV, Enroll Kurikulum, Plotting | `siswa/` | ✅ Selesai |
| **Kelas** | CRUD, wali kelas, kapasitas, ruangan, waktu | `kelas/` | ✅ Selesai |
| **Mutaba'ah** | Input setoran, multi-modul tab, status switch, debt, proyeksi | `mutabaah/` | ⚠️ Logika akhir modul & transisi perlu dipoles |
| **Evaluasi Ujian** | Form Tasmi/UKL, counter pinalti, weighted average, auto-promosi | `akademik/evaluasi/` | ⚠️ Auto-promosi lintas jenjang perlu dipoles |
| **Staff** | CRUD, Import/Export CSV, Mutasi/Rangkap | `guru_staff/` | ✅ Selesai |
| **Absensi Staff** | Presensi H/I/S/A | `staff_hub_screen.dart` | ✅ Selesai |
| **Payroll** | Pengaturan gaji, slip gaji digital | `keuangan/` | ⚠️ Kalkulasi delegasi perlu dipoles |
| **Delegasi Guru** | Minta bantuan, incoming, revoke | `delegasi_screen.dart` | ✅ Selesai |
| **Dashboard Admin** | Statistik dasar (siswa, guru, SPP) | `dashboard_admin_screen.dart` | ✅ Selesai |
| **Dashboard Guru** | Daftar siswa bimbingan, santri belum setoran | `dashboard_guru_screen.dart` | ✅ Selesai |
| **Dashboard Wali** | Progres hafalan, hutang, murojaah checklist | `dashboard_wali_screen.dart` | ⚠️ Sederhana, perlu integrasi penuh |

---

## ⚠️ FITUR YANG PERLU DI-REFACTOR (DARI KODE LAMA)

| **No** | **Fitur** | **File/Service** | **Refactor yang Harus Dilakukan** | **SDD Referensi** |
|--------|-----------|------------------|-----------------------------------|-------------------|
| **1** | **PBAC Migration** | `sidebar.dart`, `app_drawer.dart`, `main_layout.dart`, `permissions_constant.dart` | Ubah semua `if (role == 'guru')` menjadi `if (hasPermission('mutabaah.write'))`. Buat fungsi `hasPermission()` di `app_context_provider.dart`. | Bab 2.8, BR-PBAC-001 s.d 005 |
| **2** | **Logika Deteksi Akhir Modul** | `layanan_status_modul.dart` → `isContentCompleted()` | Syarat tuntas HARUS: koordinat fisik mencapai target **DAN** `status_keputusan == 1` (Lanjut). | Bab 6.3, BR-TAH-005 |
| **3** | **Transisi Tasmi Mode** | `mutabaah_service.dart` → `_evaluateExamReadiness()` | Ubah status ke `tasmi_mode` **hanya jika** `isExamRequired = true` dan volume tercapai. Jangan masuk `tasmi_mode` jika tidak wajib ujian. | Bab 6.3, BR-TAH-004 |
| **4** | **Auto-Promosi Level & Jenjang** | `ukl_engine_service.dart` → `processPromotion()` | Jika level habis di jenjang, cari jenjang berikutnya → ambil level pertama di jenjang tersebut. Jika tidak ada jenjang berikutnya → status `graduated`. | Bab 6.3, BR-TAH-006 |
| **5** | **Sinkronisasi Murojaah Manzil 4%** | `murojaah_task_service.dart` → `calculateManzilRange()` | Ambil `total_juz_hafalan` dari tabel `siswa` secara **real-time** setiap kali user buka dashboard. | Bab 6.3, BR-TAH-009 |
| **6** | **Kalkulator Payroll (Bonus Delegasi)** | `keuangan_service.dart` → `calculateMonthlyPayroll()` | Bedakan dengan jelas `guru_id` (penginput/pengganti) vs `original_guru_id` (guru tetap) untuk bonus & potongan. | Bab 6.5, BR-HR-002, BR-HR-003 |
| **7** | **UI/UX Mushaf (Scaling & Tema)** | `mushaf_page_view.dart` | Ukuran font nomor ayat (WidgetSpan) harus scaling proporsional mengikuti `dynamicFontSize`. Sinkronkan warna Emerald vs Biru Academic. | Bab 9.2.7 |

---

## ❌ FITUR YANG BELUM ADA SAMA SEKALI (HARUS BUILD DARI NOL)

| **No** | **Fitur** | **SDD Referensi** | **Prioritas** |
|--------|-----------|-------------------|---------------|
| **1** | **Admission (Penerimaan Siswa Baru)** | Bab 4.11, FR-ADM-001 s.d 006 | **P1** |
| **2** | **Manajemen Wali Santri (Student Guardians)** | Bab 4.11, FR-ADM-007 s.d 008 | **P1** |
| **3** | **SPP & Keuangan (Tagihan, Pembayaran, Denda)** | Bab 4.6, FR-FIN-001 s.d 010 | **P1** |
| **4** | **Pengeluaran & Laporan Keuangan** | Bab 4.6, FR-FIN-006 s.d 008 | **P1** |
| **5** | **LMS Core (Course, Module, Lesson, Assignment)** | Bab 4.5, FR-LMS-001 s.d 007 | **P1** |
| **6** | **Ujian CBT (Bank Soal, Quiz, Submit, Score)** | Bab 4.5, FR-LMS-008 s.d 011 | **P1** |
| **7** | **Gradebook & E-Rapor** | Bab 4.5, FR-LMS-012 s.d 014 | **P2** |
| **8** | **Notifikasi & Komunikasi (Pengumuman, Inbox, WA Gateway)** | Bab 4.9, FR-COM-001 s.d 008 | **P2** |
| **9** | **Sertifikat Digital & QR Verifikasi** | Bab 4.10, FR-CER-001 s.d 006 | **P2** |
| **10** | **Presensi Siswa (QR & GPS)** | Bab 4.8, FR-PRS-001 s.d 005 | **P2** |
| **11** | **Backup & Restore** | Bab 4.12, FR-AUD-001 s.d 004 | **P3** |
| **12** | **Audit Log (Full dengan UI)** | Bab 4.12, FR-AUD-005 s.d 007 | **P3** |
| **13** | **Enhanced Analytics (Heatmap, Leaderboard, Tren)** | Bab 4.13, FR-AI-001 s.d 004 | **P3** |

---

# 📅 ROADMAP & TIMELINE DETAIL (MULAI 12 AGUSTUS 2026)

## 🕒 ATURAN WAKTU PENGERJAAN

- **Mulai:** Rabu, **12 Agustus 2026** (malam)
- **Waktu per hari:** **4 jam** (22.00 – 02.00)
- **Hari kerja:** **Senin malam** – **Kamis malam** (4 malam/minggu)
- **Hari libur:** Jumat malam & Minggu malam
- **Total malam kerja:** 4 malam × 9 minggu = **36 malam** (12–13 Agustus s.d 8–9 Oktober 2026)

---

## 🎯 STRATEGI PENGERJAAN

1. **3 Minggu Pertama (12–27 Agustus):** Fokus **100% pada Refactoring (7 Poin P0)**.
2. **3 Minggu Berikutnya (31 Agustus – 17 September):** Bangun **Fitur Baru Prioritas P1** (Admission, Wali, SPP, LMS Core, CBT).
3. **2 Minggu Berikutnya (21 September – 1 Oktober):** Bangun **Fitur Baru P2/P3** (Notifikasi, Sertifikat, Absensi Siswa, Backup, Audit).
4. **1 Minggu Terakhir (5–9 Oktober):** **UAT, Bug Fix & Deploy.**

---

## 📋 TIMELINE PER MALAM (DETAIL & TIDAK AMBIGU)

> **Keterangan:**  
> - Setiap malam = 4 jam kerja (22.00 – 02.00).  
> - Task yang di-*strike* berarti sudah selesai/tidak perlu dikerjakan.  
> - Semua mengacu ke **Master SDD SPACE EDUOS** (Bab yang tertera).

---

### 🔥 MINGGU 1 – REFACTORING: PBAC & UNIT KERJA (12–14 Agustus)

| **Malam** | **Tanggal** | **Task** | **Rincian Teknis** | **SDD Referensi** |
|-----------|-------------|----------|--------------------|-------------------|
| **1** | 12 Agu (Rab) | **PBAC Migration (Part 1)** | 1. Tambahkan fungsi `hasPermission(String permissionCode)` di `app_context_provider.dart`.<br>2. Saat login, agregasi permissions dari semua `penugasan_staf` aktif ke dalam `List<String> grantedPermissions`.<br>3. Simpan hasil agregasi ke `AppContextState`. | Bab 2.8, BR-PBAC-001 s.d 003 |
| **2** | 13 Agu (Kam) | **PBAC Migration (Part 2)** | 1. Refactor `sidebar.dart` – ganti semua `if (role == 'guru')` → `if (hasPermission('tahfidz.write'))`.<br>2. Refactor `app_drawer.dart` dan `main_layout.dart` dengan pola yang sama.<br>3. Hapus semua import `app_roles.dart` yang tidak terpakai. | Bab 2.8, BR-PBAC-004, BR-PBAC-005 |
| **3** | 17 Agu (Sen) | **Verifikasi Unit Kerja & Jabatan** | 1. Pastikan `unit_kerja_id` di `jabatan_model.dart` sudah terisi dari form `jabatan_list_screen.dart`.<br>2. Uji coba: buat Divisi → buat Unit Kerja → buat Jabatan dengan permission.<br>3. Pastikan dropdown Unit Kerja terfilter berdasarkan Divisi yang dipilih. | Bab 7.1.6, Bab 7.1.7 |

---

### 🧠 MINGGU 2 – REFACTORING: MESIN AKADEMIK TAHFIDZ (18–21 Agustus)

| **Malam** | **Tanggal** | **Task** | **Rincian Teknis** | **SDD Referensi** |
|-----------|-------------|----------|--------------------|-------------------|
| **4** | 18 Agu (Sel) | **Fix Deteksi Akhir Modul** | 1. Buka `layanan_status_modul.dart`.<br>2. Update `isContentCompleted()`: syarat tuntas = koordinat fisik (surah/ayah) mencapai target **AND** `status_keputusan == 1` (Lanjut).<br>3. Jika `status_keputusan == -1` (Ulang) → `return false` (tidak tuntas). | Bab 6.3, BR-TAH-005 |
| **5** | 19 Agu (Rab) | **Fix Transisi Tasmi Mode** | 1. Buka `mutabaah_service.dart` → `_evaluateExamReadiness()`.<br>2. Ubah logic: `tasmi_mode` hanya diaktifkan jika `isExamRequired = true` DAN volume tercapai.<br>3. Jika `isExamRequired = false` → langsung promosi tanpa `tasmi_mode`. | Bab 6.3, BR-TAH-004 |
| **6** | 20 Agu (Kam) | **Fix Auto-Promosi Lintas Jenjang** | 1. Buka `ukl_engine_service.dart` → `processPromotion()`.<br>2. Jika level saat ini adalah level terakhir di jenjang → cari jenjang berikutnya (berdasarkan `kurikulum_id` + `urutan`).<br>3. Ambil level pertama di jenjang berikutnya → set sebagai `level_id` siswa.<br>4. Jika tidak ada jenjang berikutnya → status siswa = `graduated`. | Bab 6.3, BR-TAH-006 |

---

### 🎨 MINGGU 3 – REFACTORING: MANZIL, PAYROLL & UI MUSHAF (24–27 Agustus)

| **Malam** | **Tanggal** | **Task** | **Rincian Teknis** | **SDD Referensi** |
|-----------|-------------|----------|--------------------|-------------------|
| **7** | 24 Agu (Sen) | **Sinkronisasi Murojaah Manzil** | 1. Buka `murojaah_task_service.dart` → `calculateManzilRange()`.<br>2. Ambil `total_juz_hafalan` dari tabel `siswa` secara real-time (jangan pakai cache/stale data).<br>3. Hitung target 4% (atau sesuai `manzilAmount`). | Bab 6.3, BR-TAH-009 |
| **8** | 25 Agu (Sel) | **Fix Kalkulator Payroll (Delegasi)** | 1. Buka `keuangan_service.dart` → `calculateMonthlyPayroll()`.<br>2. Bedakan `guru_id` (penginput = pengganti) vs `original_guru_id` (guru tetap).<br>3. Bonus delegasi dihitung dari `guru_id != original_guru_id`.<br>4. Potongan dihitung dari `original_guru_id` yang memiliki delegasi keluar. | Bab 6.5, BR-HR-002, BR-HR-003 |
| **9** | 26 Agu (Rab) | **Polishing UI/UX Mushaf (Scaling)** | 1. Buka `mushaf_page_view.dart`.<br>2. Perbaiki `WidgetSpan` untuk nomor ayat: ukuran font = `dynamicFontSize * 0.7` (proporsional).<br>3. Pastikan nomor ayat tetap di dalam lingkaran hijau yang ikut membesar. | Bab 9.2.7 |
| **10** | 27 Agu (Kam) | **Testing Skenario A (Akademik)** | 1. Jalankan flow end-to-end:<br>   - Buat siswa → Enroll Kurikulum → Input setoran (Ulang/Lanjut) → Target tercapai → Tasmi Mode → Exam Ready → UKL Lulus → Naik Level/Jenjang.<br>2. Catat bug, perbaiki. | Bab 8.2, Bab 8.3 |

---

### 📚 MINGGU 4 – FITUR BARU P1: ADMISSION & WALI SANTRI (31 Agustus – 3 September)

| **Malam** | **Tanggal** | **Task** | **Rincian Teknis** | **SDD Referensi** |
|-----------|-------------|----------|--------------------|-------------------|
| **11** | 31 Agu (Sen) | **Build Admission (Model & Public Form)** | 1. Buat model `pendaftaran_siswa` (sesuai Data Dictionary).<br>2. Buat model `wali_santri`.<br>3. Buat screen public: `PendaftaranOnlineScreen` (Step 1-4).<br>4. Validasi: nama, tgl lahir, no HP, upload dokumen (Akte, KK, Foto). | Bab 4.11, FR-ADM-001, Bab 7 |
| **12** | 1 Sep (Sel) | **Build Admission (Admin Verifikasi)** | 1. Buat screen `AdmissionDashboardScreen`.<br>2. Tampilkan daftar pendaftar dengan status `registrasi`.<br>3. Tombol "Verifikasi" → ubah status ke `verifikasi`.<br>4. Tombol "Setujui" → ubah status ke `approval`, kirim notifikasi ke wali. | Bab 4.11, FR-ADM-003, FR-ADM-004 |
| **13** | 2 Sep (Rab) | **Build Admission (Enroll)** | 1. Tombol "Enroll" di Admin Dashboard.<br>2. Otomatis buat data di tabel `students` (copy dari pendaftaran).<br>3. Otomatis buat data di tabel `student_guardians` (relasi wali-siswa).<br>4. Panggil `EnrollKurikulumDialog` (seperti yang sudah ada di kode).<br>5. Update status pendaftaran → `enrolled`. | Bab 4.11, FR-ADM-006 |
| **14** | 3 Sep (Kam) | **Build Manajemen Wali & Dashboard Wali** | 1. Buat CRUD Wali di Admin (`WaliListScreen`).<br>2. Tampilkan daftar anak per wali.<br>3. Buat `DashboardWaliScreen` (lengkap):<br>   - Progres hafalan (grafik).<br>   - Setoran terakhir.<br>   - Hutang banner.<br>   - Tombol "Hubungi Guru" (template WA). | Bab 4.11, FR-ADM-007, FR-ADM-008 |

---

### 💰 MINGGU 5 – FITUR BARU P1: SPP & KEUANGAN (7–10 September)

| **Malam** | **Tanggal** | **Task** | **Rincian Teknis** | **SDD Referensi** |
|-----------|-------------|----------|--------------------|-------------------|
| **15** | 7 Sep (Sen) | **Build SPP (Tagihan & Generate)** | 1. Buat model `fee_types` dan `invoices`.<br>2. Buat logic `generateInvoices()`: trigger tanggal 1 (atau manual).<br>3. Generate untuk semua siswa aktif → insert ke `invoices` dengan status `issued`.<br>4. Buat screen `SppListScreen` dengan filter status. | Bab 4.6, FR-FIN-001, FR-FIN-002, FR-FIN-003 |
| **16** | 8 Sep (Sel) | **Build SPP (Pembayaran)** | 1. Buat modal `PaymentModal` (nominal, metode, upload bukti).<br>2. Hitung denda otomatis jika `payment_date > due_date` (10% dari total).<br>3. Update `invoices.outstanding` dan status (`paid`/`partial`).<br>4. Insert ke `payments`. | Bab 4.6, FR-FIN-004, FR-FIN-005, BR-FIN-002 |
| **17** | 9 Sep (Rab) | **Build Pengeluaran & Laporan** | 1. Buat model `expenses`.<br>2. Buat screen `ExpenseListScreen` (CRUD, kategori, nominal, bukti).<br>3. Buat screen `FinanceReportScreen`: grafik pendapatan vs pengeluaran (Bar Chart), total saldo, export PDF/Excel. | Bab 4.6, FR-FIN-006, FR-FIN-007, FR-FIN-008 |
| **18** | 10 Sep (Kam) | **Integrasi Notifikasi Tagihan** | 1. Sambungkan SPP dengan Notifikasi:<br>   - H-7 jatuh tempo → kirim WA/Email.<br>   - H-1 jatuh tempo → kirim WA/Email reminder.<br>2. Gunakan template pesan. | Bab 4.9, BR-FIN-001, BR-FIN-002 |

---

### 📜 MINGGU 6 – FITUR BARU P1: LMS CORE & CBT (14–17 September)

| **Malam** | **Tanggal** | **Task** | **Rincian Teknis** | **SDD Referensi** |
|-----------|-------------|----------|--------------------|-------------------|
| **19** | 14 Sep (Sen) | **Build LMS Core (Course, Module, Lesson)** | 1. Buat model `courses`, `course_modules`, `course_lessons`.<br>2. Buat CRUD screen: `CourseListScreen`, `CourseFormScreen`, `ModuleFormScreen`, `LessonFormScreen`.<br>3. Relasi: Course → Subject → Class → Term → Teacher. | Bab 4.5, FR-LMS-001, FR-LMS-002, FR-LMS-003 |
| **20** | 15 Sep (Sel) | **Build Assignment & Submission** | 1. Buat model `assignments` dan `assignment_submissions`.<br>2. Buat screen `AssignmentListScreen`, `AssignmentFormScreen` (due_date, max_score).<br>3. Screen `SubmitAssignmentScreen` (upload file).<br>4. Screen `GradeAssignmentScreen` (input score, feedback). | Bab 4.5, FR-LMS-005, FR-LMS-006, FR-LMS-007 |
| **21** | 16 Sep (Rab) | **Build Bank Soal & Ujian CBT (Part 1)** | 1. Buat model `question_banks`, `questions` (PG, Essay, Isian).<br>2. Buat screen `BankSoalScreen`, `QuestionFormScreen`.<br>3. Buat model `quizzes` dan `quiz_questions`.<br>4. Buat screen `QuizFormScreen` (pilih soal, atur durasi, jadwal). | Bab 4.5, FR-LMS-008, FR-LMS-009 |
| **22** | 17 Sep (Kam) | **Build Ujian CBT (Part 2 - Siswa)** | 1. Buat screen `QuizAttemptScreen` (timer, soal per halaman, navigasi).<br>2. Logic: start quiz → insert `quiz_attempts` → jawaban disimpan lokal → submit → hitung score (PG otomatis, Essay manual).<br>3. Tampilkan hasil ujian. | Bab 4.5, FR-LMS-010, FR-LMS-011 |

---

### 💬 MINGGU 7 – FITUR BARU P2: SERTIFIKAT, E-RAPOR, NOTIFIKASI (21–24 September)

| **Malam** | **Tanggal** | **Task** | **Rincian Teknis** | **SDD Referensi** |
|-----------|-------------|----------|--------------------|-------------------|
| **23** | 21 Sep (Sen) | **Build Sertifikat (QR & PDF)** | 1. Buat model `certificates`.<br>2. Generate nomor unik `TSM-YYYYMMDD-XXXX`.<br>3. Generate QR Code (data terenkripsi + URL verifikasi).<br>4. Generate PDF sertifikat (gunakan template).<br>5. Tombol "Generate" di halaman hasil ujian (jika lulus). | Bab 4.10, FR-CER-001, FR-CER-002, FR-CER-003 |
| **24** | 22 Sep (Sel) | **Build Verifikasi Online & E-Rapor** | 1. Buat public page `/verify/{nomor}` → tampilkan data sertifikat (status valid/revoked).<br>2. Buat engine E-Rapor: agregasi nilai Tahfidz + Akademik + LMS.<br>3. Buat screen `RaporScreen`: grafik progres, nilai per semester, tombol cetak PDF. | Bab 4.10, FR-CER-005, Bab 4.5, FR-LMS-012 |
| **25** | 23 Sep (Rab) | **Build Notifikasi & Pengumuman** | 1. Buat model `announcements`, `notifications`, `notification_reads`.<br>2. Buat screen `BuatPengumumanScreen` (judul, konten, target role/user, channel in-app/WA).<br>3. Logic kirim: insert announcements → insert notifications per target → panggil WA Gateway (jika aktif).<br>4. Buat screen `InboxScreen` (list, badge merah, mark as read). | Bab 4.9, FR-COM-001, FR-COM-002, FR-COM-003, FR-COM-005, FR-COM-006 |
| **26** | 24 Sep (Kam) | **Build Absensi Siswa (QR/GPS)** | 1. Buat model `attendance_sessions`, `attendance_records`, `attendance_qr_tokens`.<br>2. Buat screen `BuatPresensiScreen` (generate QR token).<br>3. Screen `ScanPresensiScreen` (scan QR → check-in).<br>4. Logic GPS: validasi lokasi (jika diaktifkan).<br>5. Screen `RekapPresensiScreen` (per kelas, per bulan, export PDF). | Bab 4.8, FR-PRS-001 s.d 005 |

---

### 🔒 MINGGU 8 – FITUR BARU P3: BACKUP, AUDIT, ANALYTICS (28 September – 1 Oktober)

| **Malam** | **Tanggal** | **Task** | **Rincian Teknis** | **SDD Referensi** |
|-----------|-------------|----------|--------------------|-------------------|
| **27** | 28 Sep (Sen) | **Build Backup & Restore** | 1. Buat model `backup_history`.<br>2. Buat logic `createBackup()`: dump data, encrypt, upload ke storage.<br>3. Buat screen `BackupScreen`: tombol Backup Manual, Riwayat Backup, tombol Restore (dengan dialog password admin).<br>4. Cron untuk backup otomatis pukul 02.00 (gunakan Edge Function atau cron job). | Bab 4.12, FR-AUD-001 s.d 004 |
| **28** | 29 Sep (Sel) | **Build Audit Log** | 1. Buat model `audit_logs`.<br>2. Buat middleware/trigger untuk mencatat setiap operasi INSERT/UPDATE/DELETE ke tabel penting.<br>3. Buat screen `AuditLogScreen`: filter tanggal, user, tabel, aksi, export Excel/PDF. | Bab 4.12, FR-AUD-005 s.d 007 |
| **29** | 30 Sep (Rab) | **Build Enhanced Analytics** | 1. Buat query agregasi untuk grafik:<br>   - Tren siswa (Line chart per bulan).<br>   - Distribusi program (Pie chart).<br>   - Heatmap aktivitas setoran (hari vs jam).<br>   - Leaderboard hafalan (top 10 siswa).<br>2. Buat screen `AnalyticsDashboardScreen` dengan widget grafik (syncfusion_flutter_charts atau fl_chart). | Bab 4.13, FR-AI-001 s.d 004 |
| **30** | 1 Okt (Kam) | **Integrasi AI Assistant (Preview)** | 1. Buat model `ai_conversations`, `ai_messages`.<br>2. Buat screen `AIAssistantScreen` (chat UI sederhana).<br>3. Integrasi ke API AI (OpenAI atau Gemini) untuk generate soal / analisis progres. **Catatan:** Ini hanya preview, full implementasi bisa di fase berikutnya. | Bab 4.13, FR-AI-001 s.d 004 |

---

### 🚀 MINGGU 9 – UAT, BUG FIX, DEPLOY (5–8 Oktober)

| **Malam** | **Tanggal** | **Task** | **Rincian Teknis** | **SDD Referensi** |
|-----------|-------------|----------|--------------------|-------------------|
| **31** | 5 Okt (Sen) | **UAT Skenario A (Academic Flow)** | 1. Jalankan flow:<br>   - Admin: Setup Lembaga → Buat Program → Buat Kurikulum → Buat Level → Buat Modul → Tambah Siswa → Enroll.<br>   - Guru: Input Setoran → Ujian → Sertifikat.<br>2. Catat bug. | Bab 8.2, Bab 8.3, Bab 8.8 |
| **32** | 6 Okt (Sel) | **UAT Skenario B (Finance Flow)** | 1. Jalankan flow:<br>   - Admin: Generate Tagihan SPP → Catat Pembayaran → Lihat Laporan Keuangan.<br>   - Wali: Login → Lihat Dashboard Anak → Bayar SPP.<br>2. Catat bug. | Bab 8.4, Bab 8.5, Bab 9.2.9 |
| **33** | 7 Okt (Rab) | **Bug Fixing & Optimasi** | 1. Perbaiki semua bug yang ditemukan.<br>2. Optimasi query: tambahkan indeks yang hilang.<br>3. Optimasi UI: loading state, empty state, error handling. | - |
| **34** | 8 Okt (Kam) | **Deploy ke Staging & Production** | 1. Deploy ke server staging.<br>2. Jalankan smoke test (login, dashboard, input setoran, pembayaran).<br>3. Deploy ke production.<br>4. Monitoring 24 jam. | - |

---

## 📊 REKAP TOTAL MALAM & TANGGAL

| **Minggu** | **Malam** | **Tanggal** | **Fokus** |
|------------|-----------|-------------|-----------|
| 1 | 1–3 | 12–17 Agu | PBAC & Unit Kerja |
| 2 | 4–6 | 18–21 Agu | Mesin Akademik |
| 3 | 7–10 | 24–27 Agu | Manzil, Payroll, Mushaf UI |
| 4 | 11–14 | 31–3 Sep | Admission & Wali |
| 5 | 15–18 | 7–10 Sep | SPP & Keuangan |
| 6 | 19–22 | 14–17 Sep | LMS Core & CBT |
| 7 | 23–26 | 21–24 Sep | Sertifikat, E-Rapor, Notifikasi |
| 8 | 27–30 | 28–1 Okt | Backup, Audit, Analytics |
| 9 | 31–34 | 5–8 Okt | UAT, Bug Fix, Deploy |

**Total malam kerja:** 34 malam  
**Estimasi selesai:** **Kamis, 8 Oktober 2026** (pukul 02.00)

---

## ✅ KESIMPULAN

- **SDD sudah lengkap** dan siap pakai.
- **Refactoring (7 Poin P0)** menjadi prioritas utama di 3 minggu pertama.
- **Fitur baru (P1)** dimulai minggu ke-4 (Admission, Wali, SPP, LMS, CBT).
- **Fitur pendukung (P2/P3)** dimulai minggu ke-7 (Sertifikat, Notifikasi, Absensi Siswa, Backup, Audit, Analytics).
- **UAT & Deploy** di minggu ke-9.

**Saya siap memulai pengerjaan malam ini, 12 Agustus 2026, pukul 22.00! 🚀**