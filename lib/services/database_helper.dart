import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ssid_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Users Table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        role TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Sessions Table (Analysis Results)
    await db.execute('''
      CREATE TABLE sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        video_path TEXT NOT NULL,
        overall_score REAL NOT NULL,
        suturing_score REAL,
        hand_movement_score REAL,
        tool_handling_score REAL,
        time_efficiency_score REAL,
        feedback TEXT,
        analyzed_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');

    // Notifications Table
    await db.execute('''
      CREATE TABLE notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        type TEXT NOT NULL,
        is_read INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');

    // Assignments Table
    await db.execute('''
      CREATE TABLE assignments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        instructor_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        due_date TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (instructor_id) REFERENCES users(id)
      )
    ''');
  }

  // ==================== USER CRUD ====================
  
  // CREATE - Insert new user
  Future<int> createUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  // READ - Get user by email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // READ - Get all users
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }

  // UPDATE - Update user
  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await database;
    return await db.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE - Delete user
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== SESSION CRUD ====================
  
  // CREATE - Insert new session
  Future<int> createSession(Map<String, dynamic> session) async {
    final db = await database;
    return await db.insert('sessions', session);
  }

  // READ - Get sessions by user ID
  Future<List<Map<String, dynamic>>> getSessionsByUserId(int userId) async {
    final db = await database;
    return await db.query(
      'sessions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'analyzed_at DESC',
    );
  }

  // READ - Get all sessions
  Future<List<Map<String, dynamic>>> getAllSessions() async {
    final db = await database;
    return await db.query('sessions', orderBy: 'analyzed_at DESC');
  }

  // READ - Get session by ID
  Future<Map<String, dynamic>?> getSessionById(int id) async {
    final db = await database;
    final result = await db.query(
      'sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // UPDATE - Update session
  Future<int> updateSession(int id, Map<String, dynamic> session) async {
    final db = await database;
    return await db.update(
      'sessions',
      session,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE - Delete session
  Future<int> deleteSession(int id) async {
    final db = await database;
    return await db.delete(
      'sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== NOTIFICATION CRUD ====================
  
  // CREATE - Insert new notification
  Future<int> createNotification(Map<String, dynamic> notification) async {
    final db = await database;
    return await db.insert('notifications', notification);
  }

  // READ - Get notifications by user ID
  Future<List<Map<String, dynamic>>> getNotificationsByUserId(int userId) async {
    final db = await database;
    return await db.query(
      'notifications',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
  }

  // READ - Get unread notifications count
  Future<int> getUnreadNotificationCount(int userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM notifications WHERE user_id = ? AND is_read = 0',
      [userId],
    );
    return result.first['count'] as int;
  }

  // UPDATE - Mark notification as read
  Future<int> markNotificationAsRead(int id) async {
    final db = await database;
    return await db.update(
      'notifications',
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // UPDATE - Mark all notifications as read
  Future<int> markAllNotificationsAsRead(int userId) async {
    final db = await database;
    return await db.update(
      'notifications',
      {'is_read': 1},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // DELETE - Delete notification
  Future<int> deleteNotification(int id) async {
    final db = await database;
    return await db.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== ASSIGNMENT CRUD ====================
  
  // CREATE - Insert new assignment
  Future<int> createAssignment(Map<String, dynamic> assignment) async {
    final db = await database;
    return await db.insert('assignments', assignment);
  }

  // READ - Get all assignments
  Future<List<Map<String, dynamic>>> getAllAssignments() async {
    final db = await database;
    return await db.query('assignments', orderBy: 'created_at DESC');
  }

  // READ - Get assignments by instructor ID
  Future<List<Map<String, dynamic>>> getAssignmentsByInstructorId(int instructorId) async {
    final db = await database;
    return await db.query(
      'assignments',
      where: 'instructor_id = ?',
      whereArgs: [instructorId],
      orderBy: 'created_at DESC',
    );
  }

  // UPDATE - Update assignment
  Future<int> updateAssignment(int id, Map<String, dynamic> assignment) async {
    final db = await database;
    return await db.update(
      'assignments',
      assignment,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE - Delete assignment
  Future<int> deleteAssignment(int id) async {
    final db = await database;
    return await db.delete(
      'assignments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== UTILITY ====================
  
  // Close database
  Future<void> close() async {
    final db = await database;
    db.close();
  }

  // Clear all data (for testing)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('notifications');
    await db.delete('sessions');
    await db.delete('assignments');
    await db.delete('users');
  }
}
