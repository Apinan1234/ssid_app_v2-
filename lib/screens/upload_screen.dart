import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../theme/colors.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';
import '../services/mock_ai_service.dart';
import '../services/database_helper.dart';
import '../providers/auth_provider.dart';
import '../providers/notification_provider.dart';
import '../services/firestore_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _selectedVideo;
  String? _validationError;
  bool _isProcessing = false;

  Future<void> _pickVideo(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(source: source);
      
      if (video != null) {
        final file = File(video.path);
        final fileSize = await file.length();
        
        // Validate file
        final validationError = Validators.validateVideoFile(video.path);
        final sizeError = Validators.validateFileSize(fileSize, 100); // 100MB limit
        
        setState(() {
          if (validationError != null) {
            _validationError = validationError;
            _selectedVideo = null;
          } else if (sizeError != null) {
            _validationError = sizeError;
            _selectedVideo = null;
          } else {
            _selectedVideo = file;
            _validationError = null;
          }
        });
      }
    } catch (e) {
      setState(() {
        _validationError = 'Error selecting video: $e';
      });
    }
  }

  Future<void> _analyzeVideo() async {
    if (_selectedVideo == null) return;
    
    setState(() => _isProcessing = true);
    
    // Read auth before async gap to avoid context usage after await
    final auth = context.read<AuthProvider>();
    final notificationProvider = context.read<NotificationProvider>();
    
    // Show processing dialog
    if (mounted) {
      _showProcessingDialog();
    }
    
    try {
      // Call mock AI service
      final result = await MockAIService.analyzeVideo(_selectedVideo!.path);
      
      // Save to SQLite database (CRUD - CREATE)
      final db = DatabaseHelper.instance;
      
      // Get or create user in database
      var user = await db.getUserByEmail(auth.userEmail ?? 'guest@ssid.app');
      int userId;
      
      if (user == null) {
        userId = await db.createUser({
          'email': auth.userEmail ?? 'guest@ssid.app',
          'name': auth.userName ?? 'Guest',
          'role': auth.userRole ?? 'Student',
        });
      } else {
        userId = user['id'] as int;
      }
      
      // Save session to database
      await db.createSession({
        'user_id': userId,
        'video_path': _selectedVideo!.path,
        'overall_score': result.overallScore,
        'suturing_score': result.suturingTechnique,
        'hand_movement_score': result.handMovement,
        'tool_handling_score': result.toolHandling,
        'time_efficiency_score': result.timeEfficiency,
        'feedback': result.feedback,
        'analyzed_at': DateTime.now().toIso8601String(),
      });

      // Sync session to Firebase Firestore
      try {
        final firestore = FirestoreService();
        await firestore.createSession(
          oderId: userId.toString(),
          videoPath: _selectedVideo!.path,
          overallScore: result.overallScore,
          suturingScore: result.suturingTechnique,
          handMovementScore: result.handMovement,
          toolHandlingScore: result.toolHandling,
          timeEfficiencyScore: result.timeEfficiency,
          feedback: result.feedback,
        );
        debugPrint('Session synced to Firebase: ${result.overallScore}');
      } catch (firebaseError) {
        debugPrint('Firebase session sync failed: $firebaseError');
      }
      
      // Create notification
      await db.createNotification({
        'user_id': userId,
        'title': 'ผลการวิเคราะห์พร้อมแล้ว',
        'message': 'คะแนนรวม: ${result.overallScore.toStringAsFixed(0)}% - ${result.feedback.substring(0, 50)}...',
        'type': 'result',
        'is_read': 0,
      });

      // Sync notification to Firebase Firestore
      try {
        final firestore = FirestoreService();
        await firestore.createNotification(
          userId: userId.toString(),
          title: 'ผลการวิเคราะห์พร้อมแล้ว',
          message: 'คะแนนรวม: ${result.overallScore.toStringAsFixed(0)}%',
          type: 'result',
        );
        debugPrint('Notification synced to Firebase');
      } catch (firebaseError) {
        debugPrint('Firebase notification sync failed: $firebaseError');
      }
      
      // Also update in-memory notification provider
      if (mounted) {
        notificationProvider.addNotification(
          title: 'ผลการวิเคราะห์พร้อมแล้ว',
          message: 'คะแนนรวม: ${result.overallScore.toStringAsFixed(0)}%',
          type: 'result',
        );
      }
      
      if (mounted) {
        // Close processing dialog
        Navigator.pop(context);
        
        // Navigate to results screen
        Navigator.pushNamed(
          context,
          '/analysis',
          arguments: result,
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error analyzing video: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _showProcessingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 24),
              const Text(
                'Analyzing Video',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please wait while our AI analyzes your technique...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Upload Video',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppTheme.mainGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Expanded(
                  child: _selectedVideo != null
                      ? _buildVideoPreview()
                      : _buildUploadOptions(),
                ),
                
                if (_selectedVideo != null) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _isProcessing ? null : _analyzeVideo,
                      icon: const Icon(LucideIcons.zap),
                      label: const Text(
                        'Analyze Video',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            LucideIcons.video,
            size: 60,
            color: AppColors.white,
          ),
        ),
        
        const SizedBox(height: 32),
        
        const Text(
          'Upload Practice Video',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        
        const SizedBox(height: 12),
        
        Text(
          'Choose a video to analyze your suturing technique',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.white.withValues(alpha: 0.9),
            fontSize: 14,
          ),
        ),
        
        if (_validationError != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.alertCircle, color: AppColors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _validationError!,
                    style: const TextStyle(color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
        
        const SizedBox(height: 40),
        
        _buildUploadButton(
          icon: LucideIcons.camera,
          label: 'Record Video',
          onTap: () => _pickVideo(ImageSource.camera),
        ),
        
        const SizedBox(height: 16),
        
        _buildUploadButton(
          icon: LucideIcons.folder,
          label: 'Choose from Gallery',
          onTap: () => _pickVideo(ImageSource.gallery),
        ),
      ],
    );
  }

  Widget _buildVideoPreview() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.checkCircle,
              size: 50,
              color: AppColors.success,
            ),
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Video Selected',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.black,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              _selectedVideo!.path.split('/').last,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.grey,
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          TextButton.icon(
            onPressed: () => setState(() => _selectedVideo = null),
            icon: const Icon(LucideIcons.x, color: AppColors.error),
            label: const Text(
              'Remove Video',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
