import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/attendance_record_model.dart';
import '../providers/attendance_provider.dart';

class RekapPresensiScreen extends ConsumerStatefulWidget {
  final String sessionId;

  const RekapPresensiScreen({
    super.key,
    required this.sessionId,
  });

  @override
  ConsumerState<RekapPresensiScreen> createState() => _RekapPresensiScreenState();
}

class _RekapPresensiScreenState extends ConsumerState<RekapPresensiScreen> {
  List<AttendanceRecordModel> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  Future<void> _fetchRecords() async {
    try {
      final records = await ref
          .read(attendanceServiceProvider)
          .fetchRecordsForSession(widget.sessionId);
      if (mounted) {
        setState(() {
          _records = records;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat rekap presensi: $e')),
        );
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'present':
        return Colors.green;
      case 'late':
        return Colors.orange;
      case 'sick':
        return Colors.blue;
      case 'excused':
        return Colors.purple;
      case 'absent':
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekapitulasi Presensi Sesi'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _records.isEmpty
          ? const Center(
        child: Text('Belum ada catatan presensi pada sesi ini.'),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _records.length,
        itemBuilder: (context, index) {
          final record = _records[index];
          final statusColor = _getStatusColor(record.status);

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: statusColor.withOpacity(0.2),
                child: Icon(Icons.person, color: statusColor),
              ),
              title: Text(
                'Santri ID: ${record.studentId ?? record.staffId ?? '-'}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Metode: ${record.checkInMethod.toUpperCase()} | Waktu: ${record.checkInTime?.toLocal().toString().substring(11, 16) ?? '-'}',
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: statusColor),
                ),
                child: Text(
                  record.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}