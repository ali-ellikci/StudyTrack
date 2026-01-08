import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_track/controllers/goal_controller.dart';
import 'package:study_track/controllers/session_controller.dart';
import 'package:study_track/controllers/subject_controller.dart';
import '../format.dart';

class SubjectProgressCard extends StatelessWidget {
  SubjectProgressCard({super.key});

  final SessionController sessionController = Get.find<SessionController>();
  final GoalController goalController = Get.find<GoalController>();
  final SubjectController subjectController = Get.find<SubjectController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final weeklyBySubject = sessionController.weeklyBySubject;
      final subjects = subjectController.subjects;

      if (subjects.isEmpty) {
        return const SizedBox.shrink();
      }

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
            Text(
              "Subjects (Week)",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: subjects.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final subject = subjects[i];
                final seconds = sessionController.weeklyBySubject[subject.id] ?? 0;
                final minutes = seconds / 60.0;
                final weeklyGoal = goalController.weeklyGoals.firstWhereOrNull(
                  (g) => g.subjectId == subject.id,
                );
                final targetMinutes = weeklyGoal?.targetMinutes ?? 0;
                final progress = targetMinutes > 0
                    ? (minutes / targetMinutes).clamp(0.0, 1.0)
                    : 0.0;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          subject.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "${formatMinutes(minutes)} / ${formatMinutes(targetMinutes.toDouble())}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: theme.scaffoldBackgroundColor,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress >= 1.0 ? Colors.green : Colors.blue.shade400,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
