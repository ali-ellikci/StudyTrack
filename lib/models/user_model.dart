class AppUser {
  final String uid;
  final String username;
  final String email;
  final int totalStudyMinutes;
  final String avatarUrl;
  final String? department;
  final String? classOf;

  AppUser({
    required this.uid,
    required this.username,
    required this.email,
    required this.totalStudyMinutes,
    required this.avatarUrl,
    this.department,
    this.classOf,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      totalStudyMinutes: map['totalStudyMinutes'] ?? 0,
      avatarUrl: map['avatarUrl'] ?? '',
      department: map['department'],
      classOf: map['class'],
    );
  }
}
