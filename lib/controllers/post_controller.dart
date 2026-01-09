import 'package:get/get.dart';
import '../services/post_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostController extends GetxController{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PostService service = PostService();
  var posts = <PostModel>[].obs;
  DocumentSnapshot? lastDoc;
  final int limit = 5;

  void createPost({
    required content,
    imageUrl,
    userProfileImageUrl
  }){
    var userName = _auth.currentUser?.displayName;
    service.createPost(userName: userName, content: content, imageUrl: imageUrl, userProfileImageUrl: userProfileImageUrl);
  }


  @override
  void onInit() {
    super.onInit();
    loadPosts();
    listenNewPost();
  }

  Future<void> loadPosts() async {
    final newPosts = await service.fetchPosts(
      limit: limit,
      lastDoc: lastDoc,
    );

    if (newPosts.isNotEmpty) {
      posts.addAll(newPosts);
    }
  }

  void listenNewPost() {
    service.streamLatestPost().listen((newPost) {
      if (!posts.any((p) => p.postId == newPost.postId)) {
        posts.insert(0, newPost);
      }
    });
  }
}

