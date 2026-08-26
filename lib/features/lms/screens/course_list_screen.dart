import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/course_provider.dart';
import 'course_form_screen.dart';

class CourseListScreen extends ConsumerWidget {
  final String organizationId;

  const CourseListScreen({
    super.key,
    required this.organizationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(courseProvider(organizationId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kelas (LMS)'),
      ),
      body: coursesAsync.when(
        data: (courses) {
          if (courses.isEmpty) {
            return const Center(
              child: Text('Belum ada kelas yang terdaftar.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    course.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${course.code ?? '-'} | Status: ${course.status.toUpperCase()}\n${course.description ?? ''}',
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: course.status == 'published'
                          ? Colors.green.shade100
                          : Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      course.status,
                      style: TextStyle(
                        fontSize: 12,
                        color: course.status == 'published'
                            ? Colors.green.shade900
                            : Colors.amber.shade900,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CourseFormScreen(organizationId: organizationId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}