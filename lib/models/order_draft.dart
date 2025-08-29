class OrderDraft {
  final bool isBuy; // 매수: true, 매도: false
  final String asset; // 예: "VERY"
  final double price; // 단가
  final double quantity; // 수량
  final double feeRate; // 0.0005 = 0.05%

  const OrderDraft({
    required this.isBuy,
    required this.asset,
    required this.price,
    required this.quantity,
    this.feeRate = 0.0005,
  });

  double get total => price * quantity;
  double get fee => isBuy ? 0 : quantity * feeRate;

  OrderDraft copyWith({
    bool? isBuy,
    String? asset,
    double? price,
    double? quantity,
    double? feeRate,
  }) {
    return OrderDraft(
      isBuy: isBuy ?? this.isBuy,
      asset: asset ?? this.asset,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      feeRate: feeRate ?? this.feeRate,
    );
  }
}
