import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String firstName;
  String lastName;
  String email;
  String programStudi;
  String fakultas;
  String country;
  String description;
  String? profileImagePath;
  DateTime firstAccess;
  DateTime lastAccess;
  bool isLoggedIn;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.programStudi,
    required this.fakultas,
    required this.country,
    required this.description,
    this.profileImagePath,
    required this.firstAccess,
    required this.lastAccess,
    this.isLoggedIn = false,
  });

  String get fullName => '$firstName $lastName';

  void updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String programStudi,
    required String fakultas,
    required String country,
    required String description,
  }) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.email = email;
    this.programStudi = programStudi;
    this.fakultas = fakultas;
    this.country = country;
    this.description = description;
    notifyListeners();
  }

  void updateProfileImage(String? path) {
    profileImagePath = path;
    notifyListeners();
  }

  void login() {
    isLoggedIn = true;
    firstAccess = DateTime.now();
    lastAccess = DateTime.now();
    notifyListeners();
  }

  void logout() {
    // Reset to default
    firstName = 'John';
    lastName = 'Doe';
    email = 'john.doe@university.edu';
    programStudi = 'Teknik Informatika';
    fakultas = 'Fakultas Teknik';
    country = 'Indonesia';
    description = 'Mahasiswa semester 5 yang tertarik dengan pengembangan aplikasi mobile.';
    profileImagePath = null;
    firstAccess = DateTime(2023, 9, 1);
    lastAccess = DateTime.now();
    isLoggedIn = false;
    notifyListeners();
  }

  void updateLastAccess() {
    lastAccess = DateTime.now();
    notifyListeners();
  }

  // Dummy classes
  static List<Map<String, String>> dummyClasses = [
    {
      'nama': 'Matematika Dasar',
      'kode': 'MATH101',
      'tanggal_mulai': '2023-09-01',
    },
    {
      'nama': 'Fisika',
      'kode': 'PHYS101',
      'tanggal_mulai': '2023-09-01',
    },
    {
      'nama': 'Kimia',
      'kode': 'CHEM101',
      'tanggal_mulai': '2023-09-01',
    },
  ];
}