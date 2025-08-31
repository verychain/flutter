import 'package:flutter/material.dart';

class StatusRollingTabs extends StatelessWidget {
  /// 'all', 'pending', 'ongoing', 'completed', 'cancelled', 'reported'
  final String selected;
  final ValueChanged<String> onChanged;

  const StatusRollingTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = const <String, String>{
      'all': '전체',
      'ongoing': '진행중',
      'pending': '미체결',
      'completed': '거래완료',
      'reported': '이의제기',
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 14,
      ), // padding: 8px 14px
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18), // border-radius: 18px
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // justify-content: center
          crossAxisAlignment: CrossAxisAlignment.center, // align-items: center
          children: [
            for (final entry in tabs.entries) ...[
              _ChipTag(
                label: entry.value,
                selected: selected.toLowerCase() == entry.key,
                onTap: () => onChanged(entry.key),
              ),
              const SizedBox(width: 10), // gap: 10px
            ],
          ],
        ),
      ),
    );
  }
}

class _ChipTag extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChipTag({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? Colors.black87 : Colors.grey.shade200;
    final fg = selected ? Colors.white : Colors.black87;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 12,
          ), // 살짝 넉넉
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ),
      ),
    );
  }
}
