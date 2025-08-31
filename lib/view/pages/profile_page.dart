import 'package:demo_flutter/data/notifiers.dart';
import 'package:demo_flutter/view/pages/welcome_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                selectedPageNotifier.value = 0;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const WelcomePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
