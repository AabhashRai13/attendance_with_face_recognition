import 'package:attendance_project/data/users.dart';
import 'package:attendance_project/model/imageResponseModel.dart';
import 'package:attendance_project/model/user.dart';
import 'package:attendance_project/widgets/scrollable_widget.dart';
import 'package:flutter/material.dart';

class AttendanceRecordView extends StatefulWidget {
  final List<Student> users;

  AttendanceRecordView({this.users});
  @override
  _AttendanceRecordView createState() => _AttendanceRecordView();
}

class _AttendanceRecordView extends State<AttendanceRecordView> {
  // List<User> users;
  int sortColumnIndex;
  bool isAscending = false;

  @override
  void initState() {
    super.initState();

    //   this.users = List.of(allUsers);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: new AppBar(
          title: Text("Student Attendance Record"),
        ),
        body: ScrollableWidget(child: buildDataTable()),
      );

  Widget buildDataTable() {
    final columns = ['Student Name', 'Roll no.', 'Status'];

    return DataTable(
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(columns),
      rows: getRows(widget.users),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List<Student> users) => users.map((Student user) {
        final cells = [user.name, user.rollNo, user.status];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) {
    return cells
        .map((dynamic data) => DataCell(
              Text(
                '$data',
                style: TextStyle(color: checkAttendanceStatus(data.toString())),
              ),
            ))
        .toList();
  }

  Color checkAttendanceStatus(String attendanceStatus) {
    if (attendanceStatus == "Present") {
      return Colors.green;
    } else if (attendanceStatus == "Absent") {
      return Colors.red;
    } else
      return Colors.black;
  }

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      widget.users.sort(
          (user1, user2) => compareString(ascending, user1.name, user2.name));
    } else if (columnIndex == 1) {
      widget.users.sort((user1, user2) => compareString(
          ascending, user1.rollNo.toString(), user2.rollNo.toString()));
    } else if (columnIndex == 2) {
      widget.users.sort((user1, user2) =>
          compareString(ascending, '${user1.status}', '${user2.status}'));
    }

    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
