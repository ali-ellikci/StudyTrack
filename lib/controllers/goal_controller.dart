import 'package:get/get.dart';
import '../models/goal_model.dart';
import '../services/goal_service.dart';
import 'auth_controller.dart';

class GoalController extends GetxController {
  final GoalService _service = GoalService();
  final AuthController authController = Get.find<AuthController>();

  final RxList<Goal> dailyGoals = <Goal>[].obs;
  final RxList<Goal> weeklyGoals = <Goal>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load immediately if user already available
    final user = authController.appUser.value;
    if (user != null) {
      final uid = user.uid;
      _loadDailyGoals(uid);
      _loadWeeklyGoals(uid);
    }

    // Also react to future auth changes to ensure initial fetch happens
    ever(authController.appUser, (appUser) {
      if (appUser != null) {
        final uid = appUser.uid;
        _loadDailyGoals(uid);
        _loadWeeklyGoals(uid);
      } else {
        dailyGoals.clear();
        weeklyGoals.clear();
      }
    });
  }

  Future<void> _loadDailyGoals(String uid) async {
    final data = await _service.getDailyGoals(uId: uid);
    dailyGoals.assignAll(data);
  }

  Future<void> _loadWeeklyGoals(String uid) async {
    final data = await _service.getWeeklyGoals(uId: uid);
    weeklyGoals.assignAll(data);
  }

  Goal? getGlobalDailyGoal() =>
      dailyGoals.firstWhereOrNull((g) => !g.hasSubject);

  Goal? getGlobalWeeklyGoal() =>
      weeklyGoals.firstWhereOrNull((g) => !g.hasSubject);

  Future<void> saveDailyGoal({String? subjectId, required int minutes}) async {
    final uid = authController.appUser.value!.uid;
    try {
      await _service.setDailyGoal(
        uId: uid,
        subjectId: subjectId,
        targetMinutes: minutes,
      );
      await _loadDailyGoals(uid);
    } catch (e) {
      Get.snackbar(
        "Connection Error",
        "Couldn't save daily goal. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> saveWeeklyGoal({String? subjectId, required int minutes}) async {
    final uid = authController.appUser.value!.uid;
    try {
      await _service.setWeeklyGoal(
        uId: uid,
        subjectId: subjectId,
        targetMinutes: minutes,
      );
      await _loadWeeklyGoals(uid);
    } catch (e) {
      Get.snackbar(
        "Connection Error",
        "Couldn't save weekly goal. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
