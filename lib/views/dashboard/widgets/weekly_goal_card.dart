import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_track/controllers/goal_controller.dart';
import 'package:study_track/controllers/session_controller.dart';
import '../format.dart';

class WeeklyGoalCard extends StatelessWidget {
  WeeklyGoalCard({super.key});

  final GoalController goalController = Get.find<GoalController>();
  final SessionController sessionController = Get.find<SessionController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final weeklyGoal = goalController.getGlobalWeeklyGoal();
      final weeklyTargetMinutes = weeklyGoal?.targetMinutes ?? 1200;
      final targetHours = weeklyTargetMinutes / 60;

      final weeklyStudySeconds = sessionController.weeklyBySubject.values
          .fold<int>(0, (sum, val) => sum + val);
      final weeklyStudyMinutes = weeklyStudySeconds / 60.0;
      final weeklyProgress = weeklyTargetMinutes > 0
          ? (weeklyStudyMinutes / weeklyTargetMinutes)
          : 0.0;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Weekly Goal",
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
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_rounded,
                        color: Colors.orange,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${targetHours.toInt()}h Target",
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: weeklyProgress.clamp(0.0, 1.0),
                minHeight: 12,
                backgroundColor: theme.scaffoldBackgroundColor,
                valueColor: AlwaysStoppedAnimation<Color>(
                  weeklyProgress >= 1.0
                      ? Colors.green
                      : Colors.orange.withOpacity(0.7),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${formatMinutes(weeklyStudyMinutes)} / ${targetHours.toStringAsFixed(1)}h",
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "${(weeklyProgress * 100).toStringAsFixed(0)}%",
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: weeklyProgress >= 1.0 ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Get.toNamed('/goals'),
                icon: const Icon(Icons.edit_rounded, size: 18),
                label: const Text("Manage Goals"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.9),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
