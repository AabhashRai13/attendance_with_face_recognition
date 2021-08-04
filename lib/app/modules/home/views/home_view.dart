import 'package:attendance_project/app/modules/image_selector/views/image_selector_view.dart';
import 'package:attendance_project/widgets/drawer.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: drawer(),
        appBar: AppBar(
          title: Text('Take Attendance'),
          centerTitle: true,
        ),
        body: ImageSelectorView());
  }
}
