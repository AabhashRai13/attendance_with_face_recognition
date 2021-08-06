import 'package:dio/dio.dart';

class Api {
  final Dio _dio = new Dio();
  final String _baseUrl = 'https://676ce1ff9ed2.ngrok.io';

  postImage(prescription) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/Uploadfile/TakeAttendance',
        data: prescription,
        options: Options(),
      );
      print("status code ${response.statusCode}");
      print(" response ${response.data}");
      if (response.statusCode == 200) {
        return true;
      } else {
        print(response.data.toString());
        return false;
      }
    } catch (error) {
      print("create product address error $error");
    }
  }
}
