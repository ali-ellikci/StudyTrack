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

  Future<XFile?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<String?> uploadPostImage(String uid, XFile image) async {
    final file = File(image.path);
    final ts = DateTime.now().millisecondsSinceEpoch;
    final ref = FirebaseStorage.instance.ref('post_images/$uid/$ts.jpg');
    await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
    final url = await ref.getDownloadURL();
    return url;
  }

  Future<String?> uploadPostImageWithProgress(
    String uid,
    XFile image,
    void Function(double progress) onProgress,
  ) async {
    final file = File(image.path);
    final ts = DateTime.now().millisecondsSinceEpoch;
    final ref = FirebaseStorage.instance.ref('post_images/$uid/$ts.jpg');
    final uploadTask = ref.putFile(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    uploadTask.snapshotEvents.listen((snapshot) {
      final total = snapshot.totalBytes;
      final transferred = snapshot.bytesTransferred;
      if (total > 0) onProgress(transferred / total);
    });
    final snapshot = await uploadTask;
    final url = await snapshot.ref.getDownloadURL();
    onProgress(1.0);
    return url;
  }
}
