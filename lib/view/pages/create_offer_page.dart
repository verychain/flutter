import 'package:demo_flutter/data/constants.dart';
import 'package:flutter/material.dart';

class CreateOfferPage extends StatelessWidget {
  const CreateOfferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('거래 등록하기'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: Center(
                child: Text('섹션 1', style: TextStyle(fontSize: 18.0)),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        SizedBox(
                          width: 150,
                          height: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              backgroundColor: AppColors.buyColor,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 4, // padding: 4px 24px
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              '매수 등록',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 24),
                        SizedBox(
                          width: 150,
                          height: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              backgroundColor: AppColors.sellColor,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 4, // padding: 4px 24px
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              '매도 등록',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: '가격',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 16),
                        SizedBox(
                          width: 120,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: '수량',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: Center(
                child: Text('섹션 3', style: TextStyle(fontSize: 18.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
