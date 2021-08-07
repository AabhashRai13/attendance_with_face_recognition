import 'dart:io';

import 'package:attendance_project/api/api.dart';
import 'package:attendance_project/app/modules/Attendence_record/view/attendence_view.dart';
import 'package:attendance_project/model/imageResponseModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart' as path;

class ImageSelectorController extends GetxController {
  File image;

  bool imageUploaded = false;
  final imageList = [];

  bool busy = false;
  Future<void> pickFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
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
      image = File(pickedFile.path);
      update();
    } else {
      print('No image selected.');
    }
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

    update();
  }

  void mapPrescriptionPressed() async {
    busy = true;
    update();
    File compressedImage =
        await testCompressAndGetFile(image, await targetPath());
    //  String dir = path.dirname(_imageFile.path);

    // String newPath = "1.jpg";
    // print('NewPath: $newPath');
    // compressedImage.renameSync(newPath);
    //   print("image namee $newImage");

    // print('Original path: ${compressedImage.path}');
    // String dir = path.dirname(compressedImage.path);
    // String newPath = path.join(dir, '2.jpg');
    // print('NewPath: $newPath');
    //  compressedImage.renameSync(newPath);
    // Future.delayed(
    //     const Duration(seconds: 5), () => Get.to(() => AttendanceRecordView()));

    var formData = dio.FormData.fromMap({
      "image": await dio.MultipartFile.fromFile(
        compressedImage.path,
      ),
    });

    sendPrescription(formData);
    busy = false;
    update();
  }

  final Api api = Api();
  ImageResponse imageResponse;
  List<Student> student;
  Future sendPrescription(myProductCreateMap) async {
    imageResponse = await api.postImage(myProductCreateMap);
    // student.assignAll(imageResponse.students);
    if (imageResponse != null) {
      Get.back();
      Get.snackbar("Image Uploaded successfully!", "Success",
          backgroundColor: Colors.blueGrey[100],
          colorText: Colors.white,
          duration: Duration(seconds: 2));

      Get.to(() => AttendanceRecordView(
            users: imageResponse.students,
          ));
    }
  }

  @override
  void onReady() {
    super.onReady();
  }
}
