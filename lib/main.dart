import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:study_track/controllers/auth_controller.dart';
import 'package:study_track/controllers/goal_controller.dart';
import 'package:study_track/controllers/timer_controller.dart';
import 'package:study_track/controllers/subject_controller.dart';
import 'package:study_track/controllers/session_controller.dart';
import 'package:study_track/firebase_options.dart';
import 'routes/app_pages.dart';
import 'theme/app_theme.dart';
import 'views/auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Global error logging to avoid silent crashes
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // Optionally send to analytics/crashlytics here
  };
  WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
    debugPrint('[UNCAUGHT] $error\n$stack');
    return true; // prevent hard crash
  };
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthController());
  Get.put(GoalController());
  Get.put(TimerController(), permanent: true);
  Get.put(SubjectController());
  Get.put(SessionController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
      getPages: AppPages.pages,
      // Smooth slide transition across all route changes
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 280),
    );
  }
}
