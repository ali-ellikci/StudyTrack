import 'package:flutter/material.dart';
import '../grid_button.dart';

class StatisticsButton extends StatelessWidget {
  const StatisticsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardGridButton(
      title: "Statistics",
      subtitle: "View Trends",
      icon: Icons.bar_chart_rounded,
      iconColor: Colors.orangeAccent,
      pageName: '/stats',
    );
  }
}
