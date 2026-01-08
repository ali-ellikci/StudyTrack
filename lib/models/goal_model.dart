import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  final String id; // docId
  final String userId;
  final String type; // daily | weekly

  final String? subjectId;

  final int targetMinutes;

  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  Goal({
    required this.id,
    required this.userId,
    required this.type,
    this.subjectId,
    required this.targetMinutes,
    this.createdAt,
    this.updatedAt,
  });

  factory Goal.fromMap(Map<String, dynamic> map, String id) {
    return Goal(
      id: id,
      userId: map['userId'],
      type: map['type'],
      subjectId: map['subjectId'],
      targetMinutes: map['targetMinutes'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  bool get isDaily => type == 'daily';
  bool get isWeekly => type == 'weekly';
  bool get hasSubject => subjectId != null && subjectId!.isNotEmpty;
}
