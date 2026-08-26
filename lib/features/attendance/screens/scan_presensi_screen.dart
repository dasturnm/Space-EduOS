import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/attendance_record_model.dart';
import '../providers/attendance_provider.dart';

class ScanPresensiScreen extends ConsumerStatefulWidget {
  final String studentId;
  final String sessionId;
  final double targetLat; // Koordinat Lintang Lembaga/Pesantren
  final double targetLng; // Koordinat Bujur Lembaga/Pesantren

  const ScanPresensiScreen({
    super.key,
    required this.studentId,
    required this.sessionId,
    this.targetLat = -6.200000, // Default Koordinat
    this.targetLng = 106.816666,
  });

  @override
  ConsumerState<ScanPresensiScreen> createState() => _ScanPresensiScreenState();
}

class _ScanPresensiScreenState extends ConsumerState<ScanPresensiScreen> {
  final _tokenController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();

  String _selectedMethod = 'qr'; // 'qr' atau 'gps'
  bool _isLoading = false;

  @override
  void dispose() {
    _tokenController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  // FR-PRS-002: Proses Submit Presensi dengan Validasi Token QR & GPS Geofencing
  Future<void> _submitCheckIn() async {
    setState(() => _isLoading = true);

    try {
      final attendanceService = ref.read(attendanceServiceProvider);

      if (_selectedMethod == 'qr') {
        final token = _tokenController.text.trim();
        if (token.isEmpty) {
          _showError('Silakan masukkan atau pindaikan token QR');
          return;
        }

        // 1. Validasi Token QR Dinamis (Kadaluarsa > 10 Detik)
        final isValidToken = await attendanceService.validateQrToken(token);
        if (!isValidToken) {
          _showError('Token QR sudah kadaluarsa atau tidak valid! Presensi ditolak.');
          return;
        }
      } else if (_selectedMethod == 'gps') {
        final userLat = double.tryParse(_latController.text.trim());
        final userLng = double.tryParse(_lngController.text.trim());

        if (userLat == null || userLng == null) {
          _showError('Koordinat GPS tidak valid');
          return;
        }

        // 2. Validasi Geofencing Jarak (Maksimal 100 Meter)
        final isWithinRange = attendanceService.isWithinGeofence(
          userLat,
          userLng,
          widget.targetLat,
          widget.targetLng,
          maxDistanceMeters: 100.0,
        );

        if (!isWithinRange) {
          _showError('Lokasi Anda di luar radius 100m dari lokasi lembaga! Presensi ditolak.');
          return;
        }
      }

      // Record Presensi Berhasil Divalidasi
      final record = AttendanceRecordModel(
        id: const Uuid().v4(),
        sessionId: widget.sessionId,
        studentId: widget.studentId,
        status: 'present',
        checkInTime: DateTime.now().toUtc(),
        checkInMethod: _selectedMethod,
        latitude: double.tryParse(_latController.text.trim()),
        longitude: double.tryParse(_lngController.text.trim()),
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      await attendanceService.submitAttendance(record);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Presensi berhasil dicatat!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _showError('Gagal melakukan presensi: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presensi Santri (QR / GPS)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'qr',
                  label: Text('Scan QR Token'),
                  icon: Icon(Icons.qr_code_scanner),
                ),
                ButtonSegment(
                  value: 'gps',
                  label: Text('GPS Geofencing'),
                  icon: Icon(Icons.my_location),
                ),
              ],
              selected: {_selectedMethod},
              onSelectionChanged: (set) {
                setState(() => _selectedMethod = set.first);
              },
            ),
            const SizedBox(height: 20),

            if (_selectedMethod == 'qr') ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(Icons.qr_code_2, size: 80, color: Colors.blue),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _tokenController,
                        decoration: const InputDecoration(
                          labelText: 'Input Token QR (atau dari Scanner)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            'Validasi Lokasi GPS (Maks 100m)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _latController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Latitude Pengguna',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _lngController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Longitude Pengguna',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _submitCheckIn,
              icon: const Icon(Icons.check_circle_outline),
              label: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Kirim Presensi Kehadiran'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}