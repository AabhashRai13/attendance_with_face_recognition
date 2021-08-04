import 'package:attendance_project/app/modules/Attendence_record/view/attendence_view.dart';
import 'package:attendance_project/app/modules/home/views/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget drawer() {
  return SafeArea(
    child: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            leading: new Icon(Icons.file_present),
            title: const Text('Records'),
            onTap: () {
              Get.to(AttendanceRecordView());
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('LogOut'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('isLoggedIn');
              Get.off(LoginPage());
            },
          ),
        ],
      ),
    ),
  );
}
