import 'package:demo_flutter/data/constants.dart';
import 'package:demo_flutter/model/trade_card.dart';
import 'package:demo_flutter/model/type.dart';
import 'package:demo_flutter/models/order_draft.dart';
import 'package:demo_flutter/view/widgets/buy_sell_confirm_modal.dart';
import 'package:demo_flutter/view/widgets/offer_amount_box.dart';
import 'package:demo_flutter/view/widgets/token_info.dart';
import 'package:flutter/material.dart';
import 'package:demo_flutter/utils/format_utils.dart';
import 'package:demo_flutter/view/widgets/commission_modal.dart';

class OrderDetailPage extends StatefulWidget {
  final bool isBuySelected;
  final TradeCard trade;

  const OrderDetailPage({
    super.key,
    required this.isBuySelected,
    required this.trade,
  });

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late TextEditingController priceController;
  late TextEditingController quantityController;
  late TextEditingController totalController;

  final priceFocusNode = FocusNode();
  final quantityFocusNode = FocusNode();
  final totalFocusNode = FocusNode();

  final double maxQuantity = 27050.0; // 사용자의 지갑에 있는 수량

  bool isEditingTotal = false;
  int? selectedMethod;

  // TokenInfo 초기값을 double로 선언
  final String assetName = "VERY";
  final double avg24h = 20.15;
  final double deltaDay = 0.69;
  final double high = 22.5;
  final double avg7d = 19.8;
  final double low = 19.8;
  final double deltaWeek = -0.73;

  @override
  void initState() {
    super.initState();

    // TradeCard에서 단가와 수량을 초기값으로 세팅
    priceController = TextEditingController(
      text: widget.trade.price.toStringAsFixed(1),
    );
    quantityController = TextEditingController(
      text: widget.trade.quantity.toStringAsFixed(2),
    );
    totalController = TextEditingController();

    priceController.addListener(_onPriceOrQuantityChanged);
    quantityController.addListener(_onPriceOrQuantityChanged);
    totalController.addListener(_onTotalChanged);
  }

  void _onPriceOrQuantityChanged() {
    // 콤마 제거 후 계산
    final price = parseNumber(priceController.text);
    final qty = parseNumber(quantityController.text);
    final total = price * qty;

    // 총액은 "표시 전용"이라서 포맷해서 넣어줌 (정수)
    final formatted = total == 0
        ? ''
        : formatWithComma(total.round(), maxFractionDigits: 0);
    if (totalController.text != formatted && !totalFocusNode.hasFocus) {
      totalController.text = formatted;
    }
  }

  void _onTotalChanged() {
    // 총액을 "직접 편집 중"일 때만 역산
    if (!totalFocusNode.hasFocus) return;

    final total = parseNumber(totalController.text);
    final price = parseNumber(priceController.text);
    final qty = parseNumber(quantityController.text);

    if (price > 0) {
      final newQty = total / price;
      final t = newQty == 0
          ? ''
          : formatWithComma(newQty, minFractionDigits: 0, maxFractionDigits: 2);
      if (quantityController.text != t) quantityController.text = t;
    } else if (qty > 0) {
      final newPrice = total / qty;
      final t = newPrice == 0
          ? ''
          : formatWithComma(
              newPrice,
              minFractionDigits: 1,
              maxFractionDigits: 1,
            );
      if (priceController.text != t) priceController.text = t;
    }
  }

  @override
  void dispose() {
    priceController.dispose();
    quantityController.dispose();
    totalController.dispose();
    totalFocusNode.dispose(); // ⬅️ 추가
    priceFocusNode.dispose();
    quantityFocusNode.dispose();

    super.dispose();
  }

