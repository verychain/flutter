import 'package:demo_flutter/data/constants.dart';
import 'package:demo_flutter/data/notifiers.dart';
import 'package:demo_flutter/view/pages/home_page.dart';
import 'package:demo_flutter/view/pages/profile_page.dart';
import 'package:demo_flutter/view/pages/settings_page.dart';
import 'package:demo_flutter/view/pages/listings_page.dart';
import 'package:demo_flutter/view/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Widget> pages = [HomePage(), ListingsPage(), ProfilePage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
        actions: [
          IconButton(
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.setBool(
                KConstants.isDarkModeKey,
                !isDarkModeNotifier.value,
              );
              // when pressed, toggle dark mode
              isDarkModeNotifier.value = !isDarkModeNotifier.value;
            },
            icon: ValueListenableBuilder(
              valueListenable: isDarkModeNotifier,
              builder: (context, isDarkMode, child) {
                return Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode);
              },
            ),
          ),
          IconButton(
            onPressed: () {
              // when pressed, toggle dark mode
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
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages[selectedPage];
        },
      ), // Display the first page by default
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
