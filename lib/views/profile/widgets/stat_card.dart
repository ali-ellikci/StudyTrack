import 'package:flutter/material.dart';
import 'local_types.dart';

class StatCard extends StatelessWidget {
  final String h1;
  final String h2;
  final LocalSpacing spacing;
  final LocalSizes sizes;
  final IconData? icon;
  const StatCard({
    super.key,
    required this.h1,
    required this.h2,
    required this.spacing,
    required this.sizes,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: spacing.l * 1.1,
        horizontal: spacing.xl * 1.1,
      ),
      decoration: BoxDecoration(
        color: Color.lerp(
          Theme.of(context).scaffoldBackgroundColor,
          Colors.white,
          0.05,
        )!,
        borderRadius: BorderRadius.circular(spacing.m),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            h1,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: spacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: sizes.icon * 0.5,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey
                      : Colors.black,
                ),
                SizedBox(width: spacing.s),
              ],
              Text(
                h2.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
