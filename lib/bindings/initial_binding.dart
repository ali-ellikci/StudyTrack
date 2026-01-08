import 'package:get/get.dart';
import '../controllers/timer_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TimerController(), permanent: true);
  }
}
