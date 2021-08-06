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

  DateTime date;
  String imageResponseClass;
  List<Student> students;

  factory ImageResponse.fromJson(Map<String, dynamic> json) => ImageResponse(
        date: DateTime.parse(json["date"]),
        imageResponseClass: json["class"],
        students: List<Student>.from(
            json["students"].map((x) => Student.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "class": imageResponseClass,
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
