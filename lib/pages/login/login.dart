import 'package:flutter/material.dart';
import 'package:flutterdemo/framework/application.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: Text(
                      'Login page',
                      style: TextStyle(
                          fontSize: 40, decoration: null, color: Colors.blue),
                    )),
              ]),
        ),
      ),
    );
  }
}
