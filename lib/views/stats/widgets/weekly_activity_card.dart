import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../controllers/session_controller.dart';

class WeeklyActivityCard extends StatelessWidget {
  const WeeklyActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final _ = Get.find<SessionController>();

    return FutureBuilder<List<_DayStat>>(
      future: _fetchLast7Days(),
      builder: (context, snapshot) {
        final days = snapshot.data ?? _emptyLast7Days();

        final int totalWeeklyMinutes = days.fold(
          0,
          (sum, d) => sum + d.minutes,
        );

        int maxMinutes = days.map((e) => e.minutes).fold(0, (a, b) => a > b ? a : b);
        if (maxMinutes == 0) maxMinutes = 1;

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
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "WEEKLY ACTIVITY",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _formatDuration(totalWeeklyMinutes),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F7FA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "↗ +0%",
                      style: TextStyle(
                        color: Color(0xFF00BFA5),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 140,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final d in days)
                      _buildBar(
                        context,
                        label: d.label,
                        fillPercent: d.minutes / maxMinutes,
                        isActive: d.isToday,
                        color: theme.colorScheme.primary,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBar(
    BuildContext context, {
    required String label,
    required double fillPercent,
    required bool isActive,
    required Color color,
  }) {
    const double barMaxHeight = 100;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: barMaxHeight,
          width: 32,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width:
                    12,
                height: barMaxHeight,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: 12,
                    height:
                        constraints.maxHeight * fillPercent,
                    decoration: BoxDecoration(
                      color: isActive
                          ? color
                          : color.withOpacity(
                              0.3,
                            ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: color.withOpacity(0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Text(
          label,
          style: TextStyle(
            color: isActive ? color : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  String _formatDuration(int totalMinutes) {
    if (totalMinutes <= 0) return "0h 0m";
    final int hours = totalMinutes ~/ 60;
    final int minutes = totalMinutes % 60;
    return "${hours}h ${minutes}m";
  }

  Future<List<_DayStat>> _fetchLast7Days() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return _emptyLast7Days();

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
    final end = DateTime(now.year, now.month, now.day + 1);

    final snap = await FirebaseFirestore.instance
        .collection('study_sessions')
        .where('userId', isEqualTo: user.uid)
        .where('startedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('startedAt', isLessThan: Timestamp.fromDate(end))
        .get();

    final Map<DateTime, int> secondsByDay = {
      for (int i = 0; i < 7; i++)
        DateTime(start.year, start.month, start.day + i): 0,
    };

    for (final doc in snap.docs) {
      final data = doc.data();
      final ts = data['startedAt'] as Timestamp?;
      if (ts == null) continue;
      final d = ts.toDate();
      final dayKey = DateTime(d.year, d.month, d.day);
      final duration = (data['duration'] ?? 0) as int;
      if (secondsByDay.containsKey(dayKey)) {
        secondsByDay[dayKey] = (secondsByDay[dayKey] ?? 0) + duration;
      }
    }

    final todayKey = DateTime(now.year, now.month, now.day);
    final labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    final List<_DayStat> items = [];
    for (int i = 0; i < 7; i++) {
      final day = DateTime(start.year, start.month, start.day + i);
      final seconds = secondsByDay[day] ?? 0;
      final minutes = (seconds / 60).round();
      final isToday = day == todayKey;
      final weekdayIndex = (day.weekday - 1);
      items.add(_DayStat(label: labels[weekdayIndex], minutes: minutes, isToday: isToday));
    }
    return items;
  }

  List<_DayStat> _emptyLast7Days() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
    final labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final List<_DayStat> items = [];
    for (int i = 0; i < 7; i++) {
      final day = DateTime(start.year, start.month, start.day + i);
      final weekdayIndex = day.weekday % 7;
      items.add(
        _DayStat(label: labels[weekdayIndex], minutes: 0, isToday: _isSameDay(day, now)),
      );
    }
    return items;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _DayStat {
  final String label;
  final int minutes;
  final bool isToday;
  _DayStat({required this.label, required this.minutes, required this.isToday});
}
