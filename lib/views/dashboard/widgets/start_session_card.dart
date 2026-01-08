import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class StartSessionCard extends StatelessWidget {
  const StartSessionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.timer);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [primary.withOpacity(0.8), primary]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Start Session",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Focus Timer & Tracker",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
            const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }
}
