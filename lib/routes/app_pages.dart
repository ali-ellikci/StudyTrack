import 'package:get/get.dart';
import '../views/auth/login_view.dart';
import '../views/auth/register_view.dart';
import '../views/dashboard/dashboard_view.dart';
import '../views/profile/profile_view.dart';
import '../views/timer/timer_view.dart';
import '../views/goals/goals_view.dart';
import '../views/subjects/subjects_view.dart';
import '../views/stats/stats_view.dart';
import '../views/community/community_view.dart';
import 'directional_slide_transition.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.login, page: () => LoginView()),
    GetPage(name: AppRoutes.register, page: () => RegisterView()),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardView(),
      customTransition: DirectionalSlideTransition(),
      transitionDuration: const Duration(milliseconds: 280),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileView(),
      customTransition: DirectionalSlideTransition(),
      transitionDuration: const Duration(milliseconds: 280),
    ),
    GetPage(name: AppRoutes.timer, page: () => TimerView()),
    GetPage(name: AppRoutes.goals, page: () => GoalsView()),
    GetPage(name: AppRoutes.subjects, page: () => LessonsView()),
    GetPage(name: AppRoutes.stats, page: () => StatsView()),
    GetPage(
      name: AppRoutes.community,
      page: () => CommunityView(),
      customTransition: DirectionalSlideTransition(),
      transitionDuration: const Duration(milliseconds: 280),
    )
  ];
}
