class AppUser {
  final String uid;
  final String username;
  final String email;
  final int totalStudyMinutes;
  final String avatarUrl;

  AppUser({
    required this.uid,
    required this.username,
    required this.email,
    required this.totalStudyMinutes,
    required this.avatarUrl,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      totalStudyMinutes: map['totalStudyMinutes'] ?? 0,
      avatarUrl: map['avatarUrl'] ?? '',
    );
  }
}
