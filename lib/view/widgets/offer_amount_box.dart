import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OfferAmountBox extends StatelessWidget {
  final TextEditingController priceController;
  final TextEditingController quantityController;
  final TextEditingController totalController;
  final VoidCallback onPriceMinus;
  final VoidCallback onPricePlus;

  const OfferAmountBox({
    super.key,
    required this.priceController,
    required this.quantityController,
    required this.totalController,
    required this.onPriceMinus,
    required this.onPricePlus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 56.0),
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
                        controller: priceController,
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
                            // right는 없음
                          ),
                        ),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent, // 배경은 컨테이너에서
                            side: BorderSide.none, // 기본 4면 테두리 제거
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero, // 28x28 정확히 맞추기
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                bottomLeft: Radius.circular(4),
                              ),
                            ),
                          ),
                          onPressed: onPriceMinus,
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
                          onPressed: onPricePlus,
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
          SizedBox(height: 16),
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
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            hintText: '0',
                          ),
                        ),
                      ),
                      SizedBox(width: 4),
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
                      controller: totalController,
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
