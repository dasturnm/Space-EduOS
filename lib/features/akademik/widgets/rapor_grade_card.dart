import 'package:flutter/material.dart';

class RaporGradeCard extends StatelessWidget {
  final double scoreTahfidz;
  final double scoreLms;
  final double finalScore;
  final String gradeLetter;

  const RaporGradeCard({
    super.key,
    required this.scoreTahfidz,
    required this.scoreLms,
    required this.finalScore,
    required this.gradeLetter,
  });

  Color _getGradeColor(String letter) {
    switch (letter.toUpperCase()) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.blue;
      case 'C':
        return Colors.orange;
      case 'D':
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradeColor = _getGradeColor(gradeLetter);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'NILAI AKHIR KUMULATIF',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      finalScore.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: gradeColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: gradeColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: gradeColor, width: 2),
                  ),
                  child: Text(
                    gradeLetter,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: gradeColor,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Tahfidz (60%)',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        scoreTahfidz.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 30,
                  width: 1,
                  color: Colors.grey.shade300,
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'LMS/Akademik (40%)',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        scoreLms.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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