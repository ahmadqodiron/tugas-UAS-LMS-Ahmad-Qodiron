import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class CreateTugasScreen extends StatefulWidget {
  const CreateTugasScreen({super.key});

  @override
  CreateTugasScreenState createState() => CreateTugasScreenState();
}

class CreateTugasScreenState extends State<CreateTugasScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDeadline;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDeadline = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _saveTugas() {
    if (_formKey.currentState!.validate() && _selectedDeadline != null) {
      final task = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'type': 'Tugas',
        'title': _titleController.text,
        'description': _descriptionController.text,
        'deadline': '${_selectedDeadline!.year}-${_selectedDeadline!.month.toString().padLeft(2, '0')}-${_selectedDeadline!.day.toString().padLeft(2, '0')} ${_selectedDeadline!.hour.toString().padLeft(2, '0')}:${_selectedDeadline!.minute.toString().padLeft(2, '0')}',
        'isCompleted': false,
      };
      Provider.of<User>(context, listen: false).addTask(task);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Tugas'),
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Tugas',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tugas wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Tugas',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tugas wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _selectDeadline,
                child: Text(
                  _selectedDeadline == null
                      ? 'Pilih Deadline'
                      : 'Deadline: ${_selectedDeadline!.day}/${_selectedDeadline!.month}/${_selectedDeadline!.year} ${_selectedDeadline!.hour}:${_selectedDeadline!.minute.toString().padLeft(2, '0')}',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty && _selectedDeadline != null) ? _saveTugas : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('SIMPAN', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}