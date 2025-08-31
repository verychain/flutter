// lib/view/widgets/my_trade/bottom_hint_bar.dart
import 'package:flutter/material.dart';

class BottomHintBar extends StatelessWidget {
  final String text;
  const BottomHintBar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                height: 1.2,
              ),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.keyboard_double_arrow_right_rounded,
            size: 16,
            color: Colors.grey.shade600,
          ),
        ],
      ),
    );
  }
}
