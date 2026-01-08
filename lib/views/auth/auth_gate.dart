import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../dashboard/dashboard_view.dart';
import 'login_view.dart';

class AuthGate extends StatelessWidget {
  AuthGate({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final u = authController.firebaseUser.value;
      print('[AuthGate] build: user=' + (u?.uid ?? 'null'));
      if (u == null) {
        print('[AuthGate] → showing LoginView');
        return LoginView();
      } else {
        print('[AuthGate] → showing DashboardView');
        return DashboardView();
      }
    });
  }
}
