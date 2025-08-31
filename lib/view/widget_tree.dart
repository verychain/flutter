import 'package:demo_flutter/data/constants.dart';
import 'package:demo_flutter/data/notifiers.dart';
import 'package:demo_flutter/view/pages/p2p_trading_page.dart';
import 'package:demo_flutter/view/pages/profile_page.dart';
import 'package:demo_flutter/view/pages/trade_history_page.dart'; // 추가
import 'package:demo_flutter/view/pages/settings_page.dart';
import 'package:demo_flutter/view/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Widget> pages = [
  P2PTradingPage(), // index 0
  TradeHistoryPage(), // index 1 (거래 내역)
  ProfilePage(), // index 2
];

class WidgetTree extends StatelessWidget {
  final String? title;
  const WidgetTree({super.key, this.title});

  final List<String> pageTitles = const ['P2P', '거래 내역', '프로필'];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        final safePage = (selectedPage >= 0 && selectedPage < pages.length)
            ? selectedPage
            : 0;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(title ?? pageTitles[safePage]),
            foregroundColor: Colors.black,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(title: "Settings"),
                    ),
                  );
                },
                icon: const Icon(Icons.notifications_outlined),
              ),
            ],
          ),
          body: pages[safePage],
          bottomNavigationBar: const NavbarWidget(), // 그대로 유지
        );
      },
    );
  }
}
