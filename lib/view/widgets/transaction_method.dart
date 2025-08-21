import 'package:demo_flutter/data/constants.dart';
import 'package:flutter/material.dart';

class TransactionMethod extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const TransactionMethod({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> methods = const [
    '은행',
    '카카오페이',
    '토스',
    '네이버 페이',
    'Remitly',
    'Paysend',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, top: 10.0, bottom: 10.0),
            child: Text(
              "거래 수단 선택",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [for (int i = 0; i < 3; i++) _buildButton(i)],
                ),
                SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [for (int i = 3; i < 6; i++) _buildButton(i)],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: selectedIndex == index
                ? AppColors.primary
                : Colors.white,
            side: BorderSide(color: Colors.grey.shade100, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            padding: EdgeInsets.symmetric(vertical: 4),
          ),
          onPressed: () => onSelected(index),
          child: Text(
            methods[index],
            style: TextStyle(
              fontSize: 14,
              color: selectedIndex == index
                  ? Colors.white
                  : Colors.grey.shade700,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
