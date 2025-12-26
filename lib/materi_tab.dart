import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'user_provider.dart';
import 'pengumuman_kelas_screen.dart';

class MateriTab extends StatefulWidget {
  const MateriTab({super.key});

  @override
  MateriTabState createState() => MateriTabState();
}

class MateriTabState extends State<MateriTab> {
  bool isSelectionMode = false;
  String? selectedClassId;

  void _enterSelectionMode(String classId) {
    setState(() {
      isSelectionMode = true;
      selectedClassId = classId;
    });
  }

  void _exitSelectionMode() {
    setState(() {
      isSelectionMode = false;
      selectedClassId = null;
    });
  }

  void _deleteSelectedClass() async {
    if (selectedClassId != null) {
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Hapus Kelas'),
          content: const Text('Apakah Anda yakin ingin menghapus kelas ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus'),
            ),
          ],
        ),
      );

      if (shouldDelete == true) {
        Provider.of<User>(context, listen: false).deleteClass(selectedClassId!);
        _exitSelectionMode();
      }
    }
  }

  void _pinSelectedClass() {
    if (selectedClassId != null) {
      Provider.of<User>(context, listen: false).togglePinClass(selectedClassId!);
      _exitSelectionMode();
    }
  }

  static const List<String> classImages = [
    'https://plus.unsplash.com/premium_photo-1661686671788-ad87a16d471a?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDQwfHx8ZW58MHx8fHx8',
    'https://plus.unsplash.com/premium_photo-1661692792947-4bf608fbcd1c?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDV8fHxlbnwwfHx8fHw%3D',
    'https://plus.unsplash.com/premium_photo-1661284942660-0b6a68520b54?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDE1fHx8ZW58MHx8fHx8',
    'https://plus.unsplash.com/premium_photo-1661727144615-2c579fffa457?q=80&w=1400&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1661304699559-36faef43655b?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDEwfHx8ZW58MHx8fHx8',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSelectionMode
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 1,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: _exitSelectionMode,
              ),
              title: const Text(
                '1 dipilih',
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.push_pin, color: Colors.blue),
                  onPressed: selectedClassId != null ? _pinSelectedClass : null,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: selectedClassId != null ? _deleteSelectedClass : null,
                ),
              ],
            )
          : null,
      body: Consumer<User>(
        builder: (context, user, child) {
          // Sort classes: pinned first
          final sortedClasses = List<Map<String, dynamic>>.from(user.classes)
            ..sort((a, b) {
              bool aPinned = a['isPinned'] ?? false;
              bool bPinned = b['isPinned'] ?? false;
              if (aPinned && !bPinned) return -1;
              if (!aPinned && bPinned) return 1;
              return 0;
            });

          if (sortedClasses.isEmpty) {
            return Container(
              color: Colors.grey[50],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada kelas. Silakan tambahkan kelas baru.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return Container(
            color: Colors.grey[50],
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: sortedClasses.length,
              itemBuilder: (context, index) {
                final kelas = sortedClasses[index];
                final imageUrl = classImages[index % classImages.length];
                final isSelected = selectedClassId == kelas['id'];
                final isPinned = kelas['isPinned'] ?? false;

                return GestureDetector(
                  onLongPress: () {
                    if (!isSelectionMode) {
                      _enterSelectionMode(kelas['id']);
                    }
                  },
                  onTap: () {
                    if (isSelectionMode) {
                      if (isSelected) {
                        _exitSelectionMode();
                      } else {
                        _enterSelectionMode(kelas['id']);
                      }
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PengumumanKelasScreen(kelas: kelas),
                        ),
                      );
                    }
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    color: isSelected ? Colors.blue[50] : Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.network(
                                imageUrl,
                                height: 130,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 130,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.blue[200]!, Colors.blue[100]!],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.school, size: 50, color: Colors.blue),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (isPinned)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.push_pin,
                                    size: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    kelas['namaKelas']!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    kelas['mataPelajaran']!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Bagian: ${kelas['bagian']}, Ruang: ${kelas['ruang']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'share') {
                                      final link = 'https://lms-app.com/invite/${kelas['id']}';
                                      Share.share('Bergabunglah dengan kelas ${kelas['namaKelas']} melalui link ini: $link');
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'share',
                                      child: Row(
                                        children: [
                                          Icon(Icons.share, color: Colors.blue),
                                          SizedBox(width: 8),
                                          Text('Bagikan Link Undangan'),
                                        ],
                                      ),
                                    ),
                                  ],
                                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}