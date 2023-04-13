import 'package:flutter/material.dart';
import 'package:testai/home.dart';
import 'package:testai/models/user.dart';
import 'package:testai/services/users_service.dart';

import 'fleet.dart';
import 'main.dart';
import 'menu_option.dart';

class MainApp extends StatefulWidget {
  final usersService = UsersService();
  User selectedUser;

  MainApp(this.selectedUser, {super.key});

  void refresh() async {
    selectedUser = await usersService.get(selectedUser.id!);
  }

  @override
  State<StatefulWidget> createState() {
    return _MainApp();
  }
}

class _MainApp extends State<MainApp> {
  Widget _content = ContentA('Welcome screen');
  String? _selectedOption;

  List<MenuOption> getOptions() {
    return [
      MenuOption(
          'Home',
          'assets/airport.png',
          Home(widget.selectedUser, () {
            widget.refresh();
            setState(() {});
          }),
          _selectedOption == 'Home'),
      MenuOption(
          'Fleet', 'assets/airport-2.png', Fleet(), _selectedOption == 'Fleet'),
      MenuOption('Mission', 'assets/departure.png', ContentA('Mission'),
          _selectedOption == 'Mission'),
      MenuOption('Bank', 'assets/departure.png', ContentA('Bank'),
          _selectedOption == 'Bank'),
      MenuOption('Hangar', 'assets/departure.png', ContentA('Hangar'),
          _selectedOption == 'Hangar'),
      MenuOption('Logs', 'assets/departure.png', ContentA('Logs'),
          _selectedOption == 'Logs'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
          height: 50,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                /*SizedBox(
                  child: Text(
                    "Welcome, ${widget.selectedUser.name}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  child: Text(
                    "You're in, ${widget.selectedUser.location}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),*/
                SizedBox(
                  height: 200,
                  child: FutureBuilder(
                      future: widget.selectedUser.balance(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            "E ${snapshot.data} available",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          return const Text(
                            "E ...",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                      }),
                ),
              ])),
      Expanded(
          child: Row(children: <Widget>[
        Container(
          width: 100,
          height: double.infinity,
          color: Colors.red,
          child: createMenu(getOptions()),
        ),
        _content
      ]))
    ]);
  }

  Column createMenu(List<MenuOption> options) {
    return Column(children: [
      for (var i in options)
        GestureDetector(
            child: i,
            onTap: () {
              setState(() {
                _content = i.content;
                _selectedOption = i.text;
              });
            }),
    ]);
  }
}
