import 'package:flutter/material.dart';
import 'package:demo_flutter/data/constants.dart';

class SessionStepper extends StatelessWidget {
  final int activeStep; // 0: 첫 단계
  final List<String> steps; // 부모에서 전달받음

  const SessionStepper({super.key, required this.steps, this.activeStep = 0});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          // Divider
          return Align(
            alignment: Alignment.topCenter,
            child: Container(
              width:
                  MediaQuery.of(context).size.width /
                  (steps.length == 4
                      ? steps.length * 3
                      : steps.length * 2), // 더 좁게 조절
              height: 1,
              color: Colors.grey.shade300,
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
            ),
          );
        } else {
          final idx = i ~/ 2;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: activeStep == idx ? AppColors.primary : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: activeStep == idx
                        ? AppColors.primary
                        : Colors.grey.shade200,
                    width: 2,
                  ),
                ),
              ),
              SizedBox(height: 6),
              Text(
                steps[idx],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }
      }),
    );
  }
}
