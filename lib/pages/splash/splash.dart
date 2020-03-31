import 'package:flutter/material.dart';
import 'package:flutterdemo/framework/application.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State<SplashPage> {
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
                  'splash page',
                  style: TextStyle(
                      fontSize: 40, decoration: null, color: Colors.blue),
                )),
                Container(
                  child: RaisedButton(
                    onPressed: () => Application.router.navigateTo(context, '/login',replace: true),
                    child: Text('开始'),
                    color: Colors.blue,
                    textColor: Colors.white,
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
