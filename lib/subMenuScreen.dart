import 'dart:convert';

import 'package:behealthy/basicplan.dart';
import 'package:behealthy/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'loginScreen.dart';

class SubMenuScreen extends StatefulWidget {
  final String planTitle;
  final String title;
  final int id;
  final int mealType;
  final String arabicName;
  SubMenuScreen(
      this.planTitle, this.title, this.id, this.mealType, this.arabicName);
  @override
  _SubMenuScreenState createState() => _SubMenuScreenState();
}

class _SubMenuScreenState extends State<SubMenuScreen> {
  planmealsetupGet() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('title', widget.title);
    preferences.setString('arabicName', widget.arabicName);
    var params = {
      'TenentID': '14',
      'PlanID': widget.id.toString(),
      'MealType': widget.mealType.toString(),
    };
    http.Response response = await http.post(
        Uri.parse('https://foodapi.pos53.com/api/Food/Planmealsetup_Get'),
        body: params);
    if (jsonDecode(response.body)['status'] == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    planmealsetupGet();
  }

  List selectedItemsList = [];

  @override
  Widget build(BuildContext context) {
    Size medq = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FutureBuilder(
        future: getPreferences(),
        builder: (context, instances) {
          if (instances.data.get('custID') != null) {
            return Container();
          } else {
            return GestureDetector(
              onTap: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setInt('PlanID', widget.id);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: CircleAvatar(
                radius: 28,
                backgroundColor: BeHealthyTheme.kMainOrange,
                child: Text(
                  'Login',
                  style: BeHealthyTheme.kMainTextStyle
                      .copyWith(color: Colors.white),
                ),
              ),
            );
          }
        },
      ),
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.24,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.68,
                  child: FutureBuilder(
                    future: DefaultAssetBundle.of(context)
                        .loadString("assets/json/planmealsetupkitchen.json"),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.data != null) {
                          var showData = jsonDecode(snapshot.data.toString());
                          return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: showData['${widget.id}']
                                      ['${widget.mealType}']
                                  .length,
                              itemBuilder: (context, index) {
                                return CustomContainer(
                                  planName: showData['${widget.id}']
                                      ['${widget.mealType}'][index]['ProdName'],
                                  imageUrl: showData['${widget.id}']
                                          ['${widget.mealType}'][index]
                                      ['MyPicture'],
                                );
                              });
                        } else {
                          return Center(
                            child: Text('Sorry we Encountered an Error'),
                          );
                        }
                      }
                    },
                  )),
            ),
            Positioned(
                top: -medq.height * 0.57,
                child: Image(
                  image: AssetImage('assets/images/Path 29.png'),
                )),
            Positioned(
              left: medq.width / 15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    alignment: Alignment.topRight,
                    child: Text(
                      widget.arabicName,
                      style: BeHealthyTheme.kMainTextStyle
                          .copyWith(fontSize: 33, color: Colors.white),
                    ),
                  ),
                  Text(
                    widget.title,
                    style: BeHealthyTheme.kMainTextStyle
                        .copyWith(color: Colors.white, fontSize: 25),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    widget.planTitle,
                    style: BeHealthyTheme.kMainTextStyle
                        .copyWith(color: Colors.white, fontSize: 18),
                  ),
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
          ],
        ),
      ),
    );
  }
}

class CustomContainer extends StatefulWidget {
  final String imageUrl;
  final String planName;
  final int planPrice;
  const CustomContainer({
    this.imageUrl,
    this.planName,
    this.planPrice,
    Key key,
  });

  @override
  _CustomContainerState createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  bool isSelected = false;
  getInstances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: BeHealthyTheme.kMainOrange.withOpacity(0.1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 115,
              width: 153,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: (widget.imageUrl != null)
                        ? NetworkImage(widget.imageUrl)
                        : AssetImage('assets/images/haha.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  child: Text(
                    (widget.planName != null)
                        ? widget.planName
                        : 'الخطة الأساسية',
                    style: BeHealthyTheme.kMainTextStyle.copyWith(
                        letterSpacing: 1.0,
                        fontSize: 15,
                        color: BeHealthyTheme.kMainOrange),
                  ),
                ),
                // Text(
                //   'Lorem Ipsum, Lorem Ipsum,\nLorem Ipsum, ',
                //   textAlign: TextAlign.start,
                //   style: BeHealthyTheme.kDhaaTextStyle
                //       .copyWith(fontSize: 10),
                // ),

                // Container(
                //   decoration: BoxDecoration(
                //       boxShadow: [
                //         BoxShadow(
                //             blurRadius: 5,
                //             offset: Offset(0, 2),
                //             color: Colors.black26)
                //       ],
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(15)),
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(
                //         vertical: 5, horizontal: 10),
                //     child: Text(
                //       (widget.planPrice != null)
                //           ? '${widget.planPrice.toString()} Kd'
                //           : '99 Kd',
                //       style: BeHealthyTheme.kDhaaTextStyle
                //           .copyWith(color: BeHealthyTheme.kMainOrange),
                //     ),
                //   ),
                // ),
              ],
            ),
            Container(
              height: 115,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(70),
                              bottomRight: Radius.circular(20)),
                          color: BeHealthyTheme.kMainOrange.withOpacity(0.27)),
                      child: FutureBuilder(
                        future: getInstances(),
                        builder: (context, instance) {
                          if (instance.hasData) {
                            if (instance.data.get('custID') != null) {
                              return IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BasicPlan()));
                                },
                                icon: Icon(Icons.arrow_forward_ios),
                                color: BeHealthyTheme.kMainOrange,
                              );
                            } else {
                              return IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                icon: isSelected
                                    ? Icon(Icons.check)
                                    : Icon(Icons.add),
                                color: BeHealthyTheme.kMainOrange,
                              );
                            }
                          } else {
                            return IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BasicPlan()));
                              },
                              icon: Icon(Icons.arrow_forward_ios),
                              color: BeHealthyTheme.kMainOrange,
                            );
                          }
                        },
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
