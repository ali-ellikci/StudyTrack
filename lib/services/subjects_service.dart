import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/subject_model.dart';

class SubjectsService {
  final _db = FirebaseFirestore.instance;

  Future<void> createSubject({
    required String uId,
    required String name,
  }) async {
    _db.collection("subjects").add({
      'createdAt': FieldValue.serverTimestamp(),
      'isArchived': false,
      'name': name,
      'userId': uId,
    });
  }

  Future<List<SubjectModel>> getSubjects({required String uId}) async {
    final snapshot = await _db
        .collection("subjects")
        .where('userId', isEqualTo: uId)
        .where('isArchived', isEqualTo: false)
        .orderBy('createdAt', descending: false)
        .get();
    return snapshot.docs
        .map((doc) => SubjectModel.fromMap(doc.id, doc.data()))
        .toList();
  }
}
