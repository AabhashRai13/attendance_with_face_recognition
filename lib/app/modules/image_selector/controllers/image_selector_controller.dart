import 'dart:io';

import 'package:attendance_project/api/api.dart';
import 'package:attendance_project/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart' as dio;

class ImageSelectorController extends GetxController {
  File image;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController prescribedByController = TextEditingController();
  final TextEditingController prescriptionController = TextEditingController();
  final TextEditingController prescribedDateController =
      TextEditingController();
  bool imageUploaded = false;
  final imageList = [];
  var selectedDate = "YY/MM/DD hr:sec".obs;
  bool isPressed = false;
  Future<void> pickFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      isPressed = true;
      image = File(pickedFile.path);
      update();
    } else {
      print('No image selected.');
    }
  }

  Future<void> pickFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      isPressed = true;
      image = File(pickedFile.path);
      update();
    } else {
      print('No image selected.');
    }
  }

  final validatedUserList = <User>[];

  void checkAttendanceList() {}
  @override
  void onInit() {
    super.onInit();
  }

  //to get a target path to provide for compressed file location
  Future<String> targetPath() async {
    final directory = await getApplicationDocumentsDirectory();
    String targetPath = directory.path + "/" + basename(image.path);
    print("Target Path $targetPath");
    return targetPath;
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 60,
    );

    return result;
  }

  void deleteImage() {
    image = null;
    update();
  }

  void addImageToList() async {
    File compressedImage =
        await testCompressAndGetFile(image, await targetPath());
    imageList.add(compressedImage);
    isPressed = false;
    update();
  }

  void mapPrescriptionPressed() async {
    File compressedImage =
        await testCompressAndGetFile(image, await targetPath());

    var formData = dio.FormData.fromMap({
      "file": await dio.MultipartFile.fromFile(
        compressedImage.path,
      ),
    });

    sendPrescription(formData);
  }

  final Api api = Api();
  Future sendPrescription(myProductCreateMap) async {
    imageUploaded = await api.postImage(myProductCreateMap);

    if (imageUploaded) {
      Get.back();
      Get.snackbar("Image Uploaded successfully!", "Success",
          backgroundColor: Colors.blueGrey[100],
          colorText: Colors.white,
          duration: Duration(seconds: 2));
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
