import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Router/RouterGenerator.dart';
import 'Router/RouterPath.dart';
import 'Style/ThemeData.dart';

class Taskmanager extends StatefulWidget {
  const Taskmanager({Key? key}) : super(key: key);
  static GlobalKey<NavigatorState> navigatorKey=GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appThemeData(Theme.of(context).textTheme),
      initialRoute: Routerpath.splash,
      onGenerateRoute:materialPageRoute,
    );;
  }
}
