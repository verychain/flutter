// my_trade.dart
class MyTrade {
  final DateTime updatedAt;
  final DateTime createdAt;
  final String userName;
  final String userRanking;
  final String type; // BUY / SELL
  final int tradeCount;
  final double successRate;
  final double price;
  final double quantity;
  final String paymentMethods; // 예: "은행"
  final String status; // 예: "completed", "pending"

  MyTrade({
    required this.updatedAt,
    required this.createdAt,
    required this.type,
    required this.userName,
    required this.userRanking,
    required this.tradeCount,
    required this.successRate,
    required this.price,
    required this.quantity,
    required this.paymentMethods,
    required this.status,
  });

  factory MyTrade.fromJson(Map<String, dynamic> j) {
    double _toD(dynamic v) {
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v.replaceAll(',', '')) ?? 0;
      return 0;
    }

    int _toI(dynamic v) {
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String) return int.tryParse(v.replaceAll(',', '')) ?? 0;
      return 0;
    }

    DateTime _toDT(dynamic v) {
      if (v is DateTime) return v;
      if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
      if (v is num) return DateTime.fromMillisecondsSinceEpoch(v.toInt());
      return DateTime.now();
    }

    return MyTrade(
      updatedAt: _toDT(j['updatedAt']),
      createdAt: _toDT(j['createdAt']),
      userName: j['userName'] ?? '',
      userRanking: j['userRanking'] ?? 'BRONZE',
      type: j['type'] ?? 'BUY',
      tradeCount: _toI(j['tradeCount']),
      successRate: _toD(j['successRate']),
      price: _toD(j['price']),
      quantity: _toD(j['quantity']),
      paymentMethods: j['paymentMethods'] ?? '',
      status: j['status'] ?? 'pending',
    );
  }
}
