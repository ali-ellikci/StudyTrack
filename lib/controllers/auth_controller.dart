import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  Rxn<User> firebaseUser = Rxn<User>();
  Rxn<AppUser> appUser = Rxn<AppUser>();

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _handleAuthChanged);
  }

  void _handleAuthChanged(User? user) {
    if (user != null) {
      loadAppUser(user.uid);
    } else {
      appUser.value = null;
    }
  }

  Future<void> loadAppUser(String uid) async {
    var user = await _userService.getUser(uid);
    if (user == null) {
      final fb = _auth.currentUser;
      final email = fb?.email ?? '';
      final name = fb?.displayName ?? '';

      try {
        await _userService.createUser(
          uid: uid,
          email: email,
          username: name.isEmpty ? email.split('@').first : name,
          password: '',
        );
        user = await _userService.getUser(uid);
      } catch (e) {
        Get.snackbar(
          "Load App User Error",
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
    appUser.value = user;
  }

  Future<bool> login(String email, String password) async {
    try {

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Login Error",
        e.message ?? e.code,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } catch (e) {
      Get.snackbar(
        "Login Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  Future<bool> register(String email, String password, String fullname) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await cred.user!.updateDisplayName(fullname);

      await _userService.createUser(
        uid: cred.user!.uid,
        email: email,
        username: fullname,
        password: password,
      );


      return true;
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Register Error",
        e.message ?? e.code,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } catch (e) {
      Get.snackbar(
        "Register Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }
  
  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      Get.snackbar(
        "Password Reset",
        "Please enter your email to reset password.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        "Password Reset",
        "Password reset email sent to $email",
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Password Reset Error",
        e.message ?? e.code,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Password Reset Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      appUser.value = null;
    } catch (e) {
      Get.snackbar(
        "Logout Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  bool get isLoggedIn => firebaseUser.value != null;

  Future<void> updateAvatarUrl(String uid, String downloadUrl) async {
    await _userService.updateAvatarUrl(uid, downloadUrl);

    if (appUser.value != null) {
      appUser.value = AppUser(
        uid: appUser.value!.uid,
        username: appUser.value!.username,
        email: appUser.value!.email,
        totalStudyMinutes: appUser.value!.totalStudyMinutes,
        avatarUrl: downloadUrl,
        department: appUser.value!.department,
        classOf: appUser.value!.classOf,
      );
    }
  }

  Future<void> updateProfile({String? department, String? classOf}) async {
    final current = appUser.value;
    if (current == null) return;
    await _userService.updateProfileFields(
      current.uid,
      department: department,
      classOf: classOf,
    );
    appUser.value = AppUser(
      uid: current.uid,
      username: current.username,
      email: current.email,
      totalStudyMinutes: current.totalStudyMinutes,
      avatarUrl: current.avatarUrl,
      department: department ?? current.department,
      classOf: classOf ?? current.classOf,
    );
  }
}
