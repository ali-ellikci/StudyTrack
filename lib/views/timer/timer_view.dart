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
            color: Colors.grey.withValues(alpha: 0.5),
          ),
        ),
      ),
      body: Padding(
        padding: padding.page,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: spacing.xl * 4.20),

            Center(child: _buildTimerCircle(context, timerController)),

            SizedBox(height: spacing.xl * 2),

            Center(child: _buildControlButton(context, timerController)),

            SizedBox(height: spacing.xl * 1.2),

            Center(
              child: _buildSaveButton(
                context,
                sessionController,
                subjectController,
                user.uid,
              ),
            ),
          ],
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
        backgroundColor: Colors.grey.withValues(alpha:0.2),
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
    
    Get.bottomSheet(
      Container(
        height: 300,
        color: Theme.of(
          context,
        ).scaffoldBackgroundColor,
        child: Column(
          children: [
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Set Duration",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),

            Expanded(
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                initialTimerDuration: Duration(
                  seconds: controller.totalSeconds.value,
                ),
                onTimerDurationChanged: (Duration newDuration) {
                  if (newDuration.inSeconds > 0) {
                    controller.setDuration(newDuration);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Widget _buildControlButton(
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
          _buildQuickSaveButton(context),
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

  Widget _buildQuickSaveButton(BuildContext context) {
    final SessionController sessionController = Get.find<SessionController>();
    final SubjectController subjectController = Get.find<SubjectController>();
    final TimerController timerController = Get.find<TimerController>();
    final user = FirebaseAuth.instance.currentUser!;

    return ElevatedButton(
      onPressed: () {
        timerController.pauseTimer();
        _openSubjectPickerAndSave(
          context,
          sessionController,
          subjectController,
          user.uid,
          timerController,
        );
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
      child: const Icon(Icons.save_outlined, size: 28),
    );
  }

  Widget _buildSaveButton(
    BuildContext context,
    SessionController sessionController,
    SubjectController subjectController,
    String uId,
  ) {
    return ElevatedButton(
      onPressed: () {
        _openManualAddSheet(
          context,
          sessionController,
          subjectController,
          uId,
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
          Icon(Icons.save_outlined, size: 25),
          SizedBox(width: 10),
          Text("Add Manual Entry"),
        ],
      ),
    );
  }

  Future<void> _openManualAddSheet(
    BuildContext context,
    SessionController sessionController,
    SubjectController subjectController,
    String uId,
  ) async {
    SubjectModel? pickedSubject = subjectController.selectedSubject.value;
    Duration pickedDuration = const Duration(minutes: 25);

    await Get.bottomSheet(
      StatefulBuilder(builder: (ctx, setState) {
        return Container(
          height: 520,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha:0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Manual Entry', style: Theme.of(context).textTheme.titleMedium),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Obx(() {
                  final items = subjectController.subjects;
                  if (items.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('No subjects yet.'),
                            const SizedBox(height: 8),
                            OutlinedButton(
                              onPressed: () {
                                Get.back();
                                Get.toNamed('/subjects');
                              },
                              child: const Text('Add Subject'),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (ctx, i) {
                      final s = items[i];
                      final selected = pickedSubject?.id == s.id;
                      return ListTile(
                        title: Text(s.name),
                        trailing: Icon(
                          selected ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: selected ? Theme.of(context).colorScheme.primary : null,
                        ),
                        onTap: () => setState(() => pickedSubject = s),
                      );
                    },
                  );
                }),
              ),
              const Divider(height: 1),
              SizedBox(
                height: 140,
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  initialTimerDuration: pickedDuration,
                  onTimerDurationChanged: (d) => setState(() => pickedDuration = d),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Save'),
                    onPressed: () async {
                      if (pickedSubject == null) {
                        Get.snackbar('Subject required', 'Please select a subject.');
                        return;
                      }
                      if (pickedDuration.inSeconds <= 0) {
                        Get.snackbar('Invalid duration', 'Please pick a duration greater than 0.');
                        return;
                      }
                      await sessionController.saveSession(
                        userId: uId,
                        subjectId: pickedSubject!.id,
                        duration: pickedDuration.inSeconds,
                      );
                      Get.back();
                      Get.snackbar('Saved', 'Manual session saved successfully.', snackPosition: SnackPosition.BOTTOM);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: const StadiumBorder(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      isDismissible: true,
      enableDrag: true,
      enterBottomSheetDuration: const Duration(milliseconds: 200),
      exitBottomSheetDuration: const Duration(milliseconds: 150),
    );
  }

  Future<void> _openSubjectPickerAndSave(
    BuildContext context,
    SessionController sessionController,
    SubjectController subjectController,
    String uId,
    TimerController timerController,
  ) async {
    SubjectModel? current = subjectController.selectedSubject.value;
    await Get.bottomSheet(
      StatefulBuilder(
        builder: (ctx, setState) {
          return Container(
            height: 420,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha:0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pick Subject and Save', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        _formatSecondsShort(timerController.elapsedSeconds.value),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Obx(() {
                    final items = subjectController.subjects;
                    if (items.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('No subjects yet.'),
                              const SizedBox(height: 8),
                              OutlinedButton(
                                onPressed: () {
                                  Get.back();
                                  Get.toNamed('/subjects');
                                },
                                child: const Text('Add Subject'),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (ctx, i) {
                        final s = items[i];
                        final selected = current?.id == s.id;
                        return ListTile(
                          title: Text(s.name),
                          trailing: Icon(
                            selected ? Icons.radio_button_checked : Icons.radio_button_off,
                            color: selected ? Theme.of(context).colorScheme.primary : null,
                          ),
                          onTap: () => setState(() => current = s),
                        );
                      },
                    );
                  }),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Save'),
                        onPressed: () async {
                          if (current == null) {
                            Get.snackbar('Subject required', 'Please select a subject.');
                            return;
                          }
                          subjectController.changeSubject(current);
                          await sessionController.saveSession(
                            userId: uId,
                            subjectId: current!.id,
                            duration: timerController.elapsedSeconds.value,
                          );
                          timerController.resetTimer();
                          Get.back();
                          Get.snackbar('Saved', 'Session saved successfully.', snackPosition: SnackPosition.BOTTOM);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      isDismissible: true,
      enableDrag: true,
      enterBottomSheetDuration: const Duration(milliseconds: 200),
      exitBottomSheetDuration: const Duration(milliseconds: 150),
    );
  }

  String _formatSecondsShort(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
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

