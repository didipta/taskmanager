import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/controller_binder.dart';

import 'Router/RouterGenerator.dart';
import 'Router/RouterPath.dart';
import 'Style/ThemeData.dart';

class Taskmanager extends StatefulWidget {
  const Taskmanager({Key? key}) : super(key: key);
  static GlobalKey<NavigatorState> navigatorKey=GlobalKey<NavigatorState>();
  @override
  State<Taskmanager> createState() => _TaskManagerAppState();
}


  class _TaskManagerAppState extends State<Taskmanager> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
       navigatorKey: Taskmanager.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: appThemeData(Theme.of(context).textTheme),
      initialRoute: Routerpath.splash,
      onGenerateRoute:materialPageRoute,
      initialBinding: ControllerBinder(),
    );;
  }
}
