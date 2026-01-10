import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/media_controller.dart';
import '../../controllers/session_controller.dart';
import '../../controllers/goal_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets/local_types.dart';
import 'widgets/stat_card.dart';
import 'widgets/info_card.dart';
import 'widgets/logout_button.dart';

final authController = Get.find<AuthController>();
final mediaController = Get.find<MediaController>();
final sessionController = Get.find<SessionController>();
final goalController = Get.find<GoalController>();

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final spacing = LocalSpacing(
      xs: h * 0.006,
      s: h * 0.01,
      m: h * 0.014,
      l: h * 0.02,
      xl: h * 0.028,
    );
    final padding = LocalPadding(
      page: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.01),
      section: EdgeInsets.only(top: h * 0.02),
    );
    final sizes = LocalSizes(
      logo: h * 0.07,
      icon: h * 0.04,
      socialIcon: h * 0.03,
      textSmall: h * 0.016,
    );

    final double profileSize = h * 0.12;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.m),
            child: const Icon(Icons.settings),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(spacing.xs),
          child: Divider(
            height: spacing.xs,
            thickness: 1,
            color: Colors.grey.withValues(alpha: 0.5),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding.page,
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    Obx(() {
                      final avatarUrl = authController.appUser.value?.avatarUrl;
                      if (avatarUrl != null && avatarUrl.isNotEmpty) {
                        return Container(
                          width: profileSize,
                          height: profileSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(avatarUrl),
                            ),
                            border: Border.all(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey.withValues(alpha: 0.7)
                                  : Colors.white,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                blurRadius: 15,
                                spreadRadius: 2,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          width: profileSize,
                          height: profileSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                            border: Border.all(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey.withValues(alpha: 0.7)
                                  : Colors.white,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                blurRadius: 15,
                                spreadRadius: 2,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: profileSize * 0.5,
                          ),
                        );
                      }
                    }),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: () async {
                          if (FirebaseAuth.instance.currentUser == null) return;
                          await mediaController.pickUploadAndSetAvatar(
                            authController,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 4,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: spacing.s),

              Obx(() {
                final name = authController.appUser.value?.username ?? " ";
                return Text(
                  name,
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              }),

              SizedBox(height: spacing.xs),

              Obx(() {
                final uid = authController.appUser.value?.uid ?? " ";
                return Text(
                  "ID : $uid",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withValues(alpha: 0.6)
                        : Colors.black.withValues(alpha: 0.6),
                  ),
                );
              }),

              SizedBox(height: spacing.l),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    final secs = (sessionController.totalStudyTime.value is int)
                        ? sessionController.totalStudyTime.value as int
                        : int.tryParse(
                                sessionController.totalStudyTime.value
                                    .toString(),
                              ) ??
                              0;
                    final hours = secs ~/ 3600;
                    final hLabel = hours >= 1
                        ? "${hours}h"
                        : "${(secs / 60).ceil()}m";
                    return StatCard(
                      h1: hLabel,
                      h2: "Study Time",
                      spacing: spacing,
                      sizes: sizes,
                      icon: Icons.timer_outlined,
                    );
                  }),
                  SizedBox(height: spacing.s),
                  Obx(() {
                    final met = _computeWeeklyGoalsMet();
                    return StatCard(
                      h1: met.toString(),
                      h2: "Goals Met",
                      spacing: spacing,
                      sizes: sizes,
                      icon: Icons.outlined_flag,
                    );
                  }),
                ],
              ),

              SizedBox(height: spacing.l),

              InfoCard(
                spacing: spacing,
                sizes: sizes,
                onEditDepartment: _editDepartment,
                onEditClass: _editClass,
              ),

              SizedBox(height: spacing.m),

              LogoutButton(spacing: spacing, sizes: sizes),
              SizedBox(height: spacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  void _editDepartment(BuildContext context) {
    final current = authController.appUser.value?.department ?? '';
    final txt = TextEditingController(text: current);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Department'),
          content: TextField(
            controller: txt,
            decoration: const InputDecoration(
              hintText: 'e.g. Computer Science',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await authController.updateProfile(department: txt.text.trim());
                Get.snackbar(
                  'Updated',
                  'Department updated',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editClass(BuildContext context) {
    final current = authController.appUser.value?.classOf ?? '';
    final txt = TextEditingController(text: current);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Class'),
          content: TextField(
            controller: txt,
            decoration: const InputDecoration(hintText: 'e.g. Class of 2026'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await authController.updateProfile(classOf: txt.text.trim());
                Get.snackbar(
                  'Updated',
                  'Class updated',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  int _computeWeeklyGoalsMet() {
    final weeklySeconds = sessionController.weeklyBySubject.values.fold<int>(
      0,
      (sum, val) => sum + (val as int),
    );
    final weeklyMinutesTotal = weeklySeconds / 60.0;

    int met = 0;
    final globalWeekly = goalController.getGlobalWeeklyGoal();
    if (globalWeekly != null) {
      if (weeklyMinutesTotal >= globalWeekly.targetMinutes) met++;
    }

    for (final g in goalController.weeklyGoals) {
      if (g.subjectId == null || g.subjectId!.isEmpty) continue;
      final subjectSeconds =
          sessionController.weeklyBySubject[g.subjectId] ?? 0;
      final subjectMinutes = (subjectSeconds as int) / 60.0;
      if (subjectMinutes >= g.targetMinutes) met++;
    }
    return met;
  }
}
