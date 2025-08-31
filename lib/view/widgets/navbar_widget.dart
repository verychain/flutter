import 'package:demo_flutter/data/notifiers.dart';
import 'package:flutter/material.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, current, _) {
        return NavigationBar(
          backgroundColor: Colors.white,
          selectedIndex: current,
          onDestinationSelected: (idx) {
            // 0:P2P 1:거래내역 2:프로필
            selectedPageNotifier.value = idx;
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.people_outline),
              label: 'P2P',
            ),
            NavigationDestination(icon: Icon(Icons.swap_horiz), label: '거래'),
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: '지갑',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              label: '프로필',
            ),
          ],
        );
      },
    );
  }
}
