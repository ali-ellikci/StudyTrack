import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/goal_model.dart';

class GoalService {
  final _db = FirebaseFirestore.instance;

  /* DAILY */
  Future<List<Goal>> getDailyGoals({required String uId}) async {
    final snap = await _db
        .collection('goals')
        .where('userId', isEqualTo: uId)
        .where('type', isEqualTo: 'daily')
        .get();

    return snap.docs.map((d) => Goal.fromMap(d.data(), d.id)).toList();
  }

  Future<void> setDailyGoal({
    required String uId,
    String? subjectId,
    int targetMinutes = 0,
  }) async {
    final docId = "$uId-daily-${subjectId ?? 'global'}";
    final ref = _db.collection('goals').doc(docId);
    await ref.set({
      'userId': uId,
      'type': 'daily',
      'subjectId': subjectId,
      'targetMinutes': targetMinutes,
    }, SetOptions(merge: true));
  }

  /* WEEKLY */
  Future<List<Goal>> getWeeklyGoals({required String uId}) async {
    final snap = await _db
        .collection('goals')
        .where('userId', isEqualTo: uId)
        .where('type', isEqualTo: 'weekly')
        .get();

    return snap.docs.map((d) => Goal.fromMap(d.data(), d.id)).toList();
  }

  Future<void> setWeeklyGoal({
    required String uId,
    String? subjectId,
    int targetMinutes = 0,
  }) async {
    final docId = "$uId-weekly-${subjectId ?? 'global'}";
    final ref = _db.collection('goals').doc(docId);
    await ref.set({
      'userId': uId,
      'type': 'weekly',
      'subjectId': subjectId,
      'targetMinutes': targetMinutes,
    }, SetOptions(merge: true));
  }
}
