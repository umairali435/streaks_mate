import 'package:flutter/material.dart';

class StreakContainer extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color? color;
  const StreakContainer({
    super.key,
    required this.child,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
        color: color,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(
          5.0,
        ),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          child: child,
        ),
      ),
    );
  }
}
