// trade_history_page.dart
import 'dart:convert';
import 'package:demo_flutter/view/widgets/my_trade/status_rolling_tabs.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:demo_flutter/view/widgets/my_trade/my_trade.dart';
import 'package:demo_flutter/view/widgets/my_trade/my_trade_widget.dart';
import 'package:demo_flutter/view/pages/trade_detail_page.dart';

class TradeHistoryPage extends StatefulWidget {
  const TradeHistoryPage({super.key});

  @override
  State<TradeHistoryPage> createState() => _TradeHistoryPageState();
}

class _TradeHistoryPageState extends State<TradeHistoryPage> {
  List<MyTrade> trades = [];
  String _selectedStatus =
      'all'; // all/pending/ongoing/completed/cancelled/reported

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTrades();
  }

  Future<void> _loadTrades() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      final raw = await rootBundle.loadString('assets/my_trades.json');
      final decoded = jsonDecode(raw);

      // 배열 또는 { "trades": [...] } 둘 다 지원
      final List list = decoded is List ? decoded : (decoded['trades'] as List);

      final items = list.map((e) => MyTrade.fromJson(e)).toList();

      // 최신(updatedAt desc) 정렬
      items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      setState(() => trades = items);
    } catch (e) {
      setState(() => _error = '거래 내역을 불러오지 못했어요: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onRefresh() async => _loadTrades();

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedStatus == 'all'
        ? trades
        : trades
              .where((t) => t.status.toLowerCase().trim() == _selectedStatus)
              .toList();
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : (_error != null)
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_error!, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _loadTrades,
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            )
          : (trades.isEmpty
                ? const Center(
                    child: Text('거래 내역이 없습니다', style: TextStyle(fontSize: 14)),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: StatusRollingTabs(
                          selected: _selectedStatus,
                          onChanged: (v) => setState(() => _selectedStatus = v),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: _buildTradeList(filtered),
                        ),
                      ),
                    ],
                  )),
    );
  }

  Widget _buildTradeList(List<MyTrade> items) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      itemCount: items.length, // 필터된 목록 길이 사용
      itemBuilder: (context, index) {
        final trade = items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TradeDetailPage(trade: trade),
                ),
              );
            },
            child: MyTradeWidget(trade: trade),
          ),
        );
      },
    );
  }
}
