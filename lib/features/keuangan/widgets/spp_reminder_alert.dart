import 'package:flutter/material.dart';

class SppReminderAlert extends StatelessWidget {
  final double outstanding;
  final int daysLeft;
  final VoidCallback onPayPressed;

  const SppReminderAlert({
    super.key,
    required this.outstanding,
    required this.daysLeft,
    required this.onPayPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (outstanding <= 0.0) return const SizedBox.shrink();

    final bool isUrgent = daysLeft <= 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUrgent ? Colors.red.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isUrgent ? Colors.red.shade200 : Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(
            isUrgent ? Icons.error_outline : Icons.warning_amber_outlined,
            color: isUrgent ? Colors.red : Colors.orange,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isUrgent ? "PERINGATAN JATUH TEMPO BESOK!" : "Tagihan SPP Menunggu Pembayaran",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isUrgent ? Colors.red.shade900 : Colors.orange.shade900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Sisa tunggakan anak Anda sebesar Rp ${outstanding.toInt()}. Segera selesaikan sebelum denda keterlambatan 10% berlaku.",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onPayPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isUrgent ? Colors.red : Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text("Bayar SPP"),
          ),
        ],
      ),
    );
  }
}