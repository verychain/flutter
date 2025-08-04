import 'package:demo_flutter/data/constants.dart';
import 'package:demo_flutter/view/pages/login_page.dart';
import 'package:demo_flutter/view/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // 컨트롤러들
  late TextEditingController controllerEmail;
  late TextEditingController controllerPassword;
  late TextEditingController controllerPasswordConfirm;
  late TextEditingController controllerVerificationCode;

  // 상태 변수들
  bool isPasswordVisible = false;
  bool isPasswordConfirmVisible = false;
  bool isEmailVerified = false;
  bool isVerificationCodeSent = false;
  String? selectedCountry;
  String? errorMessage;

  // 국가 리스트
  final List<String> countries = [
    '대한민국',
    '미국',
    '일본',
    '중국',
    '영국',
    '독일',
    '프랑스',
    '캐나다',
    '호주',
    '싱가포르',
  ];

  @override
  void initState() {
    super.initState();
    controllerEmail = TextEditingController();
    controllerPassword = TextEditingController();
    controllerPasswordConfirm = TextEditingController();
    controllerVerificationCode = TextEditingController();
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerPasswordConfirm.dispose();
    controllerVerificationCode.dispose();
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
                  "회원가입",
                  style: TextStyle(
                    color: Colors.grey.shade900,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "이미 계정이 있으신가요? ",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "로그인하기",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),

              // 이메일 입력
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !isEmailVerified,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9@._-]'),
                        ),
                      ],
                      decoration: InputDecoration(
                        hintText: '이메일',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
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
                        suffixIcon: isEmailVerified
                            ? Icon(Icons.check_circle, color: Colors.green)
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: isEmailVerified
                        ? null
                        : () {
                            sendVerificationCode();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEmailVerified
                          ? Colors.grey
                          : AppColors.primary,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          4.0,
                        ), // 15.0에서 4.0으로 변경
                      ),
                    ),
                    child: Text(
                      isEmailVerified ? '인증완료' : '인증요청',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // 인증코드 입력 (이메일 인증코드 전송 후 표시)
              if (isVerificationCodeSent && !isEmailVerified) ...[
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controllerVerificationCode,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          hintText: '인증코드 6자리',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          counterText: '',
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
                    ),
                    SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        verifyCode();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        '확인',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              SizedBox(height: 20.0),

              // 비밀번호 입력
              TextField(
                controller: controllerPassword,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  hintText: '비밀번호',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
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

              SizedBox(height: 20.0),

              // 비밀번호 확인
              TextField(
                controller: controllerPasswordConfirm,
                obscureText: !isPasswordConfirmVisible,
                decoration: InputDecoration(
                  hintText: '비밀번호 확인',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
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
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordConfirmVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey.shade400,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordConfirmVisible = !isPasswordConfirmVisible;
                      });
                    },
                  ),
                ),
              ),

              SizedBox(height: 20.0),

              // 거주국가 선택
              DropdownButtonFormField<String>(
                value: selectedCountry,
                hint: Text(
                  '거주국가 선택',
                  style: TextStyle(color: Colors.grey.shade400),
                ),
                decoration: InputDecoration(
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
                items: countries.map((String country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCountry = newValue;
                  });
                },
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

              // 회원가입 버튼
              ElevatedButton(
                onPressed: () {
                  onSignupPressed();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50.0),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // 8.0에서 4.0으로 변경
                  ),
                ),
                child: Text(
                  '가입하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Pretendard",
                    fontSize: 16.0,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendVerificationCode() {
    if (controllerEmail.text.isEmpty || !controllerEmail.text.contains('@')) {
      setState(() {
        errorMessage = '올바른 이메일 주소를 입력해주세요.';
      });
      return;
    }

    setState(() {
      isVerificationCodeSent = true;
      errorMessage = null;
    });

    // 실제로는 여기서 서버에 인증코드 전송 요청
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('인증코드가 전송되었습니다.')));
  }

  void verifyCode() {
    // 임시로 "123456"이 올바른 인증코드라고 가정
    if (controllerVerificationCode.text == "123456") {
      setState(() {
        isEmailVerified = true;
        errorMessage = null;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('이메일 인증이 완료되었습니다.')));
    } else {
      setState(() {
        errorMessage = '인증코드가 올바르지 않습니다.';
      });
    }
  }

  void onSignupPressed() {
    setState(() {
      errorMessage = null;
    });

    // 유효성 검사
    if (!isEmailVerified) {
      setState(() {
        errorMessage = '이메일 인증을 완료해주세요.';
      });
      return;
    }

    if (controllerPassword.text.length < 6) {
      setState(() {
        errorMessage = '비밀번호는 6자리 이상이어야 합니다.';
      });
      return;
    }

    if (controllerPassword.text != controllerPasswordConfirm.text) {
      setState(() {
        errorMessage = '비밀번호가 일치하지 않습니다.';
      });
      return;
    }

    if (selectedCountry == null) {
      setState(() {
        errorMessage = '거주국가를 선택해주세요.';
      });
      return;
    }

    // 회원가입 성공
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('회원가입이 완료되었습니다.')));

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => WidgetTree()),
      (route) => false,
    );
  }
}
