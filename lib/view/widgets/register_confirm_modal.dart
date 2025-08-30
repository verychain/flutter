import 'package:demo_flutter/utils/format_utils.dart';
import 'package:flutter/material.dart';

enum RegisterType { SELL, BUY }

class RegisterConfirmModal extends StatelessWidget {
  final RegisterType type;
  final String price; // ex) "10,000" or "10000.0"
  final String? commission; // ex) "500" (SELL일 때만 의미)
  final String quantityToSend; // ex) "12345.67"
  final String totalPrice; // ex) "197000"
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const RegisterConfirmModal({
    super.key,
    required this.type,
    required this.price,
    required this.commission,
    required this.quantityToSend,
    required this.totalPrice,
    required this.onConfirm,
    required this.onCancel,
  });

  // ---- 포맷 유틸: 정수면 0자리, 아니면 최대 N자리 ----
  String _krw(num v) =>
      formatWithComma(v, minFractionDigits: 0, maxFractionDigits: 0); // 원화는 정수
  String _unitPrice(num v) => formatWithComma(
    v,
    minFractionDigits: 0,
    maxFractionDigits: 1,
  ); // 단가: 소수 최대 1자리
  String _qty(num v) => formatWithComma(
    v,
    minFractionDigits: 0,
    maxFractionDigits: 2,
  ); // 수량: 소수 최대 2자리

  @override
  Widget build(BuildContext context) {
    final isSell = type == RegisterType.SELL;

    // ---- 안전 파싱 (콤마/공백/빈값 모두 허용) ----
    final double priceNum = parseNumber(price);
    final double commissionNum = parseNumber(commission ?? '0');
    final double qtyNum = parseNumber(quantityToSend);
    final double totalNum = parseNumber(totalPrice);

    // ---- 표시용 문자열 ----
    final String priceStr = _unitPrice(priceNum);
    final String commissionStr = _krw(commissionNum);
    final String qtyStr = _qty(qtyNum);
    final String totalStr = _krw(totalNum);

    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Column(
        children: [
          Text(
            isSell ? '매도 등록' : '매수 등록',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '등록을 진행하시겠습니까?',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _infoRow('단위 가격', priceStr, '원'),
          const SizedBox(height: 12),
          if (isSell) _infoRow('수수료(0.05%)', commissionStr, '원'),
          if (isSell) const SizedBox(height: 12),
          _infoRow(isSell ? '보낼 수량' : '받을 수량', qtyStr, 'VERY'),
          const SizedBox(height: 12),
          _infoRow('받을 금액', totalStr, '원'),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.grey.shade200,
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide.none,
                ),
                onPressed: onCancel,
                child: const Text('취소', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: onConfirm,
                child: const Text('확인', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value, String appendix) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        Row(
          children: [
            Text(value, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 4),
            Text(
              appendix,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      ],
    );
  }
}
