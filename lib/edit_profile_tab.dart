import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class EditProfileTab extends StatefulWidget {
  const EditProfileTab({super.key});

  @override
  EditProfileTabState createState() => EditProfileTabState();
}

class EditProfileTabState extends State<EditProfileTab> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _programStudiController;
  late TextEditingController _fakultasController;
  late TextEditingController _countryController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    final user = context.read<User>();
    _firstNameController = TextEditingController(text: user.firstName);
    _lastNameController = TextEditingController(text: user.lastName);
    _emailController = TextEditingController(text: user.email);
    _programStudiController = TextEditingController(text: user.programStudi);
    _fakultasController = TextEditingController(text: user.fakultas);
    _countryController = TextEditingController(text: user.country);
    _descriptionController = TextEditingController(text: user.description);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _programStudiController.dispose();
    _fakultasController.dispose();
    _countryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _programStudiController.text.isEmpty ||
        _fakultasController.text.isEmpty ||
        _countryController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    final user = context.read<User>();
    user.updateProfile(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      programStudi: _programStudiController.text,
      fakultas: _fakultasController.text,
      country: _countryController.text,
      description: _descriptionController.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profil berhasil disimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'Nama Depan',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Nama Terakhir',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _programStudiController,
              decoration: InputDecoration(
                labelText: 'Program Studi',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _fakultasController,
              decoration: InputDecoration(
                labelText: 'Fakultas',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _countryController,
              decoration: InputDecoration(
                labelText: 'Negara',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[900]!, Colors.blue[300]!],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}