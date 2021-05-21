import 'dart:convert';
import 'package:behealthy/constants.dart';
import 'package:behealthy/meal_selection.dart';
import 'package:behealthy/mealsAvailable.dart';
import 'package:behealthy/providers/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final dbHelper = DatabaseHelper.instance;
  List planTitlesList = [];
  _queryMain() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach(print);
    getPlanNames(allRows);
    return allRows;
  }

  getData() async {
    http.Response response = await http
        .post(Uri.parse('https://foodapi.pos53.com/api/Food/GetPackage'));
    if (jsonDecode(response.body)['status'] == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  getPlanNames(rQueryList) async {
    final String response =
        await rootBundle.loadString('assets/json/getpackagewithplanmeal.json');
    var rData = jsonDecode(response.toString());
    rQueryList.forEach((element) {
      planTitlesList
          .add(rData[element['planid'].toString()][0]['Plan_Display']);
    });
  }

  getInstances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      return prefs;
    } else {
      return null;
    }
  }

  List itemsList = [];
  List mealPlans = [];
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      itemsList = snapshot.data['data'];
                      itemsList.forEach((element) {
                        if (element['PlanID'] == 6 || element['PlanID'] == 5) {
                          mealPlans.add(element);
                        }
                      });
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Image(
                                  image:
                                      AssetImage('assets/images/location.png'),
                                  height: 25,
                                  width: 25,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Deliver To',
                                      style: BeHealthyTheme.kDeliverToStyle,
                                    ),
                                    Text(
                                      'ZYC Colony,Kuwait',
                                      style: BeHealthyTheme.kAddressStyle
                                          .copyWith(
                                              fontWeight: FontWeight.w100),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 50,
                            height: 50,
                            child: TextFormField(
                              cursorColor: BeHealthyTheme.kMainOrange,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(20),
                                  focusColor: BeHealthyTheme.kMainOrange,
                                  suffixIcon: Icon(
                                    Icons.search,
                                    size: 30,
                                  ),
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
                                        width: 1,
                                        color: BeHealthyTheme.kMainOrange),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: BeHealthyTheme.kMainOrange),
                                  ),
                                  labelText: "Search",
                                  labelStyle:
                                      BeHealthyTheme.kInputFieldTextStyle),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          // Container(
                          //   height: MediaQuery.of(context).size.height * 0.25,
                          //   width: MediaQuery.of(context).size.width * 0.9,
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(20),
                          //       color: BeHealthyTheme.kMainOrange
                          //           .withOpacity(0.11)),
                          //   child: Stack(
                          //     children: [
                          //       Image(
                          //           width:
                          //               MediaQuery.of(context).size.width * 0.9,
                          //           height: MediaQuery.of(context).size.height *
                          //               0.25,
                          //           fit: BoxFit.fitWidth,
                          //           image: AssetImage(
                          //               'assets/images/ramdan_package_bg.png')),
                          //       Positioned(
                          //         left: 10,
                          //         bottom: 0,
                          //         child: Image(
                          //           image: AssetImage(
                          //               'assets/images/Mask Group 1.png'),
                          //         ),
                          //       ),
                          //       Positioned(
                          //         top: 30,
                          //         right: 30,
                          //         child: Column(
                          //           crossAxisAlignment: CrossAxisAlignment.end,
                          //           children: [
                          //             Text(
                          //               'Ramdan\nPackage',
                          //               textAlign: TextAlign.left,
                          //               style: BeHealthyTheme.kMainTextStyle
                          //                   .copyWith(fontSize: 30),
                          //             ),
                          //             SizedBox(
                          //               height: 10,
                          //             ),
                          //             Text(
                          //               'Basic Meal',
                          //               style: BeHealthyTheme.kDhaaTextStyle,
                          //             ),
                          //             Text(
                          //               'Premium Meal',
                          //               style: BeHealthyTheme.kDhaaTextStyle,
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 30,
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: [
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: 'Your Existing ',
                                      style: BeHealthyTheme.kMainTextStyle
                                          .copyWith(
                                              color: Colors.black54,
                                              fontSize: 22)),
                                  TextSpan(
                                      text: 'Plans',
                                      style: BeHealthyTheme.kMainTextStyle
                                          .copyWith(
                                              color: BeHealthyTheme.kMainOrange,
                                              fontSize: 22))
                                ])),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FutureBuilder(
                            future: _queryMain(),
                            builder: (context, snap) {
                              if (snap.data != null) {
                                return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.28,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snap.data.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MealSelection()));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Stack(
                                                children: [
                                                  // Positioned(
                                                  //     bottom: 0,
                                                  //     right: 0,
                                                  //     child: Container(
                                                  //       decoration: BoxDecoration(
                                                  //           borderRadius: BorderRadius.only(
                                                  //               topLeft:
                                                  //                   Radius.circular(70),
                                                  //               bottomRight:
                                                  //                   Radius.circular(20)),
                                                  //           color: BeHealthyTheme
                                                  //               .kMainOrange
                                                  //               .withOpacity(0.27)),
                                                  //       child: Padding(
                                                  //         padding: const EdgeInsets.only(
                                                  //             top: 10, left: 10),
                                                  //         child: Icon(
                                                  //           Icons.add,
                                                  //           size: 30,
                                                  //           color:
                                                  //               BeHealthyTheme.kMainOrange,
                                                  //         ),
                                                  //       ),
                                                  //     )),
                                                  Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.28,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: BeHealthyTheme
                                                            .kMainOrange
                                                            .withOpacity(0.11)),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                          child: Image(
                                                            fit:
                                                                BoxFit.fitWidth,
                                                            image: AssetImage(
                                                                'assets/images/haha2.png'),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          10.0),
                                                                  child: Text(
                                                                    '${planTitlesList[index]}',
                                                                    style: BeHealthyTheme
                                                                        .kMainTextStyle
                                                                        .copyWith(
                                                                            fontSize:
                                                                                25),
                                                                  ),
                                                                ),
                                                                // Padding(
                                                                //   padding: const EdgeInsets
                                                                //           .only(
                                                                //       left:
                                                                //           12.0),
                                                                //   child: Text(
                                                                //     name.toString(),
                                                                //     style: BeHealthyTheme
                                                                //         .kDhaaTextStyle,
                                                                //   ),
                                                                // ),
                                                              ],
                                                            ),
                                                            // Padding(
                                                            //   padding:
                                                            //       const EdgeInsets.only(
                                                            //           bottom: 50,
                                                            //           right: 15),
                                                            //   child: Container(
                                                            //     decoration: BoxDecoration(
                                                            //         boxShadow: [
                                                            //           BoxShadow(
                                                            //               blurRadius: 5,
                                                            //               offset:
                                                            //                   Offset(0, 2),
                                                            //               color: Colors
                                                            //                   .black26)
                                                            //         ],
                                                            //         color: Colors.white,
                                                            //         borderRadius:
                                                            //             BorderRadius
                                                            //                 .circular(15)),
                                                            //     child: Padding(
                                                            //       padding: const EdgeInsets
                                                            //               .symmetric(
                                                            //           vertical: 5,
                                                            //           horizontal: 10),
                                                            //       child: Text(
                                                            //         '99 Kd',
                                                            //         style: BeHealthyTheme
                                                            //             .kDhaaTextStyle
                                                            //             .copyWith(
                                                            //                 color: BeHealthyTheme
                                                            //                     .kMainOrange),
                                                            //       ),
                                                            //     ),
                                                            //   ),
                                                            // )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }));
                              } else {
                                return Text('Error');
                              }
                            },
                          ),

                          // SizedBox(
                          //   height: 30,
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 8.0),
                          //   child: Row(
                          //     children: [
                          //       RichText(
                          //           text: TextSpan(children: [
                          //         TextSpan(
                          //             text: 'Meal by ',
                          //             style: BeHealthyTheme.kMainTextStyle
                          //                 .copyWith(
                          //                     color: Colors.black54,
                          //                     fontSize: 22)),
                          //         TextSpan(
                          //             text: 'Category',
                          //             style: BeHealthyTheme.kMainTextStyle
                          //                 .copyWith(
                          //                     color: BeHealthyTheme.kMainOrange,
                          //                     fontSize: 22))
                          //       ])),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          // Container(
                          //   height: MediaQuery.of(context).size.height / 2,
                          //   child: GridView.builder(
                          //       physics: BouncingScrollPhysics(),
                          //       primary: false,
                          //       itemCount: 4,
                          //       gridDelegate:
                          //           SliverGridDelegateWithFixedCrossAxisCount(
                          //               crossAxisCount: 2),
                          //       itemBuilder: (context, index) {
                          //         return Padding(
                          //           padding: const EdgeInsets.all(8.0),
                          //           child: Container(
                          //             decoration: BoxDecoration(
                          //                 borderRadius:
                          //                     BorderRadius.circular(20),
                          //                 color: BeHealthyTheme.kMainOrange
                          //                     .withOpacity(0.1)),
                          //             child: Column(
                          //               children: [
                          //                 Image(
                          //                   image: AssetImage(
                          //                       'assets/images/download.png'),
                          //                 ),
                          //                 Text(
                          //                   'الخطة الأساسية',
                          //                   style: BeHealthyTheme.kMainTextStyle
                          //                       .copyWith(
                          //                           fontSize: 22,
                          //                           color: BeHealthyTheme
                          //                               .kMainOrange),
                          //                 ),
                          //                 Text(
                          //                   'Lorem Ipsum, Lorem Ipsum,\nLorem Ipsum, ',
                          //                   textAlign: TextAlign.center,
                          //                   style: BeHealthyTheme.kDhaaTextStyle
                          //                       .copyWith(fontSize: 10),
                          //                 )
                          //               ],
                          //             ),
                          //           ),
                          //         );
                          //       }),
                          // ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: [
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: 'Basic Plans',
                                      style: BeHealthyTheme.kMainTextStyle
                                          .copyWith(
                                              color: Colors.black54,
                                              fontSize: 22)),
                                ])),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                primary: false,
                                scrollDirection: Axis.vertical,
                                itemCount: itemsList.length,
                                itemBuilder: (context, index) {
                                  return CustomContainer(
                                    planName: itemsList[index]['PlanName'],
                                    imageUrl: itemsList[index]['Plan_Image'],
                                    planPrice: itemsList[index]['Plan_price1'],
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MealsAvailableScreen(
                                                      itemsList[index]
                                                          ['PlanName'],
                                                      itemsList[index]
                                                          ['PlanID'])));
                                    },
                                  );
                                }),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: [
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: 'Top ',
                                      style: BeHealthyTheme.kMainTextStyle
                                          .copyWith(
                                              color: Colors.black54,
                                              fontSize: 22)),
                                  TextSpan(
                                      text: 'Picks',
                                      style: BeHealthyTheme.kMainTextStyle
                                          .copyWith(
                                              color: BeHealthyTheme.kMainOrange,
                                              fontSize: 22))
                                ])),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 2,
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                primary: false,
                                scrollDirection: Axis.vertical,
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  return CustomContainer();
                                }),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: [
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: 'Our ',
                                      style: BeHealthyTheme.kMainTextStyle
                                          .copyWith(
                                              color: Colors.black54,
                                              fontSize: 22)),
                                  TextSpan(
                                      text: 'Diet',
                                      style: BeHealthyTheme.kMainTextStyle
                                          .copyWith(
                                              color: BeHealthyTheme.kMainOrange,
                                              fontSize: 22)),
                                  TextSpan(
                                      text: 'Menu',
                                      style: BeHealthyTheme.kMainTextStyle
                                          .copyWith(
                                              color: Colors.black54,
                                              fontSize: 22)),
                                ])),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 2,
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                primary: false,
                                scrollDirection: Axis.vertical,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return CustomContainer();
                                }),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                          child: Text(
                        'Sorry we Encountered an Error',
                        style: BeHealthyTheme.kMainTextStyle,
                      ));
                    }
                  } else {
                    return Center(
                        child: Text(
                      'Sorry we Encountered an Error',
                      style: BeHealthyTheme.kMainTextStyle,
                    ));
                  }
                },
              )),
        ),
      ),
    );
  }
}

