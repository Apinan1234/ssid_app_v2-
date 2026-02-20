import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationItem {
  final int? id;
  final int userId;
  final String title;
  final String message;
  final DateTime createdAt;
  final String type; // 'assignment', 'result', 'alert', 'info'
  bool isRead;

  NotificationItem({
    this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.type,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() => {
    'user_id': userId,
    'title': title,
    'message': message,
    'type': type,
    'is_read': isRead ? 1 : 0,
    'created_at': createdAt.toIso8601String(),
  };

  factory NotificationItem.fromMap(Map<String, dynamic> map) => NotificationItem(
    id: map['id'],
    userId: map['user_id'] ?? 1,
    title: map['title'],
    message: map['message'],
    createdAt: map['created_at'] != null 
        ? DateTime.parse(map['created_at']) 
        : DateTime.now(),
    type: map['type'] ?? 'info',
    isRead: (map['is_read'] ?? 0) == 1,
  );
}

class NotificationProvider with ChangeNotifier {
  final List<NotificationItem> _notifications = [];
  final DatabaseHelper _db = DatabaseHelper.instance;
  int _currentUserId = 1;

  List<NotificationItem> get notifications => List.unmodifiable(_notifications);
  List<NotificationItem> get unreadNotifications => 
      _notifications.where((n) => !n.isRead).toList();
  int get unreadCount => unreadNotifications.length;

  NotificationProvider() {
    loadNotifications();
  }

  void setUserId(int userId) {
    _currentUserId = userId;
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      final data = await _db.getNotificationsByUserId(_currentUserId);
      _notifications.clear();
      _notifications.addAll(data.map((m) => NotificationItem.fromMap(m)));
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading notifications: $e');
      // Load mock data if database fails
      _loadMockNotifications();
    }
  }

  void _loadMockNotifications() {
    _notifications.addAll([
      NotificationItem(
        userId: _currentUserId,
        title: 'ผลการวิเคราะห์พร้อมแล้ว',
        message: 'การวิเคราะห์วิดีโอ "Advanced Suturing" เสร็จสิ้นแล้ว คะแนน: 88%',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        type: 'result',
      ),
      NotificationItem(
        userId: _currentUserId,
        title: 'งานใหม่จากอาจารย์',
        message: 'อาจารย์ ดร.สมชาย ได้มอบหมายงาน "Basic Knot Tying Practice"',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        type: 'assignment',
      ),
    ]);
    notifyListeners();
  }

  Future<void> addNotification({
    required String title,
    required String message,
    required String type,
  }) async {
    final notificationData = {
      'user_id': _currentUserId,
      'title': title,
      'message': message,
      'type': type,
      'is_read': 0,
    };
    
    try {
      final id = await _db.createNotification(notificationData);
      
      // Sync to Firebase Firestore
      try {
        final firestore = FirestoreService();
        await firestore.createNotification(
          userId: _currentUserId.toString(),
          title: title,
          message: message,
          type: type,
        );
        debugPrint('Notification synced to Firebase: $title');
      } catch (firebaseError) {
        debugPrint('Firebase notification sync failed: $firebaseError');
      }

      _notifications.insert(0, NotificationItem(
        id: id,
        userId: _currentUserId,
        title: title,
        message: message,
        createdAt: DateTime.now(),
        type: type,
      ));
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding notification: $e');
    }
  }

  Future<void> markAsRead(String idStr) async {
    final id = int.tryParse(idStr);
    if (id == null) return;
    
    try {
      // Update SQLite database
      await _db.markNotificationAsRead(id);
      
      // Get notification details to find matching Firebase document
      final notifications = await _db.getNotificationsByUserId(_currentUserId);
      final notification = notifications.firstWhere(
        (n) => n['id'] == id,
        orElse: () => {},
      );
      
      // Sync to Firebase Firestore by querying with userId and title
      if (notification.isNotEmpty) {
        try {
          final firestore = FirestoreService();
          final snapshot = await firestore.notificationsCollection
              .where('userId', isEqualTo: _currentUserId.toString())
              .where('title', isEqualTo: notification['title'])
              .where('isRead', isEqualTo: false)
              .limit(1)
              .get();
          
          if (snapshot.docs.isNotEmpty) {
            await snapshot.docs.first.reference.update({'isRead': true});
            debugPrint('Notification marked as read in Firebase: ${notification['title']}');
          }
        } catch (firebaseError) {
          debugPrint('Firebase mark as read failed: $firebaseError');
        }
      }
      
      // Update local list
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index].isRead = true;
        notifyListeners();
      }
      debugPrint('Notification $id marked as read in SQLite');
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _db.markAllNotificationsAsRead(_currentUserId);
      
      // Sync to Firebase Firestore by querying all unread notifications for this user
      try {
        final firestore = FirestoreService();
        final snapshot = await firestore.notificationsCollection
            .where('userId', isEqualTo: _currentUserId.toString())
            .where('isRead', isEqualTo: false)
            .get();
        
        // Update all matching documents
        final batch = FirebaseFirestore.instance.batch();
        for (var doc in snapshot.docs) {
          batch.update(doc.reference, {'isRead': true});
        }
        await batch.commit();
        
        debugPrint('All ${snapshot.docs.length} notifications marked as read in Firebase');
      } catch (firebaseError) {
        debugPrint('Firebase mark all as read failed: $firebaseError');
      }
      
      for (var notification in _notifications) {
        notification.isRead = true;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error marking all as read: $e');
    }
  }

  Future<void> deleteNotification(String idStr) async {
    final id = int.tryParse(idStr);
    if (id == null) return;
    
    try {
      // Get notification details before deleting from SQLite
      final notifications = await _db.getNotificationsByUserId(_currentUserId);
      final notification = notifications.firstWhere(
        (n) => n['id'] == id,
        orElse: () => {},
      );
      
      // Delete from SQLite
      await _db.deleteNotification(id);
      
      // Delete from Firebase by querying with userId and title
      if (notification.isNotEmpty) {
        try {
          final firestore = FirestoreService();
          final snapshot = await firestore.notificationsCollection
              .where('userId', isEqualTo: _currentUserId.toString())
              .where('title', isEqualTo: notification['title'])
              .limit(1)
              .get();
          
          if (snapshot.docs.isNotEmpty) {
            await snapshot.docs.first.reference.delete();
            debugPrint('Notification deleted from Firebase: ${notification['title']}');
          }
        } catch (firebaseError) {
          debugPrint('Firebase delete failed: $firebaseError');
        }
      }
      
      // Update local list
      _notifications.removeWhere((n) => n.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting notification: $e');
    }
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }
}