  void onMethodSelected(int idx) {
    setState(() {
      selectedMethod = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    // trade 값은 widget.trade로 접근

    final isButtonEnabled =
        priceController.text.isNotEmpty &&
        quantityController.text.isNotEmpty &&
        parseNumber(priceController.text) > 0 &&
        parseNumber(quantityController.text) > 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('주문'),
        centerTitle: true,
        backgroundColor: Colors.white, // 반드시 추가!
        foregroundColor: Colors.black, // 텍스트/아이콘 색상
        elevation: 0, // 그림자 제거(선택)
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TokenInfo(
                        assetName: assetName,
                        avg24h: avg24h,
                        deltaDay: deltaDay,
                        high: high,
                        avg7d: avg7d,
                        deltaWeek: deltaWeek,
                        low: low,
                      ),
                      SizedBox(
                        height: 8,
                        child: Container(color: Colors.grey.shade200),
                      ),
                      SizedBox(height: 24),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: OfferAmountBox(
                          priceController: priceController,
                          quantityController: quantityController,
                          maxQuantity: maxQuantity,
                          totalController: totalController,
                          priceFocusNode: priceFocusNode,
                          quantityFocusNode: quantityFocusNode,
                          totalFocusNode: totalFocusNode,
                          type: OfferAmountBoxType.order,
                          isBuySelected: widget.isBuySelected, // 생성자에서 받은 값 사용
                          onPriceMinus: () {
                            final price =
                                double.tryParse(priceController.text) ?? 0.0;
                            final newPrice = (price - 0.1).clamp(
                              0,
                              double.infinity,
                            );
                            priceController.text = newPrice.toStringAsFixed(1);
                          },
                          onPricePlus: () {
                            final price =
                                double.tryParse(priceController.text) ?? 0.0;
                            final newPrice = price + 0.1;
                            priceController.text = newPrice.toStringAsFixed(1);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 48),
                                  backgroundColor: Colors.grey.shade300,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: BorderSide(color: Colors.grey.shade300),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(
                                  '취소',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  // 배경색: disabled면 검은색, 아니면 매수/매도 컬러
                                  backgroundColor:
                                      WidgetStateProperty.resolveWith((states) {
                                        if (states.contains(
                                          WidgetState.disabled,
                                        )) {
                                          return widget.isBuySelected
                                              ? AppColors.buyColorMuted
                                              : AppColors.sellColorMuted;
                                        }
                                        return widget.isBuySelected
                                            ? AppColors.buyColor
                                            : AppColors.sellColor;
                                      }),
                                  // 텍스트색: disabled 때도 흰색 유지
                                  foregroundColor:
                                      WidgetStateProperty.resolveWith((states) {
                                        if (states.contains(
                                          WidgetState.disabled,
                                        )) {
                                          return Colors.white;
                                        }
                                        return Colors.white;
                                      }),
                                  // 눌림/hover 등 오버레이 제거 (특히 disabled 회색 오버레이 방지)
                                  overlayColor: WidgetStateProperty.resolveWith(
                                    (states) {
                                      if (states.contains(
                                        WidgetState.disabled,
                                      )) {
                                        return Colors.transparent;
                                      }
                                      return null; // 기본(pressed/hover) 유지
                                    },
                                  ),
                                  // 그림자도 통일하고 싶으면 선택
                                  shadowColor: WidgetStateProperty.resolveWith((
                                    states,
                                  ) {
                                    if (states.contains(WidgetState.disabled)) {
                                      return Colors.transparent;
                                    }
                                    return null;
                                  }),
                                  elevation: WidgetStateProperty.resolveWith((
                                    states,
                                  ) {
                                    if (states.contains(WidgetState.disabled))
                                      return 0;
                                    return null;
                                  }),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  minimumSize: WidgetStateProperty.all(
                                    const Size(double.infinity, 48),
                                  ),
                                ),
                                onPressed: isButtonEnabled
                                    ? () async {
                                        final draft = OrderDraft(
                                          isBuy: widget.isBuySelected,
                                          asset: 'VERY',
                                          price: parseNumber(
                                            priceController.text,
                                          ),
                                          quantity: parseNumber(
                                            quantityController.text,
                                          ),
                                          // feeRate 기본값 사용
                                        );

                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              BuySellConfirmModal(
                                                type: widget.isBuySelected
                                                    ? TransactionType.buy
                                                    : TransactionType.sell,
                                                draft: draft,
                                                onConfirm: () {
                                                  // 등록 처리
                                                  Navigator.of(context).pop();
                                                },
                                                onCancel: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                        );
                                      }
                                    : null,
                                child: Text(
                                  widget.isBuySelected ? '매수' : '매도',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!widget.isBuySelected)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => CommissionModal(),
                                    );
                                  },
                                  child: Text(
                                    '수수료 안내',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 14,
                                      decoration: TextDecoration
                                          .underline, // 클릭 가능하게 표시
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '거래자 정보',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/rank_${widget.trade.userRanking.toLowerCase()}.png',
                                  height: 20,
                                  width: 20,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(width: 6.0),
                                Flexible(
                                  child: Text(
                                    widget.trade.userName,
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
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    widget.trade.paymentMethods,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 8.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.0),
                            Row(
                              children: [
                                Text(
                                  '거래 ${formatNumberWithComma(widget.trade.tradeCount)}회',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                SizedBox(width: 4.0),
                                Text(
                                  '성공률 ${widget.trade.successRate.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 80), // 버튼 영역 확보용
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
