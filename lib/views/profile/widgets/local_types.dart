import 'package:flutter/material.dart';

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

class LocalSpacing {
  final double xs, s, m, l, xl;
  LocalSpacing({required this.xs, required this.s, required this.m, required this.l, required this.xl});
}

class LocalPadding {
  final EdgeInsets page, section;
  LocalPadding({required this.page, required this.section});
}

class LocalSizes {
  final double logo, icon, socialIcon, textSmall;
  LocalSizes({required this.logo, required this.icon, required this.socialIcon, required this.textSmall});
}
