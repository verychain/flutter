import 'package:demo_flutter/utils/format_utils.dart';
import 'package:demo_flutter/view/widgets/timer_text.dart';
import 'package:flutter/material.dart';
import 'package:demo_flutter/models/order_draft.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class SendWidget extends StatefulWidget {
  final String title;
  final OrderDraft draft;

  const SendWidget({super.key, required this.title, required this.draft});

  @override
  State<SendWidget> createState() => _SendWidgetState();
}

class _SendWidgetState extends State<SendWidget> {
  static const int countdownSeconds = 15 * 60;
  late int _secondsLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = countdownSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        timer.cancel(); // 타이머가 끝나면 반드시 cancel!
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // 위젯이 dispose될 때 반드시 cancel!
    super.dispose();
  }

  // ---- format helpers ----
  String _fmtKrw(num n) {
    final f = NumberFormat.decimalPattern();
    f.minimumFractionDigits = 0;
    f.maximumFractionDigits = 0;
    return f.format(n);
  }

  String _fmtToken(num n, {int maxFrac = 4}) {
    final f = NumberFormat.decimalPattern();
    f.minimumFractionDigits = 0;
    f.maximumFractionDigits = maxFrac;
    return f.format(n);
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    final isSell = !draft.isBuy;
    final token = draft.asset;

    final sendAmount = isSell
        ? draft.quantity + (draft.quantity * draft.feeRate)
        : draft.price * draft.quantity;

    final copyText = isSell
        ? _fmtToken(sendAmount, maxFrac: 4)
        : _fmtKrw(sendAmount);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isSell ? '보낼 수량' : '보낼 금액',
                style: const TextStyle(fontSize: 16),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isSell ? '$copyText $token' : '$copyText 원',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Text(
                '수수료 ${draft.feeRate * 100}%  ${formatWithComma(draft.quantity * draft.feeRate, minFractionDigits: 0, maxFractionDigits: 2)} VERY',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              SizedBox(height: 45),
              Text(
                widget.draft.isBuy
                    ? '아래 계좌로 원화를 보내주세요'
                    : '아래 컨트랙트 주소로 VERY를 보내주세요',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 14),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  hintText: draft.isBuy
                      ? '국민은행 91058742257'
                      : maskAddress(
                          '0x93b0fb5B0c7B447924acbfC152971340ea5a1C7A',
                        ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(
                            text: draft.isBuy
                                ? '국민은행 91058742257'
                                : '0x93b0fb5B0c7B447924acbfC152971340ea5a1C7A',
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              draft.isBuy ? '계좌번호가 복사되었습니다' : '주소가 복사되었습니다',
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.copy,
                            size: 18,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '복사',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // 타이머 영역 추가
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [TimerText(secondsLeft: _secondsLeft)],
              ),
              SizedBox(height: 32),
              Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 6,
                        ), // 패딩 조정
                        tapTargetSize:
                            MaterialTapTargetSize.shrinkWrap, // 터치 영역 줄이기
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(color: Colors.grey.shade600),
                      ),
                      child: Text(
                        '거래 취소하기',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '문제가 생기셨나요?',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(width: 10),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 6,
                            ), // 패딩 조정
                            tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap, // 터치 영역 줄이기
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: BorderSide(color: Colors.grey.shade600),
                          ),
                          onPressed: () {},
                          child: Text(
                            '문의하기',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
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
