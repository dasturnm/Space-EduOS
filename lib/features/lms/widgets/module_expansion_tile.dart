import 'package:flutter/material.dart';
import '../models/course_model.dart';

class ModuleExpansionTile extends StatelessWidget {
  final ModuleModel module;
  final List<LessonModel> lessons;
  final Function(LessonModel lesson)? onLessonTap;

  const ModuleExpansionTile({
    super.key,
    required this.module,
    required this.lessons,
    this.onLessonTap,
  });

  IconData _getContentTypeIcon(String contentType) {
    switch (contentType) {
      case 'video':
        return Icons.play_circle_fill;
      case 'document':
        return Icons.description;
      case 'quiz':
        return Icons.assignment;
      case 'link':
      default:
        return Icons.link;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ExpansionTile(
        title: Text(
          'Modul ${module.order}: ${module.name}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: module.description != null ? Text(module.description!) : null,
        children: lessons.isEmpty
            ? [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Belum ada materi pada modul ini.',
              style: TextStyle(color: Colors.grey),
            ),
          )
        ]
            : lessons.map((lesson) {
          return ListTile(
            leading: Icon(
              _getContentTypeIcon(lesson.contentType),
              color: Theme.of(context).primaryColor,
            ),
            title: Text(lesson.name),
            subtitle: Text('${lesson.durationMinutes} Menit'),
            trailing: lesson.isFree
                ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Gratis',
                style: TextStyle(fontSize: 10, color: Colors.green),
              ),
            )
                : null,
            onTap: () => onLessonTap?.call(lesson),
          );
        }).toList(),
      ),
    );
  }
}