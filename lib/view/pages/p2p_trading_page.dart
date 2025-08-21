import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:demo_flutter/data/constants.dart';
import 'package:demo_flutter/model/trade_card.dart';
import 'package:demo_flutter/view/widgets/trade_switch_widget.dart';
import 'package:flutter/material.dart';
import 'package:demo_flutter/view/widgets/trade_card_widget.dart';
import 'package:demo_flutter/view/widgets/trade_sort_dropdown.dart';
import 'package:demo_flutter/model/trade_sort_type.dart';
import 'package:demo_flutter/view/pages/create_offer_page.dart'; // <-- CreateOfferPage 임포트

class P2PTradingPage extends StatefulWidget {
  const P2PTradingPage({super.key});

  @override
  State<P2PTradingPage> createState() => _P2PTradingPageState();
}

class _P2PTradingPageState extends State<P2PTradingPage>
    with TickerProviderStateMixin {
  bool isBuySelected = true;
  late TabController _tabController;

  late List<TradeCard> trades = []; // 모든 거래를 한 바구니에 담음

  TradeSortType _sortType = TradeSortType.price;

  // 등급 순서 정의
  final List<String> rankingOrder = ['BRONZE', 'SILVER', 'GOLD', 'PLATINUM'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadTradesFromAsset();
  }

  Future<void> loadTradesFromAsset() async {
    final String jsonString = await rootBundle.loadString('assets/trades.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    trades = [];

    for (var item in jsonData) {
      final trade = TradeCard(
        type: item['type'] ?? '',
        successRate: item['successRate'] ?? 0.0,
        updatedAt: DateTime.parse(
          item['updatedAt'] ?? DateTime.now().toIso8601String(),
        ),
        createdAt: DateTime.parse(
          item['createdAt'] ?? DateTime.now().toIso8601String(),
        ),
        userName: item['userName'] ?? '',
        tradeCount: item['tradeCount'] ?? 0,
        price: item['price'] ?? 0,
        quantity: item['quantity'] ?? 0,
        paymentMethods: item['paymentMethods'] ?? '',
        userRanking: item['userRanking'] ?? 'BRONZE',
      );
      trades.add(trade);
    }
    setState(() {});
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
          _buildBannerAd(),

          TradeSwitchWidget(
            isBuySelected: isBuySelected,
            onChanged: (value) {
              setState(() {
                isBuySelected = value;
              });
            },
          ),

          // 정렬 필터 영역 (콤보박스 스타일)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TradeSortDropdown(
                  sortType: _sortType,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _sortType = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),

          Expanded(child: _buildTradeList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateOfferPage()),
          );
        },
        label: Text(
          '거래 등록하기',
          style: TextStyle(fontSize: 18.0, color: Colors.white),
        ),
        icon: Icon(Icons.add, color: Colors.white),
        backgroundColor: AppColors.primary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // 하단 오른쪽
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

  Widget _buildTradeList() {
    final filteredTrades = trades
        .where(
          (trade) => isBuySelected ? trade.type == 'BUY' : trade.type == 'SELL',
        )
        .toList();

    // 정렬 적용
    List<TradeCard> sortedTrades = [...filteredTrades];
    switch (_sortType) {
      case TradeSortType.price:
        sortedTrades.sort((a, b) => b.price.compareTo(a.price));
        break;
      case TradeSortType.ranking:
        sortedTrades.sort(
          (a, b) => rankingOrder
              .indexOf(b.userRanking)
              .compareTo(rankingOrder.indexOf(a.userRanking)),
        );
        break;
      case TradeSortType.totalAmount:
        sortedTrades.sort(
          (a, b) => (b.price * b.quantity).compareTo(a.price * a.quantity),
        );
        break;
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: sortedTrades.length,
      itemBuilder: (context, index) {
        return TradeCardWidget(
          trade: sortedTrades[index],
          isBuySelected: isBuySelected,
          formatTimeAgo: _formatTimeAgo,
          formatNumber: _formatNumber,
        );
      },
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

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
}
