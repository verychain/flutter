// lib/core/email_auth_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailAuthApi {
  final String baseUrl; // 예: https://us-central1-<project>.cloudfunctions.net
  EmailAuthApi(this.baseUrl);

  Future<bool> sendCode(String email) async {
    print('sendCode 함수 안. 이메일 인증코드 전송: $email');
    print(Uri.parse('$baseUrl/sendEmailCode'));
    final r = await http.post(
      Uri.parse('$baseUrl/sendEmailCode'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    print('sendCode 함수 안. r: $r');
    if (r.statusCode == 200) return true;
    throw Exception('send failed: ${r.body}');
  }

  Future<bool> verifyCode(String email, String code) async {
    print('verifyCode 함수 안. 이메일: $email, 코드: $code');
    final r = await http.post(
      Uri.parse('$baseUrl/verifyEmailCode'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
    );
    if (r.statusCode == 200) return true;
    return false;
  }
}
