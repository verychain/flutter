import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:demo_flutter/data/constants.dart';
import 'package:demo_flutter/model/trade_card.dart';
import 'package:demo_flutter/view/widgets/trade_switch_widget.dart';
import 'package:flutter/material.dart';
import 'package:demo_flutter/view/widgets/trade_card_widget.dart';
import 'package:demo_flutter/view/widgets/trade_sort_dropdown.dart';
import 'package:demo_flutter/model/type.dart';
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

  // --- 안전 파서 유틸 ---
  double _asDouble(dynamic v, [double def = 0.0]) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? def;
    return def;
  }

  int _asInt(dynamic v, [int def = 0]) {
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? def;
    return def;
  }

  String _asString(dynamic v, [String def = '']) {
    if (v == null) return def;
    return v.toString();
  }

  DateTime _asDate(dynamic v) {
    if (v is DateTime) return v;
    if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
    return DateTime.now();
  }

  // --- trades.json 로드 ---
  Future<void> loadTradesFromAsset() async {
    final jsonString = await rootBundle.loadString('assets/trades.json');
    final List<dynamic> jsonData = json.decode(jsonString) as List<dynamic>;

    final List<TradeCard> loaded = [];

    for (final raw in jsonData) {
      final m = raw as Map<String, dynamic>;

      final type = _asString(m['type']).toUpperCase(); // 'BUY' / 'SELL'
      final ranking = _asString(m['userRanking'], 'BRONZE').toUpperCase();

      loaded.add(
        TradeCard(
          type: type,
          successRate: _asDouble(m['successRate']),
          updatedAt: _asDate(m['updatedAt']),
          createdAt: _asDate(m['createdAt']),
          userName: _asString(m['userName']),
          userRanking: ranking,
          tradeCount: _asInt(m['tradeCount']),
          price: _asDouble(m['price']),
          quantity: _asDouble(m['quantity']),
          paymentMethods: _asString(m['paymentMethods']),
        ),
      );
    }

    setState(() {
      trades = loaded;
    });
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
          '주문 등록',
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
      itemCount: sortedTrades.length.toInt(),
      itemBuilder: (context, index) {
        return TradeCardWidget(
          trade: sortedTrades[index],
          isBuySelected: isBuySelected,
        );
      },
    );
  }
}
