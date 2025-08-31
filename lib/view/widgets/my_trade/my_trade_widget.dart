import 'package:demo_flutter/data/constants.dart';
import 'package:demo_flutter/view/widgets/my_trade/bottom_hint_bar.dart';
import 'package:demo_flutter/view/widgets/my_trade/my_trade.dart';
import 'package:demo_flutter/view/widgets/my_trade/status_message.dart';
import 'package:demo_flutter/view/widgets/my_trade/status_tag.dart';
import 'package:flutter/material.dart';
import 'package:demo_flutter/utils/format_utils.dart';

class MyTradeWidget extends StatelessWidget {
  final MyTrade trade;
  final VoidCallback? onTap; // ⬅️ 추가

  const MyTradeWidget({super.key, required this.trade, this.onTap});

  @override
  Widget build(BuildContext context) {
    final msg = statusMessageFor(trade);
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
      padding: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                trade.type == "BUY" ? '매수' : '매도',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: trade.type == "BUY"
                                      ? AppColors.buyColor
                                      : AppColors.sellColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 8.0),
                              StatusTag(status: trade.status),
                              SizedBox(width: 8.0),
                              Text(
                                formatTimeAgo(trade.createdAt),
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 11.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                    Spacer(),
                    if (trade.userName == "한사랑동호회")
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '내 주문',
                          textAlign: TextAlign
                              .center, // justify-content/align-items center 느낌
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.purple.shade800,
                            height: 1.0,
                          ),
                        ),
                      ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "총액",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${formatNumberWithComma(trade.quantity)} VERY',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                formatNumberWithComma(
                                  trade.price * trade.quantity,
                                ),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 4.0),
                              Text(
                                '원',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          '단위가격 ',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.red.shade800,
                          ),
                        ),
                        Text(
                          '${trade.price}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade800,
                          ),
                        ),
                        Text(
                          ' 원',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.red.shade800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          BottomHintBar(text: msg),
        ],
      ),
    );
  }
}
