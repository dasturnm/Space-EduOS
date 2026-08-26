import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/quiz_model.dart';
import '../providers/course_provider.dart';

class QuestionFormScreen extends ConsumerStatefulWidget {
  final String bankId;

  const QuestionFormScreen({
    super.key,
    required this.bankId,
  });

  @override
  ConsumerState<QuestionFormScreen> createState() => _QuestionFormScreenState();
}

class _QuestionFormScreenState extends ConsumerState<QuestionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _scoreController = TextEditingController(text: '1.0');

  String _type = 'pg'; // Options: pg, essay, isian
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  String? _correctAnswer;
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    _scoreController.dispose();
    for (var c in _optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Validasi Khusus Pilihan Ganda ('pg')
    List<String> optionsList = [];
    if (_type == 'pg') {
      optionsList = _optionControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      if (optionsList.length < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Soal pilihan ganda minimal memiliki 2 opsi jawaban')),
        );
        return;
      }

      if (_correctAnswer == null || _correctAnswer!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih kunci jawaban yang benar')),
        );
        return;
      }
    }

    setState(() => _isLoading = true);

    final question = QuestionModel(
      id: const Uuid().v4(),
      bankId: widget.bankId,
      type: _type,
      text: _textController.text.trim(),
      options: optionsList,
      correctAnswer: _type == 'pg' ? _correctAnswer : null,
      score: double.tryParse(_scoreController.text) ?? 1.0,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    try {
      await ref.read(lmsServiceProvider).saveQuestion(question);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Butir soal berhasil disimpan')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan soal: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Butir Soal')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(
                  labelText: 'Tipe Soal',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'pg', child: Text('Pilihan Ganda (PG)')),
                  DropdownMenuItem(value: 'essay', child: Text('Essay')),
                  DropdownMenuItem(value: 'isian', child: Text('Isian Singkat')),
                ],
                onChanged: (val) => setState(() => _type = val ?? 'pg'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _textController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Pertanyaan / Pertanyaan Soal *',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _scoreController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Bobot Nilai',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // UI Input Pilihan Jawaban jika tipe == 'pg'
              if (_type == 'pg') ...[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Pilihan Jawaban & Kunci Jawaban:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                ...List.generate(_optionControllers.length, (index) {
                  final label = String.fromCharCode(65 + index); // A, B, C, D
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Radio<String>(
                          value: label,
                          groupValue: _correctAnswer,
                          onChanged: (val) => setState(() => _correctAnswer = val),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _optionControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Opsi $label',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Simpan Butir Soal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}