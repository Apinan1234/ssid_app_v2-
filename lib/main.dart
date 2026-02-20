import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/instructor_home_screen.dart';
import 'screens/instructor_profile_screen.dart';
import 'screens/upload_screen.dart';
import 'screens/analysis_result_screen.dart';
import 'screens/notification_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/notification_provider.dart';
import 'utils/mock_data_seeder.dart';
import 'services/database_helper.dart';
import 'services/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Seed mock data for SQLite (for testing/screenshots)
  await MockDataSeeder.seedData();
  
  // Sync existing users to Firebase (one-time)
  try {
    final db = DatabaseHelper.instance;
    final firestore = FirestoreService();
    final users = await db.getAllUsers();
    
    if (users.isNotEmpty) {
      debugPrint('Syncing ${users.length} users to Firebase...');
      for (var user in users) {
        try {
          await firestore.createUser(
            email: user['email'] as String,
            name: user['name'] as String,
            role: user['role'] as String,
          );
        } catch (e) {
          // Ignore if user already exists
          debugPrint('User ${user['email']} sync skipped: $e');
        }
      }
      debugPrint('User sync completed');
    }
  } catch (e) {
    debugPrint('User sync error: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'SSID Platform',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const RoleBasedHomeScreen(),
          '/instructor-home': (context) => const InstructorHomeScreen(),
          '/instructor-profile': (context) => const InstructorProfileScreen(),
          '/upload': (context) => const UploadScreen(),
          '/analysis': (context) => const AnalysisResultScreen(),
          '/notifications': (context) => const NotificationScreen(),
        },
      ),
    );
  }
}

/// Determines which home screen to show based on user role
class RoleBasedHomeScreen extends StatelessWidget {
  const RoleBasedHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    
    if (auth.isInstructor) {
      return const InstructorHomeScreen();
    }
    return const HomeScreen();
  }
}
