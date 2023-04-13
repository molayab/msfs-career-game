import 'package:flutter/material.dart';

import 'main_app.dart';
import 'models/user.dart';

class UserCardView extends StatelessWidget {
  final User user;

  UserCardView(this.user);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset("assets/profiles/mexican.png",
                      width: 50, height: 50),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          child: Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Text(
                            user.location,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ]),
                  const Spacer(),
                  const SizedBox(
                      child: Text(
                    "E 1000",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ])),
        onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainApp(user)),
              )
            });
  }
}
