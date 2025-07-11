import 'package:demo_flutter/data/notifiers.dart';
import 'package:demo_flutter/view/pages/home_page.dart';
import 'package:demo_flutter/view/pages/profile_page.dart';
import 'package:demo_flutter/view/pages/settings_page.dart';
import 'package:demo_flutter/view/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';

List<Widget> pages = [HomePage(), ProfilePage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
        actions: [
          IconButton(
            onPressed: () {
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
