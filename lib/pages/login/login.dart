import 'package:flutter/material.dart';
import 'package:flutterdemo/framework/application.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String account;
  String password;

  _validateAndSubmit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(account);
      print(password);
    } else {
      _formKey.currentState.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'account should not be empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  account = value;
                },
                decoration: InputDecoration(
                  labelText: 'account',
                ),
              ),
              TextFormField(
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'account should not be empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                  labelText: 'password',
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: _validateAndSubmit,
                      child: Text('submit'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
