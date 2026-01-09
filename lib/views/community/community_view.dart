import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/post_controller.dart';
import '../../models/post_model.dart';

class CommunityView extends StatelessWidget{
  CommunityView({super.key});
  final postController = Get.find<PostController>();
  
  
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final spacing = _LocalSpacing(
      xs: h * 0.006,
      s: h * 0.01,
      m: h * 0.014,
      l: h * 0.02,
      xl: h * 0.028,
    );
    final padding = _LocalPadding(
      page: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.01),
      section: EdgeInsets.only(top: h * 0.02),
    );
    final sizes = _LocalSizes(
      logo: h * 0.07,
      icon: h * 0.04,
      socialIcon: h * 0.03,
      textSmall: h * 0.016,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Comunity"
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(spacing.xs),
            child: Divider(
              height: spacing.xs,
              thickness: 1,
              color: Colors.grey.withOpacity(0.5),
            )),
      ),

      body: Obx(
          () {
            return NotificationListener<ScrollNotification>(
                onNotification: (scroll) {
                  if (scroll.metrics.pixels ==
                      scroll.metrics.maxScrollExtent) {
                    postController.loadPosts(); // pagination
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount: postController.posts.length,
                  itemBuilder: (context, index) {final post = postController.posts[index];
                  return PostCard(post: post);
              },
            ),
            );
          }
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showCreatePostSheet(context);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add),
        shape: const CircleBorder(),
      ),
    );
  }
  void _showCreatePostSheet(BuildContext context){
    final TextEditingController textCtrl = TextEditingController();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
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
                "Yeni Post Oluştur",
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
                  hintText: "Bu gün ne düşünüyorsun? ",
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
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (textCtrl.text.trim().isNotEmpty) {
                      postController.createPost(content: textCtrl.text.trim());

                      Navigator.pop(context);
                    }
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
                  child: const Text(
                    "Gönder",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class _LocalSpacing {
  final double xs, s, m, l, xl;
  _LocalSpacing({required this.xs, required this.s, required this.m, required this.l, required this.xl});
}

class _LocalPadding {
  final EdgeInsets page, section;
  _LocalPadding({required this.page, required this.section});
}

class _LocalSizes {
  final double logo, icon, socialIcon, textSmall;
  _LocalSizes({required this.logo, required this.icon, required this.socialIcon, required this.textSmall});
}


class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: post.userProfileImageUrl != null
                      ? NetworkImage(post.userProfileImageUrl!)
                      : null,
                  child: post.userProfileImageUrl == null
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                          text: post.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        const TextSpan(
                          text: " • ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                          text: "2h", // post.timeAgo
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              post.content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (post.imageUrl != null) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  post.imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            const SizedBox(height: 15),
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      const Icon(Icons.favorite_border, size: 20, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        "${0}", // post.likeCount
                        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, size: 20, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        "${0}", // post.commentCount
                        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.ios_share, size: 20, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


