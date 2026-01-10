import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectModel {
  final String id;
  final String userId;
  final String name;
  final bool isArchived;
  final DateTime createdAt;

  SubjectModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.isArchived,
    required this.createdAt,
  });

  factory SubjectModel.fromMap(String id, Map<String, dynamic> map) {
    return SubjectModel(
      id: id,
      userId: map['userId'],
      name: map['name'],
      isArchived: map['isArchived'],
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubjectModel &&
        other.id == id &&
        other.userId == userId &&
        other.name == name &&
        other.isArchived == isArchived &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        name.hashCode ^
        isArchived.hashCode ^
        createdAt.hashCode;
  }
}
