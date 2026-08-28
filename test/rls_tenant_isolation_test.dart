import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  late SupabaseClient client;

  setUpAll(() async {
    client = SupabaseClient('https://your-project.supabase.co', 'YOUR_ANON_KEY');
  });

  test('Verifikasi RLS: Staf Lembaga A dilarang membaca data siswa Lembaga B', () async {
    // 1. Autentikasi sebagai User Staf Lembaga A
    await client.auth.signInWithPassword(
      email: 'staf.lembagaA@eduos.id',
      password: 'PasswordSecure123!',
    );

    final currentProfile = await client.from('profiles').select('lembaga_id').single();
    final userLembagaId = currentProfile['lembaga_id'];

    // 2. Query tabel target shadow 'students'
    final List<dynamic> studentsData = await client
        .from('students')
        .select('id, organization_id, full_name');

    // 3. Pastikan tidak ada satupun record milik lembaga lain yang lolos
    final hasForeignTenantData = studentsData.any(
          (student) => student['organization_id'] != userLembagaId,
    );

    expect(
      hasForeignTenantData,
      isFalse,
      reason: 'Bocor RLS: Ditemukan data siswa milik lembaga lain dalam kueri!',
    );
  });
}