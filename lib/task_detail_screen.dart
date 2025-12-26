import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'user_provider.dart';

class TaskDetailScreen extends StatefulWidget {
  final Map<String, dynamic> task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  TaskDetailScreenState createState() => TaskDetailScreenState();
}

class TaskDetailScreenState extends State<TaskDetailScreen> {
  final List<Map<String, dynamic>> _attachments = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Load existing submission if any
    final user = Provider.of<User>(context, listen: false);
    if (user.isTaskSubmitted(widget.task['id'])) {
      final submission = user.taskSubmissions[widget.task['id']]!;
      _attachments.addAll(List<Map<String, dynamic>>.from(submission['attachments'] ?? []));
    }
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
                title: const Text('Upload File'),
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
                title: const Text('Sisipkan Link'),
                onTap: () {
                  Navigator.pop(context);
                  _showLinkDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo, color: Colors.blue),
                title: const Text('Pilih Foto'),
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
                leading: const Icon(Icons.picture_as_pdf, color: Colors.blue),
                title: const Text('Upload PDF'),
                onTap: () async {
                  Navigator.pop(context);
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );
                  if (result != null) {
                    setState(() {
                      _attachments.add({
                        'type': 'pdf',
                        'name': result.files.single.name,
                        'path': result.files.single.path,
                      });
                    });
                  }
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

  void _submitTask() {
    if (_attachments.isNotEmpty) {
      final submission = {
        'submittedAt': DateTime.now().toIso8601String(),
        'attachments': List.from(_attachments),
      };
      Provider.of<User>(context, listen: false).submitTask(widget.task['id'], submission);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tugas berhasil dikumpulkan!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap pilih file untuk dikumpulkan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final isSubmitted = user.isTaskSubmitted(widget.task['id']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Task Title
            Text(
              widget.task['title'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Task Description
            Text(
              widget.task['description'],
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),

            // Deadline
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  'Deadline: ${widget.task['deadline']}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Submission Section
            if (!isSubmitted) ...[
              const Text(
                'Pengumpulan Tugas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _showAttachmentOptions,
                icon: const Icon(Icons.attach_file),
                label: const Text('Pilih File'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              if (_attachments.isNotEmpty) ...[
                const SizedBox(height: 16),
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
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Simpan / Kumpulkan Tugas',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ] else ...[
              const Text(
                'Tugas Sudah Dikumpulkan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48,
              ),
            ],
          ],
        ),
      ),
    );
  }
}