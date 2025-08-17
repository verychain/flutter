class TradeCard {
  final DateTime updatedAt;
  final DateTime createdAt;
  final String userName;
  final String userRanking;
  final String type;
  final int tradeCount;
  final double successRate;
  final int price;
  final int quantity;
  final String paymentMethods;

  TradeCard({
    required this.updatedAt,
    required this.createdAt,
    required this.type, // 거래 유형
    required this.userName, // user nickname
    required this.userRanking, // user ranking
    required this.tradeCount, // 거래 횟수
    required this.successRate, // 성공률
    required this.price, // 거래 가격
    required this.quantity, // 거래 수량
    required this.paymentMethods, // 거래 방법
  });
}
