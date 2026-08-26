import 'package:flutter/material.dart';
import '../models/assignment_model.dart';

class AssignmentStatusBadge extends StatelessWidget {
  final AssignmentModel assignment;

  const AssignmentStatusBadge({
    super.key,
    required this.assignment,
  });

  // Aturan BR-LMS-001: Cek apakah melewati batas waktu
  bool get _isExpired => DateTime.now().isAfter(assignment.dueDate);

  @override
  Widget build(BuildContext context) {
    if (_isExpired) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.red.shade300),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 12, color: Colors.red),
            SizedBox(width: 4),
            Text(
              'Melewati batas waktu',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      );
    }

    final isClosed = assignment.status == 'closed';
    final isPublished = assignment.status == 'published';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPublished
            ? Colors.blue.shade100
            : isClosed
            ? Colors.grey.shade200
            : Colors.amber.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        assignment.status.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isPublished
              ? Colors.blue.shade900
              : isClosed
              ? Colors.grey.shade800
              : Colors.amber.shade900,
        ),
      ),
    );
  }
}