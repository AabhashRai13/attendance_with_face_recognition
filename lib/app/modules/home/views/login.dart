import 'dart:convert';

import 'package:attendance_project/app/modules/home/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showLoading = false;
  GlobalKey<FormState> _key = GlobalKey();
  String message;
  TextEditingController name2 = TextEditingController();
  TextEditingController password2 = TextEditingController();
  bool validate = false;
  String name1, password1;
  var _response;

  alertbox(String message) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          // ignore: deprecated_member_use
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Okay"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showLoading,
        color: Colors.grey,
        offset: Offset(width * 0.45, height - 100.0),
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor.withOpacity(0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Form(
            key: _key,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 50.0,
                    ),
                    TextFormField(
                      autofocus: true,
                      controller: name2,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: Colors.red)),
                          hintText: "Name"),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Name is Required';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        name1 = value;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      autofocus: true,
                      controller: password2,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          hintText: "Password"),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Password is Required';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        password1 = value;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),

                    // ignore: deprecated_member_use
                    RaisedButton(
                        color: Colors.green,
                        child: showLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Text(
                                'LOGIN',
                                style: TextStyle(color: Colors.white),
                              ),
                        onPressed: () async {
                          setState(() {
                            showLoading = true;
                          });

                          if (_key.currentState.validate()) {
                            _key.currentState.save();

                            Map<String, String> data = {
                              "name": name2.text,
                              "password": password2.text,
                            };

                            try {
                              _response = await http.post(
                                  "https://protected-chamber-11354.herokuapp.com/users/authenticate",
                                  body: data);
                            } catch (e) {
                              setState(() {
                                showLoading = false;
                              });
                              alertbox("Please Check Internet Connection");
                            }
                            print(_response.statusCode);
                            Map response = jsonDecode(_response.body);
                            String authToken = response["data"]["token"];
                            print(authToken);

                            if (_response.statusCode == 200) {
                              setState(() {
                                validate = false;
                              });
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('isLoggedIn', "loggedIn");
                              prefs.setString('authToken', authToken);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => HomeView()));
                            } else {
                              alertbox("Please enter valid Email and Password");
                              setState(() {
                                showLoading = false;
                              });
                            }
                          } else {
                            setState(() {
                              showLoading = false;
                            });
                          }
                          setState(() {
                            showLoading = false;
                          });
                        })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
