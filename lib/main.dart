import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:study_track/controllers/auth_controller.dart';
import 'package:study_track/controllers/goal_controller.dart';
import 'package:study_track/controllers/timer_controller.dart';
import 'package:study_track/controllers/subject_controller.dart';
import 'package:study_track/controllers/session_controller.dart';
import 'package:study_track/controllers/post_controller.dart';
import 'package:study_track/controllers/media_controller.dart';
import 'package:study_track/firebase_options.dart';
import 'routes/app_pages.dart';
import 'theme/app_theme.dart';
import 'views/auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };
  WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
    return true;
  };
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthController());
  Get.put(GoalController());
  Get.put(TimerController(), permanent: true);
  Get.put(SubjectController());
  Get.put(SessionController());
  Get.put(PostController());
  Get.put(MediaController(), permanent: true);
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
      title: 'study_tracker',
      home: AuthGate(),
      getPages: AppPages.pages,

      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 280),
    );
  }
}
