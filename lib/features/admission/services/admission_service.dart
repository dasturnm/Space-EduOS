import '../../../core/services/base_service.dart';
import '../models/pendaftaran_model.dart';

class AdmissionService extends BaseService {
  /// 1. READ: Ambil daftar pendaftar berdasarkan organisasi & status
  Future<List<PendaftaranModel>> getPendaftarList(
      String organizationId, {
        String? status,
      }) async {
    try {
      var query = supabase
          .from('pendaftaran_siswa')
          .select()
          .eq('organization_id', organizationId);

      if (status != null && status.isNotEmpty) {
        query = query.eq('status', status);
      }

      final response = await query.order('created_at', ascending: false);
      return (response as List)
          .map((json) => PendaftaranModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception(handleError(e));
    }
  }

  /// 2. UPDATE STATUS: Verifikasi, Setujui, atau Tolak
  Future<void> updateStatus(
      String pendaftaranId,
      String newStatus, {
        String? catatanAdmin,
      }) async {
    try {
      final payload = <String, dynamic>{'status': newStatus};
      if (catatanAdmin != null) payload['catatan_admin'] = catatanAdmin;

      await supabase
          .from('pendaftaran_siswa')
          .update(payload)
          .eq('id', pendaftaranId);
    } catch (e) {
      throw Exception(handleError(e));
    }
  }

  /// 3. ENROLL: Transaksi konversi Pendaftar -> Siswa + Wali + Student Guardians
  Future<String> enrollStudentFromAdmission(PendaftaranModel pendaftar) async {
    try {
      // Step A: Insert ke tabel 'siswa'
      final studentResponse = await supabase
          .from('siswa')
          .insert({
        'lembaga_id': pendaftar.organizationId,
        'nama_lengkap': pendaftar.namaLengkap,
        'nisn': pendaftar.nisn,
        'tempat_lahir': pendaftar.tempatLahir,
        'tanggal_lahir': pendaftar.tanggalLahir?.toIso8601String().split('T')[0],
        'jenis_kelamin': pendaftar.jenisKelamin,
        'alamat': pendaftar.alamat,
        'status': 'AKTIF',
        'academic_state': 'daily',
        'total_juz_hafalan': 0.0,
      })
          .select('id')
          .single();

      final String newStudentId = studentResponse['id'].toString();

      // Step B: Cek atau Insert Wali ke tabel 'profiles' (Role: WALI / wali)
      final existingWali = await supabase
          .from('profiles')
          .select('id')
          .eq('phone', pendaftar.noHpWali)
          .maybeSingle();

      String parentId;
      if (existingWali != null) {
        parentId = existingWali['id'].toString();
      } else {
        final newWali = await supabase
            .from('profiles')
            .insert({
          'fullName': pendaftar.namaWali,
          'phone': pendaftar.noHpWali,
          'role': 'WALI',
          'lembaga_id': pendaftar.organizationId,
          'organization_id': pendaftar.organizationId,
        })
            .select('id')
            .single();
        parentId = newWali['id'].toString();
      }

      // Step C: Buat relasi di 'student_guardians' (Presisi DDL)
      await supabase.from('student_guardians').insert({
        'organization_id': pendaftar.organizationId,
        'parent_id': parentId,
        'student_id': newStudentId,
        'relationship': 'Wali',
        'is_primary': true,
      });

      // Step D: Update status pendaftaran menjadi 'enrolled'
      await updateStatus(pendaftar.id, 'enrolled');

      return newStudentId;
    } catch (e) {
      throw Exception(handleError(e));
    }
  }
}
