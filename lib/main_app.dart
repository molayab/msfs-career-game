import 'package:flutter/material.dart';

import 'fleet.dart';
import 'main.dart';
import 'menu_option.dart';

class MainApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainApp();
  }
}

class _MainApp extends State<MainApp> {
  Widget _content = ContentA('Welcome screen');
  String? _selectedOption = null;

  List<MenuOption> getOptions() {
    return [
      MenuOption('Home', 'assets/airport.png', ContentA('Home'), _selectedOption == 'Home'),
      MenuOption('Fleet', 'assets/airport-2.png', Fleet(), _selectedOption == 'Fleet'),
      MenuOption('Mission', 'assets/departure.png', ContentA('Mission'), _selectedOption == 'Mission'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 100,
            height: double.infinity,
            color: Colors.red,
            child: createMenu(getOptions()),
          ),
          _content
        ]
      )
    );
  }

  Column createMenu(List<MenuOption> options) {
    return Column(
      children: [
        for (var i in options) new GestureDetector(
          child: i,
          onTap: () {
            setState(() {
              _content = i.content;
              _selectedOption = i.text;
            });
          }),
      ]
    );
  }
}