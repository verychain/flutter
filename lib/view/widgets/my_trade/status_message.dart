// lib/view/widgets/my_trade/status_message.dart
import 'package:demo_flutter/view/widgets/my_trade/my_trade.dart';

String statusMessageFor(MyTrade t) {
  final s = t.status
      .toLowerCase()
      .trim(); // cancelled/completed/reported/pending/ongoing
  final isBuyer = t.type.toUpperCase().trim() == 'BUY';

  switch (s) {
    case 'completed':
      return '거래가 완료되었어요';
    case 'reported':
      return '송금 후 반환받지 못했어요';
    case 'pending':
      return isBuyer ? '구매자를 기다리고 있어요' : '판매자를 기다리고 있어요';
    case 'ongoing':
      return isBuyer ? '원화를 입금해주세요' : 'VERY를 입금해주세요';
    default:
      return '';
  }
}
