import 'dart:convert';

import 'package:attendance_project/model/imageResponseModel.dart';
import 'package:dio/dio.dart';

class Api {
  final Dio _dio = new Dio();
  final String _baseUrl = 'https://9ad54065f660.ngrok.io';

  Future<ImageResponse> postImage(prescription) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/Uploadfile/TakeAttendance',
        data: prescription,
        options: Options(),
      );
      print("status code ${response.statusCode}");
      print(" response ${response.data}");
      if (response.statusCode == 200) {
        return ImageResponse.fromJson(response.data);
        ;
      } else {
        print(response.data.toString());
        return null;
      }
    } catch (error) {
      print("create product address error $error");
    }
    return null;
  }
}
