import 'package:flutter/material.dart';
import 'package:flutterdemo/framework/application.dart';
import 'package:flutterdemo/framework/request.dart';

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

  _validateAndSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map result = await request('/api/user/login',
          data: {'account': account, 'password': password});
      if (result != null) {
        Application.router.navigateTo(context, '/home',replace:true);
      }
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
