import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/post_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/media_controller.dart';
import 'widgets/post_card.dart';
import 'widgets/create_post_sheet.dart';

class CommunityView extends StatelessWidget {
  CommunityView({super.key});
  final postController = Get.find<PostController>();
  final authController = Get.find<AuthController>();
  final mediaController = Get.find<MediaController>();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final spacing = _LocalSpacing(
      xs: h * 0.006,
      s: h * 0.01,
      m: h * 0.014,
      l: h * 0.02,
      xl: h * 0.028,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Comunity"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(spacing.xs),
          child: Divider(
            height: spacing.xs,
            thickness: 1,
            color: Colors.grey.withValues(alpha: 0.5),
          ),
        ),
      ),

      body: Obx(() {
        return NotificationListener<ScrollNotification>(
          onNotification: (scroll) {
            if (scroll.metrics.pixels == scroll.metrics.maxScrollExtent) {
              postController.loadPosts();
            }
            return false;
          },
          child: ListView.builder(
            itemCount: postController.posts.length,
            itemBuilder: (context, index) {
              final post = postController.posts[index];
              return PostCard(post: post);
            },
          ),
        );
      }),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreatePostSheet(context);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showCreatePostSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CreatePostSheet(
          postController: postController,
          authController: authController,
          mediaController: mediaController,
        );
      },
    );
  }
}

class _LocalSpacing {
  final double xs, s, m, l, xl;
  _LocalSpacing({
    required this.xs,
    required this.s,
    required this.m,
    required this.l,
    required this.xl,
  });
}



