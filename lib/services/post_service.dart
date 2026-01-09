import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';

class PostService {
  final _db = FirebaseFirestore.instance;


  Future<void> createPost(
      {
        required userName,
        required content,
        userProfileImageUrl,
        imageUrl,
      }) async
  {
    await _db.collection("posts")
        .add({ 'username' : userName,
            'content' : content,
            'imageUrl' : imageUrl,
            'userProfileImageUrl': userProfileImageUrl,
            'sharingDate' : FieldValue.serverTimestamp(),
      });
  }


  Future<List<PostModel>> fetchPosts({
    required int limit,
    DocumentSnapshot? lastDoc,
  }) async {
    Query query = _db
        .collection('posts')
        .orderBy('sharingDate', descending: true)
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snapshot = await query.get();

    return snapshot.docs
        .map((doc) =>
        PostModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }


  Stream<PostModel> streamLatestPost() {
    return _db
        .collection('posts')
        .orderBy('sharingDate', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      final doc = snapshot.docs.first;
      return PostModel.fromMap(
          doc.id, doc.data() as Map<String, dynamic>);
    });
  }
}
