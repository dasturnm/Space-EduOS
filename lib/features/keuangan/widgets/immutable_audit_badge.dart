import 'package:flutter/material.dart';

class ImmutableAuditBadge extends StatelessWidget {
  final String transactionId;

  const ImmutableAuditBadge({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_outline, color: Colors.amber, size: 14),
          const SizedBox(width: 6),
          Text(
            "IMMUTABLE LEDGER: ${transactionId.length >= 8 ? transactionId.substring(0, 8).toUpperCase() : transactionId}",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.amber.shade800,
            ),
          ),
        ],
      ),
    );
  }
}