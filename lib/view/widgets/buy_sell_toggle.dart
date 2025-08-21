import 'package:flutter/material.dart';
import 'package:demo_flutter/data/constants.dart';

class BuySellToggle extends StatelessWidget {
  final bool isBuySelected;
  final ValueChanged<bool> onChanged;

  const BuySellToggle({
    super.key,
    required this.isBuySelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: SizedBox(
            width: 145,
            height: 35,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                backgroundColor: isBuySelected
                    ? AppColors.buyColor
                    : Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              ),
              onPressed: () => onChanged(true),
              child: Text(
                '매수 등록',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: isBuySelected ? Colors.white : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
          child: SizedBox(
            width: 145,
            height: 35,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                backgroundColor: !isBuySelected
                    ? AppColors.sellColor
                    : Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              ),
              onPressed: () => onChanged(false),
              child: Text(
                '매도 등록',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: !isBuySelected ? Colors.white : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
