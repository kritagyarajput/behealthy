import 'dart:convert';

import 'package:behealthy/constants.dart';
import 'package:behealthy/providers/dashboard_items_dbprovider.dart';
import 'package:behealthy/providers/getDataFromApi.dart';
import 'package:behealthy/subMenuScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'loginScreen.dart';

class MealsAvailableScreen extends StatefulWidget {
  final String title;
  final int id;
  MealsAvailableScreen(this.title, this.id);
  @override
  _MealsAvailableScreenState createState() => _MealsAvailableScreenState();
}

class _MealsAvailableScreenState extends State<MealsAvailableScreen> {
  getPackageWithPlanID() async {
    // print(widget.id);
    http.Response response = await http.post(
        Uri.parse('https://foodapi.pos53.com/api/Food/Getpackagewithplanid'),
        body: {'TenentID': '14', 'PlanId': '${widget.id}'});
    if (response.statusCode == 200) {
      // print(response.body);
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  var isLoading = false;

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = DataApiProvider();
    await apiProvider.getAllPackages();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _buildEmployeeListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllPackages(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          // print(showData);
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black12,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Text(
                  "${index + 1}",
                  style: TextStyle(fontSize: 20.0),
                ),
                title: Text(
                    "ID: ${snapshot.data[index].planID} ${snapshot.data[index].planName} "),
                subtitle: Text('Price: ${snapshot.data[index].planPrice}'),
              );
            },
          );
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getData();
  }

  getData() async {
    await _loadFromApi();
  }

  getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

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
                top: -medq.height * 0.57,
                child: Image(
                  image: AssetImage('assets/images/Path 29.png'),
                )),
            Positioned(
              left: medq.width / 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    alignment: Alignment.topRight,
                    child: Text(
                      'الوجبة المتاحة',
                      textAlign: TextAlign.right,
                      style: BeHealthyTheme.kMainTextStyle
                          .copyWith(fontSize: 28, color: Colors.white),
                    ),
                  ),
                  Text(
                    widget.title,
                    style: BeHealthyTheme.kMainTextStyle
                        .copyWith(color: Colors.white, fontSize: 23),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Meals Available',
                    textAlign: TextAlign.center,
                    style: BeHealthyTheme.kMainTextStyle
                        .copyWith(color: Colors.white, fontSize: 20),
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
              top: MediaQuery.of(context).size.height * 0.23,
              child: Container(
                  margin: EdgeInsets.all(8),
                  height: MediaQuery.of(context).size.height * 0.68,
                  width: MediaQuery.of(context).size.width,
                  child: FutureBuilder(
                    future: DefaultAssetBundle.of(context)
                        .loadString("assets/json/getpackagewithplanmeal.json"),
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
                              itemCount: showData['${widget.id}'].length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: CustomCard(
                                    title: showData['${widget.id}'][index]
                                        ['Meal_Eng'],
                                    allowedMeal: showData['${widget.id}'][index]
                                        ['Allowed_Meal'],
                                    onTap: () async {
                                      SharedPreferences preferences =
                                          await SharedPreferences.getInstance();
                                      preferences.setInt('id', widget.id);
                                      preferences.setString(
                                        'planTitle',
                                        showData['${widget.id}'][index]
                                            ['Plan_Display'],
                                      );
                                      preferences.setInt(
                                        'mealType',
                                        showData['${widget.id}'][index]
                                            ['MealType'],
                                      );
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SubMenuScreen(
                                                    showData['${widget.id}']
                                                        [index]['Plan_Display'],
                                                    showData['${widget.id}']
                                                        [index]['Meal_Eng'],
                                                    showData['${widget.id}']
                                                        [index]['planid'],
                                                    showData['${widget.id}']
                                                        [index]['MealType'],
                                                    showData['${widget.id}']
                                                        [index]['Meal_arabic'],
                                                  )));
                                    },
                                  ),
                                );
                              });
                        } else {
                          return Center(
                            child: Text('Error'),
                          );
                        }
                      }
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final Function onTap;
  final int allowedMeal;
  const CustomCard({
    this.allowedMeal,
    this.onTap,
    this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: BeHealthyTheme.kMainOrange.withOpacity(0.11),
            borderRadius: BorderRadiusDirectional.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 30,
                ),
                Image(image: AssetImage('assets/images/$title.png')),
                SizedBox(
                  width: 30,
                ),
                Text(
                  '$title ($allowedMeal)',
                  textAlign: TextAlign.left,
                  style: BeHealthyTheme.kMainTextStyle.copyWith(
                      color: BeHealthyTheme.kMainOrange,
                      fontSize: 18,
                      letterSpacing: 1.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// SafeArea(
//         child: Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.5,
//                 width: MediaQuery.of(context).size.width,
//                 child: isLoading
//                     ? Center(
//                         child: CircularProgressIndicator(),
//                       )
//                     : _buildEmployeeListView(),
//               ),
//               MaterialButton(
//                 color: Colors.blue,
//                 onPressed: () async {
//                   await _loadFromApi();
//                 },
//                 child: Text('Get data'),
//               ),
//             ],
//           ),
//         ),
//       ),


