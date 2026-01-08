import 'package:cloud_firestore/cloud_firestore.dart';

class SessionService {
  final _db = FirebaseFirestore.instance;

  Future<void> saveSession({
    required userId,
    required subjectId,
    required duration,
  }) async {
    await _db.collection("study_sessions").add({
      'userId': userId,
      'subjectId': subjectId,
      'duration': duration,
      'startedAt': FieldValue.serverTimestamp(),
      'endedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<int> getAllStudyTime({required String uId}) async {
    final snapshot = await _db
        .collection("study_sessions")
        .where("userId", isEqualTo: uId)
        .get();
    int totalDocs = snapshot.docs.length;

    print("Toplam session: $totalDocs");
    final total = snapshot.docs.fold<int>(
      0,
      (sum, doc) => sum + ((doc.data()['duration'] ?? 0) as int),
    );
    return total;
  }

  /// Bugün ders yap'ılan toplam süre (dakika)
  Future<int> getTodayStudyTime({required String uId}) async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final snapshot = await _db
        .collection("study_sessions")
        .where("userId", isEqualTo: uId)
        .where(
          "startedAt",
          isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart),
        )
        .where("startedAt", isLessThan: Timestamp.fromDate(todayEnd))
        .get();

    final total = snapshot.docs.fold<int>(
      0,
      (sum, doc) => sum + ((doc.data()['duration'] ?? 0) as int),
    );
    return total;
  }

  /// Hafta içinde per subject progress
  Future<Map<String, int>> getWeeklyStudyTimeBySubject({
    required String uId,
  }) async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDay = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day,
    );

    final snapshot = await _db
        .collection("study_sessions")
        .where("userId", isEqualTo: uId)
        .where(
          "startedAt",
          isGreaterThanOrEqualTo: Timestamp.fromDate(weekStartDay),
        )
        .get();

    final Map<String, int> bySubject = {};
    for (var doc in snapshot.docs) {
      final subjectId = doc.data()['subjectId'] ?? 'unknown';
      final duration = doc.data()['duration'] ?? 0;
      bySubject[subjectId] = (bySubject[subjectId] ?? 0) + (duration as int);
    }
    return bySubject;
  }

  /// Bugün per subject progress
  Future<Map<String, int>> getTodayStudyTimeBySubject({
    required String uId,
  }) async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final snapshot = await _db
        .collection("study_sessions")
        .where("userId", isEqualTo: uId)
        .where(
          "startedAt",
          isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart),
        )
        .where("startedAt", isLessThan: Timestamp.fromDate(todayEnd))
        .get();

    final Map<String, int> bySubject = {};
    for (var doc in snapshot.docs) {
      final subjectId = doc.data()['subjectId'] ?? 'unknown';
      final duration = doc.data()['duration'] ?? 0;
      bySubject[subjectId] = (bySubject[subjectId] ?? 0) + (duration as int);
    }
    return bySubject;
  }
}
