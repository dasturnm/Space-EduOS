import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';

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

  PlatformFile? _akteFile;
  PlatformFile? _kkFile;
  PlatformFile? _fotoFile;

  Future<void> _pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (file.size > 2 * 1024 * 1024) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ukuran berkas maksimal adalah 2MB'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      setState(() {
        if (type == 'akte') _akteFile = file;
        if (type == 'kk') _kkFile = file;
        if (type == 'foto') _fotoFile = file;
      });
    }
  }

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
      Map<String, String> dokumenUrls = {};

      if (_akteFile != null && _akteFile!.bytes != null) {
        final path = '${widget.organizationId}/akte_${DateTime.now().millisecondsSinceEpoch}_${_akteFile!.name}';
        await Supabase.instance.client.storage.from('documents').uploadBinary(path, _akteFile!.bytes!);
        final url = Supabase.instance.client.storage.from('documents').getPublicUrl(path);
        dokumenUrls['akte'] = url;
      }

      if (_kkFile != null && _kkFile!.bytes != null) {
        final path = '${widget.organizationId}/kk_${DateTime.now().millisecondsSinceEpoch}_${_kkFile!.name}';
        await Supabase.instance.client.storage.from('documents').uploadBinary(path, _kkFile!.bytes!);
        final url = Supabase.instance.client.storage.from('documents').getPublicUrl(path);
        dokumenUrls['kk'] = url;
      }

      if (_fotoFile != null && _fotoFile!.bytes != null) {
        final path = '${widget.organizationId}/foto_${DateTime.now().millisecondsSinceEpoch}_${_fotoFile!.name}';
        await Supabase.instance.client.storage.from('documents').uploadBinary(path, _fotoFile!.bytes!);
        final url = Supabase.instance.client.storage.from('documents').getPublicUrl(path);
        dokumenUrls['foto'] = url;
      }

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
        'dokumen_urls': dokumenUrls,
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
                    _akteFile = null;
                    _kkFile = null;
                    _fotoFile = null;
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

  Widget _buildFileUploadTile({
    required String title,
    required PlatformFile? file,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            const Icon(Icons.upload_file, color: Color(0xFF10B981)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(
                    file != null ? file.name : 'Pilih berkas...',
                    style: TextStyle(
                      fontSize: 14,
                      color: file != null ? Colors.black : Colors.grey.shade600,
                      fontWeight: file != null ? FontWeight.bold : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (file != null)
              const Icon(Icons.check_circle, color: Color(0xFF10B981))
            else
              const Icon(Icons.attach_file, color: Colors.grey),
          ],
        ),
      ),
    );
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
              const Text(
                'Upload Dokumen (Akte, KK, Foto)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
              ),
              const SizedBox(height: 16),
              _buildFileUploadTile(
                title: 'Akte Kelahiran (Maks 2MB)',
                file: _akteFile,
                onTap: () => _pickFile('akte'),
              ),
              const SizedBox(height: 12),
              _buildFileUploadTile(
                title: 'Kartu Keluarga (KK) (Maks 2MB)',
                file: _kkFile,
                onTap: () => _pickFile('kk'),
              ),
              const SizedBox(height: 12),
              _buildFileUploadTile(
                title: 'Pas Foto (Maks 2MB)',
                file: _fotoFile,
                onTap: () => _pickFile('foto'),
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