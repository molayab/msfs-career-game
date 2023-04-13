import 'package:flutter/material.dart';

import 'models/mission.dart';
import 'models/user.dart';
import 'services/mission_service.dart';
import 'services/users_service.dart';

void main() async {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('FS Career'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: LoginView(),
    ),
  )
  );
}



class LoginView extends StatefulWidget {
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
      child: Column(
        children: <Widget>[
          SizedBox(
            child: Text('Welcome to FS Career',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: UsersList()), 
        ]
      )
    );
  }
}


// This widget list all the users and adds a button to create a new one
class UsersList extends StatefulWidget {
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
      child: Column(
        children: <Widget>[
          SizedBox(
            child: Text('Users',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            child: ElevatedButton(
              child: Text('Add new user'),
              onPressed: () => onTapFunction(context),
            ),
          ),
          Expanded(child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(users[index].name),
              );
            },
          )) 
        ]
      )
    );
  }

  onTapFunction(BuildContext context) async {
    bool reLoadPage = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserForm()),
    );

    if (reLoadPage) {
      _refresh();
    }
  }
}

// This widget is used to create a new user
class UserForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserForm();
  }
}

class _UserForm extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new user'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                hintText: 'Inital location (ICAO)',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final a = UsersService();
                  a.createUser(_nameController.text, _locationController.text);
                  Navigator.pop(context, true);
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

// This is temporal
class ContentA extends StatelessWidget {
  final String text;

  ContentA(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text),
    );
  }
}







