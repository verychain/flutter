import 'package:flutter/material.dart';

class InfoModal extends StatelessWidget {
  final String title; // 상단 큰 제목(굵게 18)
  final String description; // 본문 메시지(중간 16)
  final String? subDescription; // 제목 아래 작은 보조문구(회색 14)
  final String buttonText; // 확인 버튼 텍스트
  final String? cancelText; // 취소 버튼 텍스트(없으면 단일 버튼)

  const InfoModal({
    super.key,
    required this.title,
    required this.description,
    this.subDescription,
    required this.buttonText,
    this.cancelText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // ✅ BuySellConfirmModal 과 동일한 타이틀 구성: 제목 + 작은 설명문
      title: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          if (subDescription != null)
            Text(
              subDescription!,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
        ],
      ),
      // ✅ 본문은 중앙 정렬 텍스트 1~2줄 정도를 가정
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            description,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      // ✅ 버튼 가로 배치(취소 / 확인) — BuySellConfirmModal 동일 양식
      actions: [
        Row(
          children: [
            if (cancelText != null) ...[
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey.shade200,
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide.none,
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    cancelText!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(buttonText, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
