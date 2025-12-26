import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  NotificationsScreenState createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen> {
  bool isSelectionMode = false;
  Set<String> selectedNotificationIds = {};

  void _enterSelectionMode(String notificationId) {
    setState(() {
      isSelectionMode = true;
      selectedNotificationIds = {notificationId};
    });
  }

  void _exitSelectionMode() {
    setState(() {
      isSelectionMode = false;
      selectedNotificationIds.clear();
    });
  }

  void _toggleSelection(String notificationId) {
    setState(() {
      if (selectedNotificationIds.contains(notificationId)) {
        selectedNotificationIds.remove(notificationId);
        if (selectedNotificationIds.isEmpty) {
          _exitSelectionMode();
        }
      } else {
        selectedNotificationIds.add(notificationId);
      }
    });
  }

  void _deleteSelectedNotifications() {
    final user = Provider.of<User>(context, listen: false);
    for (final id in selectedNotificationIds) {
      user.deleteNotification(id);
    }
    _exitSelectionMode();
  }

  void _pinSelectedNotifications() {
    final user = Provider.of<User>(context, listen: false);
    for (final id in selectedNotificationIds) {
      user.togglePinNotification(id);
    }
    _exitSelectionMode();
  }

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
              title: Text(
                '${selectedNotificationIds.length} dipilih',
                style: const TextStyle(color: Colors.black),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.push_pin, color: Colors.blue),
                  onPressed: selectedNotificationIds.isNotEmpty ? _pinSelectedNotifications : null,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: selectedNotificationIds.isNotEmpty ? _deleteSelectedNotifications : null,
                ),
              ],
            )
          : AppBar(
              title: const Text('Notifikasi'),
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
      body: Consumer<User>(
        builder: (context, user, child) {
          // Sort notifications: pinned first, then by date
          final sortedNotifications = List<Map<String, dynamic>>.from(user.notifications)
            ..sort((a, b) {
              bool aPinned = a['isPinned'] ?? false;
              bool bPinned = b['isPinned'] ?? false;
              if (aPinned && !bPinned) return -1;
              if (!aPinned && bPinned) return 1;
              return (b['createdAt'] as DateTime).compareTo(a['createdAt'] as DateTime);
            });

          if (sortedNotifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada notifikasi',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: sortedNotifications.length,
            itemBuilder: (context, index) {
              final notification = sortedNotifications[index];
              final icon = _getIcon(notification['iconType']);
              final relativeTime = _getRelativeTime(notification['createdAt']);
              final isSelected = selectedNotificationIds.contains(notification['id']);
              final isPinned = notification['isPinned'] ?? false;

              return GestureDetector(
                onLongPress: () {
                  if (!isSelectionMode) {
                    _enterSelectionMode(notification['id']);
                  }
                },
                onTap: () {
                  if (isSelectionMode) {
                    _toggleSelection(notification['id']);
                  }
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 2,
                  color: isSelected ? Colors.blue[50] : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          icon,
                          size: 32,
                          color: Colors.blue[800],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      notification['title'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  if (isPinned)
                                    const Icon(
                                      Icons.push_pin,
                                      size: 16,
                                      color: Colors.blue,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notification['description'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                relativeTime,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelectionMode)
                          Checkbox(
                            value: isSelected,
                            onChanged: (value) => _toggleSelection(notification['id']),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _getRelativeTime(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return '1 hari yang lalu';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} hari yang lalu';
      } else {
        final weeks = (difference.inDays / 7).floor();
        final days = difference.inDays % 7;
        if (days == 0) {
          return '$weeks minggu yang lalu';
        } else {
          return '$weeks minggu $days hari yang lalu';
        }
      }
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  IconData _getIcon(String iconType) {
    switch (iconType) {
      case 'class':
        return Icons.class_;
      case 'task':
        return Icons.assignment;
      case 'quiz':
        return Icons.quiz;
      default:
        return Icons.notifications;
    }
  }
}