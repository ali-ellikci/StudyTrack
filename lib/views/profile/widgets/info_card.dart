import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import 'local_types.dart';
import 'info_row.dart';

final authController = Get.find<AuthController>();

class InfoCard extends StatelessWidget {
  final LocalSpacing spacing;
  final LocalSizes sizes;
  final void Function(BuildContext) onEditDepartment;
  final void Function(BuildContext) onEditClass;
  const InfoCard({
    super.key,
    required this.spacing,
    required this.sizes,
    required this.onEditDepartment,
    required this.onEditClass,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: spacing.m, horizontal: spacing.m),
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
      child: Column(
        children: [
          Obx(() {
            final email = authController.appUser.value?.email ?? "";
            return InfoRow(
              h1: "Email",
              h2: email,
              spacing: spacing,
              sizes: sizes,
              icon: Icons.mail_outline,
            );
          }),
          Divider(color: Colors.grey.withValues(alpha: 0.5)),
          GestureDetector(
            onTap: () => onEditDepartment(context),
            child: Obx(() {
              final dep =
                  authController.appUser.value?.department ?? "Add department";
              return InfoRow(
                h1: "Department",
                h2: dep,
                spacing: spacing,
                sizes: sizes,
                icon: Icons.business,
              );
            }),
          ),
          Divider(color: Colors.grey.withValues(alpha: 0.5)),
          GestureDetector(
            onTap: () => onEditClass(context),
            child: Obx(() {
              final cls = authController.appUser.value?.classOf ?? "Add class";
              return InfoRow(
                h1: "Class",
                h2: cls,
                spacing: spacing,
                sizes: sizes,
                icon: Icons.school_outlined,
              );
            }),
          ),
        ],
      ),
    );
  }
}
