import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:study_track/controllers/session_controller.dart';
import '../../controllers/subject_controller.dart';
import '../../controllers/timer_controller.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../models/subject_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    final SubjectController subjectController = Get.find<SubjectController>();
    final TimerController timerController = Get.find<TimerController>();
    final SessionController sessionController = Get.find<SessionController>();
    final user = FirebaseAuth.instance.currentUser;

    subjectController.fetchSubjects(user!.uid);
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
        title: const Text("Study Timer"),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.m),
            child: const Icon(Icons.settings),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(spacing.xs),
          child: Divider(
            height: spacing.xs,
            thickness: 1,
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
      ),
      body: Padding(
        padding: padding.page,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Current Subject",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white54
                    : Colors.black,
              ),
            ),
            SizedBox(height: spacing.s),

            _buildSubjectSelector(context, subjectController),
            SizedBox(height: spacing.xl * 4.20),

            Center(child: _buildTimerCircle(context, timerController)),

            SizedBox(height: spacing.xl * 2),

            Center(child: _buildControllButton(context, timerController)),

            SizedBox(height: spacing.xl * 1.2),

            Center(
              child: _buildSaveButton(
                context,
                sessionController,
                subjectController,
                user.uid,
                timerController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectSelector(
    BuildContext context,
    SubjectController controller,
  ) {
    return Container(
      height: 55,
      width: double.infinity,
      child: Obx(
        () => DropdownButtonFormField<SubjectModel>(
          // Bunlar sadece açılınca gelen kutuyu etkiler
          borderRadius: BorderRadius.circular(12),
          menuMaxHeight: 300,
          elevation: 4,
          value: controller.selectedSubject.value,
          hint: Text(
            'Select a subject...',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white54
                : Colors.black,
          ),
          dropdownColor: Theme.of(context).brightness == Brightness.dark
              ? Color.lerp(
                  Theme.of(context).scaffoldBackgroundColor,
                  Colors.white,
                  0.1,
                )
              : Color.lerp(
                  Theme.of(context).scaffoldBackgroundColor,
                  Colors.black,
                  0.1,
                ),
          items: controller.subjects.map((SubjectModel subject) {
            return DropdownMenuItem<SubjectModel>(
              value: subject,
              child: Text(subject.name),
            );
          }).toList(),
          onChanged: (val) => controller.changeSubject(val),

          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? Color.lerp(
                    Theme.of(context).scaffoldBackgroundColor,
                    Colors.white,
                    0.1,
                  )
                : Color.lerp(
                    Theme.of(context).scaffoldBackgroundColor,
                    Colors.black,
                    0.05,
                  ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white24
                    : Colors.black12,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimerCircle(BuildContext context, TimerController controller) {
    return Obx(() {
      return CircularPercentIndicator(
        radius: 130.0,
        lineWidth: 15.0,
        percent: controller.percent,
        circularStrokeCap: CircularStrokeCap.round,
        backgroundColor: Colors.grey.withOpacity(0.2),
        progressColor: Theme.of(context).colorScheme.primary,

        center: GestureDetector(
          onTap: () {
            controller.pauseTimer();
            _showTimePicker(context, controller);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.timeDisplay,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showTimePicker(BuildContext context, TimerController controller) {
    // iOS tarzı süre seçici (Dakika ve Saat)
    Get.bottomSheet(
      Container(
        height: 300,
        color: Theme.of(
          context,
        ).scaffoldBackgroundColor, // Temaya uygun arka plan
        child: Column(
          children: [
            // Kapatma butonu veya Başlık
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Set Duration",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),

            // Dönen Tekerlek (Picker)
            Expanded(
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm, // Saat ve Dakika modu
                initialTimerDuration: Duration(
                  seconds: controller.totalSeconds.value,
                ),
                onTimerDurationChanged: (Duration newDuration) {
                  // Her çevirişte süreyi anlık güncelle
                  // Eğer anlık değişsin istemiyorsan burayı boş bırakıp bir "Kaydet" butonu koyabiliriz.
                  if (newDuration.inSeconds > 0) {
                    controller.setDuration(newDuration);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      // BottomSheet ayarları
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Widget _buildControllButton(
    BuildContext context,
    TimerController controller,
  ) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildResetButton(context, controller),
          SizedBox(width: 10),
          _buildPlayButton(context, controller),
          SizedBox(width: 10),
          _buildFinishButton(context, controller),
        ],
      ),
    );
  }

  Widget _buildResetButton(BuildContext context, TimerController controller) {
    return ElevatedButton(
      onPressed: () {
        controller.resetTimer();
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(15),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Color.lerp(
                Theme.of(context).scaffoldBackgroundColor,
                Colors.white,
                0.1,
              )
            : Color.lerp(
                Theme.of(context).scaffoldBackgroundColor,
                Colors.black,
                0.05,
              ),
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white70
            : Colors.black54,
        elevation: 5,
      ),
      child: Icon(Icons.restart_alt_rounded, size: 30),
    );
  }

  Widget _buildPlayButton(BuildContext context, TimerController controller) {
    return Obx(() {
      return ElevatedButton(
        onPressed: () {
          controller.toggleTimer();
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(14),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 15,
        ),
        child: Icon(
          controller.isRunning.value ? Icons.pause : Icons.play_arrow_rounded,
          size: 55,
        ),
      );
    });
  }

  Widget _buildFinishButton(BuildContext context, TimerController controller) {
    return ElevatedButton(
      onPressed: () {
        controller.pauseTimer();
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(15),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Color.lerp(
                Theme.of(context).scaffoldBackgroundColor,
                Colors.white,
                0.1,
              )
            : Color.lerp(
                Theme.of(context).scaffoldBackgroundColor,
                Colors.black,
                0.05,
              ),
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white70
            : Colors.black54,
        elevation: 5,
      ),
      child: Icon(Icons.stop, size: 30),
    );
  }

  Widget _buildSaveButton(
    BuildContext context,
    SessionController sessionController,
    SubjectController subjectController,
    String uId,
    TimerController timerController,
  ) {
    return ElevatedButton(
      onPressed: () {
        if (subjectController.selectedSubject.value == null) {
          Get.snackbar('Error', 'Please select a subject first');
          return;
        }
        print(timerController.elapsedSeconds.value);
        sessionController.saveSession(
          userId: uId,
          subjectId: subjectController.selectedSubject.value!.id,
          duration: timerController.elapsedSeconds.value,
        );
      },
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Color.lerp(
                Theme.of(context).scaffoldBackgroundColor,
                Colors.white,
                0.1,
              )
            : Colors.black87,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.save, size: 25),
          SizedBox(width: 10),
          Text("Save Session"),
        ],
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