class CustomContainer extends StatefulWidget {
  final String imageUrl;
  final String planName;
  final int planPrice;
  final Function onTap;
  const CustomContainer({
    this.onTap,
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: 115,
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
                      fit: BoxFit.fitHeight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    )),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150,
                    child: Text(
                      (widget.planName != null)
                          ? widget.planName
                          : 'الخطة الأساسية',
                      style: BeHealthyTheme.kMainTextStyle.copyWith(
                          fontSize: 15, color: BeHealthyTheme.kMainOrange),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      'Breakfast 1, Lunch 1, Dinner 1, Salad 1, Soup 1',
                      textAlign: TextAlign.start,
                      style:
                          BeHealthyTheme.kDhaaTextStyle.copyWith(fontSize: 10),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              offset: Offset(0, 2),
                              color: Colors.black26)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Text(
                        (widget.planPrice != null)
                            ? '${widget.planPrice.toString()} Kd'
                            : '99 Kd',
                        style: BeHealthyTheme.kDhaaTextStyle
                            .copyWith(color: BeHealthyTheme.kMainOrange),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
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
                      child: IconButton(
                        onPressed: () {
                          print('tapped');
                          setState(() {
                            isSelected = !isSelected;
                          });
                        },
                        splashColor: Colors.transparent,
                        splashRadius: 10,
                        icon: isSelected ? Icon(Icons.check) : Icon(Icons.add),
                        color: BeHealthyTheme.kMainOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
