import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/sertifikasi_model.dart';
import '../providers/sertifikasi_provider.dart';
import '../widgets/certificate_preview_dialog.dart';

class CertificateScreen extends ConsumerStatefulWidget {
  final String organizationId;

  const CertificateScreen({
    super.key,
    required this.organizationId,
  });

  @override
  ConsumerState<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends ConsumerState<CertificateScreen> {
  final _studentIdController = TextEditingController();
  String _certType = 'ukl';
  bool _isGenerating = false;

  @override
  void dispose() {
    _studentIdController.dispose();
    super.dispose();
  }

  // Aturan BR-CER-002: Format Nomor Unik Sertifikat
  String _generateCertificateNumber() {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month.toString().padLeft(2, '0');
    final shortUuid = const Uuid().v4().substring(0, 4).toUpperCase();
    return 'TSM-$year$month-$shortUuid';
  }

  Future<void> _issueCertificate() async {
    final studentId = _studentIdController.text.trim();
    if (studentId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID Santri wajib diisi')),
      );
      return;
    }

    setState(() => _isGenerating = true);

    final certNumber = _generateCertificateNumber();
    // Aturan BR-CER-003: QR Code berisi URL verifikasi publik
    final qrData = 'https://spaceeduos.com/verify/$certNumber';

    final cert = SertifikasiModel(
      id: const Uuid().v4(),
      organizationId: widget.organizationId,
      studentId: studentId,
      type: _certType,
      certificateNumber: certNumber,
      qrCodeData: qrData,
      status: 'published',
      issuedDate: DateTime.now(),
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    try {
      await ref.read(sertifikasiServiceProvider).generateCertificate(cert);
      ref.invalidate(certificateProvider(widget.organizationId));
      if (mounted) {
        _studentIdController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sertifikat $certNumber berhasil diterbitkan')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menerbitkan sertifikat: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final certsAsync = ref.watch(certificateProvider(widget.organizationId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Sertifikat Kelulusan'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Terbitkan Sertifikat Baru',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _studentIdController,
                      decoration: const InputDecoration(
                        labelText: 'ID Santri / Siswa *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _certType,
                      decoration: const InputDecoration(
                        labelText: 'Jenis Sertifikat',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'tasmi', child: Text('Sertifikat Tasmi\'')),
                        DropdownMenuItem(value: 'ukl', child: Text('Sertifikat UKL')),
                        DropdownMenuItem(value: 'program', child: Text('Sertifikat Kelulusan Program')),
                      ],
                      onChanged: (val) => setState(() => _certType = val ?? 'ukl'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _isGenerating ? null : _issueCertificate,
                      icon: const Icon(Icons.verified),
                      label: _isGenerating
                          ? const CircularProgressIndicator()
                          : const Text('Terbitkan Sertifikat'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: certsAsync.when(
              data: (certificates) {
                if (certificates.isEmpty) {
                  return const Center(
                    child: Text('Belum ada sertifikat yang diterbitkan.'),
                  );
                }
                return ListView.builder(
                  itemCount: certificates.length,
                  itemBuilder: (context, index) {
                    final cert = certificates[index];
                    return ListTile(
                      leading: const Icon(Icons.card_membership, color: Colors.amber),
                      title: Text(
                        cert.certificateNumber,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Siswa ID: ${cert.studentId} | Tipe: ${cert.type.toUpperCase()}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.qr_code_2),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => CertificatePreviewDialog(certificate: cert),
                          );
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}