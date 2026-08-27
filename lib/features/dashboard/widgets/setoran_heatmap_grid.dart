import 'package:flutter/material.dart';

class SetoranHeatmapGrid extends StatelessWidget {
  /// Struktur Data: {DayIndex (1: Sen, 2: Sel, 3: Rab, 4: Kam): {HourIndex (5..21): Count}}
  final Map<int, Map<int, int>> heatmapData;

  const SetoranHeatmapGrid({super.key, required this.heatmapData});

  Color _getHeatmapColor(int count) {
    if (count == 0) return Colors.grey.shade100;
    if (count <= 3) return Colors.green.shade100;
    if (count <= 7) return Colors.green.shade300;
    if (count <= 12) return Colors.green.shade500;
    return Colors.green.shade800; // Sangat Padat
  }

  @override
  Widget build(BuildContext context) {
    final List<String> days = ["Sen", "Sel", "Rab", "Kam"];
    final List<int> hours = List.generate(17, (index) => index + 5); // 05:00 - 21:00

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Heatmap Kepadatan Setoran Santri",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Sumbu Y: Jam Operasional
                  Column(
                    children: hours
                        .map((h) => Container(
                      height: 32,
                      width: 45,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "$h:00",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ))
                        .toList(),
                  ),
                  const SizedBox(width: 8),
                  // Grid Matriks Matrik Hari x Jam
                  ...List.generate(days.length, (dayIdx) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            days[dayIdx],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        ...hours.map((hour) {
                          final count = heatmapData[dayIdx + 1]?[hour] ?? 0;
                          return Tooltip(
                            message:
                            "Hari ${days[dayIdx]}, Jam $hour:00\nJumlah Setoran: $count kali",
                            child: Container(
                              margin: const EdgeInsets.all(2),
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: _getHeatmapColor(count),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}