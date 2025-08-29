import 'dart:math';

import 'package:demo_flutter/data/notifiers.dart';
import 'package:demo_flutter/models/order_draft.dart';
import 'package:demo_flutter/utils/format_utils.dart';
import 'package:demo_flutter/view/widget_tree.dart';
import 'package:demo_flutter/view/widgets/exchange_summary_card.dart';
import 'package:demo_flutter/view/widgets/info_modal.dart';
import 'package:demo_flutter/view/widgets/session/session_stepper.dart';
import 'package:demo_flutter/view/widgets/timer_text.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // 추가: Timer 사용
import 'package:demo_flutter/view/widgets/send_widget.dart';
import 'package:demo_flutter/core/wepin_service.dart';

class TransactionSessionPage extends StatefulWidget {
  const TransactionSessionPage({super.key, required this.draft});

  final OrderDraft draft;

  @override
  State<TransactionSessionPage> createState() => _TransactionSessionPageState();
}

class _TransactionSessionPageState extends State<TransactionSessionPage> {
  static const int countdownSeconds = 15 * 60; // 15분
  late int _secondsLeft;
  Timer? _timer;
  Timer? _autoDialogTimer;
  int? _autoScheduledStep; // 어떤 step에 대해 타이머가 걸렸는지
  bool _autoDialogOpen = false; // 모달이 떠 있는지
  late final List<String> _steps;
  int _activeStep = 0;

  final WepinService _wepin = WepinService(); // 서비스 인스턴스
  bool _busyWallet = false;
  bool _walletWidgetOpened = false; // 위젯 열림 후(닫히고 돌아온 뒤) 다음 버튼 전환용

  @override
  void initState() {
    super.initState();
    _secondsLeft = countdownSeconds;
    _startCountdown();
    _scheduleAutoModalIfNeeded(); // 시작 단계에서도 한 번만 검사

    _steps = widget.draft.isBuy
        ? ['VERY 입금', '원화 송금', '원화 입금 확인', '완료'] // BUY: 4단계
        : ['VERY 송금', '원화 입금 확인', '완료']; // SELL: 3단계
  }

  void _nextStep() {
    if (_activeStep < _steps.length - 1) {
      setState(() => _activeStep++);
      _scheduleAutoModalIfNeeded(); // ← 여기서 호출
      _onStepEntered(_activeStep); // ← 추가
    }
  }

  void _prevStep() {
    if (_activeStep > 0) {
      setState(() => _activeStep--);
      _scheduleAutoModalIfNeeded(); // ← 필요시
    }
  }

  void _resetCountdownTo15m() {
    _timer?.cancel();
    setState(() {
      _secondsLeft = countdownSeconds; // 15 * 60
    });
    _startCountdown();
  }

  void _onStepEntered(int step) {
    // BUY & ‘VERY 수령 확인’(index 2) 진입 시 타이머 리셋
    _resetCountdownTo15m();

    // (있다면) 자동 모달 스케줄도 여기서 호출
    // _scheduleAutoModalIfNeeded();
  }

