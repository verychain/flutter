import 'package:flutter/material.dart';
import 'package:demo_flutter/data/constants.dart';

class TradeSwitchWidget extends StatelessWidget {
  final bool isBuySelected;
  final ValueChanged<bool> onChanged;

  const TradeSwitchWidget({
    super.key,
    required this.isBuySelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      width: 184,
      height: 36, // 높이 고정
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(true),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: 30, // 내부 버튼 높이도 조정
                padding: EdgeInsets.symmetric(vertical: 0.0),
                decoration: BoxDecoration(
                  color: isBuySelected
                      ? AppColors.buyColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22.0),
                ),
                child: Center(
                  child: Text(
                    '매수',
                    style: TextStyle(
                      color: isBuySelected ? Colors.white : Colors.white70,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 3.0),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(false),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: 30, // 내부 버튼 높이도 조정
                padding: EdgeInsets.symmetric(vertical: 0.0),
                decoration: BoxDecoration(
                  color: !isBuySelected
                      ? AppColors.sellColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22.0),
                ),
                child: Center(
                  child: Text(
                    '매도',
                    style: TextStyle(
                      color: !isBuySelected ? Colors.white : Colors.white70,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
