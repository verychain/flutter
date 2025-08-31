import 'dart:convert';
import 'package:demo_flutter/core/email_auth_api.dart';
import 'package:demo_flutter/data/constants.dart';
import 'package:demo_flutter/view/pages/signup_complete_page.dart';
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
  late TextEditingController controllerNickname;
  late TextEditingController controllerVerificationCode;

  // 상태 변수들
  bool isPasswordVisible = false;
  bool isPasswordConfirmVisible = false;
  bool isEmailVerified = false;
  bool isNicknameValid = false;
  bool isVerificationCodeSent = false;
  bool passwordConfirmMatched = true;
  String? selectedCountry;
  String? errorMessage;

  // 비밀번호 규칙 상태 변수
  bool lengthQualified = false;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;

  // 닉네임 규칙 상태 변수
  bool nicknameLengthQualified = false;
  bool nicknameAllowedChars = false;
  bool nicknameStartEndValid = false;
  bool nicknameNoInvalidSpaceOrSpecial = true; // 하나의 규칙으로 합침

  // 국가 리스트

  List<Map<String, dynamic>> countryList = [];

  Future<void> loadCountryList() async {
    final String jsonString = await rootBundle.loadString(
      'assets/countries.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    countryList = jsonData.map((e) => Map<String, dynamic>.from(e)).toList();
    setState(() {});
  }

  // final String url = 'http://192.168.0.92';
  final String url = 'http://127.0.0.1';
  late final EmailAuthApi api;

  @override
  void initState() {
    super.initState();
    controllerEmail = TextEditingController();
    controllerPassword = TextEditingController();
    controllerPasswordConfirm = TextEditingController();
    controllerVerificationCode = TextEditingController();
    controllerNickname = TextEditingController(); // 닉네임 컨트롤러 초기화 추가
    loadCountryList(); // 국가 리스트 로드
    api = EmailAuthApi('$url:5001/verypool-email/asia-northeast1');
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerPasswordConfirm.dispose();
    controllerVerificationCode.dispose();
    controllerNickname.dispose(); // ✅ 추가
    super.dispose();
  }

  // 상태 변수 추가
  bool sendingCode = false;
  bool verifyingCode = false;

  Future<void> onRequestCode(String email) async {
    print('이메일 인증코드 전송 before: $email');
    await api.sendCode(email);
    print('이메일 인증코드 전송 완료: $email');
    // UI: "코드를 보냈어요. 이메일 확인해 주세요" + 재전송 60초 쿨다운
  }

  Future<bool> onVerify(String email, String code) async {
    final ok = await api.verifyCode(email, code); // <- Future<bool>
    return ok;
  }

  bool get canSubmit =>
      isEmailVerified &&
      validatePassword(controllerPassword.text) &&
      controllerPassword.text == controllerPasswordConfirm.text &&
      (selectedCountry != null);

  // ElevatedButton(onPressed: canSubmit ? onSignupPressed : null, ...)

  // 비밀번호 규칙별 체크 함수
  void validatePasswordRules(String password) {
    setState(() {
      lengthQualified = password.length >= 12 && password.length <= 128;
      hasUppercase = password.contains(RegExp(r'[A-Z]'));
      hasLowercase = password.contains(RegExp(r'[a-z]'));
      hasNumber = password.contains(RegExp(r'[0-9]'));
      hasSpecialChar = password.contains(
        RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=~`/\[\]\\]'),
      );
    });
  }

  // 닉네임 규칙 체크 함수
  void validateNicknameRules(String nickname) {
    setState(() {
      nicknameLengthQualified = nickname.length >= 2 && nickname.length <= 20;
      nicknameAllowedChars = RegExp(
        r'^[A-Za-z0-9가-힣 _.\-]+$',
      ).hasMatch(nickname);
      nicknameStartEndValid =
          nickname.isNotEmpty &&
          RegExp(r'^[A-Za-z0-9가-힣]').hasMatch(nickname[0]) &&
          RegExp(r'[A-Za-z0-9가-힣]$').hasMatch(nickname[nickname.length - 1]);
      // 금지: 앞뒤 공백, 연속 공백, 연속 특수문자(__, .., -- 등)
      nicknameNoInvalidSpaceOrSpecial =
          nickname == nickname.trim() &&
          !nickname.contains('  ') &&
          !RegExp(r'(\.\.|__|--|  )').hasMatch(nickname);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        centerTitle: true,
        backgroundColor: Colors.white, // 반드시 추가!
        foregroundColor: Colors.black,
        elevation: 0, // 그림자 제거
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                        : () async {
                            final email = controllerEmail.text.trim();
                            if (email.isEmpty || !email.contains('@')) {
                              setState(
                                () => errorMessage = '올바른 이메일 주소를 입력해주세요.',
                              );
                              return;
                            }
                            setState(() {
                              errorMessage = null;
                            });

                            try {
                              final ok = await api.sendCode(email);
                              if (!mounted) return;
                              if (ok) {
                                setState(() => isVerificationCodeSent = true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('인증코드가 전송되었습니다.'),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (!mounted) return;
                              setState(() => errorMessage = '코드 전송 실패: $e');
                            }
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
                    child: sendingCode
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
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
                      onPressed: verifyingCode
                          ? null
                          : () async {
                              final email = controllerEmail.text.trim();
                              final code = controllerVerificationCode.text
                                  .trim();
                              if (code.length != 6) {
                                setState(
                                  () => errorMessage = '6자리 인증코드를 입력해주세요.',
                                );
                                return;
                              }
                              setState(() {
                                verifyingCode = true;
                                errorMessage = null;
                              });
                              try {
                                final ok = await onVerify(email, code);
                                if (!mounted) return;
                                if (ok) {
                                  setState(() => isEmailVerified = true);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('이메일 인증이 완료되었습니다.'),
                                    ),
                                  );
                                } else {
                                  setState(
                                    () =>
                                        errorMessage = '인증코드가 올바르지 않거나 만료되었어요.',
                                  );
                                }
                              } catch (e) {
                                if (!mounted) return;
                                setState(() => errorMessage = '인증 실패: $e');
                              } finally {
                                if (mounted)
                                  setState(() => verifyingCode = false);
                              }
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
                onChanged: (value) {
                  validatePasswordRules(value);
                },
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

              // 비밀번호 규칙 체크 UI
              SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRuleCheck(lengthQualified, '12자 이상 128자 이하'),
                  _buildRuleCheck(hasUppercase, '대문자 포함(A-Z)'),
                  _buildRuleCheck(hasLowercase, '소문자 포함(a-z)'),
                  _buildRuleCheck(hasNumber, '숫자 포함'),
                  _buildRuleCheck(hasSpecialChar, '특수문자 포함'),
                ],
              ),

              SizedBox(height: 20.0),

              // 비밀번호 확인
              TextField(
                controller: controllerPasswordConfirm,
                obscureText: !isPasswordConfirmVisible,
                onChanged: (value) {
                  setState(() {
                    passwordConfirmMatched = value == controllerPassword.text;
                  });
                },
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
              // 비밀번호 확인 규칙 체크 UI
              SizedBox(height: 8.0),
              _buildRuleCheck(passwordConfirmMatched, '비밀번호와 동일하게 입력'),

              SizedBox(height: 20.0),

              // 닉네임
              TextField(
                controller: controllerNickname,
                onChanged: (value) {
                  validateNicknameRules(value);
                },
                decoration: InputDecoration(
                  hintText: '닉네임',
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
                ),
              ),

              // 닉네임 규칙 체크 UI
              SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRuleCheck(nicknameLengthQualified, '2자 이상 20자 이하'),
                  _buildRuleCheck(
                    nicknameAllowedChars,
                    '한글/영문/숫자/띄어쓰기/언더바/점/하이픈 포함 가능',
                  ),
                  _buildRuleCheck(nicknameStartEndValid, '한글/영문/숫자로 시작하고 끝나기'),
                  _buildRuleCheck(
                    nicknameNoInvalidSpaceOrSpecial,
                    '앞뒤 공백, 연속 공백, 연속 특수문자(__, .., -- 등) 포함하지 않기',
                  ),
                ],
              ),

              SizedBox(height: 20.0),

              // 기존 TextField 교체
              InkWell(
                onTap: () async {
                  final countryName = await showDialog<String>(
                    context: context,
                    builder: (_) => SimpleDialog(
                      title: const Text('거주국가 선택'),
                      children: countryList.map((country) {
                        return SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context, country['name'] as String);
                          },
                          child: Text(country['name'] as String),
                        );
                      }).toList(),
                    ),
                  );
                  if (countryName != null) {
                    setState(() => selectedCountry = countryName);
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    hintText: '거주국가 선택',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
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
                    suffixIcon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  child: Text(
                    selectedCountry ?? '',
                    style: TextStyle(
                      color: selectedCountry == null
                          ? Colors.grey.shade400
                          : Colors.black,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 32.0),

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

  Widget _buildRuleCheck(bool isChecked, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check,
          color: isChecked ? Colors.green : Colors.grey,
          size: 18.0,
        ),
        SizedBox(width: 6.0),
        Expanded(
          child: Text(
            text,
            softWrap: true,
            maxLines: 2, // 필요시 더 늘릴 수 있음
            style: TextStyle(
              color: isChecked ? Colors.green.shade700 : Colors.grey.shade600,
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  bool validatePassword(String password) {
    final lengthQualified = password.length >= 12 && password.length <= 128;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final hasSpecialChar = password.contains(
      RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=~`/\[\]\\]'),
    );

    return lengthQualified &&
        hasUppercase &&
        hasLowercase &&
        hasNumber &&
        hasSpecialChar;
  }

  void onSignupPressed() {
    setState(() => errorMessage = null);

    if (!isEmailVerified) {
      setState(() => errorMessage = '이메일 인증을 완료해주세요.');
      return;
    }
    if (!validatePassword(controllerPassword.text)) {
      setState(() => errorMessage = '비밀번호는 12~128자, 대/소문자/숫자/특수문자 모두 포함해야 해요.');
      return;
    }
    if (controllerPassword.text != controllerPasswordConfirm.text) {
      setState(() => errorMessage = '비밀번호가 일치하지 않습니다.');
      return;
    }
    if (selectedCountry == null) {
      setState(() => errorMessage = '거주국가를 선택해주세요.');
      return;
    }

    // ✅ 모든 검증 통과 후에만 이동
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SignupCompletePage()),
      (_) => false,
    );
  }
}
