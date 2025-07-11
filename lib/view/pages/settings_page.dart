import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<SettingsPage> {
  TextEditingController controller = TextEditingController();
  bool? isChecked = false;
  bool isOn = false;
  double sliderValue = 0.0;
  String? menuItem = 'Option 1';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(
              context,
            ); // Navigate back when the back button is pressed
          },
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton(
                value: menuItem,
                items: [
                  DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
                  DropdownMenuItem(value: 'Option 2', child: Text('Option 2')),
                  DropdownMenuItem(value: 'Option 3', child: Text('Option 3')),
                ],
                onChanged: (String? value) {
                  setState(() {
                    menuItem =
                        value; // Update the state when a menu item is selected
                  });
                },
              ),
              TextField(
                controller: controller,
                onEditingComplete: () => setState(() {
                  // Update the state when editing is complete
                }),
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              Text(controller.text),
              Checkbox(
                tristate: true,
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked =
                        value; // Update the state when checkbox is changed
                  });
                },
              ),
              CheckboxListTile.adaptive(
                tristate: true,
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    isChecked =
                        value; // Update the state when checkbox is changed
                  });
                },
                title: const Text('Checkbox List Tile'),
              ),
              Switch(
                value: isOn,
                onChanged: (bool value) {
                  setState(() {
                    isOn = value; // Update the state when switch is toggled
                  });
                },
              ),
              SwitchListTile.adaptive(
                value: isOn,
                onChanged: (bool value) {
                  setState(() {
                    isOn = value; // Update the state when switch is toggled
                  });
                },
                title: const Text('Switch List Tile'),
              ),
              Slider.adaptive(
                value: sliderValue,
                max: 10.0,
                divisions: 10,
                onChanged: (value) {
                  print(value);
                  setState(() {
                    sliderValue =
                        value; // Update the state when slider value changes
                  });
                },
              ),
              InkWell(
                splashColor: Colors.blue,
                onTap: () {
                  print('Image tapped');
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  color: Colors.white10,
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
                child: Text("Click Me"),
              ),
              ElevatedButton(onPressed: () {}, child: Text("Click Me")),
              FilledButton(onPressed: () {}, child: Text("Click Me")),
              TextButton(onPressed: () {}, child: Text("Click Me")),
              OutlinedButton(onPressed: () {}, child: Text("Click Me")),
              CloseButton(onPressed: () {}),
              BackButton(onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
