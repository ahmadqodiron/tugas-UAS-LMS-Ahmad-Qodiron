import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'user_provider.dart';
import 'task_detail_screen.dart';
import 'take_quiz_screen.dart';
import 'quiz_results_screen.dart';

class TugasKuisTab extends StatelessWidget {
  const TugasKuisTab({super.key});

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Quiz':
        return Icons.quiz;
      case 'Tugas':
        return Icons.assignment;
      case 'Pertemuan':
        return Icons.meeting_room;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) {
        final allItems = user.tasks;
        return Container(
          color: Colors.grey[50], // Soft background
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: allItems.length,
            itemBuilder: (context, index) {
              final item = allItems[index];
              final type = item['type'] as String? ?? 'Unknown';
              final title = item['title'] as String? ?? 'No Title';
              final deadline = item['deadline'] as String? ?? 'No Deadline';
              final id = item['id'] as String? ?? '';
              final isSubmitted = type == 'Tugas' && user.isTaskSubmitted(id);
              return InkWell(
                onTap: () {
                  if (type == 'Tugas') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(task: item),
                      ),
                    );
                  } else if (type == 'Quiz') {
                    final isCompleted = (item['isCompleted'] as bool? ?? false);
                    if (isCompleted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizResultsScreen(quiz: item),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TakeQuizScreen(quiz: item),
                        ),
                      );
                    }
                  }
                },
                child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2, // Lighter shadow
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12), // More spacing
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, isSubmitted ? 60.0 : 20.0), // More padding, extra bottom for checkmark
                  child: Stack(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            _getIconForType(type),
                            color: Colors.blue[800],
                            size: 28, // Slightly larger
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  type,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue[400], // Slightly darker blue
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 18, // Slightly larger
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    height: 1.2, // Better line height
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Deadline: $deadline',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700], // Darker grey
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (type == 'Tugas' || type == 'Quiz')
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Column(
                            children: [
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'share') {
                                    final link = type == 'Tugas' ? 'https://lms-app.com/tugas/$id' : 'https://lms-app.com/quiz/$id';
                                    final itemType = type == 'Tugas' ? 'tugas' : 'kuis';
                                    Share.share('Lihat $itemType: $title melalui link ini: $link');
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'share',
                                    child: Row(
                                      children: [
                                        const Icon(Icons.share, color: Colors.blue),
                                        const SizedBox(width: 8),
                                        Text(type == 'Tugas' ? 'Bagikan Link Tugas' : 'Bagikan Link Kuis'),
                                      ],
                                    ),
                                  ),
                                ],
                                icon: const Icon(Icons.more_vert, color: Colors.grey),
                              ),
                              if ((type == 'Tugas' && isSubmitted) || (type == 'Quiz' && (item['isCompleted'] as bool? ?? false)))
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.green[600],
                                    size: 28,
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              );
            },
          ),
    );
  },
);
  }
}