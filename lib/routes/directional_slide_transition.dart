import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DirectionalSlideTransition extends CustomTransition {
  DirectionalSlideTransition();

  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Expect arguments like {'dir': 'ltr' | 'rtl'}
    final args = Get.arguments;
    final String dir = (args is Map && (args['dir'] == 'ltr' || args['dir'] == 'rtl'))
        ? args['dir'] as String
        : 'rtl';

    final beginOffset = dir == 'ltr' ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);
    final effectiveCurve = curve ?? Curves.easeInOut;
    final tween = Tween<Offset>(begin: beginOffset, end: Offset.zero)
        .chain(CurveTween(curve: effectiveCurve));
    return SlideTransition(position: animation.drive(tween), child: child);
  }
}
