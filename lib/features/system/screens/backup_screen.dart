import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/backup_model.dart';
import '../services/backup_service.dart';

class BackupScreen extends StatefulWidget {
  final String organizationId;

  const BackupScreen({super.key, required this.organizationId});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  late final BackupService _backupService;
  late Future<List<BackupHistoryModel>> _historyFuture;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _backupService = BackupService(Supabase.instance.client);
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _historyFuture = _backupService.getBackupHistory(widget.organizationId);
    });
  }

  Future<void> _handleBackup() async {
    setState(() => _isProcessing = true);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      await _backupService.triggerBackup(
        organizationId: widget.organizationId,
        secretKey: "SPACE_EDU_SECURE_KEY",
        actorId: user?.id ?? "",
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Backup berhasil dibuat!")),
        );
      }
      _loadHistory();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal melakukan backup: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showRestoreConfirmDialog(BackupHistoryModel backup) {
    final passController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Restore Data"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tindakan ini akan mengembalikan keadaan database. Masukkan Kata Sandi Admin untuk melanjutkan:",
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Sandi Super Admin",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              if (passController.text == "admin123") {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Proses restore berhasil diajukan!")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Sandi Admin Salah!")),
                );
              }
            },
            child: const Text("Restore", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manajemen Backup & Restore"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.security, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Cadangkan Database",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text("Data akan dienkripsi dengan format biner .bin secara aman."),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _isProcessing ? null : _handleBackup,
                      icon: _isProcessing
                          ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Icon(Icons.cloud_upload),
                      label: const Text("Backup Sekarang"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Riwayat Backup Data",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<BackupHistoryModel>>(
                future: _historyFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
                  }
                  final history = snapshot.data ?? [];
                  if (history.isEmpty) {
                    return const Center(child: Text("Belum ada riwayat backup."));
                  }
                  return ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final item = history[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.insert_drive_file, color: Colors.blue),
                          title: Text("${item.backupType.toUpperCase()} BACKUP"),
                          subtitle: Text(
                            "Ukuran: ${(item.fileSize / 1024).toStringAsFixed(2)} KB | ${item.createdAt.toLocal()}",
                          ),
                          trailing: OutlinedButton(
                            onPressed: () => _showRestoreConfirmDialog(item),
                            child: const Text("Restore"),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}