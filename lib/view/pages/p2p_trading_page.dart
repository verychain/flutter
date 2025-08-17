import 'package:demo_flutter/data/constants.dart';
import 'package:demo_flutter/view/widgets/trade_switch_widget.dart';
import 'package:flutter/material.dart';
import 'dart:math'; // 랜덤 함수를 위해 추가

class P2PTradingPage extends StatefulWidget {
  const P2PTradingPage({super.key});

  @override
  State<P2PTradingPage> createState() => _P2PTradingPageState();
}

class _P2PTradingPageState extends State<P2PTradingPage>
    with TickerProviderStateMixin {
  bool isBuySelected = true; // true: 매수, false: 매도
  late TabController _tabController;

  // 랜덤 과거 시간 생성 함수
  DateTime _getRandomPastTime() {
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));
    final random = Random();

    // 어제부터 지금까지의 시간 범위에서 랜덤 선택
    final totalMinutes = now.difference(yesterday).inMinutes;
    final randomMinutes = random.nextInt(totalMinutes);

    return yesterday.add(Duration(minutes: randomMinutes));
  }

  // 시간 포맷팅 함수
  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}일전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분전';
    } else {
      return '방금전';
    }
  }

  // 샘플 거래 데이터 - 생성자에서 랜덤 시간 할당
  late final List<TradeCard> buyTrades;
  late final List<TradeCard> sellTrades;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // 랜덤 시간으로 데이터 초기화
    buyTrades = [
      TradeCard(
        updatedAt: _getRandomPastTime(),
        createdAt: _getRandomPastTime(),
        userName: "김거래자",
        userRating: 98.5,
        tradeCount: 245,
        price: 1350.50,
        minAmount: 50000,
        maxAmount: 1000000,
        paymentMethods: ["신한은행", "카카오페이"],
        responseTime: "평균 2분",
      ),
      TradeCard(
        updatedAt: _getRandomPastTime(),
        createdAt: _getRandomPastTime(),
        userName: "박트레이더",
        userRating: 99.2,
        tradeCount: 156,
        price: 1351.20,
        minAmount: 100000,
        maxAmount: 500000,
        paymentMethods: ["국민은행", "토스"],
        responseTime: "평균 1분",
      ),
      TradeCard(
        updatedAt: _getRandomPastTime(),
        createdAt: _getRandomPastTime(),
        userName: "이코인러",
        userRating: 97.8,
        tradeCount: 89,
        price: 1352.00,
        minAmount: 30000,
        maxAmount: 2000000,
        paymentMethods: ["우리은행", "페이코"],
        responseTime: "평균 3분",
      ),
    ];

    sellTrades = [
      TradeCard(
        updatedAt: _getRandomPastTime(),
        createdAt: _getRandomPastTime(),
        userName: "최셀러",
        userRating: 99.0,
        tradeCount: 312,
        price: 1348.80,
        minAmount: 100000,
        maxAmount: 800000,
        paymentMethods: ["하나은행", "카카오페이"],
        responseTime: "평균 1분",
      ),
      TradeCard(
        updatedAt: _getRandomPastTime(),
        createdAt: _getRandomPastTime(),
        userName: "정판매자",
        userRating: 96.5,
        tradeCount: 67,
        price: 1347.50,
        minAmount: 50000,
        maxAmount: 1500000,
        paymentMethods: ["신한은행", "토스"],
        responseTime: "평균 4분",
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 배너 광고
          _buildBannerAd(),

          // 매수/매도 스위치 버튼
          TradeSwitchWidget(
            isBuySelected: isBuySelected,
            onChanged: (value) {
              setState(() {
                isBuySelected = value;
              });
            },
          ),

          // 거래 카드 리스트
          Expanded(child: _buildTradeList()),
        ],
      ),
    );
  }

  Widget _buildBannerAd() {
    return Container(
      width: double.infinity,
      height: 100.0,
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.purple.shade400],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '🎉 P2P 거래 수수료 50% 할인',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              '이번 주 한정 특가 이벤트',
              style: TextStyle(color: Colors.white70, fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTradeSwitch() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: EdgeInsets.all(3.0), // 4.0에서 3.0으로 줄임
      decoration: BoxDecoration(
        color: Color(0xFF1E2939), // 배경색을 #1E2939로 변경
        borderRadius: BorderRadius.circular(25.0), // 30.0에서 25.0으로 줄임
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isBuySelected = true;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                ), // 14.0에서 10.0으로 줄임
                decoration: BoxDecoration(
                  color: isBuySelected
                      ? AppColors.buyColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22.0), // 26.0에서 22.0으로 줄임
                  boxShadow: isBuySelected
                      ? [
                          BoxShadow(
                            color: AppColors.buyColor.withOpacity(0.3),
                            blurRadius: 8.0,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    '매수',
                    style: TextStyle(
                      color: isBuySelected ? Colors.white : Colors.white70,
                      fontSize: 15.0, // 16.0에서 15.0으로 줄임
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 3.0), // 4.0에서 3.0으로 줄임
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isBuySelected = false;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                ), // 14.0에서 10.0으로 줄임
                decoration: BoxDecoration(
                  color: !isBuySelected
                      ? AppColors.sellColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22.0), // 26.0에서 22.0으로 줄임
                  boxShadow: !isBuySelected
                      ? [
                          BoxShadow(
                            color: AppColors.sellColor,
                            blurRadius: 8.0,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    '매도',
                    style: TextStyle(
                      color: !isBuySelected ? Colors.white : Colors.white70,
                      fontSize: 15.0, // 16.0에서 15.0으로 줄임
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

  Widget _buildTradeList() {
    final trades = isBuySelected ? buyTrades : sellTrades;

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: trades.length,
      itemBuilder: (context, index) {
        return _buildTradeCardWidget(trades[index]);
      },
    );
  }

  Widget _buildTradeCardWidget(TradeCard trade) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade200),
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
          // 사용자 정보 행
          Row(
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundColor: AppColors.primary,
                child: Text(
                  trade.userName[0],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 첫 번째 행: 이름과 업데이트 시간
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            trade.userName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Text(
                            _formatTimeAgo(trade.updatedAt),
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 10.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    // 두 번째 행: 평점과 응답시간
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 14.0),
                        SizedBox(width: 4.0),
                        Flexible(
                          flex: 2,
                          child: Text(
                            '${trade.userRating}% (${trade.tradeCount}회)',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Flexible(
                          flex: 2,
                          child: Text(
                            trade.responseTime,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.0),
                    // 세 번째 행: 등록 시간
                    Text(
                      '등록 ${_formatTimeAgo(trade.createdAt)}',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11.0,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.0),
              // 가격
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₩${trade.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: isBuySelected
                          ? AppColors.buyColor
                          : AppColors.sellColor,
                    ),
                  ),
                  Text(
                    'USDT',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 12.0),

          // 거래 한도
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                size: 16.0,
                color: Colors.grey.shade600,
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  '한도: ₩${_formatNumber(trade.minAmount)} - ₩${_formatNumber(trade.maxAmount)}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14.0),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.0),

          // 결제 방법
          Row(
            children: [
              Icon(Icons.payment, size: 16.0, color: Colors.grey.shade600),
              SizedBox(width: 8.0),
              Expanded(
                child: Wrap(
                  spacing: 6.0,
                  runSpacing: 4.0,
                  children: trade.paymentMethods.map((method) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        method,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  void _showTradeDialog(TradeCard trade) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${isBuySelected ? '매수' : '매도'} 확인'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('거래자: ${trade.userName}'),
              Text('가격: ₩${trade.price.toStringAsFixed(2)} USDT'),
              Text(
                '한도: ₩${_formatNumber(trade.minAmount)} - ₩${_formatNumber(trade.maxAmount)}',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('거래 요청이 전송되었습니다.')));
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}

// 거래 카드 데이터 모델
class TradeCard {
  final DateTime updatedAt;
  final DateTime createdAt;
  final String userName;
  final double userRating;
  final int tradeCount;
  final double price;
  final int minAmount;
  final int maxAmount;
  final List<String> paymentMethods;
  final String responseTime;

  TradeCard({
    required this.updatedAt,
    required this.createdAt,
    required this.userName,
    required this.userRating,
    required this.tradeCount,
    required this.price,
    required this.minAmount,
    required this.maxAmount,
    required this.paymentMethods,
    required this.responseTime,
  });
}
