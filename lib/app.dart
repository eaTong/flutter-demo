import 'package:bot_toast/bot_toast.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/stores/app_store.dart';
import 'package:provider/provider.dart';

import 'framework/application.dart';
import 'framework/routes.dart';


class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<MyApp> {
  AppState() {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }
  AppStore _app = AppStore();

  @override
  Widget build(BuildContext context) {
    final app = BotToastInit(
        child: MaterialApp(
      title: 'Flutter Demo',
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: Application.router.generator,
    ));
    return MultiProvider(
      providers: [
        Provider<AppStore>.value(value: _app)
      ],
      child: app,
    );
  }
}
