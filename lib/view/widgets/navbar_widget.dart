import 'package:demo_flutter/data/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:wepin_flutter_widget_sdk/wepin_flutter_widget_sdk.dart';
import 'package:wepin_flutter_login_lib/wepin_flutter_login_lib.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

import 'package:wepin_flutter_widget_sdk/wepin_flutter_widget_sdk_type.dart';

class NavbarWidget extends StatefulWidget {
  const NavbarWidget({super.key});

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  late WepinWidgetSDK wepinSDK;
  late WepinLogin wepinLogin;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    initWepinLogin();
  }

  void initWepinLogin() async {
    final androidAppKey = dotenv.env['WEPIN_APP_KEY_ANDROID'];
    final iosAppKey = dotenv.env['WEPIN_APP_KEY_IOS'];
    final appKey = Platform.isAndroid ? androidAppKey : iosAppKey;
    final appId = dotenv.env['WEPIN_APP_ID'] ?? '';

    wepinSDK = WepinWidgetSDK(
      wepinAppKey: appKey ?? '',
      wepinAppId: appId ?? '',
    );
    await wepinSDK.init();
    wepinLogin = WepinLogin(wepinAppKey: appKey ?? '', wepinAppId: appId);
    await wepinLogin.init();
  }

  String? userAddress;

  Future<void> _login() async {
    final googleClientId = dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
    print('[Wepin] 로그인 시도');
    final loginResult = await wepinSDK.loginWithUI(
      context,
      loginProviders: [
        LoginProvider(provider: 'google', clientId: googleClientId),
      ],
    );
    print('[Wepin] 로그인 결과: $loginResult');

    if (loginResult != null &&
        loginResult.status == 'success' &&
        loginResult.userStatus?.loginStatus == 'complete') {
      wepinSDK.openWidget(context);
      print(
        '[Wepin] 로그인 성공: userId=${loginResult.userInfo?.userId}, email=${loginResult.userInfo?.email}',
      );
      setState(() {
        isLoggedIn = true;
      });
      final accountResult = await wepinSDK.getAccounts();
      print('accountResult: $accountResult');
      final account = accountResult.firstWhere(
        (acc) => acc.network == 'evmVERY',
        orElse: () => WepinAccount(address: '', network: 'evmVERY'),
      );
      print('account: $account');

      final String receiverAddress =
          '0x8946732aD6f195865B62927749c275Cde659d055';

      // final sendResult = await wepinSDK.send(
      //   context,
      //   account: WepinAccount(address: userAddress ?? '', network: 'evmVERY'),
      //   txData: WepinTxData(toAddress: receiverAddress, amount: '0.1'),
      // );
      // print('sendResult: $sendResult');

      return;

      if (account.address.isEmpty) {
        print('[Wepin] evmVERY 네트워크에 계정이 없습니다.');
        return;
      }
      userAddress = account.address;
      print('userAddress 저장됨: $userAddress');

      if (userAddress == null) {
        print('[Wepin] 지갑 주소가 없습니다.');
        return;
      }
    } else {
      print(
        '[Wepin] 로그인 실패 또는 추가 인증 필요: status=${loginResult?.status}, loginStatus=${loginResult?.userStatus?.loginStatus}',
      );
      setState(() {
        isLoggedIn = false;
      });
      if (loginResult?.userStatus?.loginStatus == 'registerRequired') {
        print('[Wepin] 회원가입 필요');
        // 회원가입 처리 로직
      } else if (loginResult?.userStatus?.loginStatus == 'pinRequired') {
        print('[Wepin] PIN 입력 필요');
        // PIN 입력 처리 로직
      }
    }
  }

  Future<void> _openWallet() async {
    await wepinSDK.openWidget(context);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return NavigationBar(
          backgroundColor: Colors.white,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.swap_horiz_rounded),
              label: "거래",
            ),
            NavigationDestination(
              icon: IconButton(
                icon: const Icon(Icons.account_balance_wallet_outlined),
                onPressed: () async {
                  await _login();
                },
              ),
              label: '지갑',
            ),
            const NavigationDestination(icon: Icon(Icons.person), label: '프로필'),
          ],
          selectedIndex: selectedPage,
          onDestinationSelected: (value) {
            selectedPageNotifier.value = value;
          },
        );
      },
    );
  }
}
