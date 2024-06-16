import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Router/RouterGenerator.dart';
import 'Router/RouterPath.dart';
import 'Style/ThemeData.dart';

class Taskmanager extends StatelessWidget {
  const Taskmanager({Key? key}) : super(key: key);

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
