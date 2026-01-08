import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_track/controllers/session_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/goal_controller.dart';
import '../../controllers/subject_controller.dart';

import 'widgets/header.dart';
import 'widgets/daily_progress_card.dart';
import 'widgets/start_session_card.dart';
import 'widgets/motivation_card.dart';
import 'widgets/quick_actions/my_goals_button.dart';
import 'widgets/quick_actions/statistics_button.dart';
import 'widgets/quick_actions/community_button.dart';
import 'widgets/quick_actions/my_subjects_button.dart';

const double dPagePadding = 24;
const double dSectionGap = 28;
const double dTitleGap = 24;
const double dCardGap = 16;
const double dSmallGap = 12;

class DashboardView extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final SessionController sessionController = Get.find<SessionController>();
  final GoalController goalController = Get.find<GoalController>();
  final subjectController = Get.find<SubjectController>();

  DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final appUser = authController.appUser.value;
          if (appUser == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (appUser.username.isEmpty) {
            return const Center(child: Text("There is no User data"));
          }
          sessionController.fetchTotalStudyTime(appUser.uid);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(dPagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DashboardHeader(userName: appUser.username),
                const SizedBox(height: dTitleGap),
                DailyProgressCard(),
                const SizedBox(height: dSectionGap),
                // WeeklyGoalCard moved to Stats page
                // SubjectProgressCard moved to Stats page
                Text(
                  "Quick Actions",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: dTitleGap),
                const StartSessionCard(),
                const SizedBox(height: dCardGap),
                Row(
                  children: [
                    const Expanded(child: MyGoalsButton()),
                    const SizedBox(width: dCardGap),
                    const Expanded(child: StatisticsButton()),
                  ],
                ),
                const SizedBox(height: dCardGap),
                Row(
                  children: [
                    const Expanded(child: CommunityButton()),
                    const SizedBox(width: dCardGap),
                    const Expanded(child: MySubjectsButton()),
                  ],
                ),
                const SizedBox(height: dTitleGap),
              ],
            ),
          );
        }),
      ),
    );
  }
}
