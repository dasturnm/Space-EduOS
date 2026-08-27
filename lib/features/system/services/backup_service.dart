import 'dart:convert';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/backup_model.dart';

class BackupService {
  final SupabaseClient _supabase;

  BackupService(this._supabase);

  // Enkripsi/Dekripsi Biner XOR Taktis
  Uint8List _encryptDecryptData(Uint8List data, String key) {
    final keyBytes = utf8.encode(key);
    final encrypted = Uint8List(data.length);
    for (int i = 0; i < data.length; i++) {
      encrypted[i] = data[i] ^ keyBytes[i % keyBytes.length];
    }
    return encrypted;
  }

  // Mengambil Riwayat Backup
  Future<List<BackupHistoryModel>> getBackupHistory(String organizationId) async {
    final response = await _supabase
        .from('backup_history')
        .select()
        .eq('organization_id', organizationId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => BackupHistoryModel.fromJson(json))
        .toList();
  }

  // Memicu Backup Data Terenkripsi
  Future<void> triggerBackup({
    required String organizationId,
    required String secretKey,
    required String actorId,
  }) async {
    // 1. Ambil Data Sensitif Utama
    final siswa = await _supabase
        .from('siswa')
        .select()
        .eq('lembaga_id', organizationId);

    final invoices = await _supabase
        .from('invoices')
        .select()
        .eq('organization_id', organizationId);

    final mutabaah = await _supabase
        .from('mutabaah_records')
        .select();

    final Map<String, dynamic> backupPayload = {
      'metadata': {
        'organization_id': organizationId,
        'timestamp': DateTime.now().toIso8601String(),
        'version': '1.0',
      },
      'siswa': siswa,
      'invoices': invoices,
      'mutabaah_records': mutabaah,
    };

    // 2. Serialisasi & Enkripsi Biner
    final jsonString = jsonEncode(backupPayload);
    final rawBytes = Uint8List.fromList(utf8.encode(jsonString));
    final encryptedBytes = _encryptDecryptData(rawBytes, secretKey);

    final String fileName = "backup_${DateTime.now().millisecondsSinceEpoch}.bin";

    // 3. Upload ke Bucket Supabase Storage 'backups'
    await _supabase.storage.from('backups').uploadBinary(
      fileName,
      encryptedBytes,
    );

    final String publicUrl =
    _supabase.storage.from('backups').getPublicUrl(fileName);

    // 4. Catat Log Riwayat Backup
    await _supabase.from('backup_history').insert({
      'organization_id': organizationId,
      'backup_type': 'full',
      'file_url': publicUrl,
      'file_size': encryptedBytes.length,
      'status': 'success',
      'encrypted': true,
      'created_by': actorId,
    });
  }
}