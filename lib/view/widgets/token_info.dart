import 'package:flutter/material.dart';

class TokenInfo extends StatelessWidget {
  final String assetName;
  final double avg24h;
  final double deltaDay;
  final double high;
  final double avg7d;
  final double deltaWeek;
  final double low;

  const TokenInfo({
    super.key,
    required this.assetName,
    required this.avg24h,
    required this.deltaDay,
    required this.high,
    required this.avg7d,
    required this.deltaWeek,
    required this.low,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            assetName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      '24시간 평균',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Spacer(),
                    Text(
                      avg24h.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(width: 4),

                    Text(
                      '${deltaDay >= 0 ? '+' : '-'}${deltaDay.abs()}%',
                      style: TextStyle(
                        fontSize: 14,
                        color: deltaDay >= 0 ? Colors.red : Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      '고가',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Spacer(),
                    Text(
                      high.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      '7일 평균',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Spacer(),
                    Text(
                      avg7d.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${deltaWeek >= 0 ? '+' : '-'}${deltaWeek.abs()}%',
                      style: TextStyle(
                        fontSize: 14,
                        color: deltaWeek >= 0 ? Colors.red : Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 6),

              Expanded(
                child: Row(
                  children: [
                    Text(
                      '저가',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Spacer(),
                    Text(
                      low.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
