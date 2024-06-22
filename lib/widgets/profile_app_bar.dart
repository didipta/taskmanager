import 'package:flutter/material.dart';
import 'package:taskmanager/Router/RouterPath.dart';

import '../Style/Colors.dart';
import '../Ui/screen/update_profile_screen.dart';


AppBar profileAppBar(context, [bool fromUpdateProfile = false]) {
  return AppBar(
    backgroundColor: AppColors.themeColor,
    leading: GestureDetector(
      onTap: () {
        if (fromUpdateProfile) {
          return;
        }
        Navigator.pushNamed(context, Routerpath.updateprofile);
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(),
      ),
    ),
    title: GestureDetector(
      onTap: () {
        if (fromUpdateProfile) {
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UpdateProfileScreen(),
          ),
        );
      },
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dummy name',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          Text(
            'email@gmail.com',
            style: TextStyle(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
    actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.logout))],
  );
}
