import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== USER CRUD ====================
  
  // Collection reference
  CollectionReference get usersCollection => _firestore.collection('users');
  CollectionReference get sessionsCollection => _firestore.collection('sessions');
  CollectionReference get notificationsCollection => _firestore.collection('notifications');
  CollectionReference get assignmentsCollection => _firestore.collection('assignments');

  // CREATE - Add new user
  Future<String> createUser({
    required String email,
    required String name,
    required String role,
  }) async {
    final docRef = await usersCollection.add({
      'email': email,
      'name': name,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  // READ - Get user by email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final snapshot = await usersCollection
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    
    if (snapshot.docs.isEmpty) return null;
    
    final doc = snapshot.docs.first;
    return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
  }

  // READ - Get all users
  Stream<List<Map<String, dynamic>>> getAllUsers() {
    return usersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
      }).toList();
    });
  }

  // UPDATE - Update user
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await usersCollection.doc(id).update(data);
  }

  // DELETE - Delete user
  Future<void> deleteUser(String id) async {
    await usersCollection.doc(id).delete();
  }

  // ==================== SESSION CRUD ====================
  
  // CREATE - Add new session
  Future<String> createSession({
    required String oderId,
    required String videoPath,
    required double overallScore,
    required double suturingScore,
    required double handMovementScore,
    required double toolHandlingScore,
    required double timeEfficiencyScore,
    required String feedback,
  }) async {
    final docRef = await sessionsCollection.add({
      'userId': oderId,
      'videoPath': videoPath,
      'overallScore': overallScore,
      'suturingScore': suturingScore,
      'handMovementScore': handMovementScore,
      'toolHandlingScore': toolHandlingScore,
      'timeEfficiencyScore': timeEfficiencyScore,
      'feedback': feedback,
      'analyzedAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  // READ - Get sessions by user ID
  Stream<List<Map<String, dynamic>>> getSessionsByUserId(String oderId) {
    return sessionsCollection
        .where('userId', isEqualTo: oderId)
        .orderBy('analyzedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
          }).toList();
        });
  }

  // READ - Get all sessions (for instructor)
  Stream<List<Map<String, dynamic>>> getAllSessions() {
    return sessionsCollection
        .orderBy('analyzedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
          }).toList();
        });
  }

  // UPDATE - Update session
  Future<void> updateSession(String id, Map<String, dynamic> data) async {
    await sessionsCollection.doc(id).update(data);
  }

  // DELETE - Delete session
  Future<void> deleteSession(String id) async {
    await sessionsCollection.doc(id).delete();
  }

  // ==================== NOTIFICATION CRUD ====================
  
  // CREATE - Add new notification
  Future<String> createNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
  }) async {
    final docRef = await notificationsCollection.add({
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  // READ - Get notifications by user ID
  Stream<List<Map<String, dynamic>>> getNotificationsByUserId(String userId) {
    return notificationsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
          }).toList();
        });
  }

  // UPDATE - Mark notification as read
  Future<void> markNotificationAsRead(String id) async {
    await notificationsCollection.doc(id).update({'isRead': true});
  }

  // UPDATE - Mark all notifications as read
  Future<void> markAllNotificationsAsRead(String userId) async {
    final batch = _firestore.batch();
    final snapshot = await notificationsCollection
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();
    
    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    
    await batch.commit();
  }

  // DELETE - Delete notification
  Future<void> deleteNotification(String id) async {
    await notificationsCollection.doc(id).delete();
  }

  // ==================== ASSIGNMENT CRUD ====================
  
  // CREATE - Add new assignment
  Future<String> createAssignment({
    required String instructorId,
    required String title,
    required String description,
    DateTime? dueDate,
  }) async {
    final docRef = await assignmentsCollection.add({
      'instructorId': instructorId,
      'title': title,
      'description': description,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate) : null,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  // READ - Get all assignments
  Stream<List<Map<String, dynamic>>> getAllAssignments() {
    return assignmentsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
          }).toList();
        });
  }

  // READ - Get assignments by instructor ID
  Stream<List<Map<String, dynamic>>> getAssignmentsByInstructorId(String instructorId) {
    return assignmentsCollection
        .where('instructorId', isEqualTo: instructorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
          }).toList();
        });
  }

  // UPDATE - Update assignment
  Future<void> updateAssignment(String id, Map<String, dynamic> data) async {
    await assignmentsCollection.doc(id).update(data);
  }

  // DELETE - Delete assignment
  Future<void> deleteAssignment(String id) async {
    await assignmentsCollection.doc(id).delete();
  }
}
