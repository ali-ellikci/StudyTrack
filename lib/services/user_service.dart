import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final _db = FirebaseFirestore.instance;

  Future<void> createUser({
    required String uid,
    required String username,
    required String email,
    required String password,
  }) async {
    // Retry on transient Firestore outages
    final payload = {
      "avatarUrl": "",
      "createdAt": FieldValue.serverTimestamp(),
      "email": email,
      "totalStudyMinutes": 0,
      "username": username,
    };

    int attempt = 0;
    while (true) {
      try {
        await _db
            .collection("users")
            .doc(uid)
            .set(payload, SetOptions(merge: true));
        return;
      } catch (e) {
        attempt++;
        if (attempt >= 3) rethrow;
        await Future.delayed(
          Duration(milliseconds: 400 * (1 << (attempt - 1))),
        );
      }
    }
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    if (!doc.exists) return null;

    final data = doc.data();
    if (data == null) return null;

    return AppUser.fromMap(uid, data);
  }
}
