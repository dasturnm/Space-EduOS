import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/sertifikasi_model.dart';

class SertifikasiService {
  final SupabaseClient _supabase;

  SertifikasiService([SupabaseClient? client])
      : _supabase = client ?? Supabase.instance.client;

  Future<List<SertifikasiModel>> fetchCertificates(String organizationId) async {
    final response = await _supabase
        .from('certificates')
        .select()
        .eq('organization_id', organizationId)
        .order('created_at', ascending: false);
    return (response as List).map((json) => SertifikasiModel.fromJson(json)).toList();
  }

  Future<void> generateCertificate(SertifikasiModel certificate) async {
    await _supabase.from('certificates').upsert(certificate.toJson());
  }

  Future<SertifikasiModel?> verifyCertificate(String certificateNumber) async {
    final response = await _supabase
        .from('certificates')
        .select()
        .eq('certificate_number', certificateNumber)
        .maybeSingle();
    if (response == null) return null;
    return SertifikasiModel.fromJson(response);
  }

  Future<String> uploadCertificatePdf({
    required String fileName,
    required Uint8List bytes,
  }) async {
    final path = 'pdfs/$fileName';
    await _supabase.storage.from('certificates').uploadBinary(
      path,
      bytes,
      fileOptions: const FileOptions(
        contentType: 'application/pdf',
        upsert: true,
      ),
    );
    return _supabase.storage.from('certificates').getPublicUrl(path);
  }
}