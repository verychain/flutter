// format_utils.dart
import 'package:intl/intl.dart';

// 컨트랙트 주소 마스킹 함수 추가
String maskAddress(String address) {
  if (address.length <= 12) return address;
  return '${address.substring(0, 6)}...${address.substring(address.length - 6)}';
}

String formatWithComma(
  num? n, {
  int minFractionDigits = 0,
  int maxFractionDigits = 0,
}) {
  if (n == null) return '';
  final f = NumberFormat.decimalPattern()
    ..minimumFractionDigits = minFractionDigits
    ..maximumFractionDigits = maxFractionDigits;
  return f.format(n);
}

// 정수면 소수 자릿수 0, 소수면 최대 1자리 (가격)
String formatPriceSmart(num v) =>
    formatWithComma(v, minFractionDigits: 0, maxFractionDigits: 1);

// 정수면 0자리, 소수면 최대 2자리 (수량)
String formatQtySmart(num v) =>
    formatWithComma(v, minFractionDigits: 0, maxFractionDigits: 2);

String krw(num n) => formatWithComma(n, maxFractionDigits: 0); // 정수 표기
String num2(num n, {int max = 2}) =>
    formatWithComma(n, minFractionDigits: 0, maxFractionDigits: max);

String stripComma(String s) => s.replaceAll(',', '');

double parseNumber(String s) {
  final raw = stripComma(s.trim());
  return double.tryParse(raw) ?? 0;
}

String formatNumberWithComma(num number) {
  return number
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
}

String formatTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 0) {
    return '${difference.inDays}일전';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}시간전';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}분전';
  } else {
    return '방금전';
  }
}
