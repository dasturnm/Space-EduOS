// Lokasi: lib/features/auth/screens/setup_wizard_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/providers/app_context_provider.dart';
import '../../management_lembaga/services/lembaga_seeding_service.dart';

class SetupWizardScreen extends ConsumerStatefulWidget {
  const SetupWizardScreen({super.key});

  @override
  ConsumerState<SetupWizardScreen> createState() => _SetupWizardScreenState();
}

class _SetupWizardScreenState extends ConsumerState<SetupWizardScreen> {
  final _seedingService = LembagaSeedingService();
  bool _isProcessing = false;
  int _selectedOption = 0; // 0: Auto Seed, 1: Manual

  Future<void> _handleProceed() async {
    final appContext = ref.read(appContextProvider);
    final lembaga = appContext.lembaga;

    if (lembaga == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data lembaga belum terdeteksi. Silakan muat ulang.")),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      if (_selectedOption == 0) {
        // Option 0: Jalankan Golden Seed otomatis
        await _seedingService.seedUniversalOrganization(lembaga.id);

        // Refresh AppContext agar permission & struktur baru langsung terbaca
        await ref.read(appContextProvider.notifier).initContext(forceRefresh: true);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Template organisasi berhasil diterapkan!")),
        );
      }

      if (!mounted) return;
      // Navigasi ke Dashboard Utama
      context.go(AppRouteNames.dashboard);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengonfigurasi lembaga: $e")),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appContext = ref.watch(appContextProvider);
    final namaLembaga = appContext.lembaga?.namaLembaga ?? "Lembaga Anda";

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Inisialisasi Lembaga Baru"),
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.auto_awesome, color: Color(0xFF10B981), size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Selamat Datang, $namaLembaga!",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Pilih metode setup struktur organisasi lembaga Anda.",
                                style: TextStyle(color: Colors.grey[600], fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    const Divider(),
                    const SizedBox(height: 20),

                    // OPSI 1: TEMPLATE STANDAR
                    InkWell(
                      onTap: () => setState(() => _selectedOption = 0),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _selectedOption == 0 ? const Color(0xFFECFDF5) : Colors.transparent,
                          border: Border.all(
                            color: _selectedOption == 0 ? const Color(0xFF10B981) : Colors.grey.shade300,
                            width: _selectedOption == 0 ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Radio<int>(
                              value: 0,
                              groupValue: _selectedOption,
                              activeColor: const Color(0xFF10B981),
                              onChanged: (val) => setState(() => _selectedOption = val!),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "Gunakan Template Standar Tahfidz Core",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Text("Rekomendasi", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Otomatis menginstalkan 3 Divisi, 5 Unit Kerja, 6 Jabatan, serta 23 Permission PBAC siap pakai (Akademik, Kesantrian, Keuangan, Mudir).",
                                    style: TextStyle(color: Colors.grey[700], fontSize: 12, height: 1.4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // OPSI 2: MANUAL SETUP
                    InkWell(
                      onTap: () => setState(() => _selectedOption = 1),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _selectedOption == 1 ? const Color(0xFFECFDF5) : Colors.transparent,
                          border: Border.all(
                            color: _selectedOption == 1 ? const Color(0xFF10B981) : Colors.grey.shade300,
                            width: _selectedOption == 1 ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Radio<int>(
                              value: 1,
                              groupValue: _selectedOption,
                              activeColor: const Color(0xFF10B981),
                              onChanged: (val) => setState(() => _selectedOption = val!),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Konfigurasi Manual dari Kosong",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Mulai dengan struktur organisasi kosong dan daftarkan Divisi, Unit Kerja, dan Jabatan satu per satu secara mandiri.",
                                    style: TextStyle(color: Colors.grey[700], fontSize: 12, height: 1.4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: _isProcessing ? null : _handleProceed,
                        child: _isProcessing
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                            : const Text("Lanjutkan ke Dashboard", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}