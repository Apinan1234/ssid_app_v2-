import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../services/database_helper.dart';

class AuthProvider with ChangeNotifier {
  int? _userId;
  String? _userEmail;
  String? _userName;
  String? _userRole;
  bool _isAuthenticated = false;

  int? get userId => _userId;
  String? get userEmail => _userEmail;
  String? get userName => _userName;
  String? get userRole => _userRole;
  bool get isAuthenticated => _isAuthenticated;
  bool get isInstructor => _userRole == 'Instructor';
  bool get isStudent => _userRole == 'Student';

  Future<void> login({
    required String email,
    required String name,
    required String role,
    int? userId,
  }) async {
    // Get or create user in SQLite database
    final db = DatabaseHelper.instance;
    int actualUserId;
    
    try {
      // Check if user exists in SQLite
      var user = await db.getUserByEmail(email);
      
      if (user == null) {
        // User doesn't exist, create new user
        actualUserId = await db.createUser({
          'email': email,
          'name': name,
          'role': role,
        });
        debugPrint('Created new user in SQLite: $email (id: $actualUserId)');
      } else {
        // User exists, use existing ID
        actualUserId = user['id'] as int;
        debugPrint('Found existing user in SQLite: $email (id: $actualUserId)');
      }
    } catch (e) {
      debugPrint('SQLite user error: $e');
      actualUserId = userId ?? 1;
    }
    
    _userId = actualUserId;
    _userEmail = email;
    _userName = name;
    _userRole = role;
    _isAuthenticated = true;
    notifyListeners();

    // Sync to Firestore
    try {
      final firestoreService = FirestoreService();
      await firestoreService.createUser(
        email: email,
        name: name,
        role: role,
      );
      debugPrint('User synced to Firebase: $email');
    } catch (e) {
      debugPrint('Firebase user sync failed: $e');
    }
  }

  void logout() {
    _userId = null;
    _userEmail = null;
    _userName = null;
    _userRole = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}

