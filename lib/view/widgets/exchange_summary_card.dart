import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExchangeSummaryCard extends StatelessWidget {
  final bool isBuy;
  final num sendAmountKrw; // 왼쪽: 보낼 금액(원)
  final num receiveQuantity; // 오른쪽: 받을 수량(토큰 수량)
  final num unitPriceKrw; // 하단: 단위가격(원)
  final String tokenSymbol; // 'VERY' 등
  final EdgeInsets padding;
  final double borderRadius;

  const ExchangeSummaryCard({
    super.key,
    required this.isBuy,
    required this.sendAmountKrw,
    required this.receiveQuantity,
    required this.unitPriceKrw,
    this.tokenSymbol = 'VERY',
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 16,
  });

  // ---------- formatting helpers ----------
  String _fmtInt(num n) {
    final f = NumberFormat.decimalPattern();
    f.minimumFractionDigits = 0;
    f.maximumFractionDigits = 0;
    return f.format(n);
  }

  String _fmtNum(num n, {int maxFrac = 2}) {
    final f = NumberFormat.decimalPattern();
    f.minimumFractionDigits = 0;
    f.maximumFractionDigits = maxFrac;
    return f.format(n);
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(fontSize: 12, color: Colors.black87);
    final subLabelStyle = TextStyle(
      fontSize: 14,
      color: Colors.grey.shade600,
      fontWeight: FontWeight.w500,
    );
    final bigNumberStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.1,
      color: Colors.black,
    );
    final unitStyle = TextStyle(
      fontSize: 16,
      color: Colors.grey.shade600,
      fontWeight: FontWeight.w500,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft, // 90deg → 왼쪽 → 오른쪽
          end: Alignment.centerRight,
          colors: [
            Color.fromRGBO(255, 126, 131, 0.30), // rgba(255,126,131,0.30)
            Color.fromRGBO(255, 126, 131, 0.30), // 동일 색상 반복
            Color.fromRGBO(178, 151, 253, 0.30), // rgba(178,151,253,0.30)
          ],
          stops: [
            0.0185, // 1.85%
            0.2144, // 21.44%
            0.9978, // 99.78%
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),

      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 상단: 좌/우 값 + 가운데 화살표
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 왼쪽
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isBuy ? '보낼 금액' : '받을 금액', style: labelStyle),
                    SizedBox(height: 6),
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.center, // 가운데 정렬로 변경
                      children: [
                        Text(_fmtInt(sendAmountKrw), style: bigNumberStyle),
                        SizedBox(width: 6),
                        Text('원', style: unitStyle),
                      ],
                    ),
                  ],
                ),
              ),
              // 가운데 화살표
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    Icon(Icons.arrow_forward, size: 18, color: Colors.black87),
                    SizedBox(height: 4),
                    Icon(Icons.arrow_back, size: 18, color: Colors.black87),
                  ],
                ),
              ),
              // 오른쪽
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(isBuy ? '받을 수량' : '보낸 수량', style: labelStyle),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(_fmtNum(receiveQuantity), style: bigNumberStyle),
                        SizedBox(width: 6),
                        Text(tokenSymbol, style: unitStyle),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
          Divider(height: 1, thickness: 1, color: Colors.grey.shade600),
          SizedBox(height: 18),
          // 하단: 단위 가격
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // space-between 적용
            children: [
              Text('단위 가격', style: subLabelStyle),
              Text(
                '${_fmtNum(unitPriceKrw, maxFrac: 2)} 원',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
