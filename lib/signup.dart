import 'dart:convert';
import 'package:behealthy/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController compName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  // TextEditingController countryId = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController gender = TextEditingController();
  String add = 'ADD';

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    compName.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    // countryId.dispose();
    state.dispose();
    gender.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BeHealthyTheme.kMainOrange,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 50,
                  child: TextFormField(
                    controller: compName,
                    cursorColor: BeHealthyTheme.kMainOrange,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide: BorderSide(
                              width: 1,
                            )),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                              width: 1, color: BeHealthyTheme.kMainOrange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                              width: 2, color: BeHealthyTheme.kMainOrange),
                        ),
                        labelText: "Company Name",
                        labelStyle: BeHealthyTheme.kInputFieldTextStyle),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 50,
                  child: TextFormField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: BeHealthyTheme.kMainOrange,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide: BorderSide(
                              width: 1,
                            )),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                              width: 1, color: BeHealthyTheme.kMainOrange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                              width: 2, color: BeHealthyTheme.kMainOrange),
                        ),
                        labelText: "E-mail Address",
                        labelStyle: BeHealthyTheme.kInputFieldTextStyle),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 50,
                  child: TextFormField(
                    controller: phone,
                    cursorColor: BeHealthyTheme.kMainOrange,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide: BorderSide(
                              width: 1,
                            )),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                              width: 1, color: BeHealthyTheme.kMainOrange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                              width: 2, color: BeHealthyTheme.kMainOrange),
                        ),
                        labelText: "Phone Number",
                        labelStyle: BeHealthyTheme.kInputFieldTextStyle),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 50,
                  child: TextFormField(
                    cursorColor: BeHealthyTheme.kMainOrange,
                    textAlign: TextAlign.center,
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide: BorderSide(
                              width: 1,
                            )),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                              width: 1, color: BeHealthyTheme.kMainOrange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                              width: 2, color: BeHealthyTheme.kMainOrange),
                        ),
                        labelText: "Password",
                        labelStyle: BeHealthyTheme.kInputFieldTextStyle),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 50,
                  child: TextFormField(
                    controller: state,
                    cursorColor: BeHealthyTheme.kMainOrange,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide: BorderSide(
                              width: 1,
                            )),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                              width: 1, color: BeHealthyTheme.kMainOrange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                              width: 2, color: BeHealthyTheme.kMainOrange),
                        ),
                        labelText: "State",
                        labelStyle: BeHealthyTheme.kInputFieldTextStyle),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 50,
                  child: TextFormField(
                    controller: gender,
                    cursorColor: BeHealthyTheme.kMainOrange,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide: BorderSide(
                              width: 1,
                            )),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                              width: 1, color: BeHealthyTheme.kMainOrange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                              width: 2, color: BeHealthyTheme.kMainOrange),
                        ),
                        labelText: "Gender",
                        labelStyle: BeHealthyTheme.kInputFieldTextStyle),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width - 100,
              //   height: 50,
              //   child: TextFormField(
              //     cursorColor: BeHealthyTheme.kMainOrange,
              //     textAlign: TextAlign.center,
              //     decoration: InputDecoration(
              //         isDense: true,
              //         border: OutlineInputBorder(
              //             borderRadius: BorderRadius.all(Radius.circular(25)),
              //             borderSide: BorderSide(
              //               width: 1,
              //             )),
              //         enabledBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.all(Radius.circular(25)),
              //           borderSide:
              //               BorderSide(width: 1, color: BeHealthyTheme.kMainOrange),
              //         ),
              //         focusedBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.all(Radius.circular(25)),
              //           borderSide:
              //               BorderSide(width: 2, color: BeHealthyTheme.kMainOrange),
              //         ),
              //         labelText: "Enter E-mail Address",
              //         labelStyle: BeHealthyTheme.kInputFieldTextStyle),
              //   ),
              // ),

              Flexible(
                child: MaterialButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(Duration(seconds: 3), () async {
                            try {
                              http.Response response = await http.post(
                                Uri.parse(
                                    "https://foodapi.pos53.com/api/Food/CompanySetupSave"),
                                body: {
                                  'TenentID': '14',
                                  'COMPNAME1': compName.text,
                                  'EMAIL': email.text,
                                  'MOBPHONE': phone.text,
                                  'CPASSWRD': password.text,
                                  'COUNTRYID': '1',
                                  'STATE': state.text,
                                  'Gender': gender.text,
                                  'Action': 'ADD'
                                },
                              );
                              print(jsonDecode(response.body));
                              if (jsonDecode(response.body)['status'] == 200) {
           
                                Toast.show(
                                  '${jsonDecode(response.body)['message']}',
                                  context,
                                  textColor: Colors.black,
                                  duration: 1,
                                  backgroundColor: BeHealthyTheme.kMainOrange
                                      .withOpacity(0.27),
                                );

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              } else {
                                Navigator.pop(context);
                                compName.clear();
                                email.clear();
                                password.clear();
                                phone.clear();
                                state.clear();
                                gender.clear();
                                Toast.show(jsonDecode(response.body)['message'],
                                    context,
                                    duration: 2,
                                    backgroundColor: BeHealthyTheme.kMainOrange
                                        .withOpacity(0.27),
                                    textColor: Colors.black);
                              }
                            } catch (e) {
                              Navigator.pop(context);
                              Toast.show(e.toString(), context,
                                  duration: 2,
                                  backgroundColor: BeHealthyTheme.kMainOrange
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
                      'SIGNUP',
                      style: BeHealthyTheme.kMainTextStyle
                          .copyWith(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
