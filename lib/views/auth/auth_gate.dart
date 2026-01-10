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
      if (u == null) {
        return LoginView();
      } else {
        return DashboardView();
      }
    });
  }
}
