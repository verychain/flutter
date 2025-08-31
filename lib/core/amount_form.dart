// lib/core/amount_form.dart
import 'package:flutter/material.dart';
import 'package:demo_flutter/utils/format_utils.dart';

class OrderAmountForm {
  // Controllers
  final TextEditingController priceController;
  final TextEditingController quantityController;
  final TextEditingController totalController;

  // Focus
  final FocusNode priceNode;
  final FocusNode qtyNode;
  final FocusNode totalNode;

  // 초기값(선택)
  final double? initialPrice;
  final double? initialQuantity;

  // 리스너 보관
  late final VoidCallback _priceQtyListener;
  late final VoidCallback _totalListener;

  OrderAmountForm({
    this.initialPrice,
    this.initialQuantity,
    // 🔹 파라미터 이름 변경(섀도잉 방지)
    TextEditingController? priceCtrl,
    TextEditingController? quantityCtrl,
    TextEditingController? totalCtrl,
    FocusNode? priceFocus,
    FocusNode? qtyFocus,
    FocusNode? totalFocus,
  }) : priceController = priceCtrl ?? TextEditingController(),
       quantityController = quantityCtrl ?? TextEditingController(),
       totalController = totalCtrl ?? TextEditingController(),
       priceNode = priceFocus ?? FocusNode(debugLabel: 'price'),
       qtyNode = qtyFocus ?? FocusNode(debugLabel: 'qty'),
       totalNode = totalFocus ?? FocusNode(debugLabel: 'total') {
    // ✅ 여기서는 "필드"를 사용
    if (initialPrice != null) {
      priceController.text = _formatPriceSmart(initialPrice!);
    }
    if (initialQuantity != null) {
      quantityController.text = _formatQtySmart(initialQuantity!);
    }

    _priceQtyListener = _recomputeTotalNow;
    priceController.addListener(_priceQtyListener);
    quantityController.addListener(_priceQtyListener);
    print('price:::' + priceController.text);
    print('quantity:::' + quantityController.text);
    _totalListener = _onTotalEdited;
    totalController.addListener(_totalListener);

    WidgetsBinding.instance.addPostFrameCallback((_) => _recomputeTotalNow());
  }
  // ---------- 포맷 정책 ----------
  static String _formatPriceSmart(num v) =>
      formatWithComma(v, minFractionDigits: 0, maxFractionDigits: 1);
  static String _formatQtySmart(num v) =>
      formatWithComma(v, minFractionDigits: 0, maxFractionDigits: 2);
  static String _formatTotalSmart(num v) =>
      formatWithComma(v.round(), maxFractionDigits: 0);

  // ---------- 계산 ----------
  void _recomputeTotalNow() {
    if (totalNode.hasFocus) return; // 총액을 사용자가 직접 수정 중이면 덮어쓰지 않음
    final price = parseNumber(priceController.text);
    final qty = parseNumber(quantityController.text);
    final total = price * qty;

    final next = total == 0 ? '' : _formatTotalSmart(total);
    if (totalController.text != next) {
      totalController.value = TextEditingValue(
        text: next,
        selection: TextSelection.collapsed(offset: next.length),
      );
    }
  }

  void _onTotalEdited() {
    if (!totalNode.hasFocus) return; // 총액 직접 편집 중일 때만 역산

    final total = parseNumber(totalController.text);
    final price = parseNumber(priceController.text);
    final qty = parseNumber(quantityController.text);

    if (price > 0) {
      final newQty = total / price;
      final t = newQty == 0 ? '' : _formatQtySmart(newQty);
      if (quantityController.text != t) {
        quantityController.value = TextEditingValue(
          text: t,
          selection: TextSelection.collapsed(offset: t.length),
        );
      }
    } else if (qty > 0) {
      final newPrice = total / qty;
      final t = newPrice == 0 ? '' : _formatPriceSmart(newPrice);
      if (priceController.text != t) {
        priceController.value = TextEditingValue(
          text: t,
          selection: TextSelection.collapsed(offset: t.length),
        );
      }
    }
  }

  // ---------- 헬퍼 ----------
  void bumpPrice(double delta, {double min = 0}) {
    final cur = parseNumber(priceController.text);
    final next = (cur + delta).clamp(min, double.infinity);
    final txt = next == 0 ? '' : _formatPriceSmart(next);
    priceController.value = TextEditingValue(
      text: txt,
      selection: TextSelection.collapsed(offset: txt.length),
    );
  }

  void controllerClear() {
    priceController.clear();
    quantityController.clear();
    totalController.clear();
  }

  void formatOnBlurPrice() {
    final v = parseNumber(priceController.text);
    final t = v == 0 ? '' : _formatPriceSmart(v);
    if (t != priceController.text) {
      priceController.value = TextEditingValue(
        text: t,
        selection: TextSelection.collapsed(offset: t.length),
      );
    }
  }

  void formatOnBlurQty() {
    final v = parseNumber(quantityController.text);
    final t = v == 0 ? '' : _formatQtySmart(v);
    if (t != quantityController.text) {
      quantityController.value = TextEditingValue(
        text: t,
        selection: TextSelection.collapsed(offset: t.length),
      );
    }
  }

  void formatOnBlurTotal() {
    final v = parseNumber(totalController.text);
    final t = v == 0 ? '' : _formatTotalSmart(v);
    if (t != totalController.text) {
      totalController.value = TextEditingValue(
        text: t,
        selection: TextSelection.collapsed(offset: t.length),
      );
    }
  }

  bool get isValid =>
      parseNumber(priceController.text) > 0 &&
      parseNumber(quantityController.text) > 0;

  void dispose() {
    priceController.removeListener(_priceQtyListener);
    quantityController.removeListener(_priceQtyListener);
    totalController.removeListener(_totalListener);

    priceController.dispose();
    quantityController.dispose();
    totalController.dispose();
    priceNode.dispose();
    qtyNode.dispose();
    totalNode.dispose();
  }
}
