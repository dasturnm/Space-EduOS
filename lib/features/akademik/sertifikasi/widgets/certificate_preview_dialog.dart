import 'package:flutter/material.dart';
import '../models/sertifikasi_model.dart';

class CertificatePreviewDialog extends StatelessWidget {
  final SertifikasiModel certificate;

  const CertificatePreviewDialog({
    super.key,
    required this.certificate,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Detail & QR Code Sertifikat'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                certificate.qrCodeData,
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Text('Nomor: ${certificate.certificateNumber}'),
            Text('Status: ${certificate.status.toUpperCase()}'),
            Text('ID Santri: ${certificate.studentId}'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
      ],
    );
  }
}