import 'package:flutter/material.dart';
import 'local_types.dart';

class InfoRow extends StatelessWidget {
  final String h1;
  final String h2;
  final LocalSpacing spacing;
  final LocalSizes sizes;
  final IconData? icon;
  const InfoRow({
    super.key,
    required this.h1,
    required this.h2,
    required this.spacing,
    required this.sizes,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.08,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(spacing.s),
            decoration: BoxDecoration(
              color: Color.lerp(
                Theme.of(context).scaffoldBackgroundColor,
                Colors.white,
                0.1,
              )!,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: sizes.icon * 0.5,
            ),
          ),
          SizedBox(width: spacing.m),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(h1, style: Theme.of(context).textTheme.bodySmall),
              Text(
                h2,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey
                      : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
