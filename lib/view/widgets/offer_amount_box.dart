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

  const OfferAmountBox({
    super.key,
    required this.priceController,
    required this.quantityController,
    required this.totalController,
    required this.onPriceMinus,
    required this.onPricePlus,
    required this.maxQuantity,
    required this.isBuySelected,
  });

  @override
  State<OfferAmountBox> createState() => _OfferAmountBoxState();
}

class _OfferAmountBoxState extends State<OfferAmountBox> {
  double? selectedPercent;

  final List<double> percents = [0.1, 0.25, 0.5, 1.0];
  final List<String> labels = ['10%', '25%', '50%', '최대'];

  double get availableQuantity => (widget.maxQuantity * 0.9995);

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
              Container(
                height: 46,
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: TextField(
                        controller: widget.priceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
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
                    Text(
                      '원',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                      ),
                    ),
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
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                        (widget.maxQuantity * 0.9995).toStringAsFixed(2),
                        style: TextStyle(
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
                        child: TextField(
                          controller: widget.quantityController,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'),
                            ),
                          ],
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            hintText: '0',
                          ),
                          onTap: () {
                            setState(() {
                              selectedPercent = null;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      widget.isBuySelected
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
                                widget.quantityController.text =
                                    (availableQuantity * percent)
                                        .toStringAsFixed(2);
                                setState(() {
                                  selectedPercent = percent;
                                });
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
                        ((double.tryParse(widget.quantityController.text) ??
                                    0) *
                                0.05)
                            .toStringAsFixed(2),
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
                    child: TextField(
                      controller: widget.totalController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
