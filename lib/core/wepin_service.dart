// lib/core/wepin_service.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wepin_flutter_widget_sdk/wepin_flutter_widget_sdk.dart';
import 'package:wepin_flutter_login_lib/wepin_flutter_login_lib.dart';
import 'package:wepin_flutter_widget_sdk/wepin_flutter_widget_sdk_type.dart';

class WepinService {
  late final WepinWidgetSDK _sdk;
  late final WepinLogin _login;
  bool _initialized = false;

  bool get isInitialized => _initialized;

  Future<void> init() async {
    if (_initialized) return;
    final androidAppKey = dotenv.env['WEPIN_APP_KEY_ANDROID'] ?? '';
    final iosAppKey = dotenv.env['WEPIN_APP_KEY_IOS'] ?? '';
    final appKey = Platform.isAndroid ? androidAppKey : iosAppKey;
    final appId = dotenv.env['WEPIN_APP_ID'] ?? '';

    // 🔒 키 검증 (비어있으면 즉시 오류)
    if (appKey.isEmpty || appId.isEmpty) {
      throw ArgumentError('[Wepin] appKey/appId가 비어있습니다. .env 설정 확인');
    }

    _sdk = WepinWidgetSDK(wepinAppKey: appKey, wepinAppId: appId);
    await _sdk.init();

    _login = WepinLogin(wepinAppKey: appKey, wepinAppId: appId);
    await _login.init();

    _initialized = true;
  }

  /// UI가 필요한 SDK 메서드는 BuildContext를 받아서 실행
  Future<WepinUser?> loginWithGoogle(BuildContext context) async {
    assert(_initialized, 'Call WepinService.init() first');
    final googleClientId = dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
    final res = await _sdk.loginWithUI(
      context,
      loginProviders: [
        LoginProvider(provider: 'google', clientId: googleClientId),
      ],
    );
    // LoginResult 타입으로 캐스팅
    return res;
  }

  Future<void> openWallet(BuildContext context) async {
    assert(_initialized, 'Call WepinService.init() first');
    await _sdk.openWidget(context);
  }

  Future<List<WepinAccount>> getAccounts() async {
    assert(_initialized, 'Call WepinService.init() first');
    return await _sdk.getAccounts();
  }

  // 필요시 추가: send, logout 등등
}
