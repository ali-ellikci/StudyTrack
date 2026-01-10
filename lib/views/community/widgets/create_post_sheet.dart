import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../../../controllers/post_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/media_controller.dart';

class CreatePostSheet extends StatefulWidget {
  final PostController postController;
  final AuthController authController;
  final MediaController mediaController;

  const CreatePostSheet({
    super.key,
    required this.postController,
    required this.authController,
    required this.mediaController,
  });

  @override
  State<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<CreatePostSheet> {
  final TextEditingController textCtrl = TextEditingController();
  XFile? selectedImage;
  bool isUploading = false;
  double uploadProgress = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Create New Post",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: textCtrl,
            autofocus: true,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            decoration: InputDecoration(
              hintText: "What are you thinking today?",
              hintStyle: TextStyle(color: Colors.grey.shade500),
              filled: true,
              fillColor: const Color(0xFFF5F7FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: isUploading
                    ? null
                    : () async {
                        final picked = await widget.mediaController
                            .pickImageFromGallery();
                        if (picked != null) {
                          setState(() {
                            selectedImage = picked;
                          });
                          final thumb = Image.file(
                            File(picked.path),
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  thumb,
                                  const SizedBox(width: 12),
                                  const Text("Image selected"),
                                ],
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text("Add Image"),
              ),
            ],
          ),
          if (isUploading) ...[
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: uploadProgress,
              minHeight: 6,
            ),
          ],
          if (selectedImage != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(selectedImage!.path),
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isUploading
                  ? null
                  : () async {
                      if (textCtrl.text.trim().isEmpty) return;
                      final avatar =
                          widget.authController.appUser.value?.avatarUrl ?? '';
                      String? imageUrl;
                      final uid = widget.authController.firebaseUser.value?.uid;
                      if (uid != null && selectedImage != null) {
                        setState(() {
                          isUploading = true;
                          uploadProgress = 0;
                        });
                        imageUrl = await widget.mediaController
                            .uploadPostImageWithProgress(
                          uid,
                          selectedImage!,
                          (p) {
                            setState(() {
                              uploadProgress = p;
                            });
                          },
                        );
                      }
                      widget.postController.createPost(
                        content: textCtrl.text.trim(),
                        userProfileImageUrl: avatar.isNotEmpty ? avatar : null,
                        imageUrl: imageUrl,
                      );
                      setState(() {
                        isUploading = false;
                      });
                      Navigator.pop(context);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isUploading) ...[
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  const Text(
                    "Post",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
