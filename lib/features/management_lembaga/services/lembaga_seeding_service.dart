// Lokasi: lib/features/management_lembaga/services/lembaga_seeding_service.dart

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LembagaSeedingService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Blueprint Data Universal (Golden Seed 8 Divisi Complete)
  static const Map<String, dynamic> goldenSeedTemplate = {
    "divisi": [
      {
        "nama_divisi": "Divisi Pimpinan",
        "deskripsi": "Unsur pimpinan tinggi yayasan dan manajemen sekolah.",
        "status": "aktif",
        "unit_kerja": [
          {
            "nama_unit_kerja": "Unit Kerja Yayasan",
            "kode_unit": "PIM-YYS-001",
            "deskripsi": "Pengawas dan pembina yayasan.",
            "status": "aktif",
            "jabatan": [
              {
                "nama_jabatan": "Ketua Yayasan",
                "default_role": "ADMIN_PUSAT",
                "level_jabatan": 1,
                "catatan_jabatan": "Akses penuh ke seluruh fitur lembaga.",
                "status": "aktif",
                "permissions": [
                  "lembaga_manage", "akademik_program_manage", "akademik_kurikulum_manage",
                  "siswa_manage", "siswa_enroll", "kelas_manage", "mutabaah_input",
                  "mutabaah_view_all", "evaluasi_input", "evaluasi_promote", "sertifikat_generate",
                  "keuangan_payroll_view", "keuangan_spp_manage", "notifikasi_send",
                  "laporan_cetak", "audit_log_view", "backup_manage", "staf_manage",
                  "staf_read", "presensi_input", "presensi_read", "mushaf_view", "sertifikasi_mandiri"
                ]
              },
              {
                "nama_jabatan": "Pembina",
                "default_role": "ADMIN_PUSAT",
                "level_jabatan": 1,
                "catatan_jabatan": "Monitoring executive dashboard dan laporan.",
                "status": "aktif",
                "permissions": ["laporan_cetak", "audit_log_view", "mutabaah_view_all", "presensi_read"]
              },
              {
                "nama_jabatan": "Pengawas",
                "default_role": "ADMIN_PUSAT",
                "level_jabatan": 1,
                "catatan_jabatan": "Pengawas sistem, audit log, dan laporan.",
                "status": "aktif",
                "permissions": ["audit_log_view", "laporan_cetak", "mutabaah_view_all"]
              }
            ]
          },
          {
            "nama_unit_kerja": "Unit Kerja Manajemen",
            "kode_unit": "PIM-MNJ-002",
            "deskripsi": "Pimpinan eksekutif operasional madrasah/sekolah.",
            "status": "aktif",
            "jabatan": [
              {
                "nama_jabatan": "Kepala Sekolah",
                "default_role": "ADMIN_CABANG",
                "level_jabatan": 2,
                "catatan_jabatan": "Pimpinan operasional harian sekolah.",
                "status": "aktif",
                "permissions": [
                  "akademik_program_manage", "akademik_kurikulum_manage", "siswa_manage",
                  "kelas_manage", "mutabaah_view_all", "evaluasi_promote", "sertifikat_generate",
                  "notifikasi_send", "laporan_cetak", "staf_read", "presensi_read"
                ]
              },
              {
                "nama_jabatan": "Wakil Kepala Sekolah",
                "default_role": "ADMIN_CABANG",
                "level_jabatan": 2,
                "catatan_jabatan": "Pendamping pimpinan bidang akademik & kesiswaan.",
                "status": "aktif",
                "permissions": [
                  "akademik_program_manage", "siswa_manage", "kelas_manage",
                  "mutabaah_view_all", "laporan_cetak", "presensi_read"
                ]
              }
            ]
          }
        ]
      },
      {
        "nama_divisi": "Divisi Akademik",
        "deskripsi": "Pengelolaan kurikulum, guru, halaqah, dan evaluasi.",
        "status": "aktif",
        "unit_kerja": [
          {
            "nama_unit_kerja": "Unit Kerja Kurikulum",
            "kode_unit": "AKA-KUR-001",
            "deskripsi": "Pengembangan modul dan blueprint pembelajaran.",
            "status": "aktif",
            "jabatan": [
              {
                "nama_jabatan": "Koordinator Kurikulum",
                "default_role": "STAFF",
                "level_jabatan": 3,
                "catatan_jabatan": "Pengelola blueprint kurikulum dan modul.",
                "status": "aktif",
                "permissions": ["akademik_program_manage", "akademik_kurikulum_manage", "kelas_manage"]
              },
              {
                "nama_jabatan": "Staff Kurikulum",
                "default_role": "STAFF",
                "level_jabatan": 4,
                "catatan_jabatan": "Pelaksana penyusunan program akademik.",
                "status": "aktif",
                "permissions": ["akademik_program_manage", "kelas_manage"]
              }
            ]
          },
          {
            "nama_unit_kerja": "Unit Kerja Guru",
            "kode_unit": "AKA-GRU-002",
            "deskripsi": "Tenaga pengajar dan pembimbing halaqah.",
            "status": "aktif",
            "jabatan": [
              {
                "nama_jabatan": "Guru",
                "default_role": "GURU",
                "level_jabatan": 4,
                "catatan_jabatan": "Pengajar harian dan penginput mutabaah.",
                "status": "aktif",
                "permissions": ["mutabaah_input", "evaluasi_input", "siswa_enroll", "mushaf_view", "presensi_input"]
              },
              {
                "nama_jabatan": "Wali Kelas",
                "default_role": "GURU",
                "level_jabatan": 4,
                "catatan_jabatan": "Penanggung jawab kelas dan rapor santri.",
                "status": "aktif",
                "permissions": ["mutabaah_input", "evaluasi_input", "sertifikat_generate", "laporan_cetak", "presensi_input"]
              },
              {
                "nama_jabatan": "Koordinator Guru",
                "default_role": "GURU",
                "level_jabatan": 3,
                "catatan_jabatan": "Supervisor kinerja mutabaah & guru.",
                "status": "aktif",
                "permissions": ["mutabaah_view_all", "evaluasi_promote", "staf_read", "presensi_read", "laporan_cetak"]
              }
            ]
          },
          {
            "nama_unit_kerja": "Unit Kerja Evaluasi",
            "kode_unit": "AKA-EVL-003",
            "deskripsi": "Pengujian hafalan, tasmi, dan sertifikasi.",
            "status": "aktif",
            "jabatan": [
              {
                "nama_jabatan": "Penguji",
                "default_role": "GURU",
                "level_jabatan": 4,
                "catatan_jabatan": "Penguji tasmi & munaqasyah.",
                "status": "aktif",
                "permissions": ["evaluasi_input", "sertifikat_generate", "sertifikasi_mandiri"]
              },
              {
                "nama_jabatan": "Koordinator Evaluasi",
                "default_role": "GURU",
                "level_jabatan": 3,
                "catatan_jabatan": "Penanggung jawab ujian dan pencatatan kelulusan.",
                "status": "aktif",
                "permissions": ["evaluasi_input", "evaluasi_promote", "sertifikat_generate", "sertifikasi_mandiri", "laporan_cetak"]
              }
            ]
          }
        ]
      },
      {
        "nama_divisi": "Divisi Kesiswaan",
        "deskripsi": "Administrasi santri, penempatan kelas, dan wali.",
        "status": "aktif",
        "unit_kerja": [
          {
            "nama_unit_kerja": "Unit Kerja Administrasi Siswa",
            "kode_unit": "KSI-ADM-001",
            "deskripsi": "Pengelolaan data pokok dan mutasi siswa.",
            "status": "aktif",
            "jabatan": [
              {
                "nama_jabatan": "Staff Kesiswaan",
                "default_role": "STAFF",
                "level_jabatan": 4,
                "catatan_jabatan": "Pengelola data kesiswaan.",
                "status": "aktif",
                "permissions": ["siswa_manage", "siswa_enroll", "kelas_manage"]
              },
              {
                "nama_jabatan": "Operator Siswa",
                "default_role": "STAFF",
                "level_jabatan": 4,
                "catatan_jabatan": "Operator impor/ekspor data santri.",
                "status": "aktif",
                "permissions": ["siswa_manage", "siswa_enroll"]
              }
            ]
          },
          {
            "nama_unit_kerja": "Unit Kerja Wali",
            "kode_unit": "KSI-WAL-002",
            "deskripsi": "Pengelolaan relasi dan data wali murid.",
            "status": "aktif",
            "jabatan": [
              {
                "nama_jabatan": "Staff Wali",
                "default_role": "STAFF",
                "level_jabatan": 4,
                "catatan_jabatan": "Pengelola kontak dan informasi wali.",
                "status": "aktif",
                "permissions": ["siswa_manage", "notifikasi_send"]
              }
            ]
          }
        ]
      },
      {
        "nama_divisi": "Divisi Keuangan",
        "deskripsi": "Pengelolaan SPP, pengeluaran, dan ganjaran staf.",
        "status": "aktif",
        "unit_kerja": [
          {
            "nama_unit_kerja": "Unit Kerja Bendahara",
            "kode_unit": "KEU-BND-001",
            "deskripsi": "Penerimaan kas, SPP, dan pembayaran operasional.",
            "status": "aktif",
            "jabatan": [
              {
                "nama_jabatan": "Bendahara",
                "default_role": "STAFF",
                "level_jabatan": 3,
                "catatan_jabatan": "Penanggung jawab utama keuangan.",
                "status": "aktif",
                "permissions": ["keuangan_spp_manage", "keuangan_payroll_view", "laporan_cetak"]
              },
              {
                "nama_jabatan": "Staff Keuangan",
                "default_role": "STAFF",
                "level_jabatan": 4,
                "catatan_jabatan": "Kasir pembayaran SPP dan transaksi.",
                "status": "aktif",
                "permissions": ["keuangan_spp_manage"]
              }
            ]
          },
          {
            "nama_unit_kerja": "Unit Kerja Payroll",
            "kode_unit": "KEU-PYR-002",
            "deskripsi": "Pengelolaan insentif dan gaji musyrif/staf.",
            "status": "aktif",
            "jabatan": [
              {
                "nama_jabatan": "Staff Payroll",
                "default_role": "STAFF",
                "level_jabatan": 4,
                "catatan_jabatan": "Penyusun rekap jam mengajar dan slip gaji.",
                "status": "aktif",
                "permissions": ["keuangan_payroll_view", "staf_read"]
              }
            ]
          }
        ]
      },
      {
        "nama_divisi": "Divisi PPDB",
        "deskripsi": "Penerimaan Peserta Didik Baru.",
        "status": "aktif",
        "unit_kerja": [
          {
            "nama_unit_kerja": "Unit Kerja PPDB",
            "kode_unit": "PDB-UNT-001",
            "deskripsi": "Panitia pendaftaran dan seleksi santri baru.",
            "status": "aktif",
            "jabatan": [
              {
                "nama_jabatan": "Ketua PPDB",
                "default_role": "STAFF",
                "level_jabatan": 3,
                "catatan_jabatan": "Penanggung jawab penerimaan santri baru.",
                "status": "aktif",
                "permissions": ["siswa_manage", "siswa_enroll", "notifikasi_send", "laporan_cetak"]
              },
              {
                "nama_jabatan": "Staff PPDB",
                "default_role": "STAFF",
                "level_jabatan": 4,
                "catatan_jabatan": "Petugas entri pendaftaran dan verifikasi berkas.",
                "status": "aktif",
                "permissions": ["siswa_manage", "siswa_enroll"]
              }
            ]
          }
        ]
      },
      {
        "nama_divisi": "Divisi Inventaris",
        "deskripsi": "Pengelolaan aset, barang, dan fasilitas lembaga.",
        "status": "aktif",
        "unit_kerja": [
          {
            "nama_unit_kerja": "Unit Kerja Inventaris",
            "kode_unit": "INV-UNT-001",
            "deskripsi": "Pencatatan dan pemeliharaan sarana prasarana.",
            "status": "aktif",
            "jabatan": [
              {
                "nama_jabatan": "Kepala Inventaris",
                "default_role": "STAFF",
                "level_jabatan": 3,
                "catatan_jabatan": "Penanggung jawab aset dan sarpras.",
                "status": "aktif",
                "permissions": ["laporan_cetak", "staf_read"]
              },
              {
                "nama_jabatan": "Staff Inventaris",
                "default_role": "STAFF",
                "level_jabatan": 4,
                "catatan_jabatan": "Petugas logistik dan peminjaman alat.",
                "status": "aktif",
                "permissions": ["staf_read"]
              }
            ]
          }
        ]
      },
      {
        "nama_divisi": "Divisi Administrasi",
        "deskripsi": "Persuratan, kearsipan, dan Tata Usaha umum.",
        "status": "aktif",
        "unit_kerja": [
          {
            "nama_unit_kerja": "Unit Kerja Tata Usaha",
            "kode_unit": "ADM-TU-001",
            "deskripsi": "Pelayanan administrasi umum dan persuratan.",
            "status": "aktif",
            "jabatan": [
              {
                "nama_jabatan": "Kepala TU",
                "default_role": "STAFF",
                "level_jabatan": 3,
                "catatan_jabatan": "Kepala kantor tata usaha.",
                "status": "aktif",
                "permissions": ["siswa_manage", "notifikasi_send", "laporan_cetak", "staf_read"]
              },
              {
                "nama_jabatan": "Staff TU",
                "default_role": "STAFF",
                "level_jabatan": 4,
                "catatan_jabatan": "Petugas administrasi dan kearsipan.",
                "status": "aktif",
                "permissions": ["siswa_manage", "notifikasi_send"]
              }
            ]
          }
        ]
      },
      {
        "nama_divisi": "Divisi Teknologi Informasi",
        "deskripsi": "Pengelolaan akun, backup data, dan infrastruktur IT.",
        "status": "aktif",
        "unit_kerja": [
          {
            "nama_unit_kerja": "Unit Kerja Administrator Sistem",
            "kode_unit": "TI-ADM-001",
            "deskripsi": "Pengawasan keamanan dan manajemen pengguna.",
            "status": "aktif",
            "jabatan": [
              {
                "nama_jabatan": "Administrator Sistem",
                "default_role": "ADMIN_PUSAT",
                "level_jabatan": 2,
                "catatan_jabatan": "Pengelola teknis utama aplikasi dan data.",
                "status": "aktif",
                "permissions": [
                  "lembaga_manage", "staf_manage", "audit_log_view", "backup_manage",
                  "notifikasi_send", "laporan_cetak"
                ]
              },
              {
                "nama_jabatan": "IT Support",
                "default_role": "STAFF",
                "level_jabatan": 4,
                "catatan_jabatan": "Dukungan teknis pengguna dan pemeliharaan rutin.",
                "status": "aktif",
                "permissions": ["audit_log_view", "backup_manage", "staf_read"]
              }
            ]
          }
        ]
      }
    ]
  };

  /// Fungsi untuk mereset seluruh data organisasi lama lalu melakukan seeding ulang
  Future<void> resetAndSeedUniversalOrganization(String lembagaId) async {
    try {
      debugPrint("🧹 Memulai pembersihan (reset) data organisasi lama untuk Lembaga ID: $lembagaId");

      await _supabase.from('job_positions').delete().eq('organization_id', lembagaId);
      await _supabase.from('departments').delete().eq('organization_id', lembagaId);

      debugPrint("✨ Data lama berhasil dibersihkan. Memulai proses seeding baru...");

      await seedUniversalOrganization(lembagaId);

      debugPrint("✅ Reset dan Re-Seed Golden Seed berhasil diselesaikan!");
    } catch (e) {
      debugPrint("❌ Gagal melakukan reset & re-seed: $e");
      rethrow;
    }
  }

  /// Fungsi utama untuk menyuntikkan Golden Seed Data secara berurutan
  Future<void> seedUniversalOrganization(String lembagaId) async {
    try {
      debugPrint("🚀 Memulai proses seeding 8 Divisi untuk Lembaga ID: $lembagaId");

      final List<dynamic> divisiList = goldenSeedTemplate["divisi"] ?? [];

      for (var divData in divisiList) {
        // 1. Insert Divisi (departments)
        final divisiInsert = await _supabase
            .from('departments')
            .insert({
          'organization_id': lembagaId,
          'name': divData['nama_divisi'],
        })
            .select('id')
            .single();

        final String divisiId = divisiInsert['id'];

        final List<dynamic> unitList = divData['unit_kerja'] ?? [];
        for (var unitData in unitList) {
          // 2. Insert Unit Kerja (work_units)
          final unitInsert = await _supabase
              .from('work_units')
              .insert({
            'department_id': divisiId,
            'name': unitData['nama_unit_kerja'],
          })
              .select('id')
              .single();

          final String unitKerjaId = unitInsert['id'];

          final List<dynamic> jabatanList = unitData['jabatan'] ?? [];
          for (var jabData in jabatanList) {
            // 3. Insert Jabatan + Permissions PBAC (job_positions)
            await _supabase.from('job_positions').insert({
              'organization_id': lembagaId,
              'title': jabData['nama_jabatan'],
              'permissions': jabData['permissions'] ?? [],
            });
          }
        }
      }

      debugPrint("✅ Proses seeding 8 Divisi Komplit berhasil diselesaikan.");
    } catch (e) {
      debugPrint("❌ Error saat seeding data: $e");
      rethrow;
    }
  }
}