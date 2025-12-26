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
  List<Map<String, dynamic>> classes;
  Map<String, List<Map<String, dynamic>>> classAnnouncements;
  List<Map<String, dynamic>> tasks;
  Map<String, Map<String, dynamic>> taskSubmissions;
  List<Map<String, dynamic>> notifications;
  int unreadCount;

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
    List<Map<String, dynamic>>? classes,
    Map<String, List<Map<String, dynamic>>>? classAnnouncements,
    List<Map<String, dynamic>>? tasks,
    Map<String, Map<String, dynamic>>? taskSubmissions,
    List<Map<String, dynamic>>? notifications,
    int? unreadCount,
  }) : classes = classes ?? [], classAnnouncements = classAnnouncements ?? {}, tasks = tasks ?? [], taskSubmissions = taskSubmissions ?? {}, notifications = notifications ?? [], unreadCount = unreadCount ?? 0;

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
    notifications.clear();
    unreadCount = 0;
    notifyListeners();
  }

  void updateLastAccess() {
    lastAccess = DateTime.now();
    notifyListeners();
  }

  void addClass(Map<String, dynamic> newClass) {
    classes.add(newClass);
    classAnnouncements[newClass['id']!] = [];
    // Add notification
    final notification = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': 'class',
      'title': 'Kelas Baru Dibuat',
      'description': 'Kelas "${newClass['namaKelas']}" telah berhasil dibuat.',
      'iconType': 'class',
      'createdAt': DateTime.now(),
      'isRead': false,
      'isPinned': false,
    };
    addNotification(notification);
  }

  void deleteClass(String classId) {
    final index = classes.indexWhere((c) => c['id'] == classId);
    if (index != -1) {
      classes.removeAt(index);
      classAnnouncements.remove(classId);
      notifyListeners();
    }
  }

  void togglePinClass(String classId) {
    final index = classes.indexWhere((c) => c['id'] == classId);
    if (index != -1) {
      classes[index]['isPinned'] = !(classes[index]['isPinned'] ?? false);
      // Reorder: pinned classes to the top
      classes.sort((a, b) {
        bool aPinned = a['isPinned'] ?? false;
        bool bPinned = b['isPinned'] ?? false;
        if (aPinned && !bPinned) return -1;
        if (!aPinned && bPinned) return 1;
        // If both pinned or both not, maintain current order
        return 0;
      });
      notifyListeners();
    }
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
    // Add notification
    String type = task['type'] == 'Quiz' ? 'quiz' : 'task';
    String title = type == 'quiz' ? 'Kuis Baru Dibuat' : 'Tugas Baru Dibuat';
    String description = type == 'quiz'
        ? 'Kuis "${task['title']}" telah berhasil dibuat.'
        : 'Tugas "${task['title']}" telah berhasil dibuat.';
    String iconType = type;
    final notification = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': type,
      'title': title,
      'description': description,
      'iconType': iconType,
      'createdAt': DateTime.now(),
      'isRead': false,
      'isPinned': false,
    };
    addNotification(notification);
  }

  void submitTask(String taskId, Map<String, dynamic> submission) {
    taskSubmissions[taskId] = submission;
    notifyListeners();
  }

  bool isTaskSubmitted(String taskId) {
    return taskSubmissions.containsKey(taskId);
  }

  void addNotification(Map<String, dynamic> notification) {
    notifications.add(notification);
    unreadCount++;
    notifyListeners();
  }

  void markNotificationAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      notifications[index]['isRead'] = true;
      unreadCount = unreadCount > 0 ? unreadCount - 1 : 0;
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    for (var notification in notifications) {
      notification['isRead'] = true;
    }
    unreadCount = 0;
    notifyListeners();
  }

  void deleteNotification(String notificationId) {
    final index = notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      if (!(notifications[index]['isRead'] as bool)) {
        unreadCount = unreadCount > 0 ? unreadCount - 1 : 0;
      }
      notifications.removeAt(index);
      notifyListeners();
    }
  }

  void togglePinNotification(String notificationId) {
    final index = notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      notifications[index]['isPinned'] = !(notifications[index]['isPinned'] as bool);
      // Reorder: pinned notifications to the top
      notifications.sort((a, b) {
        bool aPinned = a['isPinned'] ?? false;
        bool bPinned = b['isPinned'] ?? false;
        if (aPinned && !bPinned) return -1;
        if (!aPinned && bPinned) return 1;
        // If both pinned or both not, sort by createdAt descending
        return (b['createdAt'] as DateTime).compareTo(a['createdAt'] as DateTime);
      });
      notifyListeners();
    }
  }
}