import 'package:demo_flutter/data/constants.dart';
import 'package:demo_flutter/view/pages/reset_password_page.dart'; // 추가
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController controllerEmail = TextEditingController();
  String? errorMessage;
  bool isEmailSent = false;

  @override
  void dispose() {
    controllerEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 찾기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "비밀번호 찾기",
              style: TextStyle(
                color: Colors.grey.shade900,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              "가입하신 이메일 주소를 입력해주세요.\n비밀번호 재설정 링크를 보내드립니다.",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16.0,
                height: 1.5,
              ),
            ),
            SizedBox(height: 30.0),
            
            if (!isEmailSent) ...[
              // 이메일 입력 필드
              TextField(
                controller: controllerEmail,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                enableSuggestions: false,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')),
                ],
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
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              
              SizedBox(height: 16.0),
              
              // 오류 메시지 표시
              if (errorMessage != null)
                Container(
                  margin: EdgeInsets.only(bottom: 16.0),
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
              
              // 재설정 링크 전송 버튼
              ElevatedButton(
                onPressed: () {
                  sendResetLink();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50.0),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  '재설정 링크 전송',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Pretendard",
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ] else ...[
              // 이메일 전송 완료 메시지
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      color: Colors.green.shade600,
                      size: 48.0,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      '이메일을 확인해주세요',
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '${controllerEmail.text}로\n비밀번호 재설정 링크를 보냈습니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 14.0,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20.0),
              
              // 다시 전송 버튼
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    isEmailSent = false;
                    errorMessage = null;
                  });
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50.0),
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  '다시 전송하기',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            
            SizedBox(height: 20.0),
            
            // 로그인으로 돌아가기
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "로그인으로 돌아가기",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ),
            ),
            
            // 디버깅용 버튼 추가
            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPasswordPage(token: "debug_token"),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                ),
                child: Text(
                  "디버그: 비밀번호 재설정 페이지",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendResetLink() {
    setState(() {
      errorMessage = null;
    });

    // 이메일 유효성 검사
    if (controllerEmail.text.isEmpty) {
      setState(() {
        errorMessage = '이메일을 입력해주세요.';
      });
      return;
    }

    if (!controllerEmail.text.contains('@')) {
      setState(() {
        errorMessage = '올바른 이메일 주소를 입력해주세요.';
      });
      return;
    }

    // 실제로는 여기서 서버에 비밀번호 재설정 이메일 전송 요청
    setState(() {
      isEmailSent = true;
    });
  }
}