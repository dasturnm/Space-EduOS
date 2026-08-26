import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/attendance_provider.dart';

class QrGeneratorBoard extends ConsumerStatefulWidget {
  final String sessionId;

  const QrGeneratorBoard({
    super.key,
    required this.sessionId,
  });

  @override
  ConsumerState<QrGeneratorBoard> createState() => _QrGeneratorBoardState();
}

class _QrGeneratorBoardState extends ConsumerState<QrGeneratorBoard> {
  Timer? _timer;
  String? _currentToken;
  int _secondsLeft = 10;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _fetchNextToken();
    _startPeriodicRefresh();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // FR-PRS-002: QR Token Dinamis Berubah Otomatis Setiap 10 Detik
  void _startPeriodicRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 1) {
        setState(() => _secondsLeft--);
      } else {
        _fetchNextToken();
      }
    });
  }

  Future<void> _fetchNextToken() async {
    if (_isGenerating) return;
    setState(() {
      _isGenerating = true;
      _secondsLeft = 10;
    });

    try {
      final token = await ref
          .read(attendanceServiceProvider)
          .generateQrToken(widget.sessionId);

      if (mounted) {
        setState(() {
          _currentToken = token;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat token QR: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'BOARD QR DINAMIS PRESENSI',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Minta santri melakukan pemindaian melalui aplikasi mobile.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: Center(
                child: _currentToken == null
                    ? const CircularProgressIndicator()
                    : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code_2, size: 100, color: Colors.black87),
                      const SizedBox(height: 12),
                      SelectableText(
                        _currentToken!,
                        style: const TextStyle(
                          fontSize: 10,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.autorenew, size: 16, color: Colors.orange),
                const SizedBox(width: 6),
                Text(
                  'Kadaluarsa dalam $_secondsLeft detik',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}