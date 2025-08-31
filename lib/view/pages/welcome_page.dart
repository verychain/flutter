import 'package:demo_flutter/view/pages/login_page.dart';
import 'package:demo_flutter/view/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // 전경 내용
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lotties/wave.json',
                    fit: BoxFit.cover, // 화면 전체를 덮도록
                    height: 300.0,
                  ),
                  SizedBox(height: 40.0),
                  FittedBox(
                    child: Text(
                      'Buy & Sell Crypto\nP2P Market',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50.0,
                        letterSpacing: 10.0,
                        shadows: [
                          Shadow(
                            // 텍스트 그림자 추가로 가독성 향상
                            offset: Offset(2.0, 2.0),
                            blurRadius: 4.0,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return WidgetTree();
                          },
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: Size(double.infinity, 50.0),
                    ),
                    child: Text(
                      '시작하기',
                      style: TextStyle(
                        // color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginPage(title: '로그인');
                          },
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size(double.infinity, 50.0),
                      backgroundColor: Colors.black26, // 반투명 배경
                    ),
                    child: Text(
                      '로그인',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 40.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
