import 'package:flutter/material.dart';

Widget imageUploadSelection(
    Color containerColor,
    IconData icons,
    Color iconColor,
    String option,
    Color textColor,
    double textsize,
    function()) {
  return GestureDetector(
    onTap: () => function(),
    child: Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.6),
          blurRadius: 5,
          spreadRadius: 2,
        )
      ], color: containerColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Icon(
            icons,
            color: iconColor,
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            option,
            style: TextStyle(color: textColor, fontSize: textsize),
          )
        ],
      ),
    ),
  );
}
