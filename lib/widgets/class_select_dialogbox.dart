import 'package:flutter/material.dart';

Future<void> classSelectDialogBox(
    BuildContext context
    ) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select your class!'),
        content: SingleChildScrollView(
          child: ListBody(
            children:  <Widget>[
              Divider(),
              InkWell(
                child: Container(
                    height: 30,
                    child: Text("Class A")),
                onTap: () {
                  Navigator.of(context).pop();
  
                  confirmSelect(context,"Class A");
                }, ),
              Divider(),
              InkWell(
                child: SizedBox(
                    height: 30,
                    child: Text("Class B")),
                onTap: () {
                  Navigator.of(context).pop();
  
                  confirmSelect(context,"Class B");
                }, ),
              Divider()
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> confirmSelect(
    BuildContext context, String className
    ) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm your class!'),
        content: Text(
        "Are you sure $className is your class?"
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ), TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}