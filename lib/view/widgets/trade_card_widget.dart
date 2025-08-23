import 'package:flutter/material.dart';
import 'package:demo_flutter/model/trade_card.dart';
import 'package:demo_flutter/view/pages/order_detail_page.dart';
import 'package:demo_flutter/utils/format_utils.dart';

class TradeCardWidget extends StatelessWidget {
  final TradeCard trade;
  final bool isBuySelected;

  const TradeCardWidget({
    super.key,
    required this.trade,
    required this.isBuySelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailPage(
              isBuySelected: isBuySelected,
              trade: trade, // trade 값 전달
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.0),
        padding: EdgeInsets.all(16.0),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/rank_${trade.userRanking.toLowerCase()}.png',
                            height: 20,
                            width: 20,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 6.0),
                          Flexible(
                            // <--- 추가
                            child: Text(
                              trade.userName,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w300,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.0,
                              vertical: 2.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Text(
                              trade.paymentMethods,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 8.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '거래 ${formatNumberWithComma(trade.tradeCount)}회',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            '성공률 ${trade.successRate.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
                Spacer(),
                Column(
                  children: [
                    Text(
                      formatTimeAgo(trade.createdAt),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11.0,
                      ),
                    ),
                  ],
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
                            formatNumberWithComma(trade.price * trade.quantity),
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
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
