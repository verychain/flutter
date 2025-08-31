import 'package:flutter/material.dart';

class StatusTag extends StatelessWidget {
  final String status; // "cancelled" | "completed" | "reported" | "pending"
  final double radius;
  final EdgeInsetsGeometry padding;

  const StatusTag({
    super.key,
    required this.status,
    this.radius = 6,
    this.padding = const EdgeInsets.symmetric(vertical: 6, horizontal: 7),
  });

  @override
  Widget build(BuildContext context) {
    final s = _styleOf(status);

    return Container(
      padding: padding, // padding: 6px 7px;
      decoration: BoxDecoration(
        color: s.bg,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(
        s.label,
        textAlign: TextAlign.center, // justify-content/align-items center 느낌
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: s.fg,
          height: 1.0,
        ),
      ),
    );
  }
}

class _TagStyle {
  final String label;
  final Color bg;
  final Color fg;
  const _TagStyle(this.label, this.bg, this.fg);
}

/// status → 라벨/색상 매핑
_TagStyle _styleOf(String raw) {
  final s = raw.toLowerCase().trim();
  switch (s) {
    case 'pending': // 미체결 - 옅은 회색
      return _TagStyle('미체결', const Color(0xFFF0F0F0), Colors.grey);
    case 'completed': // 거래완료 - #C9F1C4
      return _TagStyle(
        '거래완료',
        const Color(0xFFC9F1C4),
        const Color(0xFF256C1A),
      );
    case 'reported': // 이의제기 - #FF9650
      return _TagStyle('이의제기', const Color(0xFFFF9650), Colors.white);
    case 'ongoing': // 진행중 - #FFF6A4
      return _TagStyle('진행중', const Color(0xFFFFF6A4), const Color(0xFF5F5A00));
    default:
      return _TagStyle(raw, Colors.grey.shade200, Colors.grey.shade800);
  }
}
