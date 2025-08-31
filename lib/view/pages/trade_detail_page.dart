import 'package:demo_flutter/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:demo_flutter/view/widgets/exchange_summary_card.dart';
import 'package:demo_flutter/view/widgets/my_trade/my_trade.dart';
import 'package:intl/intl.dart';

// trade_detail_page.dart (상단에 유틸/상수 추가)
const _kStatusTextStyle = TextStyle(
  color: Color(0xFF1C2029),
  fontFamily: 'Pretendard',
  fontSize: 24,
  fontWeight: FontWeight.w600,
  height: 14 / 24, // CSS line-height 14px 대응 (필요시 1.2~1.4로 조정)
);

String statusLabel(String status) {
  switch (status.toLowerCase().trim()) {
    case 'completed':
      return '거래완료';
    case 'cancelled':
      return '거래 취소';
    case 'reported':
      return '이의 제기';
    case 'pending':
      return '미체결';
    case 'ongoing':
      return '진행중';
    default:
      return status; // 혹시 모를 값
  }
}

class TradeDetailPage extends StatelessWidget {
  final MyTrade trade;
  const TradeDetailPage({super.key, required this.trade});

  String _fmtDate(DateTime? dt) {
    if (dt == null) return '-';
    return DateFormat('yyyy.MM.dd HH:mm:ss').format(dt);
  }

  String _two(int n) => n.toString().padLeft(2, '0');
  String formatUpdatedAt(DateTime dt) {
    final kst = dt.toLocal(); // 필요시 타임존 보정
    return '${kst.year}.${_two(kst.month)}.${_two(kst.day)} '
        '${_two(kst.hour)}:${_two(kst.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final total = (trade.price * trade.quantity);
    return Scaffold(
      appBar: AppBar(
        title: const Text('거래 상세'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(statusLabel(trade.status), style: _kStatusTextStyle),
            SizedBox(height: 10),
            Text(
              formatUpdatedAt(trade.updatedAt),
              style: const TextStyle(
                // color: const Colors.grey.shade400,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),

            SizedBox(height: 26.0),
            ExchangeSummaryCard(
              isBuy: trade.type == 'BUY',
              sendAmountKrw: trade.quantity * trade.price,
              receiveQuantity: trade.quantity,
              unitPriceKrw: trade.price,
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _txTile('유형', trade.type),
                  _tile('수량', '${trade.quantity}'),
                  _tile('단가', '${trade.price} 원'),
                  _tile('총액', '${(trade.price * trade.quantity)} 원'),

                  _tile('생성 시간', _fmtDate(trade.createdAt)),
                  _tile('업데이트 시간', _fmtDate(trade.updatedAt)),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      t,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    ),
  );

  Widget _tile(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        SizedBox(
          width: 96,
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
  );
  Widget _txTile(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        SizedBox(
          width: 96,
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
          ),
        ),
        Expanded(
          child: Text(
            value.toUpperCase() == 'BUY' ? '매수' : '매도',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: value.toUpperCase() == 'BUY'
                  ? AppColors.buyColor
                  : AppColors.sellColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}
