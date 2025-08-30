import 'package:demo_flutter/model/type.dart';
import 'package:demo_flutter/utils/format_utils.dart';
import 'package:demo_flutter/view/widgets/info_modal.dart';
import 'package:demo_flutter/view/widgets/percent_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrderAmountBox extends StatefulWidget {
  final String price;
  final String quantity;
  final String total;
  final double maxQuantity;
  final bool isBuySelected;
  final OfferAmountBoxType type; // enum 타입으로 변경

  const OrderAmountBox({
    super.key,
    required this.price,
    required this.quantity,
    required this.total,
    required this.maxQuantity,
    required this.isBuySelected,
    required this.type,
  });

  @override
  State<OrderAmountBox> createState() => _OrderAmountBoxState();
}

class _OrderAmountBoxState extends State<OrderAmountBox> {
  double? selectedPercent;

  bool _ownPriceNode = false;
  bool _ownQtyNode = false;
  bool _ownTotalNode = false;

  double get availableQuantity => (widget.maxQuantity * 0.9995);

  // 컨트롤러에 스마트 포맷 적용 (포커스 없을 때만)
  void _attachAutoFormat({
    required TextEditingController controller,
    required FocusNode node,
    required String Function(num) formatter,
  }) {
    void listener() {
      if (node.hasFocus) return; // 입력 중일 때는 건드리지 않음
      final raw = controller.text;
      if (raw.isEmpty) return;
      final v = parseNumber(raw);
      final formatted = v == 0 ? '' : formatter(v);
      if (formatted != controller.text) {
        controller.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    }

    controller.addListener(listener);
    // 첫 렌더 뒤 한 번 초기 포맷
    WidgetsBinding.instance.addPostFrameCallback((_) => listener());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('가격', style: TextStyle(fontSize: 16)),
              ),
              Text(widget.price, style: TextStyle(fontSize: 18)),
            ],
          ),
          if (!widget.isBuySelected) SizedBox(height: 16),
          if (!widget.isBuySelected)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "최대 거래 가능",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      Text(
                        formatQtySmart(availableQuantity),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      SizedBox(width: 4),
                      Row(
                        children: [
                          Text(
                            'VERY',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => InfoModal(
                                  title: '거래 가능 수량',
                                  description:
                                      '${(widget.maxQuantity * 0.9995).toStringAsFixed(2)} VERY',
                                  subDescription: '0.05% 수수료와 가스비를 제외한 수량입니다.',
                                  buttonText: '확인',
                                ),
                              );
                            },
                            child: Icon(
                              Icons.info_outlined,
                              size: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("수량", style: TextStyle(fontSize: 16)),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: SizedBox(
                  height: 46,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          widget.quantity,
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'VERY',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (!widget.isBuySelected)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "수수료",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      Text(
                        formatQtySmart(parseNumber(widget.quantity) * 0.0005),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'VERY',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      SizedBox(width: 4),
                    ],
                  ),
                ),
              ],
            ),
          Divider(color: Colors.grey.shade200),
          SizedBox(height: 16),
          SizedBox(
            height: 46,
            child: Container(
              color: Colors.grey.shade50,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      '총액',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 80,
                    child: Text(
                      widget.total,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text(
                      '원',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
