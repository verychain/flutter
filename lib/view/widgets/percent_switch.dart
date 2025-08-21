import 'package:flutter/material.dart';

class PercentSwitch extends StatelessWidget {
  final double? selectedPercent;
  final ValueChanged<double> onPercentSelected;

  final List<String> labels = const ['10%', '25%', '50%', '75%', '최대'];
  final List<double> percents = const [0.1, 0.25, 0.5, 0.75, 1.0];

  const PercentSwitch({
    super.key,
    required this.selectedPercent,
    required this.onPercentSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54,
      height: 32, // 높이도 32으로 맞춰줌
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade400, width: 1),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<double>(
            value: selectedPercent != null
                ? selectedPercent
                : null, // 값이 없으면 hint가 보임
            hint: SizedBox(
              width: 54,
              height: 32,

              child: Center(
                child: Text(
                  '비율',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            items: List.generate(
              percents.length,
              (i) => DropdownMenuItem<double>(
                value: percents[i],
                child: SizedBox(
                  width: 40,
                  child: Text(
                    labels[i],
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            onChanged: (value) {
              if (value != null) {
                onPercentSelected(value);
              }
            },
            borderRadius: BorderRadius.circular(4),
            style: TextStyle(fontSize: 12, color: Colors.black),
            icon: Icon(Icons.arrow_drop_down, size: 18),
            isExpanded: true,
            dropdownColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
