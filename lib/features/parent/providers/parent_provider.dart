import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../siswa/models/siswa_model.dart';

/// Provider untuk mengambil daftar santri (anak) yang terhubung dengan akun Wali Santri yang sedang login
final parentChildrenProvider = FutureProvider<List<SiswaModel>>((ref) async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;
  if (user == null) return [];

  // Ambil profile ID wali berdasarkan auth ID
  final profileData = await supabase
      .from('profiles')
      .select('id')
      .eq('id', user.id)
      .maybeSingle();

  final profileId = profileData != null ? profileData['id'] : user.id;

  // Query relasi student_guardians join ke tabel siswa
  final response = await supabase
      .from('student_guardians')
      .select('siswa:student_id(*)')
      .eq('parent_id', profileId);

  final List<dynamic> data = response as List<dynamic>;
  final children = data.map((item) {
    final siswaJson = item['siswa'] as Map<String, dynamic>;
    return SiswaModel.fromJson(siswaJson);
  }).toList();

  return children;
});

/// Notifier untuk menyimpan Santri yang sedang dipilih/aktif di Dashboard Wali
class SelectedChildNotifier extends Notifier<SiswaModel?> {
  @override
  SiswaModel? build() => null;

  void selectChild(SiswaModel? child) {
    state = child;
  }
}

/// Provider untuk menyimpan Santri yang sedang dipilih/aktif di Dashboard Wali
final selectedChildProvider = NotifierProvider<SelectedChildNotifier, SiswaModel?>(SelectedChildNotifier.new);