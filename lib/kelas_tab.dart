import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class KelasTab extends StatelessWidget {
  const KelasTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final classes = user.classes;

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final kelas = classes[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kelas['nama']!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Kode Kelas: ${kelas['kode']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Tanggal Mulai: ${kelas['tanggal_mulai']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}