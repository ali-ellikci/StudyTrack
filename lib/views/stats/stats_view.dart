import 'package:flutter/material.dart';
// Local UI metrics (moved from core/ui)
import 'widgets/daily_goal_card.dart';
import 'widgets/weekly_activity_card.dart';
import '../dashboard/widgets/weekly_goal_card.dart';
import '../dashboard/widgets/subject_progress_card.dart';

class StatsView extends StatelessWidget {
  StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final spacing = _LocalSpacing(
      xs: h * 0.006,
      s: h * 0.01,
      m: h * 0.014,
      l: h * 0.02,
      xl: h * 0.028,
    );
    final padding = _LocalPadding(
      page: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.01),
      section: EdgeInsets.only(top: h * 0.02),
    );
    final sizes = _LocalSizes(
      logo: h * 0.07,
      icon: h * 0.04,
      socialIcon: h * 0.03,
      textSmall: h * 0.016,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Merhaba"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(spacing.xs),
          child: Divider(
            height: spacing.xs,
            thickness: 1,
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding.page,
          child: Column(
            children: [
              DailyGoalCard(),
              SizedBox(height: 24),
              WeeklyGoalCard(),
              SizedBox(height: 24),
              SubjectProgressCard(),
              SizedBox(height: 24),
              WeeklyActivityCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocalSpacing {
  final double xs, s, m, l, xl;
  _LocalSpacing({required this.xs, required this.s, required this.m, required this.l, required this.xl});
}

class _LocalPadding {
  final EdgeInsets page, section;
  _LocalPadding({required this.page, required this.section});
}

class _LocalSizes {
  final double logo, icon, socialIcon, textSmall;
  _LocalSizes({required this.logo, required this.icon, required this.socialIcon, required this.textSmall});
}
