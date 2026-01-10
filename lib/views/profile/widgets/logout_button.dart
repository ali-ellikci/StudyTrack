import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import 'local_types.dart';

final authController = Get.find<AuthController>();

class LogoutButton extends StatelessWidget {
  final LocalSpacing spacing;
  final LocalSizes sizes;
  const LogoutButton({super.key, required this.spacing, required this.sizes});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        authController.logout();
        Get.toNamed('/login');
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.06,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.lerp(
            Theme.of(context).scaffoldBackgroundColor,
            Colors.white,
            0.05,
          )!,
          borderRadius: BorderRadius.circular(spacing.m),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.redAccent, size: sizes.icon * 0.7),
            SizedBox(width: spacing.s),
            Text(
              "Log Out",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}
