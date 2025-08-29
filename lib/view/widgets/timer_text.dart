import 'package:flutter/material.dart';

class TimerText extends StatelessWidget {
  final int secondsLeft;
  final TextStyle? textStyle;
  final Color? iconColor;
  final double iconSize;

  const TimerText({
    super.key,
    required this.secondsLeft,
    this.textStyle,
    this.iconColor,
    this.iconSize = 18,
  });

  String _formatTime(int seconds) {
    final min = (seconds ~/ 60).toString();
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min분 $sec초';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          Icons.timer_outlined,
          size: iconSize,
          color: iconColor ?? Colors.black87,
        ),
        const SizedBox(width: 4),
        Text(
          _formatTime(secondsLeft),
          style:
              textStyle ??
              TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
