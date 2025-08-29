import 'package:flutter/material.dart';
import 'package:wepin_flutter_widget_sdk/wepin_flutter_widget_sdk.dart';
import 'package:wepin_flutter_widget_sdk/wepin_flutter_widget_sdk_type.dart';

Future<void> openSendWidget(
  BuildContext context, {
  required WepinWidgetSDK wepinSDK,
  required WepinAccount account,
  required String toAddress,
  required String amount,
  required List<LoginProvider> loginProviders,
}) async {
  final status = await wepinSDK.getStatus();

  if (status == WepinLifeCycle.login) {
    await wepinSDK.send(
      context,
      account: account,
      txData: WepinTxData(toAddress: toAddress, amount: amount),
    );
  } else {
    final loginResult = await wepinSDK.loginWithUI(
      context,
      loginProviders: loginProviders,
    );

    if (loginResult?.userStatus?.loginStatus == "complete") {
      await wepinSDK.send(
        context,
        account: account,
        txData: WepinTxData(toAddress: toAddress, amount: amount),
      );
    } else {
      await wepinSDK.register(context);
      // 추가 동작 필요시 여기에 작성
    }
  }
}
