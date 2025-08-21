import 'package:demo_flutter/data/constants.dart';
import 'package:demo_flutter/data/notifiers.dart';
import 'package:demo_flutter/view/pages/p2p_trading_page.dart';
import 'package:demo_flutter/view/pages/profile_page.dart';
import 'package:demo_flutter/view/pages/settings_page.dart';
import 'package:demo_flutter/view/pages/wallet_page.dart';
import 'package:demo_flutter/view/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Widget> pages = [P2PTradingPage(), WalletPage(), ProfilePage()];

class WidgetTree extends StatelessWidget {
  final String? title;

  const WidgetTree({super.key, this.title});

  // 페이지별 제목 정의 (기본값들)
  final List<String> pageTitles = const ['P2P', '지갑', '프로필'];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(title ?? pageTitles[selectedPage]),
            actions: [
              IconButton(
                onPressed: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool(
                    KConstants.isDarkModeKey,
                    !isDarkModeNotifier.value,
                  );
                  isDarkModeNotifier.value = !isDarkModeNotifier.value;
                },
                icon: ValueListenableBuilder(
                  valueListenable: isDarkModeNotifier,
                  builder: (context, isDarkMode, child) {
                    return Icon(
                      isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    );
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(title: "Settings"),
                    ),
                  );
                },
                icon: Icon(Icons.settings),
              ),
            ],
          ),
          body: pages[selectedPage],
          bottomNavigationBar: NavbarWidget(),
        );
      },
    );
  }
}
