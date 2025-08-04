import 'package:demo_flutter/data/constants.dart';
import 'package:demo_flutter/view/pages/signup_page.dart';
import 'package:demo_flutter/view/pages/forgot_password_page.dart'; // 추가
import 'package:demo_flutter/view/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 컨트롤러를 클래스 내부로 이동
  late TextEditingController controllerEmail;
  late TextEditingController controllerPassword;
  String confirmedEmail = '123';
  String confirmedPassword = '456';
  bool? isChecked = false;
  bool isPasswordVisible = false; // 패스워드 표시 상태 추가
  String? errorMessage; // 오류 메시지 상태 추가

  @override
  void initState() {
    super.initState();
    // initState에서 컨트롤러 초기화
    controllerEmail = TextEditingController();
    controllerPassword = TextEditingController();
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "로그인",
                  style: TextStyle(
                    color: Colors.grey.shade900,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
                children: [
                  Text(
                    "계정이 없으신가요?",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(width: 8.0), // 마진 추가
                  GestureDetector(
                    onTap: () {
                      // 회원가입 페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SignupPage();
                          },
                        ),
                      );
                    },
                    child: Text(
                      "회원가입하기",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline, // 밑줄 추가
                        decorationColor: AppColors.primary, // 밑줄 색상도 primary로
                        decorationThickness: 0.8, // 밑줄 두께
                        height: 1.5, // 줄 간격 조정으로 밑줄과 글씨 사이 간격 늘리기
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: controllerEmail,
                keyboardType: TextInputType.emailAddress, // 이메일 키보드 타입 추가
                textInputAction: TextInputAction.next, // 다음 필드로 이동
                autocorrect: false, // 자동 수정 비활성화
                enableSuggestions: false, // 제안 비활성화
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z0-9@._-]'),
                  ), // 영문, 숫자, 이메일 특수문자만 허용
                ],
                onEditingComplete: () => setState(() {
                  // Update the state when editing is complete
                }),
                decoration: InputDecoration(
                  hintText: '이메일',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: controllerPassword,
                obscureText: !isPasswordVisible, // 패스워드 표시 상태에 따라 변경
                onEditingComplete: () => setState(() {
                  // Update the state when editing is complete
                }),
                decoration: InputDecoration(
                  hintText: '비밀번호',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  // 눈 아이콘 추가
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey.shade400,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // 비밀번호 찾기 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage(),
                      ),
                    );
                  },
                  child: Text(
                    "비밀번호를 잊어버리셨나요?",
                    style: TextStyle(color: AppColors.primary, fontSize: 12.0),
                  ),
                ),
              ),
              SizedBox(height: 12),

              // 오류 메시지 표시
              if (errorMessage != null)
                Container(
                  margin: EdgeInsets.only(bottom: 12.0),
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red.shade600,
                        size: 20.0,
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ElevatedButton(
                onPressed: () {
                  onLoginPressed();
                },
                style: TextButton.styleFrom(
                  minimumSize: Size(double.infinity, 50.0),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Pretendard",
                    fontSize: 16.0,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Row(
                children: [
                  Expanded(
                    child: Divider(color: Colors.grey.shade400, thickness: 1.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "또는",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Colors.grey.shade400, thickness: 1.0),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              // 카카오 간편 로그인/회원가입 버튼
              ElevatedButton(
                onPressed: () {
                  // 카카오 로그인 로직
                  print("카카오 로그인");
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50.0),
                  backgroundColor: Color(0xFFFEE500), // 카카오 노란색
                  elevation: 0, // shadow 제거
                  shadowColor: Colors.transparent, // shadow 색상도 투명으로
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/logos/kakao.svg',
                      width: 20.0,
                      height: 20.0,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      "카카오 1초 로그인/회원가입",
                      style: TextStyle(color: Colors.black87, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              OutlinedButton(
                onPressed: () {
                  // 이메일 회원가입 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50.0),
                  side: BorderSide(color: Colors.grey.shade400),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  "이메일로 회원가입",
                  style: TextStyle(color: Colors.black87, fontSize: 16.0),
                ),
              ),
              SizedBox(height: 20.0),
              // 네이버, 구글, 애플 간편 로그인 버튼들
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 네이버 로그인
                  GestureDetector(
                    onTap: () {
                      print("네이버 로그인");
                    },
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/logos/naver.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // 구글 로그인
                  GestureDetector(
                    onTap: () {
                      print("구글 로그인");
                    },
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/logos/google.svg',
                          width: 60.0,
                          height: 60.0,
                        ),
                      ),
                    ),
                  ),
                  // 애플 로그인
                  GestureDetector(
                    onTap: () {
                      print("애플 로그인");
                    },
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/logos/apple.svg',
                        width: 60.0,
                        height: 60.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),

              // 이메일 회원가입 버튼
            ],
          ),
        ),
      ),
    );
  }

  void onLoginPressed() {
    // 오류 메시지 초기화
    setState(() {
      errorMessage = null;
    });

    if (confirmedEmail == controllerEmail.text &&
        confirmedPassword == controllerPassword.text) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return WidgetTree();
          },
        ),
        (route) => false,
      );
    } else {
      // 로그인 실패 시 오류 메시지 표시
      setState(() {
        errorMessage = '이메일 또는 비밀번호가 올바르지 않습니다.\n다시 시도해주세요.';
      });
    }
  }
}
