import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/attendance_session_model.dart';
import '../providers/attendance_provider.dart';
import '../widgets/qr_generator_board.dart';

class BuatPresensiScreen extends ConsumerStatefulWidget {
  final String organizationId;

  const BuatPresensiScreen({
    super.key,
    required this.organizationId,
  });

  @override
  ConsumerState<BuatPresensiScreen> createState() => _BuatPresensiScreenState();
}

class _BuatPresensiScreenState extends ConsumerState<BuatPresensiScreen> {
  final _formKey = GlobalKey<FormState>();
  final _classIdController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  AttendanceSessionModel? _createdSession;
  bool _isLoading = false;

  @override
  void dispose() {
    _classIdController.dispose();
    super.dispose();
  }

  Future<void> _createSession() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final session = AttendanceSessionModel(
      id: const Uuid().v4(),
      organizationId: widget.organizationId,
      classId: _classIdController.text.trim(),
      date: _selectedDate,
      createdAt: DateTime.now().toUtc(),
    );

    try {
      final result = await ref
          .read(attendanceServiceProvider)
          .createSession(session);

      if (mounted) {
        setState(() {
          _createdSession = result;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sesi presensi berhasil dibuka')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat sesi presensi: $e')),
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
        title: const Text('Buka Sesi Presensi Kelas'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _classIdController,
                    decoration: const InputDecoration(
                      labelText: 'ID Kelas / Rombel *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                    val == null || val.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    tileColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    title: const Text('Tanggal Presensi'),
                    subtitle: Text(
                      _selectedDate.toLocal().toString().substring(0, 10),
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now().subtract(const Duration(days: 30)),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _createSession,
                    icon: const Icon(Icons.qr_code_scanner),
                    label: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Buat Sesi & Tampilkan Board QR'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ],
              ),
            ),

            if (_createdSession != null) ...[
              const Divider(height: 32),
              QrGeneratorBoard(sessionId: _createdSession!.id),
            ],
          ],
        ),
      ),
    );
  }
}