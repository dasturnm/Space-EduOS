import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_model.dart';
import '../providers/course_provider.dart';

class QuizAttemptScreen extends ConsumerStatefulWidget {
  final QuizModel quiz;
  final List<QuestionModel> questions;
  final String studentId;
  final String attemptId;

  const QuizAttemptScreen({
    super.key,
    required this.quiz,
    required this.questions,
    required this.studentId,
    required this.attemptId,
  });

  @override
  ConsumerState<QuizAttemptScreen> createState() => _QuizAttemptScreenState();
}

class _QuizAttemptScreenState extends ConsumerState<QuizAttemptScreen> {
  Timer? _timer;
  int _secondsRemaining = 0;
  int _currentIndex = 0;
  final Map<String, dynamic> _userAnswers = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.quiz.durationMinutes * 60;
    _loadLocalCache();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Kepatuhan BR-LMS-002: Offline Resilience (Muat cache lokal saat mulai)
  Future<void> _loadLocalCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('quiz_attempt_${widget.attemptId}');
    if (cachedData != null) {
      final decoded = jsonDecode(cachedData) as Map<String, dynamic>;
      setState(() {
        _userAnswers.addAll(decoded);
      });
    }
  }

  // Kepatuhan BR-LMS-002: Simpan jawaban langsung ke SharedPreferences
  Future<void> _saveAnswerToLocalCache(String questionId, dynamic answer) async {
    setState(() {
      _userAnswers[questionId] = answer;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('quiz_attempt_${widget.attemptId}', jsonEncode(_userAnswers));
  }

  // Kepatuhan BR-LMS-002: Auto-Submit Timer Klien
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
        _forceSubmitTimedOut();
      }
    });
  }

  // Auto Submit paksa saat waktu habis
  Future<void> _forceSubmitTimedOut() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    try {
      await ref.read(lmsServiceProvider).updateQuizAnswers(
        attemptId: widget.attemptId,
        answers: _userAnswers,
        status: 'timed_out',
      );
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text('Waktu Habis!'),
            content: const Text('Waktu pengerjaan telah selesai. Jawaban Anda otomatis dikirim ke server.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim jawaban: $e')),
        );
      }
    }
  }

  Future<void> _submitQuiz() async {
    setState(() => _isSubmitting = true);
    _timer?.cancel();

    try {
      await ref.read(lmsServiceProvider).updateQuizAnswers(
        attemptId: widget.attemptId,
        answers: _userAnswers,
        status: 'submitted',
      );

      // Clear local cache setelah sukses
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('quiz_attempt_${widget.attemptId}');

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ujian berhasil dikumpulkan')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim kuis: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.quiz.name)),
        body: const Center(child: Text('Tidak ada soal pada ujian ini.')),
      );
    }

    final currentQuestion = widget.questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.name),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: _secondsRemaining < 300 ? Colors.red.shade100 : Colors.blue.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.timer,
                  color: _secondsRemaining < 300 ? Colors.red : Colors.blue,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  _formatTime(_secondsRemaining),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _secondsRemaining < 300 ? Colors.red : Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Soal ${_currentIndex + 1} dari ${widget.questions.length}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Text(
              currentQuestion.text,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            // Pilihan Ganda Render
            if (currentQuestion.type == 'pg') ...[
              ...List.generate(currentQuestion.options.length, (optIndex) {
                final optionText = currentQuestion.options[optIndex].toString();
                final optionLabel = String.fromCharCode(65 + optIndex);
                final isSelected = _userAnswers[currentQuestion.id] == optionLabel;

                return Card(
                  color: isSelected ? Colors.blue.shade50 : null,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected ? Colors.blue : Colors.grey.shade200,
                      child: Text(
                        optionLabel,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    title: Text(optionText),
                    onTap: () => _saveAnswerToLocalCache(currentQuestion.id, optionLabel),
                  ),
                );
              }),
            ] else ...[
              TextFormField(
                initialValue: _userAnswers[currentQuestion.id]?.toString() ?? '',
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Tuliskan jawaban Anda',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => _saveAnswerToLocalCache(currentQuestion.id, val),
              ),
            ],

            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentIndex > 0)
                  OutlinedButton(
                    onPressed: () => setState(() => _currentIndex--),
                    child: const Text('Sebelumnya'),
                  )
                else
                  const SizedBox.shrink(),
                if (_currentIndex < widget.questions.length - 1)
                  ElevatedButton(
                    onPressed: () => setState(() => _currentIndex++),
                    child: const Text('Berikutnya'),
                  )
                else
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitQuiz,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: _isSubmitting
                        ? const CircularProgressIndicator()
                        : const Text('Selesai & Kirim'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}