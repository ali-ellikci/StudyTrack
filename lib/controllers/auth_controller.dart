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
    print('[AuthController] onInit: binding authStateChanges');
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _handleAuthChanged);
  }

  void _handleAuthChanged(User? user) {
    print('[AuthController] auth state changed: ' + (user?.uid ?? 'null'));
    if (user != null) {
      loadAppUser(user.uid);
    } else {
      appUser.value = null;
    }
  }

  Future<void> loadAppUser(String uid) async {
    print('[AuthController] loadAppUser: uid=' + uid);
    var user = await _userService.getUser(uid);
    if (user == null) {
      // Lazily provision user document if missing
      final fb = _auth.currentUser;
      final email = fb?.email ?? '';
      final name = fb?.displayName ?? '';
      print(
        '[AuthController] user doc missing → creating (email=' +
            email +
            ', name=' +
            name +
            ')',
      );
      try {
        await _userService.createUser(
          uid: uid,
          email: email,
          username: name.isEmpty ? email.split('@').first : name,
          password: '',
        );
        user = await _userService.getUser(uid);
      } catch (e) {
        print('[AuthController] failed to create user doc: ' + e.toString());
      }
    }
    print(
      '[AuthController] loadAppUser result: ' + (user == null ? 'null' : 'ok'),
    );
    appUser.value = user;
  }

  Future<bool> login(String email, String password) async {
    try {
      print(
        '[AuthController] login start for ' +
            (email.isEmpty ? '<empty>' : email),
      );
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('[AuthController] login success');
      return true;
    } on FirebaseAuthException catch (e) {
      print(
        '[AuthController] login FirebaseAuthException: ' +
            (e.code) +
            ' ' +
            (e.message ?? ''),
      );
      Get.snackbar(
        "Login Error",
        e.message ?? e.code,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } catch (e) {
      print('[AuthController] login error: ' + e.toString());
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
      print(
        '[AuthController] register start for ' +
            (email.isEmpty ? '<empty>' : email),
      );
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
      print('[AuthController] register success: uid=' + cred.user!.uid);

      return true;
    } on FirebaseAuthException catch (e) {
      print(
        '[AuthController] register FirebaseAuthException: ' +
            (e.code) +
            ' ' +
            (e.message ?? ''),
      );
      Get.snackbar(
        "Register Error",
        e.message ?? e.code,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } catch (e) {
      print('[AuthController] register error: ' + e.toString());
      Get.snackbar(
        "Register Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
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
}
