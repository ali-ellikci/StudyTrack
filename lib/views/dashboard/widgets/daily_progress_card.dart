import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:study_track/controllers/goal_controller.dart';
import 'package:study_track/controllers/session_controller.dart';
import '../format.dart';

class DailyProgressCard extends StatelessWidget {
  DailyProgressCard({super.key});

  final SessionController sessionController = Get.find<SessionController>();
  final GoalController goalController = Get.find<GoalController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final dailyGoal = goalController.dailyGoals.firstWhereOrNull(
        (g) => !g.hasSubject,
      );
      final dailyTargetMinutes = dailyGoal?.targetMinutes ?? 240;
      final currentDailyMinutes = sessionController.todayStudyTime.value / 60.0;
      final dailyProgress = (currentDailyMinutes / dailyTargetMinutes).clamp(
        0.0,
        1.0,
      );

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Daily Progress",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_fire_department_rounded,
                        color: theme.colorScheme.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "3 Day Streak",
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            CircularPercentIndicator(
              radius: 85,
              lineWidth: 12,
              percent: dailyProgress,
              animation: true,
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: theme.scaffoldBackgroundColor,
              linearGradient: LinearGradient(
                colors: [theme.colorScheme.primary, Colors.cyanAccent],
              ),
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Study Time", style: theme.textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(
                    formatMinutes(currentDailyMinutes),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "/ ${formatMinutes(dailyTargetMinutes.toDouble())} goal",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              dailyProgress >= 1.0
                  ? "Congrats! You reached your daily goal! 🎉"
                  : "Keep going! You're getting close to your daily goal!",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey
                    : Colors.black,
              ),
            ),
          ],
        ),
      );
    });
  }
}