  void _scheduleAutoModalIfNeeded() {
    // 이미 동일 step에 대해 스케줄했거나 모달이 떠 있으면 무시
    if (_autoScheduledStep == _activeStep || _autoDialogOpen) return;

    _autoScheduledStep = _activeStep;

    _autoDialogTimer?.cancel();
    final randomSeconds = 8 + Random().nextInt(8); // 8~15

    _autoDialogTimer = Timer(Duration(seconds: randomSeconds), () async {
      if (!mounted) return;
      // 여전히 같은 조건인지 재확인 (step 바뀌었으면 취소)
      if (!widget.draft.isBuy || !(_activeStep == 0 || _activeStep == 2)) {
        return;
      }

      _autoDialogOpen = true;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => InfoModal(
          title: _activeStep == 0 ? '거래 알림' : '거래 성공',
          description: _activeStep == 0
              ? '판매자가 VERY를 입금했어요'
              : '판매자가 원화 입금을 확인했어요',
          subDescription: _activeStep == 0
              ? '원화 송금을 진행해주세요'
              : '안전하게 VERY가 보내졌어요',
          cancelText: '닫기',
          buttonText: '확인', // InfoModal의 버튼이 Navigator.pop(ctx) 하도록 구현되어 있어야 함
        ),
      );

      if (!mounted) return;

      _autoDialogOpen = false;
      // 다음 단계로
      _nextStep();

      // 사용 끝난 타이머/스케줄 마커 정리
      _autoDialogTimer?.cancel();
      _autoDialogTimer = null;
      _autoScheduledStep = null;
    });
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        timer.cancel();
        // 필요시 타임아웃 처리
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // 기존 카운트다운
    _autoDialogTimer?.cancel(); // 자동 모달 타이머
    super.dispose();
  }

  // void _showSnack(String msg) {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  // }

  final steps = ['VERY 송금', '원화 입금 확인', '완료'];
  @override
  Widget build(BuildContext context) {
    final d = widget.draft;

    return Scaffold(
      appBar: AppBar(
        title: const Text('거래 진행중'),
        centerTitle: true,
        backgroundColor: Colors.white, // 반드시 추가!
        foregroundColor: Colors.black, // 텍스트/아이콘 색상
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 32),
              SessionStepper(activeStep: _activeStep, steps: _steps),
              SizedBox(height: 32),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: _buildStepBody(d),
                ),
              ),
            ],
          ),

          if ((!d.isBuy || _activeStep != 2) && (!d.isBuy || _activeStep != 0))
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildBottomActions(d),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(OrderDraft d) {
    // 필요 없는 단계에선 숨김 처리 가능
    String primaryLabel;
    VoidCallback? onPrimary;

    if (d.isBuy) {
      switch (_activeStep) {
        // case 0: primaryLabel = '입금하러 가기'; onPrimary = _openBankAppAndNext; break;
        case 1:
          primaryLabel = '송금 완료했어요';
          onPrimary = _confirmCurrencySentAndNext;
          break;
        case 3:
          primaryLabel = '확인';
          // Transaction Complete 페이지로 이동
          onPrimary = () => Navigator.pop(context);
          break;
        default:
          primaryLabel = '다음';
          onPrimary = _nextStep;
      }
    } else {
      switch (_activeStep) {
        case 0:
          if (_busyWallet) {
            primaryLabel = '열는 중…';
            onPrimary = null;
          } else if (_walletWidgetOpened) {
            primaryLabel = 'VERY를 보냈어요';
            onPrimary = _confirmSentAndNext; // ↓ 3) 함수
          } else {
            primaryLabel = '월렛 열기';
            onPrimary = _openWalletOnly; // ↓ 3) 함수
          }
          break;
        case 1:
          primaryLabel = '${formatPriceSmart(d.price * d.quantity)}원 입금 받았어요';
          onPrimary = _nextStep;
          break;
        case 2:
          primaryLabel = '확인';
          onPrimary = () {
            selectedPageNotifier.value = 0; // 거래 탭 선택
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const WidgetTree()),
              (route) => false,
            );
          };
          break;
        default:
          primaryLabel = '다음';
          onPrimary = _nextStep;
      }
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPrimary,
      child: Text(
        primaryLabel,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _openWalletOnly() async {
    if (_busyWallet) return;

    setState(() => _busyWallet = true);

    // 컨텍스트 의존 객체 미리 뽑기(린트 회피)
    final messenger = ScaffoldMessenger.of(context);

    try {
      await _wepin.init();

      // 로그인 선행
      final res = await _wepin.loginWithGoogle(context);
      if (!mounted) return;

      final ok =
          res != null &&
          res.status == 'success' &&
          res.userStatus?.loginStatus == 'complete';

      if (!ok) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              '로그인이 완료되지 않았어요. (${res?.userStatus?.loginStatus ?? 'unknown'})',
            ),
          ),
        );
        return;
      }

      // 지갑 위젯 열기(사용자가 닫으면 다음 줄로 복귀)
      await _wepin.openWallet(context);
      if (!mounted) return;

      // 위젯 닫히고 돌아오면 버튼 전환
      setState(() => _walletWidgetOpened = true);

      messenger.showSnackBar(
        const SnackBar(content: Text('송금이 끝났다면 "VERY를 보냈어요"를 눌러주세요.')),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('월렛 열기 실패: $e')));
    } finally {
      if (mounted) setState(() => _busyWallet = false);
    }
  }

  Future<void> _confirmCurrencySentAndNext() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => InfoModal(
        title: '확인 알림',
        description: '해당 계좌로 정확한 금액을 송금하셨나요?',
        buttonText: '확인',
        cancelText: '닫기 ',
      ),
    );

    if (!mounted) return;

    // 5) 다음 단계로 이동
    _nextStep();
  }

  Future<void> _confirmSentAndNext() async {
    // (옵션) 중복 클릭 방지용 플래그가 있다면 체크
    // if (_busyWallet) return;

    // 컨텍스트 의존 객체는 미리 뽑기 (await 뒤 린트 회피)
    final navigator = Navigator.of(context);

    // 1) 스피너 다이얼로그 표시 (block)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 80),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.8),
              ),
              SizedBox(width: 12),
              Text('로딩 중입니다…', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );

    // 2) 3초 대기
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    // 3) 스피너 닫기
    navigator.pop();

    // 4) InfoModal 띄우기 (확인 누르면 닫힘)
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => InfoModal(
        title: '송금 확인',
        description: '네트워크에서 송금이 확인되었습니다.',
        subDescription: '구매자에게 원화 입금 요청할게요',
        cancelText: '닫기',
        buttonText: '확인', // <- 내부에서 Navigator.pop(context) 호출되어야 함
      ),
    );
    if (!mounted) return;

    // 5) 다음 단계로 이동
    _nextStep();
  }

  Widget _buildStepBody(OrderDraft d) {
    if (d.isBuy) {
      switch (_activeStep) {
        case 0: // 원화 입금 안내
          return _pendingSection(
            '판매자가 VERY 입금\n진행중이에요',
            '시간 내에 VERY 입금이 없을 경우 자동 종료돼요',
            d,
          );
        case 1: // 정보 등록
          return SendWidget(title: '원화 송금 후\n아래 버튼을 눌러주세요', draft: d);
        case 2: // VERY 수령 확인(대기)
          return _pendingSection(
            '판매자가 입금된 원화를\n확인중이에요',
            '시간 내에 원화 입금 확인이 없을 경우, 자동 종료돼요',
            d,
          );
        case 3: // 완료
          return Padding(
            padding: const EdgeInsets.only(top: 32),
            child: _doneSection(),
          );
      }
    } else {
      switch (_activeStep) {
        case 0: // VERY 송금
          return SendWidget(
            title: '웰렛을 열어\nVERY를 송금해주세요',
            draft: d,
          ); // 월렛 열어 송금 UI
        case 1: // 정보 등록
          return _pendingSection(
            '구매자가 원화 입금을 진행중이에요\n아직 떠나지 마세요',
            '입금 확인 후, 아래 버튼을 눌러주세요',
            d,
          );
        case 2: // 원화 입금 확인(대기)
          return Padding(
            padding: const EdgeInsets.only(top: 32),
            child: _doneSection(),
          );
      }
    }
    return const SizedBox.shrink();
  }

  Widget _pendingSection(String title, String description, OrderDraft draft) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          SizedBox(height: 46),
          ExchangeSummaryCard(
            isBuy: draft.isBuy,
            sendAmountKrw: draft.price * draft.quantity,
            receiveQuantity: draft.quantity,
            unitPriceKrw: draft.price,
          ),
          SizedBox(height: 8),
          TimerText(secondsLeft: _secondsLeft),
          // 오른쪽 하단 버튼 영역을 Row + mainAxisAlignment로 대체
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!draft.isBuy || _activeStep != 2)
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 6,
                        ),
                        tapTargetSize:
                            MaterialTapTargetSize.shrinkWrap, // 터치 영역 줄이기
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(color: Colors.grey.shade600),
                      ),
                      child: Text(
                        '거래 취소하기',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '문제가 생기셨나요?',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(width: 10),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 5,
                          ), // 3px 5px
                          tapTargetSize:
                              MaterialTapTargetSize.shrinkWrap, // 터치 영역 줄이기
                          visualDensity: VisualDensity.compact, // (옵션) 더 타이트하게
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(color: Colors.grey.shade600),
                        ),
                        onPressed: () {},
                        child: Text(
                          '문의하기',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _doneSection() {
    return Align(
      alignment: Alignment.topCenter, // ⬅️ 위쪽 고정
      child: Column(
        mainAxisSize: MainAxisSize.min, // ⬅️ 필요한 높이만 차지
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/green_check.png'),
          const SizedBox(height: 24),
          const Text(
            '거래를 완료했어요!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            '자산이 지갑에 입금되었어요\n다음 거래도 시작해보세요',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
