import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  Widget _buildProgressItem(BuildContext context, Map<String, dynamic> kelas, double progress, bool hasCompleted) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.book, color: Colors.blue[800]),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kelas['namaKelas'] ?? 'Unknown Class',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  if (hasCompleted) ...[
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800]!),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${(progress * 100).toInt()}% Selesai',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ] else ...[
                    Text(
                      'Belum ada progres. Kerjakan tugas atau kuis untuk melihat progres.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) {
        // Calculate overall progress
        final totalTasks = user.tasks.length;
        final completedTasks = user.tasks.where((task) => task['isCompleted'] == true).length;
        final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;
        final hasCompleted = completedTasks > 0;

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Section: Tugas Yang Akan Datang
            Text(
              'Tugas Yang Akan Datang',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[800]!, Colors.blue[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Matematika Dasar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Tugas Aljabar Linear',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Deadline: 25 Desember 2023',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Section: Pengumuman Terakhir
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pengumuman Terakhir',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      'https://media.istockphoto.com/id/2233876941/id/foto/guru-memberikan-pelajaran-kepada-kelas-yang-beragam-di-kelas.jpg?s=612x612&w=0&k=20&c=atuRpN4S82V19D2mlVUSzLAsCzUi3HqZxDP-5ecEX5g=',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Pengumuman penting tentang jadwal ujian akhir semester.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Section: Progres Kelas
            Text(
              'Progres Kelas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            if (user.classes.isEmpty)
              _buildProgressItem(context, {'namaKelas': 'Belum ada kelas'}, progress, hasCompleted)
            else
              ...user.classes.map((kelas) => _buildProgressItem(context, kelas, progress, hasCompleted)),
          ],
        );
      },
    );
  }
}