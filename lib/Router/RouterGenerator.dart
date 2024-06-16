import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/Ui/screen/reset_password_screen.dart';
import 'package:taskmanager/Ui/screen/sign_up_screen.dart';
import 'package:taskmanager/Ui/screen/splash_screen.dart';

import '../Ui/screen/sign_in_screen.dart';
import 'RouterPath.dart';

MaterialPageRoute? materialPageRoute(RouteSettings settings){
  Widget? widget;
  switch(settings.name){
    case Routerpath.splash:
      widget=SplashScreen();
      break;
    case Routerpath.signIn:
      widget=SignInScreen();
      break;
    case Routerpath.signup:
      widget=SignUpScreen();
      break;
    case Routerpath.forgetpass:
      widget=ResetPasswordScreen();
      break;





  }
  if(widget !=null){
    return MaterialPageRoute(builder: (context)=>widget!);
  }

  return null;
}