import 'package:flutter/material.dart';
import '../grid_button.dart';

class MySubjectsButton extends StatelessWidget {
  const MySubjectsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardGridButton(
      title: "My Subjects",
      subtitle: "You have 3 subjects",
      icon: Icons.book_outlined,
      iconColor: Colors.blue,
      pageName: '/subjects',
    );
  }
}
