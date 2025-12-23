import 'package:flutter/material.dart';

class TugasKuisTab extends StatelessWidget {
  const TugasKuisTab({super.key});

  // Dummy data for tugas and kuis
  static const List<Map<String, dynamic>> dummyTugasKuis = [
    {
      'type': 'Quiz',
      'title': 'Quiz Review 01',
      'deadline': '2023-12-25 10:00',
      'isCompleted': true,
    },
    {
      'type': 'Tugas',
      'title': 'Tugas 01 – UID Android Mobile Game',
      'deadline': '2023-12-26 23:59',
      'isCompleted': false,
    },
    {
      'type': 'Pertemuan',
      'title': 'Diskusi Pertemuan 2',
      'deadline': '2023-12-27 14:00',
      'isCompleted': false,
    },
    {
      'type': 'Quiz',
      'title': 'Quiz Midterm',
      'deadline': '2023-12-28 12:00',
      'isCompleted': false,
    },
    {
      'type': 'Tugas',
      'title': 'Tugas 02 – Prototyping App',
      'deadline': '2023-12-29 23:59',
      'isCompleted': false,
    },
  ];

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
    return Container(
      color: Colors.grey[50], // Soft background
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dummyTugasKuis.length,
        itemBuilder: (context, index) {
          final item = dummyTugasKuis[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2, // Lighter shadow
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 12), // More spacing
            child: Padding(
              padding: const EdgeInsets.all(20.0), // More padding
              child: Row(
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
                  if (item['isCompleted'])
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green[600], // Slightly darker green
                        size: 28, // Slightly larger
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}