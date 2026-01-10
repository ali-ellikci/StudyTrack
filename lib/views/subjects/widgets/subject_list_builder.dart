import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/subject_controller.dart';
import '../../../models/subject_model.dart';

class SubjectListBuilder extends StatelessWidget {
  final SubjectController subjectController;

  const SubjectListBuilder({super.key, required this.subjectController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final subjects = subjectController.subjects;

      if (subjects.isEmpty) {
        return const SizedBox.shrink();
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return _buildSubjectCard(context, subjects[index]);
        },
      );
    });
  }

  Widget _buildSubjectCard(BuildContext context, SubjectModel subject) {
    final Color cardColor = Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : Colors.blue;

    final Color textColor =
        ThemeData.estimateBrightnessForColor(cardColor) == Brightness.dark
        ? Colors.white
        : const Color(0xFF1A1F36);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: textColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.book_outlined, color: textColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              subject.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
