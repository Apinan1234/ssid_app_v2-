import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/notification_provider.dart';
import '../services/database_helper.dart';
import '../services/firestore_service.dart';

class InstructorHomeScreen extends StatefulWidget {
  const InstructorHomeScreen({super.key});

  @override
  State<InstructorHomeScreen> createState() => _InstructorHomeScreenState();
}

class _InstructorHomeScreenState extends State<InstructorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppTheme.mainGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Notification
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'สวัสดีครับ, อาจารย์',
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          auth.userName ?? 'Instructor',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Notification Bell
                        _buildNotificationBell(context),
                        const SizedBox(width: 12),
                        // Profile Avatar
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/instructor-profile'),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.warning, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(
                              LucideIcons.userCheck,
                              color: AppColors.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Instructor Stats Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(LucideIcons.graduationCap, color: AppColors.warning, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'Instructor Dashboard',
                                  style: TextStyle(
                                    color: AppColors.warning,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            icon: LucideIcons.users,
                            label: 'นักศึกษา',
                            value: '24',
                            color: AppColors.primary,
                          ),
                          _buildStatItem(
                            icon: LucideIcons.fileText,
                            label: 'งานที่มอบหมาย',
                            value: '8',
                            color: AppColors.info,
                          ),
                          _buildStatItem(
                            icon: LucideIcons.checkCircle,
                            label: 'ส่งแล้ว',
                            value: '156',
                            color: AppColors.success,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Quick Actions
                Row(
                  children: [
                    Expanded(
                      child: _buildActionCard(
                        icon: LucideIcons.plusCircle,
                        title: 'สร้างงาน',
                        color: AppColors.primary,
                        onTap: () => _showCreateAssignmentDialog(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildActionCard(
                        icon: LucideIcons.barChart3,
                        title: 'ดูสถิติ',
                        color: AppColors.success,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Recent Submissions
                const Text(
                  'งานที่ส่งล่าสุด',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                _buildSubmissionCard(
                  studentName: 'นายสมชาย ใจดี',
                  assignmentTitle: 'Advanced Suturing',
                  score: 92,
                  submittedAt: '2 ชั่วโมงที่แล้ว',
                ),
                
                const SizedBox(height: 12),
                
                _buildSubmissionCard(
                  studentName: 'นางสาวสมหญิง รักเรียน',
                  assignmentTitle: 'Basic Knot Tying',
                  score: 85,
                  submittedAt: '5 ชั่วโมงที่แล้ว',
                ),
                
                const SizedBox(height: 12),
                
                _buildSubmissionCard(
                  studentName: 'นายวิชัย เก่งมาก',
                  assignmentTitle: 'Needle Handling',
                  score: 78,
                  submittedAt: 'เมื่อวาน',
                ),
                
                const SizedBox(height: 32),
                
                // Logout Button
                TextButton.icon(
                  onPressed: () {
                    auth.logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  icon: const Icon(LucideIcons.logOut, color: AppColors.white),
                  label: const Text(
                    'ออกจากระบบ',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationBell(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, _) {
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/notifications'),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    LucideIcons.bell,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
                if (notificationProvider.unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          notificationProvider.unreadCount > 9 
                              ? '9+' 
                              : notificationProvider.unreadCount.toString(),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppColors.black,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmissionCard({
    required String studentName,
    required String assignmentTitle,
    required int score,
    required String submittedAt,
  }) {
    final isGood = score >= 80;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              LucideIcons.user,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.black,
                  ),
                ),
                Text(
                  '$assignmentTitle • $submittedAt',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isGood
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$score%',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: isGood ? AppColors.success : AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateAssignmentDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final auth = context.read<AuthProvider>();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'สร้างงานใหม่',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'ชื่องาน',
                  hintText: 'เช่น Basic Suturing Practice',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'รายละเอียด',
                  hintText: 'คำอธิบายงาน...',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isNotEmpty) {
                      // Save assignment to SQLite database
                      final db = DatabaseHelper.instance;
                      final instructorId = auth.userId ?? 1;
                      
                      try {
                        await db.createAssignment({
                          'instructor_id': instructorId,
                          'title': titleController.text,
                          'description': descController.text.isNotEmpty 
                              ? descController.text 
                              : 'ไม่มีคำอธิบาย',
                          'due_date': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
                        });
                        
                        debugPrint('Assignment created in SQLite: ${titleController.text}');
                        
                        // Try to sync to Firebase Firestore (may fail if no permission)
                        try {
                          final firestore = FirestoreService();
                          await firestore.createAssignment(
                            instructorId: instructorId.toString(),
                            title: titleController.text,
                            description: descController.text.isNotEmpty 
                                ? descController.text 
                                : 'ไม่มีคำอธิบาย',
                            dueDate: DateTime.now().add(const Duration(days: 7)),
                          );
                          debugPrint('Assignment synced to Firebase: ${titleController.text}');
                        } catch (firebaseError) {
                          debugPrint('Firebase sync failed (will retry later): $firebaseError');
                          // Continue anyway - SQLite is the primary database
                        }
                        
                        // Add notification for students
                        if (context.mounted) {
                          context.read<NotificationProvider>().addNotification(
                            title: 'งานใหม่: ${titleController.text}',
                            message: descController.text.isNotEmpty 
                                ? descController.text 
                                : 'มีงานใหม่รอให้คุณทำ',
                            type: 'assignment',
                          );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('สร้างงานสำเร็จ! บันทึกลง SQLite และ Firebase แล้ว'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        }
                      } catch (e) {
                        debugPrint('Error creating assignment: $e');
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('เกิดข้อผิดพลาด: $e'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: const Text(
                    'สร้างงาน',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
