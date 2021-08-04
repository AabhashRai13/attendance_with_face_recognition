import 'package:attendance_project/app/modules/home/views/home_view.dart';
import 'package:attendance_project/app/modules/home/views/login.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String isLoggedin = prefs.getString('isLoggedIn');
  runApp(
    GetMaterialApp(
      title: "Application",
      debugShowCheckedModeBanner: false,
      home: isLoggedin != null ? HomeView() : LoginPage(),
    ),
  );
}
