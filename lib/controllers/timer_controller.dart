import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class TimerController extends GetxController with WidgetsBindingObserver {
  Timer? _timer;

  final totalSeconds = (25 * 60).obs;
  final remainingSeconds = (25 * 60).obs;
  final elapsedSeconds = (0).obs;
  final isRunning = false.obs;

  DateTime? _startTime;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && isRunning.value) {
      // 👇 EKRAN AÇILDI → GERÇEK ZAMANI HESAPLA
      _recalculateRemaining();
    }
  }

  String get timeDisplay {
    final m = remainingSeconds.value ~/ 60;
    final s = remainingSeconds.value % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  double get percent {
    if (totalSeconds.value == 0) return 0.0;
    return remainingSeconds.value / totalSeconds.value;
  }

  void _updateElapsedSeconds() {
    elapsedSeconds.value = totalSeconds.value - remainingSeconds.value;
  }

  void setDuration(Duration duration) {
    pauseTimer();
    totalSeconds.value = duration.inSeconds;
    remainingSeconds.value = duration.inSeconds;
    _updateElapsedSeconds();
    _startTime = null;
  }

  void startTimer() {
    if (isRunning.value) return;

    isRunning.value = true;
    _startTime ??= DateTime.now();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _recalculateRemaining(),
    );
  }

  void _recalculateRemaining() {
    if (_startTime == null) return;

    final elapsed = DateTime.now().difference(_startTime!).inSeconds;

    final left = totalSeconds.value - elapsed;

    if (left <= 0) {
      remainingSeconds.value = 0;
      _updateElapsedSeconds();
      pauseTimer();
      Get.snackbar("Congratulations!", "You completed the target time");
    } else {
      remainingSeconds.value = left;
      _updateElapsedSeconds();
    }
  }

  void pauseTimer() {
    _timer?.cancel();
    _timer = null;
    isRunning.value = false;
  }

  void toggleTimer() {
    isRunning.value ? pauseTimer() : startTimer();
  }

  void resetTimer() {
    pauseTimer();
    _startTime = null;
    remainingSeconds.value = totalSeconds.value;
    _updateElapsedSeconds();
  }
}
