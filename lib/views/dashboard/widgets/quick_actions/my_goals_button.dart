import 'package:flutter/material.dart';
import '../grid_button.dart';

class MyGoalsButton extends StatelessWidget {
  const MyGoalsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardGridButton(
      title: "My Goals",
      subtitle: "3 Pending",
      icon: Icons.flag_rounded,
      iconColor: Colors.purpleAccent,
      pageName: '/goals',
    );
  }
}
