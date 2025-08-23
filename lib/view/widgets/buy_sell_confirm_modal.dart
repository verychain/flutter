import 'package:demo_flutter/model/type.dart';
import 'package:flutter/material.dart';

class BuySellConfirmModal extends StatelessWidget {
  final TransactionType type;
  final String price;
  final String? commission;
  final String quantityToSend;
  final String totalPrice;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const BuySellConfirmModal({
    super.key,
    required this.type,
    required this.price,
    required this.commission,
    required this.quantityToSend,
    required this.totalPrice,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final isSell = type == TransactionType.sell;
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Column(
        children: [
          Text(
            isSell ? 'VERY 매도' : 'VERY 매수',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            isSell
                ? '거래를 진행하시겠어요?\n15분 내에 베리 송금을 진행하지 않을 경우 거래가 취소되요.'
                : '거래를 진행하시겠어요?\n15분 내에 원화 입금을 진행하지 않을 경우 거래가 취소되요.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _infoRow('단위 가격', price, '원'),
          SizedBox(height: 12),
          if (isSell) _infoRow('수수료(0.05%)', commission ?? '0', '원'),
          if (isSell) SizedBox(height: 12),
          _infoRow(isSell ? '보낼 수량' : '받을 수량', quantityToSend, 'VERY'),
          SizedBox(height: 12),
          _infoRow('받을 금액', totalPrice, '원'),
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
                  minimumSize: Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide.none,
                ),
                onPressed: onCancel,
                child: Text('취소', style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: onConfirm,
                child: Text('확인', style: TextStyle(fontSize: 16)),
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
            Text(value, style: TextStyle(fontSize: 16)),
            SizedBox(width: 4),
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
