import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'user_provider.dart';

class PengumumanKelasScreen extends StatefulWidget {
  final Map<String, dynamic> kelas;

  const PengumumanKelasScreen({super.key, required this.kelas});

  @override
  PengumumanKelasScreenState createState() => PengumumanKelasScreenState();
}

class PengumumanKelasScreenState extends State<PengumumanKelasScreen> {
  final TextEditingController _announcementController = TextEditingController();
  final List<Map<String, dynamic>> _attachments = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _announcementController.dispose();
    super.dispose();
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.upload_file, color: Colors.blue),
                title: const Text('Upload file'),
                onTap: () async {
                  Navigator.pop(context);
                  final result = await FilePicker.platform.pickFiles();
                  if (result != null) {
                    setState(() {
                      _attachments.add({
                        'type': 'file',
                        'name': result.files.single.name,
                        'path': result.files.single.path,
                      });
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.link, color: Colors.blue),
                title: const Text('Sisipkan link'),
                onTap: () {
                  Navigator.pop(context);
                  _showLinkDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo, color: Colors.blue),
                title: const Text('Pilih foto'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _attachments.add({
                        'type': 'photo',
                        'name': pickedFile.name,
                        'path': pickedFile.path,
                      });
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera, color: Colors.blue),
                title: const Text('Ambil foto'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _attachments.add({
                        'type': 'photo',
                        'name': pickedFile.name,
                        'path': pickedFile.path,
                      });
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam, color: Colors.blue),
                title: const Text('Rekam video'),
                onTap: () {
                  Navigator.pop(context);
                  // Dummy
                  setState(() {
                    _attachments.add({
                      'type': 'video',
                      'name': 'Video Rekaman.mp4',
                    });
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.blue),
                title: const Text('Buat PDF baru'),
                onTap: () {
                  Navigator.pop(context);
                  // Dummy
                  setState(() {
                    _attachments.add({
                      'type': 'pdf',
                      'name': 'Dokumen Baru.pdf',
                    });
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLinkDialog() {
    final TextEditingController linkController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sisipkan Link'),
          content: TextField(
            controller: linkController,
            decoration: const InputDecoration(hintText: 'Masukkan URL'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (linkController.text.isNotEmpty) {
                  setState(() {
                    _attachments.add({
                      'type': 'link',
                      'url': linkController.text,
                    });
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  void _postAnnouncement() {
    if (_announcementController.text.isNotEmpty || _attachments.isNotEmpty) {
      final user = Provider.of<User>(context, listen: false);
      final announcement = {
        'senderName': user.fullName,
        'senderPhoto': user.profileImagePath,
        'content': _announcementController.text,
        'attachments': List.from(_attachments),
        'timestamp': DateTime.now(),
      };
      user.addAnnouncement(widget.kelas['id']!, announcement);
      _announcementController.clear();
      setState(() {
        _attachments.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final announcements = user.classAnnouncements[widget.kelas['id']] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kelas['namaKelas']!),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[900]!, Colors.blue[300]!],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: (_announcementController.text.isNotEmpty || _attachments.isNotEmpty) ? _postAnnouncement : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Buat', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _announcementController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Umumkan sesuatu kepada kelas …',
                      border: InputBorder.none,
                    ),
                  ),
                  if (_attachments.isNotEmpty)
                    Wrap(
                      spacing: 8.0,
                      children: _attachments.map((attachment) {
                        return Chip(
                          label: Text(attachment['name'] ?? attachment['url'] ?? 'Attachment'),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () => _removeAttachment(_attachments.indexOf(attachment)),
                        );
                      }).toList(),
                    ),
                  TextButton.icon(
                    onPressed: _showAttachmentOptions,
                    icon: const Icon(Icons.attach_file, color: Colors.blue),
                    label: const Text('Tambahkan lampiran', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                final announcement = announcements[announcements.length - 1 - index]; // Reverse order
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: announcement['senderPhoto'] != null
                                  ? FileImage(File(announcement['senderPhoto']))
                                  : null,
                              child: announcement['senderPhoto'] == null
                                  ? Text(announcement['senderName'][0])
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  announcement['senderName'],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${announcement['timestamp'].hour}:${announcement['timestamp'].minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(announcement['content']),
                        if (announcement['attachments'].isNotEmpty)
                          Wrap(
                            spacing: 8.0,
                            children: (announcement['attachments'] as List).map<Widget>((att) {
                              return Chip(
                                avatar: Icon(_getIconForType(att['type']), size: 18),
                                label: Text(att['name'] ?? att['url'] ?? 'Attachment'),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'file':
        return Icons.insert_drive_file;
      case 'link':
        return Icons.link;
      case 'photo':
        return Icons.photo;
      case 'video':
        return Icons.videocam;
      case 'pdf':
        return Icons.picture_as_pdf;
      default:
        return Icons.attach_file;
    }
  }
}