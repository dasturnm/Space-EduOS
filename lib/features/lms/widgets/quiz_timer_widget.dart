import 'package:flutter/material.dart';

class QuizTimerWidget extends StatelessWidget {
  final int secondsRemaining;

  const QuizTimerWidget({
    super.key,
    required this.secondsRemaining,
  });

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isCritical = secondsRemaining < 300; // Kurang dari 5 menit

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isCritical ? Colors.red.shade100 : Colors.blue.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCritical ? Colors.red : Colors.blue,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            color: isCritical ? Colors.red : Colors.blue.shade800,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            _formatTime(secondsRemaining),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isCritical ? Colors.red.shade900 : Colors.blue.shade900,
            ),
          ),
        ],
      ),
    );
  }
}