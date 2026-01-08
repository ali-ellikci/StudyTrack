import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/subject_controller.dart';
import '../../controllers/goal_controller.dart';
import '../../models/subject_model.dart';

class SubjectsGoalsView extends StatelessWidget {
  SubjectsGoalsView({super.key});

  final SubjectController subjectController = Get.find();
  final GoalController goalController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(),
        const SizedBox(height: 12),

        Obx(() {
          if (subjectController.subjects.isEmpty) {
            return _empty();
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: subjectController.subjects.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, i) {
              final subject = subjectController.subjects[i];
              return Obx(() {
                final weeklyGoal = goalController.weeklyGoals.firstWhereOrNull(
                  (g) => g.subjectId == subject.id,
                );

                final hours = weeklyGoal == null
                    ? 0.0
                    : weeklyGoal.targetMinutes / 60.0;

                return SubjectGoalCard(
                  subject: subject,
                  weeklyHours: hours,
                  onTap: () => _openEditSheet(context, subject, hours),
                );
              });
            },
          );
        }),
      ],
    );
  }

  /* ================= HEADER ================= */

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "PRIORITY SUBJECTS",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.grey.shade600,
          ),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 18),
          label: const Text("Add New"),
        ),
      ],
    );
  }

  Widget _empty() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(child: Text("No subjects yet")),
    );
  }

  /* ================= EDIT SHEET ================= */

  void _openEditSheet(
    BuildContext context,
    SubjectModel subject,
    double initialHours,
  ) {
    final sliderVal = initialHours.toDouble().obs;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              Obx(
                () => Text(
                  "Weekly Target: ${sliderVal.value.toStringAsFixed(1)} h",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Obx(
                () => Slider(
                  min: 0,
                  max: 40,
                  value: sliderVal.value,
                  onChanged: (v) => sliderVal.value = v,
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await goalController.saveWeeklyGoal(
                      subjectId: subject.id,
                      minutes: (sliderVal.value * 60).round(),
                    );
                    Get.back();
                  },
                  child: const Text("Save"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SubjectGoalCard extends StatelessWidget {
  final SubjectModel subject;
  final double weeklyHours;
  final VoidCallback onTap;

  const SubjectGoalCard({
    super.key,
    required this.subject,
    required this.weeklyHours,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${weeklyHours.toStringAsFixed(1)} h / week",
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.edit, size: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
