import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppNotification {
  final String title;
  final String body;
  final DateTime timestamp;
  final String? type;
  bool isRead;

  AppNotification({
    required this.title,
    required this.body,
    required this.timestamp,
    this.type,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'body': body,
    'timestamp': timestamp.toIso8601String(),
    'type': type,
    'isRead': isRead,
  };

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
    title: json['title'] ?? '',
    body: json['body'] ?? '',
    timestamp: DateTime.parse(json['timestamp']),
    type: json['type'],
    isRead: json['isRead'] ?? false,
  );
}

class NotificationHistoryService extends ChangeNotifier {
  static const String _storageKey = 'notifications_history';
  List<AppNotification> _notifications = [];

  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataString = prefs.getString(_storageKey);
    
    if (dataString != null) {
      try {
        final List<dynamic> decodedList = jsonDecode(dataString);
        _notifications = decodedList.map((item) => AppNotification.fromJson(item)).toList();
        
        // Sort newest first
        _notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        notifyListeners();
      } catch (e) {
        debugPrint('Error loading notification history: $e');
      }
    }
  }

  Future<void> addNotification({
    required String title,
    required String body,
    String? type,
  }) async {
    final notification = AppNotification(
      title: title,
      body: body,
      timestamp: DateTime.now(),
      type: type,
    );
    
    _notifications.insert(0, notification);
    notifyListeners();
    
    await _saveHistory();
  }

  Future<void> markAllAsRead() async {
    bool hasChanges = false;
    for (var notif in _notifications) {
      if (!notif.isRead) {
        notif.isRead = true;
        hasChanges = true;
      }
    }
    
    if (hasChanges) {
      notifyListeners();
      await _saveHistory();
    }
  }

  Future<void> clearHistory() async {
    _notifications.clear();
    notifyListeners();
    await _saveHistory();
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(_notifications.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, encodedList);
  }
}
