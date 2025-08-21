import 'package:flutter/material.dart';
import 'package:wepin_flutter_widget_sdk/wepin_flutter_widget_sdk.dart';
import 'package:wepin_flutter_login_lib/wepin_flutter_login_lib.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late WepinWidgetSDK wepinSDK;
  late WepinLogin wepinLogin;
  bool isLoggedIn = false;

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
    print(wepinSDK.isInitialized());
    wepinLogin = WepinLogin(wepinAppKey: appKey ?? '', wepinAppId: appId);
    await wepinLogin.init();
  }

  @override
  void initState() {
    super.initState();
    initWepinLogin();
  }

  Future<void> _login() async {
    final googleClientId = dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
    final loginResult = await wepinLogin.loginWithOauthProvider(
      provider: 'google',
      clientId: googleClientId,
    );
    setState(() {
      isLoggedIn = loginResult != null;
    });
  }

  Future<void> _openWallet() async {
    await wepinSDK.openWidget(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('지갑')),
      body: Center(
        child: isLoggedIn
            ? ElevatedButton(onPressed: _openWallet, child: Text('위핀 지갑 열기'))
            : ElevatedButton(onPressed: _login, child: Text('위핀 로그인')),
      ),
    );
  }
}
