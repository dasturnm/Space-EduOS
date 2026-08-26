import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/announcement_model.dart';
import '../providers/communication_provider.dart';

class BuatPengumumanScreen extends ConsumerStatefulWidget {
  final String organizationId;

  const BuatPengumumanScreen({
    super.key,
    required this.organizationId,
  });

  @override
  ConsumerState<BuatPengumumanScreen> createState() => _BuatPengumumanScreenState();
}

class _BuatPengumumanScreenState extends ConsumerState<BuatPengumumanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  String _targetRole = 'ALL';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final announcement = AnnouncementModel(
      id: const Uuid().v4(),
      organizationId: widget.organizationId,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      targetRole: _targetRole,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    try {
      await ref.read(communicationServiceProvider).createAnnouncement(announcement);
      ref.invalidate(announcementProvider(widget.organizationId));

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengumuman berhasil diterbitkan')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menerbitkan pengumuman: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Pengumuman Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Pengumuman *',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _targetRole,
                decoration: const InputDecoration(
                  labelText: 'Target Penerima *',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'ALL', child: Text('Semua Pengguna (ALL)')),
                  DropdownMenuItem(value: 'GURU', child: Text('Pengajar / Guru')),
                  DropdownMenuItem(value: 'WALI', child: Text('Wali Santri / Orang Tua')),
                  DropdownMenuItem(value: 'SISWA', child: Text('Santri / Siswa')),
                ],
                onChanged: (val) => setState(() => _targetRole = val ?? 'ALL'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contentController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Isi Pengumuman *',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _submit,
                icon: const Icon(Icons.campaign),
                label: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Siarkan Pengumuman'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}