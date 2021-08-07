// To parse this JSON data, do
//
//     final imageResponse = imageResponseFromJson(jsonString);

import 'dart:convert';

ImageResponse imageResponseFromJson(String str) =>
    ImageResponse.fromJson(json.decode(str));

String imageResponseToJson(ImageResponse data) => json.encode(data.toJson());

class ImageResponse {
  ImageResponse({
    this.date,
    this.imageResponseClass,
    this.students,
  });

  double date;
  int imageResponseClass;
  List<Student> students;

  factory ImageResponse.fromJson(Map<String, dynamic> json) => ImageResponse(
        date: json["date"].toDouble(),
        imageResponseClass: json["Class"],
        students: List<Student>.from(
            json["students"].map((x) => Student.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "Class": imageResponseClass,
        "students": List<dynamic>.from(students.map((x) => x.toJson())),
      };
}

class Student {
  Student({
    this.name,
    this.rollNo,
    this.status,
  });

  String name;
  int rollNo;
  String status;

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        name: json["name"],
        rollNo: json["roll_no"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "roll_no": rollNo,
        "status": status,
      };
}
