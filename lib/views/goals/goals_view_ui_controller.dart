import 'package:get/get.dart';
import '../../controllers/goal_controller.dart';


class GoalsUiController extends GetxController {
  final GoalController goalController = Get.find();

  var dailySliderVal = 0.0.obs;
  var weeklySliderVal = 0.0.obs;

  var isGeneralSelected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialValues();
  }

  void _loadInitialValues() {
    final dailyGoal = goalController.getGlobalDailyGoal();
    if (dailyGoal != null) {
      dailySliderVal.value = dailyGoal.targetMinutes / 60.0;
    }

    final weeklyGoal = goalController.getGlobalWeeklyGoal();
    if (weeklyGoal != null) {
      weeklySliderVal.value = weeklyGoal.targetMinutes / 60.0;
    }
  }

  void updateDaily(double val) => dailySliderVal.value = val;
  void updateWeekly(double val) => weeklySliderVal.value = val;

  Future<void> saveDaily() async {
    await goalController.saveDailyGoal(
      subjectId: null,
      minutes: (dailySliderVal.value * 60).round(),
    );
  }

  Future<void> saveWeekly() async {
    await goalController.saveWeeklyGoal(
      subjectId: null,
      minutes: (weeklySliderVal.value * 60).round(),
    );
  }

  void changeTab(bool isGeneral) => isGeneralSelected.value = isGeneral;
}
