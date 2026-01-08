import 'package:flutter/material.dart';
import '../grid_button.dart';

class CommunityButton extends StatelessWidget {
  const CommunityButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardGridButton(
      title: "Community",
      subtitle: "5 New Posts",
      icon: Icons.chat_bubble_outline_rounded,
      iconColor: Colors.greenAccent,
      pageName: '/community',
    );
  }
}
