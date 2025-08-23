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
