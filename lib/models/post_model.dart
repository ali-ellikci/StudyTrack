import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String userName;
  final String content;
  final Timestamp sharingDate;
  final String? imageUrl;
  final String? userProfileImageUrl;

  PostModel({
    required this.postId,
    required this.userName,
    required this.content,
    required this.sharingDate,
    this.imageUrl,
    this.userProfileImageUrl
  });

  factory PostModel.fromMap(
      String postId,
      Map<String, dynamic> data,
      ) {
    return PostModel(
        postId: postId,
        userName: data['username'] ?? '',
        content: data['content'] ?? '',
        sharingDate: data['sharingDate'] is Timestamp
            ? data['sharingDate']
            : Timestamp.now(),
        imageUrl: data['imageUrl'],
        userProfileImageUrl : data['userProfileImageUrl']

    );
  }
}
