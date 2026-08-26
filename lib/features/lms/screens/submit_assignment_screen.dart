import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/assignment_model.dart';
import '../providers/course_provider.dart';

class SubmitAssignmentScreen extends ConsumerStatefulWidget {
  final AssignmentModel assignment;
  final String studentId;

  const SubmitAssignmentScreen({
    super.key,
    required this.assignment,
    required this.studentId,
  });

  @override
  ConsumerState<SubmitAssignmentScreen> createState() => _SubmitAssignmentScreenState();
}

class _SubmitAssignmentScreenState extends ConsumerState<SubmitAssignmentScreen> {
  Uint8List? _selectedFileBytes;
  String? _selectedFileName;
  bool _isLoading = false;

  // Aturan BR-LMS-001: Evaluasi batas waktu
  bool get _isExpired => DateTime.now().isAfter(widget.assignment.dueDate);

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png', 'zip'],
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      final file = result.files.single;

      // Validation: Maximum file size 5MB (5 * 1024 * 1024 bytes)
      if (file.size > 5 * 1024 * 1024) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ukuran berkas melebihi batas maksimum 5MB'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      setState(() {
        _selectedFileBytes = file.bytes;
        _selectedFileName = file.name;
      });
    }
  }

  Future<void> _submitAssignment() async {
    if (_selectedFileBytes == null || _selectedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih berkas tugas terlebih dahulu')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final lmsService = ref.read(lmsServiceProvider);

      // 1. Upload biner ke Supabase Storage
      final fileUrl = await lmsService.uploadAssignmentFile(
        fileName: '${widget.studentId}_${DateTime.now().millisecondsSinceEpoch}_$_selectedFileName',
        bytes: _selectedFileBytes!,
      );

      // 2. Simpan record submission
      final submission = SubmissionModel(
        id: const Uuid().v4(),
        assignmentId: widget.assignment.id,
        studentId: widget.studentId,
        fileUrl: fileUrl,
        submittedAt: DateTime.now().toUtc(),
        status: 'submitted',
      );

      await lmsService.submitAssignment(submission);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tugas berhasil dikumpulkan')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengumpulkan tugas: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kumpul Tugas: ${widget.assignment.title}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.assignment.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(widget.assignment.description ?? 'Tidak ada instruksi khusus.'),
            const SizedBox(height: 12),
            Text(
              'Batas Waktu: ${widget.assignment.dueDate.toLocal().toString().substring(0, 16)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 32),

            // Kepatuhan BR-LMS-001: Peringatan Merah jika Melewati Batas Waktu
            if (_isExpired) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Melewati batas waktu',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Pengumpulan tugas ini telah ditutup.'),
            ] else ...[
              OutlinedButton.icon(
                onPressed: _isLoading ? null : _pickFile,
                icon: const Icon(Icons.attach_file),
                label: Text(_selectedFileName ?? 'Pilih Berkas Tugas (Maks 5MB)'),
              ),
              if (_selectedFileName != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Terpilih: $_selectedFileName',
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitAssignment,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Kirim Tugas'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}