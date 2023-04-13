import 'package:flutter/material.dart';

import 'models/user.dart';
import 'services/users_service.dart';
import 'user_form.dart';
import 'user_list_card.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UsersList();
  }
}

class _UsersList extends State<UsersList> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() async {
    final a = UsersService();
    final us = await a.all();

    setState(() {
      users = us;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      const SizedBox(
        child: Text(
          'Users',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(
        child: ElevatedButton(
          child: const Text('Add new user'),
          onPressed: () => onTapFunction(context),
        ),
      ),
      Expanded(
          child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: users.length,
        itemBuilder: (context, index) {
          return UserCardView(users[index]);
        },
      ))
    ]));
  }

  onTapFunction(BuildContext context) async {
    bool? reLoadPage = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserForm()),
    );

    if (reLoadPage == true) {
      _refresh();
    }
  }
}
