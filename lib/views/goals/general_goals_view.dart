import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'goals_view_ui_controller.dart';

class GeneralGoalsView extends StatelessWidget {
  GeneralGoalsView({super.key}) {
    debugPrint("🟢 GeneralGoalsView CREATED");
  }

  final GoalsUiController controller =
      Get.find<GoalsUiController>(); // TEK INSTANCE

  @override
  Widget build(BuildContext context) {
    debugPrint("🟢 GeneralGoalsView BUILD");

    return Column(
      children: [
        /// ================= DAILY =================
        GoalCard(
          title: "Daily Goal",
          subtitle: "Hours per day",
          rxValue: controller.dailySliderVal,
          max: 12,
          icon: Icons.wb_sunny_rounded,
          themeColor: const Color(0xFF5356FF),
          onChanged: (v) {
            debugPrint("🟡 DAILY onChanged => $v");
            controller.updateDaily(v);
          },
          onChangeEnd: () async {
            debugPrint("🔵 DAILY onChangeEnd -> saveDaily()");
            await controller.saveDaily();
            debugPrint("✅ DAILY saveDaily DONE");
          },
        ),

        const SizedBox(height: 24),

        /// ================= WEEKLY =================
        GoalCard(
          title: "Weekly Goal",
          subtitle: "Total hours",
          rxValue: controller.weeklySliderVal,
          max: 80,
          icon: Icons.calendar_month_rounded,
          themeColor: const Color(0xFF9747FF),
          onChanged: (v) {
            debugPrint("🟡 WEEKLY onChanged => $v");
            controller.updateWeekly(v);
          },
          onChangeEnd: () async {
            debugPrint("🔵 WEEKLY onChangeEnd -> saveWeekly()");
            await controller.saveWeekly();
            debugPrint("✅ WEEKLY saveWeekly DONE");
          },
        ),
      ],
    );
  }
}

/// ======================================================================
/// =============================== CARD ================================
/// ======================================================================

class GoalCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final RxDouble rxValue;
  final double max;
  final IconData icon;
  final Color themeColor;
  final Function(double) onChanged;
  final Future<void> Function() onChangeEnd;

  const GoalCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.rxValue,
    required this.max,
    required this.icon,
    required this.themeColor,
    required this.onChanged,
    required this.onChangeEnd,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("🧱 GoalCard BUILD => $title | value=${rxValue.value}");

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Color.lerp(
                Theme.of(context).scaffoldBackgroundColor,
                Colors.white,
                0.1,
              ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          /// ================= HEADER =================
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: themeColor, size: 24),
              ),
              const SizedBox(width: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Obx(() {
                debugPrint("🔁 Obx TEXT [$title] => ${rxValue.value}");
                return RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: rxValue.value.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      const TextSpan(
                        text: " h",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),

          const SizedBox(height: 24),

          /// ================= SLIDER =================
          Obx(() {
            debugPrint("🎚 Slider REBUILD [$title] => ${rxValue.value}");
            return SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: themeColor,
                inactiveTrackColor:
                    Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade200
                    : Theme.of(context).scaffoldBackgroundColor,
                trackHeight: 8,
                thumbColor: Colors.white,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 12,
                  elevation: 4,
                ),
                overlayColor: themeColor.withOpacity(0.2),
              ),
              child: Slider(
                value: rxValue.value,
                min: 0,
                max: max,
                onChanged: (v) {
                  debugPrint("🟡 SLIDER MOVE [$title] => $v");
                  onChanged(v);
                },
                onChangeEnd: (v) async {
                  debugPrint("🔵 SLIDER END [$title] => $v");
                  await onChangeEnd();
                  debugPrint("✅ SLIDER SAVE DONE [$title]");
                },
              ),
            );
          }),

          const SizedBox(height: 8),

          /// ================= FOOTER =================
          Obx(() {
            debugPrint("📦 FOOTER REBUILD [$title] => ${rxValue.value}");
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "0H",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "TARGET: ${rxValue.value.toStringAsFixed(1)}H",
                  style: TextStyle(
                    color: themeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  "${max.toInt()}H",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
