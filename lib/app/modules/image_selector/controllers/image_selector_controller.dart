import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImageSelectorController extends GetxController {
  File image;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController prescribedByController = TextEditingController();
  final TextEditingController prescriptionController = TextEditingController();
  final TextEditingController prescribedDateController =
      TextEditingController();
  bool prescriptionAdded = false;

  var selectedDate = "YY/MM/DD hr:sec".obs;

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

  final count = 0.obs;

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

  // void mapPrescriptionPressed() async {
  //   // File compressedImage =
  //   //     await testCompressAndGetFile(image, await targetPath());

  //   var formData = dio.FormData.fromMap({
  //     // "image": await dio.MultipartFile.fromFile(
  //     //   compressedImage.path,
  //     // ),
  //     "prescription": prescriptionController,
  //     "prescribed_by": "Ram",
  //     "uploaded_date": DateTime.now(),
  //     "prescribed_date": "2021-04-15 5:17"
  //   });

  //   sendPrescription(formData);
  // }

  // Future sendPrescription(myProductCreateMap) async {
  //   setState(ViewState.Busy);
  //   prescriptionAdded =
  //       await apiAuthProvider.postPrescription(myProductCreateMap);
  //   setState(ViewState.Retrieved);
  //   if (prescriptionAdded) {
  //     Get.back();
  //     Get.snackbar("Product created successfully!", "Success",
  //         backgroundColor: Colors.blueGrey[100],
  //         colorText: Colors.white,
  //         duration: Duration(seconds: 2));
  //   }
  // }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void increment() => count.value++;
}
