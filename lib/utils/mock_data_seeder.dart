import 'package:flutter/foundation.dart';
import '../services/database_helper.dart';
import '../services/firestore_service.dart';

class MockDataSeeder {
  static Future<void> seedData() async {
    final db = DatabaseHelper.instance;
    
    // Check if data already exists
    final existingUsers = await db.getAllUsers();
    if (existingUsers.isNotEmpty) {
      debugPrint('Mock data already exists');
      return;
    }
    
    debugPrint('Seeding mock data...');
    
    // Create Users in SQLite
    final studentId = await db.createUser({
      'email': 'student@ssid.com',
      'name': 'นายสมชาย ใจดี',
      'role': 'student',
    });
    
    final instructorId = await db.createUser({
      'email': 'instructor@ssid.com',
      'name': 'ดร.สมศรี สอนดี',
      'role': 'instructor',
    });
    
    debugPrint('Created users: student=$studentId, instructor=$instructorId');
    
    // Sync users to Firebase Firestore
    try {
      final firestore = FirestoreService();
      
      await firestore.createUser(
        email: 'student@ssid.com',
        name: 'นายสมชาย ใจดี',
        role: 'student',
      );
      
      await firestore.createUser(
        email: 'instructor@ssid.com',
        name: 'ดร.สมศรี สอนดี',
        role: 'instructor',
      );
      
      debugPrint('Users synced to Firebase');
    } catch (firebaseError) {
      debugPrint('Firebase user sync failed: $firebaseError');
    }
    
    // Create Sessions (Analysis Results)
    await db.createSession({
      'user_id': studentId,
      'video_path': '/storage/emulated/0/DCIM/suturing_video_1.mp4',
      'overall_score': 85.5,
      'suturing_score': 88.0,
      'hand_movement_score': 82.0,
      'tool_handling_score': 86.0,
      'time_efficiency_score': 86.0,
      'feedback': 'เทคนิคการเย็บแผลดี การจับเครื่องมือถูกต้อง ควรปรับปรุงความเร็วในการทำงาน',
    });
    
    await db.createSession({
      'user_id': studentId,
      'video_path': '/storage/emulated/0/DCIM/suturing_video_2.mp4',
      'overall_score': 78.0,
      'suturing_score': 80.0,
      'hand_movement_score': 75.0,
      'tool_handling_score': 78.0,
      'time_efficiency_score': 79.0,
      'feedback': 'การเย็บแผลพื้นฐานดี ควรฝึกความมั่นคงของมือเพิ่มเติม',
    });
    
    await db.createSession({
      'user_id': studentId,
      'video_path': '/storage/emulated/0/DCIM/suturing_video_3.mp4',
      'overall_score': 92.0,
      'suturing_score': 95.0,
      'hand_movement_score': 90.0,
      'tool_handling_score': 91.0,
      'time_efficiency_score': 92.0,
      'feedback': 'ผลงานยอดเยี่ยม! เทคนิคสมบูรณ์แบบ',
    });
    
    debugPrint('Created 3 sessions');
    
    // Create Notifications
    await db.createNotification({
      'user_id': studentId,
      'title': 'ผลวิเคราะห์พร้อมแล้ว',
      'message': 'วิดีโอ suturing_video_1.mp4 ได้รับการวิเคราะห์แล้ว คะแนนรวม: 85.5%',
      'type': 'result',
      'is_read': 0,
    });
    
    await db.createNotification({
      'user_id': studentId,
      'title': 'มีงานใหม่',
      'message': 'อาจารย์มอบหมายงาน: ฝึกเย็บแผลครั้งที่ 1',
      'type': 'assignment',
      'is_read': 1,
    });
    
    await db.createNotification({
      'user_id': studentId,
      'title': 'แจ้งเตือนกำหนดส่ง',
      'message': 'งาน "ฝึกเย็บแผลครั้งที่ 1" ครบกำหนดภายใน 2 วัน',
      'type': 'reminder',
      'is_read': 0,
    });
    
    debugPrint('Created 3 notifications');
    
    // Create Assignments
    await db.createAssignment({
      'instructor_id': instructorId,
      'title': 'ฝึกเย็บแผลครั้งที่ 1',
      'description': 'ฝึกเทคนิคการเย็บแผลพื้นฐาน Simple Interrupted Suture',
      'due_date': '2026-02-10',
    });
    
    await db.createAssignment({
      'instructor_id': instructorId,
      'title': 'ฝึกเย็บแผลครั้งที่ 2',
      'description': 'ฝึกเทคนิค Continuous Suture และ Mattress Suture',
      'due_date': '2026-02-20',
    });
    
    debugPrint('Created 2 assignments');
    debugPrint('Mock data seeding completed!');
  }
}
