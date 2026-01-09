import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'auth_controller.dart';

class MediaController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final AuthController authController = AuthController();

  Future<void> pickUploadAndSetAvatar(AuthController authController) async {
    final uid = authController.firebaseUser.value?.uid;
    if (uid == null) return;

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final file = File(image.path);

    final ref = FirebaseStorage.instance.ref('profile_photos/$uid.jpg');
    await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));

    final downloadUrl = await ref.getDownloadURL();

    await authController.updateAvatarUrl(uid, downloadUrl);
  }
}
