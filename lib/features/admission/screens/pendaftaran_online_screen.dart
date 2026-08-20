import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PendaftaranOnlineScreen extends StatefulWidget {
  final String organizationId;

  const PendaftaranOnlineScreen({super.key, required this.organizationId});

  @override
  State<PendaftaranOnlineScreen> createState() => _PendaftaranOnlineScreenState();
}

class _PendaftaranOnlineScreenState extends State<PendaftaranOnlineScreen> {
  final _formKey = GlobalKey<FormState>();

  final _namaLengkapController = TextEditingController();
  final _nisnController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _alamatController = TextEditingController();
  final _namaWaliController = TextEditingController();
  final _noHpWaliController = TextEditingController();

  DateTime? _tanggalLahir;
  String _jenisKelamin = 'L';
  bool _isLoading = false;

  void _submitPendaftaran() async {
    if (!_formKey.currentState!.validate()) return;
    if (_tanggalLahir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal lahir wajib dipilih')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.from('pendaftaran_siswa').insert({
        'organization_id': widget.organizationId,
        'nama_lengkap': _namaLengkapController.text.trim(),
        'nisn': _nisnController.text.trim().isEmpty ? null : _nisnController.text.trim(),
        'tempat_lahir': _tempatLahirController.text.trim().isEmpty ? null : _tempatLahirController.text.trim(),
        'tanggal_lahir': _tanggalLahir!.toIso8601String().split('T')[0],
        'jenis_kelamin': _jenisKelamin,
        'alamat': _alamatController.text.trim().isEmpty ? null : _alamatController.text.trim(),
        'nama_wali': _namaWaliController.text.trim(),
        'no_hp_wali': _noHpWaliController.text.trim(),
        'status': 'registrasi',
      });

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('Pendaftaran Berhasil'),
            content: const Text('Data pendaftaran Anda telah berhasil dikirim. Pihak lembaga akan memverifikasi pendaftaran Anda.'),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
                onPressed: () {
                  Navigator.pop(ctx);
                  _formKey.currentState?.reset();
                  setState(() {
                    _tanggalLahir = null;
                    _jenisKelamin = 'L';
                  });
                },
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mendaftar: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _namaLengkapController.dispose();
    _nisnController.dispose();
    _tempatLahirController.dispose();
    _alamatController.dispose();
    _namaWaliController.dispose();
    _noHpWaliController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendaftaran Santri Baru'),
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Data Calon Santri',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaLengkapController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap Calon Santri *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person, color: Color(0xFF10B981)),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Nama calon santri wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nisnController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'NISN (Opsional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.badge, color: Color(0xFF10B981)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _jenisKelamin,
                      decoration: const InputDecoration(
                        labelText: 'Jenis Kelamin',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                        DropdownMenuItem(value: 'P', child: Text('Perempuan')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _jenisKelamin = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _tempatLahirController,
                      decoration: const InputDecoration(
                        labelText: 'Tempat Lahir',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_city, color: Color(0xFF10B981)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().subtract(const Duration(days: 365 * 7)),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() => _tanggalLahir = picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Tgl Lahir *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF10B981)),
                        ),
                        child: Text(
                          _tanggalLahir == null
                              ? 'Pilih Tgl'
                              : "${_tanggalLahir!.day}/${_tanggalLahir!.month}/${_tanggalLahir!.year}",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _alamatController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Alamat Lengkap',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home, color: Color(0xFF10B981)),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Data Orang Tua / Wali',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaWaliController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap Wali *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.family_restroom, color: Color(0xFF10B981)),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Nama wali wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noHpWaliController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor WhatsApp / HP Wali *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone, color: Color(0xFF10B981)),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Nomor HP wali wajib diisi' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _isLoading ? null : _submitPendaftaran,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Kirim Pendaftaran', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
