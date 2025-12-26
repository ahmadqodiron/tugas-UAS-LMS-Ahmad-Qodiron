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
  List<Map<String, String>> classes;
  Map<String, List<Map<String, dynamic>>> classAnnouncements;
  List<Map<String, dynamic>> tasks;
  Map<String, Map<String, dynamic>> taskSubmissions;

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
    List<Map<String, String>>? classes,
    Map<String, List<Map<String, dynamic>>>? classAnnouncements,
    List<Map<String, dynamic>>? tasks,
    Map<String, Map<String, dynamic>>? taskSubmissions,
  }) : classes = classes ?? [], classAnnouncements = classAnnouncements ?? {}, tasks = tasks ?? [], taskSubmissions = taskSubmissions ?? {};

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
    classes.clear();
    classAnnouncements.clear();
    tasks.clear();
    taskSubmissions.clear();
    notifyListeners();
  }

  void updateLastAccess() {
    lastAccess = DateTime.now();
    notifyListeners();
  }

  void addClass(Map<String, String> newClass) {
    classes.add(newClass);
    classAnnouncements[newClass['id']!] = [];
    notifyListeners();
  }

  void addAnnouncement(String classId, Map<String, dynamic> announcement) {
    if (!classAnnouncements.containsKey(classId)) {
      classAnnouncements[classId] = [];
    }
    classAnnouncements[classId]!.add(announcement);
    notifyListeners();
  }

  void addTask(Map<String, dynamic> task) {
    tasks.add(task);
    notifyListeners();
  }

  void submitTask(String taskId, Map<String, dynamic> submission) {
    taskSubmissions[taskId] = submission;
    notifyListeners();
  }

  bool isTaskSubmitted(String taskId) {
    return taskSubmissions.containsKey(taskId);
  }
}