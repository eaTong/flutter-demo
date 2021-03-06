import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterdemo/pages/contact/contact_form.dart';
import 'package:flutterdemo/pages/detail/detail.dart';
import 'package:flutterdemo/pages/home/home.dart';
import 'package:flutterdemo/pages/login/login.dart';
import 'package:flutterdemo/pages/splash/splash.dart';

class Routes {
  static void configureRoutes(Router router) {
    router.define('/', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return SplashPage();
    }));
    router.define('/home', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return HomePage();
    }));
    router.define('/login', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return LoginPage();
    }));
    router.define('/contact/form/:operate/:id', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return ContactFormPage(
          operate: params['operate'][0],
          id: int.parse(params['id'][0] == 'null' ? '0' : params['id'][0]));
    }));
    router.define('/detail', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return DetailPage();
    }));
  }
}
