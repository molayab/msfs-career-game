import 'package:flutter/material.dart';

import 'login.dart';

void main() async {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('FS Career'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: const LoginView(),
    ),
  ));
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
