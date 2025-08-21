import 'package:demo_flutter/data/constants.dart';
import 'package:demo_flutter/view/widgets/buy_sell_toggle.dart';
import 'package:demo_flutter/view/widgets/offer_amount_box.dart';
import 'package:demo_flutter/view/widgets/token_info.dart';
import 'package:demo_flutter/view/widgets/transaction_method.dart';
import 'package:flutter/material.dart';

class CreateOfferPage extends StatefulWidget {
  const CreateOfferPage({super.key});

  @override
  State<CreateOfferPage> createState() => _CreateOfferPageState();
}

class _CreateOfferPageState extends State<CreateOfferPage> {
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final totalController = TextEditingController();

  bool isEditingTotal = false;
  bool isBuySelected = true;
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

    priceController.addListener(_onPriceOrQuantityChanged);
    quantityController.addListener(_onPriceOrQuantityChanged);
    totalController.addListener(_onTotalChanged);
  }

  void _onPriceOrQuantityChanged() {
    if (isEditingTotal) return;
    final price = double.tryParse(priceController.text) ?? 0;
    final quantity = double.tryParse(quantityController.text) ?? 0;
    final total = price * quantity;
    totalController.text = total == 0
        ? ''
        : total.round().toString(); // 총액은 반올림해서 정수로 표기
  }

  void _onTotalChanged() {
    isEditingTotal = true;
    final total = int.tryParse(totalController.text) ?? 0; // 총액은 정수로 처리
    final price = double.tryParse(priceController.text) ?? 0;
    final quantity = double.tryParse(quantityController.text) ?? 0;

    if (price > 0) {
      final newQuantity = total / price;
      quantityController.text = newQuantity == 0
          ? ''
          : newQuantity.toStringAsFixed(1);
    } else if (quantity > 0) {
      final newPrice = total / quantity;
      priceController.text = newPrice == 0 ? '' : newPrice.toStringAsFixed(1);
    }
    isEditingTotal = false;
  }

  @override
  void dispose() {
    priceController.dispose();
    quantityController.dispose();
    totalController.dispose();
    super.dispose();
  }

  void onMethodSelected(int idx) {
    setState(() {
      selectedMethod = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('거래 등록하기'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: Container(
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
                  BuySellToggle(
                    isBuySelected: isBuySelected,
                    onChanged: (value) {
                      setState(() {
                        isBuySelected = value;
                      });
                    },
                  ),
                  SizedBox(height: 24),
                  OfferAmountBox(
                    priceController: priceController,
                    quantityController: quantityController,
                    totalController: totalController,
                    onPriceMinus: () {
                      final price =
                          double.tryParse(priceController.text) ?? 0.0;
                      final newPrice = (price - 0.1).clamp(0, double.infinity);
                      priceController.text = newPrice.toStringAsFixed(1);
                    },
                    onPricePlus: () {
                      final price =
                          double.tryParse(priceController.text) ?? 0.0;
                      final newPrice = price + 0.1;
                      priceController.text = newPrice.toStringAsFixed(1);
                    },
                  ),
                  SizedBox(
                    height: 8,
                    child: Container(color: Colors.grey.shade200),
                  ),
                  TransactionMethod(
                    selectedIndex: selectedMethod ?? -1,
                    onSelected: onMethodSelected,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
