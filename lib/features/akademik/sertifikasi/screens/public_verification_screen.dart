import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sertifikasi_model.dart';
import '../providers/sertifikasi_provider.dart';

class PublicVerificationScreen extends ConsumerStatefulWidget {
  final String? initialCertificateNumber;

  const PublicVerificationScreen({
    super.key,
    this.initialCertificateNumber,
  });

  @override
  ConsumerState<PublicVerificationScreen> createState() => _PublicVerificationScreenState();
}

class _PublicVerificationScreenState extends ConsumerState<PublicVerificationScreen> {
  late final TextEditingController _certNumberController;
  SertifikasiModel? _verifiedCert;
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _certNumberController = TextEditingController(text: widget.initialCertificateNumber ?? '');
    if (widget.initialCertificateNumber != null && widget.initialCertificateNumber!.isNotEmpty) {
      _verify();
    }
  }

  @override
  void dispose() {
    _certNumberController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final query = _certNumberController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _verifiedCert = null;
    });

    try {
      final cert = await ref.read(sertifikasiServiceProvider).verifyCertificate(query);
      setState(() => _verifiedCert = cert);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal melakukan verifikasi: $e')),
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
        title: const Text('Verifikasi Ijazah / Sertifikat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _certNumberController,
              decoration: InputDecoration(
                labelText: 'Nomor Sertifikat (misal: TSM-202603-A1B2)',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _verify,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            if (!_isLoading && _hasSearched && _verifiedCert == null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Sertifikat tidak ditemukan atau tidak valid!',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            if (!_isLoading && _verifiedCert != null) ...[
              Card(
                color: Colors.green.shade50,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'SERTIFIKAT VALID & TERVERIFIKASI',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Text('Nomor: ${_verifiedCert!.certificateNumber}'),
                      Text('Siswa ID: ${_verifiedCert!.studentId}'),
                      Text('Tipe Sertifikat: ${_verifiedCert!.type.toUpperCase()}'),
                      Text('Status: ${_verifiedCert!.status.toUpperCase()}'),
                      Text('Tanggal Terbit: ${_verifiedCert!.issuedDate.toLocal().toString().substring(0, 10)}'),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}