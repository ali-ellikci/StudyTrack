import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/subject_controller.dart';
// Local UI metrics (moved from core/ui)

import 'custom_tab_switcher.dart';
import 'goals_view_ui_controller.dart';
import 'general_goals_view.dart';
import 'subjects_goals_view.dart';

class GoalsView extends StatelessWidget {
  GoalsView({super.key});

  /// UI controller – tek instance
  final GoalsUiController uiController = Get.put(
    GoalsUiController(),
    permanent: true,
  );

  /// SubjectController zaten globalde put edilmiş
  final SubjectController subjectController = Get.find<SubjectController>();

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
        title: const Text("Goals"),
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
      body: SafeArea(
        child: Column(
          children: [
            /// TAB SWITCHER
            Obx(
              () => CustomTabSwitcher(
                isGeneralSelected: uiController.isGeneralSelected.value,
                onTabChanged: uiController.changeTab,
              ),
            ),

            SizedBox(height: spacing.m),

            /// HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Set Your Targets",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            SizedBox(height: spacing.m),

            /// CONTENT
            Expanded(
              child: Obx(
                () => SingleChildScrollView(
                  padding: padding.page,
                  child: uiController.isGeneralSelected.value
                      ? GeneralGoalsView()
                      : SubjectsGoalsView(),
                ),
              ),
            ),
          ],
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
