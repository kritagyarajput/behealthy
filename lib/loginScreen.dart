import 'dart:convert';
import 'package:behealthy/basicplan.dart';
import 'package:behealthy/constants.dart';
import 'package:behealthy/homePage.dart';
import 'package:behealthy/signup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    username.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size medq = MediaQuery.of(context).size;
    return Material(
      child: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Positioned(
                top: -medq.height * 0.53,
                child: Image(
                  image: AssetImage('assets/images/Path 29.png'),
                )),
            Positioned(
              top: medq.height / 20,
              left: medq.width / 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تسجيل الدخول',
                    style: BeHealthyTheme.kMainTextStyle
                        .copyWith(fontSize: 33, color: Colors.white),
                  ),
                  Text(
                    'Login',
                    style: BeHealthyTheme.kMainTextStyle
                        .copyWith(color: Colors.white, fontSize: 25),
                  )
                ],
              ),
            ),
            Positioned(
                top: -medq.height * 0.35,
                left: medq.width * 0.65,
                child: Image(
                    width: 71,
                    height: 455,
                    image: AssetImage('assets/images/login_lamp.png'))),
            Positioned(
                top: medq.height / 30,
                left: medq.width * 0.85,
                child: Image(
                    width: 40,
                    height: 40,
                    color: Colors.white,
                    image: AssetImage('assets/images/bh_logo.png'))),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      height: 50,
                      child: TextFormField(
                        controller: username,
                        cursorColor: BeHealthyTheme.kMainOrange,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(
                                  width: 1,
                                )),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(
                                  width: 1, color: BeHealthyTheme.kMainOrange),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(
                                  width: 2, color: BeHealthyTheme.kMainOrange),
                            ),
                            labelText: "E-mail / Phone Number",
                            labelStyle: BeHealthyTheme.kInputFieldTextStyle),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      height: 50,
                      child: TextFormField(
                        controller: password,
                        obscureText: true,
                        cursorColor: BeHealthyTheme.kMainOrange,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(
                                  width: 1,
                                )),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(
                                  width: 1, color: BeHealthyTheme.kMainOrange),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(
                                  width: 2, color: BeHealthyTheme.kMainOrange),
                            ),
                            labelText: "Enter Password",
                            labelStyle: BeHealthyTheme.kInputFieldTextStyle),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text('Don\'t have an account?',
                            style: BeHealthyTheme.kDhaaTextStyle),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return SignUpScreen();
                            }));
                          },
                          child: Text(
                            'Signup',
                            style: BeHealthyTheme.kDhaaTextStyle
                                .copyWith(color: BeHealthyTheme.kMainOrange),
                          ),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        showDialog(
                          barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 3), () async {
                                try {
                                  http.Response response = await http.post(
                                    Uri.parse(
                                        "https://foodapi.pos53.com/api/Food/AuthenticateUser"),
                                    body: {
                                      'TenentID': '14',
                                      'EMAIL': username.text,
                                      'CPASSWRD': password.text,
                                      'MOBPHONE': username.text,
                                      'FCNToken':
                                          'fUg2zKpUf0T4tHnY-ZIFXU:APA91bGg34bXYOpCuztrnTaQhxRixKeHxGxc0Xbfr1pkyjRMkBamc0DV6ErTw7SnkGyy7lN5jAaHpouz_EC1hGZagBfRmo7y7nCnP5ulcOg9fE7Zm6XT5y2zdLJitx1zRv7y5Y2dn1xi',
                                      'action': 'AppLogin'
                                    },
                                  );
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  // print(response.body);
                                  var data = jsonDecode(response.body);
                                  if (jsonDecode(response.body)['status'] ==
                                      200) {
                                    preferences.setString(
                                        'email', data['data']['EMAIL']);
                                    preferences.setString(
                                        'compName', data['data']['COMPNAME1']);
                                    preferences.setString(
                                        'number', data['data']['MOBPHONE']);
                                    preferences.setString(
                                        'state', data['data']['STATE']);
                                    preferences.setString(
                                        'gender', data['data']['GENDER']);
                                    preferences.setInt(
                                        'custID', data['data']['COMPID']);
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BasicPlan()));
                                  } else {
                                    Navigator.pop(context);
                                    username.clear();
                                    password.clear();
                                    Toast.show(
                                        jsonDecode(response.body)['message'],
                                        context,
                                        duration: 2,
                                        backgroundColor: BeHealthyTheme
                                            .kMainOrange
                                            .withOpacity(0.27),
                                        textColor: Colors.black);
                                  }
                                } catch (e) {
                                  Navigator.pop(context);
                                  Toast.show(e.toString(), context,
                                      duration: 2,
                                      backgroundColor: BeHealthyTheme
                                          .kMainOrange
                                          .withOpacity(0.27),
                                      textColor: Colors.black);
                                }
                              });
                              return Center(
                                  child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    BeHealthyTheme.kMainOrange),
                              ));
                            });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 100,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: BeHealthyTheme.kMainOrange,
                            borderRadius: BorderRadius.circular(25)),
                        child: Text(
                          'LOGIN',
                          style: BeHealthyTheme.kMainTextStyle
                              .copyWith(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
