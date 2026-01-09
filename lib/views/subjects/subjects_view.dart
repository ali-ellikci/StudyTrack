import 'package:flutter/material.dart';
import 'widgets/search_bar.dart';
import 'widgets/add_subject_card.dart';
import 'widgets/subject_list_builder.dart';
import '../../controllers/subject_controller.dart';
import 'package:get/get.dart';

class LessonsView extends StatelessWidget {
  LessonsView({super.key});
  final subjectController = Get.find<SubjectController>();

  @override
  Widget build(BuildContext context) {
    // Local UI metrics (moved from core/ui)
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
        title: Text("Lessons"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(spacing.xs),
          child: Divider(
            height: spacing.xs,
            thickness: 1,
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomSearchBar(),
                const SizedBox(height: 24),
                SubjectListBuilder(subjectController: subjectController),
                const SizedBox(height: 24),
                AddSubjectCard(
                  onTap: () {
                    _showAddSubjectSheet(context);
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddSubjectSheet(BuildContext context) {
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
              "Yeni Ders Ekle",
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
                hintText: "Örn: Matematik, İngilizce...",
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
                    subjectController.addSubject(name: textCtrl.text.trim());

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
                  "Oluştur",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
