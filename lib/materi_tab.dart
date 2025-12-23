import 'package:flutter/material.dart';

class MateriTab extends StatelessWidget {
  const MateriTab({super.key});

  // Dummy data for materi
  static const List<Map<String, dynamic>> dummyMateri = [
    {
      'label': 'Pertemuan 1',
      'title': '01 – Pengantar User Interface Design',
      'description': '2 URL, 1 File, 0 Kuis, 1 Interactive Content',
      'isCompleted': true,
    },
    {
      'label': 'Pertemuan 2',
      'title': '02 – Prinsip Desain UI',
      'description': '3 URL, 2 File, 1 Kuis, 0 Interactive Content',
      'isCompleted': true,
    },
    {
      'label': 'Pertemuan 3',
      'title': '03 – Wireframing dan Prototyping',
      'description': '1 URL, 3 File, 0 Kuis, 2 Interactive Content',
      'isCompleted': false,
    },
    {
      'label': 'Pertemuan 4',
      'title': '04 – Color Theory dalam UI',
      'description': '2 URL, 1 File, 1 Kuis, 1 Interactive Content',
      'isCompleted': false,
    },
    {
      'label': 'Pertemuan 5',
      'title': '05 – Typography dan Layout',
      'description': '3 URL, 2 File, 0 Kuis, 1 Interactive Content',
      'isCompleted': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50], // Soft background
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dummyMateri.length,
        itemBuilder: (context, index) {
          final materi = dummyMateri[index];
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          materi['label'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[400], // Slightly darker blue
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          materi['title'],
                          style: TextStyle(
                            fontSize: 18, // Slightly larger
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.2, // Better line height
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          materi['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700], // Darker grey
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (materi['isCompleted'])
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