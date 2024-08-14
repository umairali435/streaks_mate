import 'package:flutter/material.dart';
import 'package:streaksmate/widgets/streaks_container.dart';

class StreakMenu extends StatefulWidget {
  final VoidCallback onTap;
  final Widget icon;
  final String text;
  const StreakMenu({super.key, required this.icon, required this.text, required this.onTap});

  @override
  State createState() => _StreakMenuState();
}

class _StreakMenuState extends State<StreakMenu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      child: Row(
        children: <Widget>[
          StreakContainer(
            onTap: widget.onTap,
            child: widget.icon,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
            ),
            child: Text(
              widget.text,
            ),
          ),
        ],
      ),
    );
  }
}
