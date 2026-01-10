import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.1),
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
                return RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: rxValue.value.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.light
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
          Obx(() {
            return SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: themeColor,
                inactiveTrackColor: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade200
                    : Theme.of(context).scaffoldBackgroundColor,
                trackHeight: 8,
                thumbColor: Colors.white,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 12,
                  elevation: 4,
                ),
                overlayColor: themeColor.withValues(alpha: 0.2),
              ),
              child: Slider(
                value: rxValue.value,
                min: 0,
                max: max,
                onChanged: (v) {
                  onChanged(v);
                },
                onChangeEnd: (v) async {
                  await onChangeEnd();
                },
              ),
            );
          }),
          const SizedBox(height: 8),
          Obx(() {
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
