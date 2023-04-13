import 'package:flutter/material.dart';

import 'models/mission.dart';
import 'services/mission_service.dart';
import 'user_list.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginView();
  }
}

class _LoginView extends State<LoginView> {
  List<Mission> airports = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() async {
    final a = MissionService();
    final air = await a.generateOnLocation("SKRG", 350);

    setState(() {
      airports = air;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(children: <Widget>[
          const SizedBox(
            child: Text(
              'Welcome to FS Career',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: UsersList()),
        ]));
  }
}
