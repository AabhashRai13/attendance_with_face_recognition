import 'package:attendance_project/app/modules/home/controllers/zipcontroller_controller.dart';
import 'package:attendance_project/app/modules/image_selector/controllers/image_selector_controller.dart';
import 'package:attendance_project/widgets/image_selector_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ImageSelectorView extends GetView {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final ImageSelectorController imageSelectorController =
      Get.put(ImageSelectorController());
  final ZipControllerController zipControllerController =
      Get.put(ZipControllerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(children: [
        Container(
          height: Get.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GetBuilder<ImageSelectorController>(
                  builder: (controller) => Container(
                        margin: EdgeInsets.symmetric(vertical: 30),
                        decoration: controller.image == null
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: Colors.grey))
                            : BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                    image: FileImage(controller.image),
                                    fit: BoxFit.fill),
                              ),
                        height: Get.height * 0.4,
                        width: Get.width * 0.9,
                        child: imageSelectorController.image != null
                            ? Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                    icon: new Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      imageSelectorController.deleteImage();
                                    }),
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: Get.height * 0.1,
                                  ),
                                  Icon(
                                    Icons.cloud_upload,
                                    color: Colors.blue,
                                    size: 40,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      'Upload Image from your phone or open camera to scan for new Image.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                ],
                              ),
                      )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      imageUploadSelection(
                          Colors.blue,
                          Icons.camera_alt,
                          Colors.white,
                          'Open Camera',
                          Colors.white,
                          18,
                          () => imageSelectorController.pickFromCamera()),
                      imageUploadSelection(
                          Colors.white,
                          Icons.image,
                          Colors.grey,
                          'Open Gallery',
                          Colors.grey,
                          18,
                          () => imageSelectorController.pickFromGallery()),
                    ]),
              ),
              SizedBox(
                height: 50,
              ),
              GetBuilder<ImageSelectorController>(
                  builder: (controller) => imageSelectorController
                              .imageList.length >
                          0
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 0.0, 5.0, 2),
                          child: Center(
                            child: Container(
                              height: 20,
                              child: imageSelectorController.imageList.length ==
                                      5
                                  ? Text(
                                      "5 photos are stored now zip to continue the process.")
                                  : Text(
                                      "Take ${(5 - imageSelectorController.imageList.length)} more photos",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                            ),
                          ),
                        )
                      : SizedBox()),
              GetBuilder<ImageSelectorController>(
                  builder: (controller) => imageSelectorController.image != null
                      ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: MaterialButton(
                              height: Get.height * 0.06,
                              minWidth: Get.width * 0.5,
                              color: Colors.blue,
                              child: Text(
                                "Upload Image",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                imageSelectorController
                                    .mapPrescriptionPressed();
                              },
                            ),
                          ),
                        )
                      : SizedBox()),
              GetBuilder<ImageSelectorController>(
                  builder: (controller) =>
                      imageSelectorController.imageList.length == 5
                          ? Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: MaterialButton(
                                  height: Get.height * 0.06,
                                  minWidth: Get.width * 0.5,
                                  color: Colors.blue,
                                  child: Text(
                                    "Zip Images",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    zipControllerController.test(
                                        imageList:
                                            imageSelectorController.imageList);
                                  },
                                ),
                              ),
                            )
                          : SizedBox())
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: showInstructions,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 2,
                  )
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
              ),
              width: Get.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Instructions',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_up_outlined,
                    color: Colors.grey,
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }

  void showInstructions() {
    _scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
            )
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                    )
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                ),
                width: Get.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Instructions',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down_outlined,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    instructions(
                        'Step 1: Choose if you want to take image or select from gallery.'),
                    SizedBox(
                      height: 10,
                    ),
                    instructions('Step 2: Press on Check attendance button.'),
                    SizedBox(
                      height: 10,
                    ),
                    instructions(
                        'Step 3: You will receive a List of present employee.'),
                    SizedBox(
                      height: 10,
                    ),
                    instructions(
                        'Step 4: Press save button to save the records.'),
                  ],
                ),
              ),
            ),
          ],
        ),
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
      );
    });
  }
}

Widget instructions(String points) {
  return Text(
    points,
    style: TextStyle(fontSize: 18),
  );
}
