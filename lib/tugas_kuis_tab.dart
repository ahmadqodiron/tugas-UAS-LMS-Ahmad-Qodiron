import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'user_provider.dart';
import 'task_detail_screen.dart';

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
              final isSubmitted = item['type'] == 'Tugas' && user.isTaskSubmitted(item['id'] ?? '');
          return InkWell(
            onTap: item['type'] == 'Tugas' ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailScreen(task: item),
                ),
              );
            } : null,
            child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2, // Lighter shadow
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 12), // More spacing
            child: Padding(
              padding: const EdgeInsets.all(20.0), // More padding
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        _getIconForType(item['type']),
                        color: Colors.blue[800],
                        size: 28, // Slightly larger
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['type'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[400], // Slightly darker blue
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['title'],
                              style: TextStyle(
                                fontSize: 18, // Slightly larger
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                height: 1.2, // Better line height
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Deadline: ${item['deadline']}',
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
                  if (item['type'] == 'Tugas')
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Column(
                        children: [
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'share') {
                                final link = 'https://lms-app.com/tugas/${item['id'] ?? allItems.indexOf(item)}';
                                Share.share('Lihat tugas: ${item['title']} melalui link ini: $link');
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'share',
                                child: Row(
                                  children: [
                                    Icon(Icons.share, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text('Bagikan Link Tugas'),
                                  ],
                                ),
                              ),
                            ],
                            icon: const Icon(Icons.more_vert, color: Colors.grey),
                          ),
                          if (isSubmitted)
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