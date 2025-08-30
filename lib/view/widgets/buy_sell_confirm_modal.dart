import 'package:demo_flutter/model/type.dart';
import 'package:demo_flutter/models/order_draft.dart';
import 'package:demo_flutter/utils/format_utils.dart';
import 'package:demo_flutter/view/pages/transaction_session.dart';
import 'package:flutter/material.dart';

class BuySellConfirmModal extends StatelessWidget {
  final TransactionType type;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final OrderDraft draft;

  const BuySellConfirmModal({
    super.key,
    required this.type,
    required this.draft,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final isSell = !draft.isBuy;

    String qty(num n, {int max = 2}) => formatWithComma(
      n,
      minFractionDigits: 0,
      maxFractionDigits: max,
    ); // 수량: 정수면 0자리, 아니면 최대 2자리 + 천단위
    final double sendQty = isSell
        ? (draft.quantity + draft.fee)
        : draft.quantity;

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
          _infoRow('단위 가격', krw(draft.price), '원'),
          SizedBox(height: 12),
          if (isSell)
            _infoRow('수수료(0.05%)', num2(draft.fee), 'VERY'), // 수량 기준 수수료

          if (isSell) SizedBox(height: 12),
          _infoRow(isSell ? '보낼 수량' : '받을 수량', qty(sendQty), 'VERY'),
          const SizedBox(height: 12),
          _infoRow('받을 금액', krw(draft.total), '원'),
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
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          TransactionSessionPage(draft: draft),
                    ),
                  );
                },
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
