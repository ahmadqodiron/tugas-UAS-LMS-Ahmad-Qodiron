import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class CreateClassScreen extends StatefulWidget {
  const CreateClassScreen({super.key});

  @override
  CreateClassScreenState createState() => CreateClassScreenState();
}

class CreateClassScreenState extends State<CreateClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaKelasController = TextEditingController();
  final _mataPelajaranController = TextEditingController();
  final _bagianController = TextEditingController();
  final _ruangController = TextEditingController();

  @override
  void dispose() {
    _namaKelasController.dispose();
    _mataPelajaranController.dispose();
    _bagianController.dispose();
    _ruangController.dispose();
    super.dispose();
  }

  void _saveClass() {
    if (_formKey.currentState!.validate()) {
      final newClass = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'namaKelas': _namaKelasController.text,
        'mataPelajaran': _mataPelajaranController.text,
        'bagian': _bagianController.text,
        'ruang': _ruangController.text,
        'isPinned': false,
      };
      Provider.of<User>(context, listen: false).addClass(newClass);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Kelas Baru'),
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
          TextButton(
            onPressed: _saveClass,
            child: const Text(
              'Simpan',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaKelasController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kelas',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Kelas wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mataPelajaranController,
                decoration: const InputDecoration(
                  labelText: 'Mata Pelajaran',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bagianController,
                decoration: const InputDecoration(
                  labelText: 'Bagian',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ruangController,
                decoration: const InputDecoration(
                  labelText: 'Ruang',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}