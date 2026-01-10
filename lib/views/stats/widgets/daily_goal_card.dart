import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/goal_controller.dart';
import '../../../controllers/session_controller.dart';

class DailyGoalCard extends StatelessWidget {
  const DailyGoalCard({super.key});

  @override
  Widget build(BuildContext context) {
    final goalController = Get.find<GoalController>();
    final sessionController = Get.find<SessionController>();
    final theme = Theme.of(context);

    return Obx(() {
      final dailyGoal = goalController.dailyGoals.firstWhereOrNull(
        (g) => !g.hasSubject,
      );

        final int dailyTargetMinutes = dailyGoal?.targetMinutes ?? 240;
      final double currentDailyMinutes =
          sessionController.todayStudyTime.value / 60.0;

      final double dailyProgress = (dailyTargetMinutes > 0)
          ? (currentDailyMinutes / dailyTargetMinutes).clamp(0.0, 1.0)
          : 0.0;

      final int percentage = (dailyProgress * 100).toInt();

      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "DAILY GOAL",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          "$percentage",
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 48,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        Text(
                          "%",
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "completed",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.timer_outlined,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time_filled,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatDuration(currentDailyMinutes.toInt()),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Target: ${_formatDuration(dailyTargetMinutes)}",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: dailyProgress,
                minHeight: 12,
                backgroundColor: Colors.grey.withOpacity(0.15),
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      );
    });
  }

  String _formatDuration(int totalMinutes) {
    if (totalMinutes <= 0) return "0h 0m";
    final int hours = totalMinutes ~/ 60;
    final int minutes = totalMinutes % 60;
    return "${hours}h ${minutes}m";
  }
}
