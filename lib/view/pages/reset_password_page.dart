import 'package:demo_flutter/data/constants.dart';
import 'package:demo_flutter/view/pages/login_page.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  final String? token; // 재설정 링크의 토큰

  const ResetPasswordPage({super.key, this.token});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController controllerNewPassword = TextEditingController();
  final TextEditingController controllerConfirmPassword = TextEditingController();
  
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  String? errorMessage;
  bool isPasswordReset = false;

  // 비밀번호 조건 체크 상태
  bool hasMinLength = false;
  bool hasMaxLength = true;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;

  @override
  void dispose() {
    controllerNewPassword.dispose();
    controllerConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 재설정'),
        automaticallyImplyLeading: false, // 뒤로 가기 버튼 제거
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isPasswordReset) ...[
                Text(
                  "새 비밀번호 설정",
                  style: TextStyle(
                    color: Colors.grey.shade900,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  "새로운 비밀번호를 입력해주세요.\n보안을 위해 강력한 비밀번호를 설정하세요.",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16.0,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 30.0),

                // 새 비밀번호 입력
                TextField(
                  controller: controllerNewPassword,
                  obscureText: !isNewPasswordVisible,
                  onChanged: (value) {
                    checkPasswordRequirements(value);
                  },
                  decoration: InputDecoration(
                    hintText: '새 비밀번호',
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        isNewPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey.shade400,
                      ),
                      onPressed: () {
                        setState(() {
                          isNewPasswordVisible = !isNewPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),

                SizedBox(height: 16.0),

                // 비밀번호 조건 표시
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "비밀번호 조건",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      _buildPasswordRequirement("8자 이상 16자 이하", hasMinLength && hasMaxLength),
                      _buildPasswordRequirement("대문자 포함 (A-Z)", hasUppercase),
                      _buildPasswordRequirement("소문자 포함 (a-z)", hasLowercase),
                      _buildPasswordRequirement("숫자 포함 (0-9)", hasNumber),
                      _buildPasswordRequirement("특수문자 포함 (!@#\$%)", hasSpecialChar),
                    ],
                  ),
                ),

                SizedBox(height: 20.0),

                // 비밀번호 확인
                TextField(
                  controller: controllerConfirmPassword,
                  obscureText: !isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    hintText: '비밀번호 확인',
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        isConfirmPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey.shade400,
                      ),
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
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

                // 비밀번호 재설정 버튼
                ElevatedButton(
                  onPressed: () {
                    resetPassword();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50.0),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    '비밀번호 재설정',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Pretendard",
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ] else ...[
                // 비밀번호 재설정 완료 메시지
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
                        Icons.check_circle_outline,
                        color: Colors.green.shade600,
                        size: 48.0,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        '비밀번호 재설정 완료',
                        style: TextStyle(
                          color: Colors.green.shade800,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        '새로운 비밀번호로 설정이 완료되었습니다.\n이제 새 비밀번호로 로그인하세요.',
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

                // 로그인하기 버튼
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(title: '로그인'),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50.0),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    '로그인하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Pretendard",
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordRequirement(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.cancel,
            color: isValid ? Colors.green : Colors.grey.shade400,
            size: 16.0,
          ),
          SizedBox(width: 8.0),
          Text(
            text,
            style: TextStyle(
              color: isValid ? Colors.green.shade700 : Colors.grey.shade600,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  void checkPasswordRequirements(String password) {
    setState(() {
      hasMinLength = password.length >= 8;
      hasMaxLength = password.length <= 16;
      hasUppercase = password.contains(RegExp(r'[A-Z]'));
      hasLowercase = password.contains(RegExp(r'[a-z]'));
      hasNumber = password.contains(RegExp(r'[0-9]'));
      hasSpecialChar = password.contains(RegExp(r'[!@#$%]'));
    });
  }

  bool isPasswordValid() {
    return hasMinLength && hasMaxLength && hasUppercase && hasLowercase && hasNumber && hasSpecialChar;
  }

  void resetPassword() {
    setState(() {
      errorMessage = null;
    });

    // 비밀번호 유효성 검사
    if (!isPasswordValid()) {
      setState(() {
        errorMessage = '비밀번호가 조건을 만족하지 않습니다.';
      });
      return;
    }

    if (controllerNewPassword.text != controllerConfirmPassword.text) {
      setState(() {
        errorMessage = '비밀번호가 일치하지 않습니다.';
      });
      return;
    }

    // 실제로는 여기서 서버에 새 비밀번호 업데이트 요청
    setState(() {
      isPasswordReset = true;
    });
  }
}