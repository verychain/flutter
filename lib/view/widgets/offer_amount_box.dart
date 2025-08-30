import 'package:demo_flutter/model/type.dart';
import 'package:demo_flutter/utils/format_utils.dart';
import 'package:demo_flutter/view/widgets/info_modal.dart';
import 'package:demo_flutter/view/widgets/percent_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OfferAmountBox extends StatefulWidget {
  final TextEditingController priceController;
  final TextEditingController quantityController;
  final TextEditingController totalController;
  final VoidCallback onPriceMinus;
  final VoidCallback onPricePlus;
  final double maxQuantity;
  final bool isBuySelected;
  final FocusNode? priceFocusNode;
  final FocusNode? quantityFocusNode;
  final FocusNode? totalFocusNode;
  final OfferAmountBoxType type; // enum 타입으로 변경

  const OfferAmountBox({
    super.key,
    required this.priceController,
    required this.quantityController,
    required this.totalController,
    required this.onPriceMinus,
    required this.onPricePlus,
    required this.maxQuantity,
    required this.isBuySelected,
    this.totalFocusNode,
    this.priceFocusNode,
    this.quantityFocusNode,
    required this.type, // 필수로 변경
  });

  @override
  State<OfferAmountBox> createState() => _OfferAmountBoxState();
}

class _OfferAmountBoxState extends State<OfferAmountBox> {
  double? selectedPercent;

  // 내부용 FocusNode (null-safe)
  late final FocusNode _priceNode =
      widget.priceFocusNode ?? FocusNode(debugLabel: 'price');
  late final FocusNode _qtyNode =
      widget.quantityFocusNode ?? FocusNode(debugLabel: 'qty');
  late final FocusNode _totalNode =
      widget.totalFocusNode ?? FocusNode(debugLabel: 'total');

  bool _ownPriceNode = false;
  bool _ownQtyNode = false;
  bool _ownTotalNode = false;

  final List<double> percents = [0.1, 0.25, 0.5, 1.0];
  final List<String> labels = ['10%', '25%', '50%', '최대'];

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

    // 우리가 생성했는지 플래그(디스포즈용)
    _ownPriceNode = widget.priceFocusNode == null;
    _ownQtyNode = widget.quantityFocusNode == null;
    _ownTotalNode = widget.totalFocusNode == null;

    // 초기값/프로그램적 변경도 포맷되도록 리스너 부착
    _attachAutoFormat(
      controller: widget.priceController,
      node: _priceNode,
      formatter: formatPriceSmart,
    );
    _attachAutoFormat(
      controller: widget.quantityController,
      node: _qtyNode,
      formatter: formatQtySmart,
    );
    // 총액은 현재 정수 표기 정책이라면 필요 시 동일하게 붙일 수 있음
    // _attachAutoFormat(
    //   controller: widget.totalController,
    //   node: _totalNode,
    //   formatter: (v) => formatWithComma(v.round(), maxFractionDigits: 0),
    // );
  }

  @override
  void dispose() {
    if (_ownPriceNode) _priceNode.dispose();
    if (_ownQtyNode) _qtyNode.dispose();
    if (_ownTotalNode) _totalNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
      'box.priceController   = ${identityHashCode(widget.priceController)}',
    );

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
              Container(
                height: 46,
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Focus(
                        focusNode: _priceNode,
                        onFocusChange: (hasFocus) {
                          final c = widget.priceController;
                          if (hasFocus) {
                            c.text = stripComma(c.text);
                          } else {
                            final v = parseNumber(c.text);
                            final txt = v == 0
                                ? ''
                                : formatPriceSmart(v); // ← 여기!
                            c.value = TextEditingValue(
                              text: txt,
                              selection: TextSelection.collapsed(
                                offset: txt.length,
                              ),
                            );
                          }
                        },

                        child: TextField(
                          controller: widget.priceController,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ), // 소수점 포함
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            hintText: '0',
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '원',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    if (widget.type == OfferAmountBoxType.offer)
                      Row(
                        children: [
                          SizedBox(width: 10),
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                ),
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                  ),
                                  left: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  side: BorderSide.none,
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      bottomLeft: Radius.circular(4),
                                    ),
                                  ),
                                ),
                                onPressed: widget.onPriceMinus,
                                child: Text(
                                  '-',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 28,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                ),
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                  ),
                                  right: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  side: BorderSide.none,
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(4),
                                      topRight: Radius.circular(4),
                                    ),
                                  ),
                                ),
                                onPressed: widget.onPricePlus,
                                child: Text(
                                  '+',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
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
                        child: Focus(
                          focusNode: _qtyNode,
                          onFocusChange: (hasFocus) {
                            final c = widget.quantityController;
                            if (hasFocus) {
                              c.text = stripComma(c.text);
                            } else {
                              final v = parseNumber(c.text);
                              final txt = v == 0
                                  ? ''
                                  : formatQtySmart(v); // ← 여기!

                              c.value = TextEditingValue(
                                text: txt,
                                selection: TextSelection.collapsed(
                                  offset: txt.length,
                                ),
                              );
                            }
                          },
                          child: TextField(
                            controller: widget.quantityController,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.]'),
                              ),
                            ],
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              // hintText: '0',
                            ),
                            onTap: () {
                              setState(() {
                                selectedPercent = null;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ((widget.type == OfferAmountBoxType.offer &&
                                  widget.isBuySelected) ||
                              (widget.type == OfferAmountBoxType.order))
                          ? Text(
                              'VERY',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade500,
                              ),
                            )
                          : PercentSwitch(
                              selectedPercent: selectedPercent,
                              onPercentSelected: (percent) {
                                FocusScope.of(context).unfocus();
                                final q = availableQuantity * percent;
                                widget.quantityController.text = formatQtySmart(
                                  q,
                                ); // ← 여기!
                                setState(() => selectedPercent = percent);
                              },
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
                        formatQtySmart(
                          parseNumber(widget.quantityController.text) * 0.0005,
                        ),
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
                    child: Focus(
                      focusNode: _totalNode,
                      onFocusChange: (hasFocus) {
                        final c = widget.totalController;
                        print('Total Focus: $c');
                        if (hasFocus) {
                          c.text = stripComma(c.text);
                        } else {
                          final v = parseNumber(c.text);
                          c.value = TextEditingValue(
                            text: v == 0
                                ? ''
                                : formatWithComma(
                                    v.round(),
                                    maxFractionDigits: 0,
                                  ),
                            selection: TextSelection.collapsed(
                              offset: (v == 0
                                  ? 0
                                  : formatWithComma(
                                      v.round(),
                                      maxFractionDigits: 0,
                                    ).length),
                            ),
                          );
                        }
                      },
                      child: TextField(
                        controller: widget.totalController,

                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ), // 소수점 포함
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          hintText: '0',
                        ),
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
