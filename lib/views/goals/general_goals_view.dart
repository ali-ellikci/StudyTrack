import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'goals_view_ui_controller.dart';
import 'widgets/goal_card.dart';

class GeneralGoalsView extends StatelessWidget {
  GeneralGoalsView({super.key}) {
    
  }

  final GoalsUiController controller =
      Get.find<GoalsUiController>();

  @override
  Widget build(BuildContext context) {
    

    return Column(
      children: [
        
        GoalCard(
          title: "Daily Goal",
          subtitle: "Hours per day",
          rxValue: controller.dailySliderVal,
          max: 12,
          icon: Icons.wb_sunny_rounded,
          themeColor: const Color(0xFF5356FF),
          onChanged: (v) {
            controller.updateDaily(v);
          },
          onChangeEnd: () async {
            await controller.saveDaily();
          },
        ),

        const SizedBox(height: 24),
        GoalCard(
          title: "Weekly Goal",
          subtitle: "Total hours",
          rxValue: controller.weeklySliderVal,
          max: 80,
          icon: Icons.calendar_month_rounded,
          themeColor: const Color(0xFF9747FF),
          onChanged: (v) {
            controller.updateWeekly(v);
          },
          onChangeEnd: () async {
            await controller.saveWeekly();
          },
        ),
      ],
    );
  }
}


