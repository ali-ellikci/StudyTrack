import 'package:cloud_firestore/cloud_firestore.dart';

class SessionModel {
  final String userId;
  final String subjectId;
  final DateTime startedAt;
  final DateTime endedAt;
  final int duration;

  SessionModel({
    required this.userId,
    required this.subjectId,
    required this.startedAt,
    required this.endedAt,
    required this.duration,
  });

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      userId: map['userId'],
      subjectId: map['subjectId'],
      startedAt: map['startedAt'] != null
          ? (map['startedAt'] as Timestamp).toDate()
          : DateTime.now(),
      endedAt: map['endedAt'] != null
          ? (map['endedAt'] as Timestamp).toDate()
          : DateTime.now(),
      duration: map['duration'],
    );
  }
}
