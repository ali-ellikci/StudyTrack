import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import '../services/session_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SessionController extends GetxController with WidgetsBindingObserver {
  final _sessionService = SessionService();
  final _auth = FirebaseAuth.instance;

  Rx totalStudyTime = 0.obs;
  Rx todayStudyTime = 0.obs;
  RxMap<String, int> todayBySubject = <String, int>{}.obs;
  RxMap<String, int> weeklyBySubject = <String, int>{}.obs;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    // If user already available, fetch immediately
    final user = _auth.currentUser;
    if (user != null) {
      fetchTotalStudyTime(user.uid);
    }

    // React to auth changes (login/logout) to refresh metrics
    _auth.authStateChanges().listen((u) {
      if (u != null) {
        fetchTotalStudyTime(u.uid);
      } else {
        totalStudyTime.value = 0;
        todayStudyTime.value = 0;
        todayBySubject.clear();
        weeklyBySubject.clear();
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final user = _auth.currentUser;
      if (user != null) {
        fetchTotalStudyTime(user.uid);
      }
    }
  }

  Future<void> saveSession({
    required userId,
    required subjectId,
    required duration,
  }) async {
    print(duration);
    await _sessionService.saveSession(
      userId: userId,
      subjectId: subjectId,
      duration: duration,
    );
    // Save ettikten sonra hemen refresh et
    await fetchTotalStudyTime(userId);
  }

  Future<void> fetchTotalStudyTime(String uId) async {
    print(uId);
    totalStudyTime.value = await _sessionService.getAllStudyTime(uId: uId);

    // Bugünün verisi
    todayStudyTime.value = await _sessionService.getTodayStudyTime(uId: uId);

    // Subject başına veriler
    todayBySubject.value = await _sessionService.getTodayStudyTimeBySubject(
      uId: uId,
    );
    weeklyBySubject.value = await _sessionService.getWeeklyStudyTimeBySubject(
      uId: uId,
    );

    RxInt getWeeklySecondsForSubject(int subjectId) {
      return RxInt(weeklyBySubject[subjectId] ?? 0);
    }
  }
}
