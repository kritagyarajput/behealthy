import 'package:flutter/material.dart';
import 'package:behealthy/constants.dart';
import 'package:behealthy/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'basicplan.dart';
import 'loginScreen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future shardPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      return prefs;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.6,
            child: Container(
              width: 530,
              height: 610,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/Path 29.png'))),
              child: Stack(
                children: [
                  Positioned(
                    top: 435,
                    left: 90,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الملف الشخصي',
                          style: BeHealthyTheme.kMainTextStyle
                              .copyWith(fontSize: 32, color: Colors.white),
                        ),
                        Text(
                          'Profile',
                          style: BeHealthyTheme.kMainTextStyle
                              .copyWith(color: Colors.white, fontSize: 19),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      top: 120,
                      left: 350,
                      child: Image(
                          width: 71,
                          height: 455,
                          image: AssetImage('assets/images/login_lamp.png')))
                ],
              ),
            ),
          ),
          Positioned(
            top: 255,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder(
                          future: shardPref(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              var email = snapshot.data.get('email');
                              var number = snapshot.data.get('number');
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    email.toString(),
                                    style: BeHealthyTheme.kMainTextStyle
                                        .copyWith(
                                            color: BeHealthyTheme.kMainOrange,
                                            fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(number.toString(),
                                      style: BeHealthyTheme.kProfileFont),
                                ],
                              );
                            } else {
                              return Text('');
                            }
                          }),
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/images/arabMan.png'), //NetworkImage
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 1),
                                  blurRadius: 6,
                                  spreadRadius: 1),
                            ] //BoxSha
                            ),
//                        child: Image.asset('assets/images/profilepic.png'),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/heart (2).png',
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              'Favorite',
                              style: BeHealthyTheme.kProfileFont,
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/settings (2).png',
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Settings',
                              style: BeHealthyTheme.kProfileFont,
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/card.png',
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              'Payments',
                              style: BeHealthyTheme.kProfileFont,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Divider(
                    color: Colors.black12,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            height: 95,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: BeHealthyTheme.kLightOrange,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Colors.black12,
                                  blurRadius: 5,
                                )
                              ],
                            ),
                            //color: Colors.green,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Image.asset(
                                  'assets/images/dish.png',
                                  height: 40,
                                  width: 40,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  'Package',
                                  style: BeHealthyTheme.kProfileFont.copyWith(
                                      fontSize: 14,
                                      color: BeHealthyTheme.kMainOrange),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            height: 95,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: BeHealthyTheme.kLightOrange,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Colors.black12,
                                  blurRadius: 5,
                                )
                              ],
                            ),
                            //color: Colors.green,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Image.asset(
                                  'assets/images/take-away (3).png',
                                  height: 40,
                                  width: 40,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  'My Orders',
                                  style: BeHealthyTheme.kProfileFont.copyWith(
                                      fontSize: 14,
                                      color: BeHealthyTheme.kMainOrange),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            height: 95,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: BeHealthyTheme.kLightOrange,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Colors.black12,
                                  blurRadius: 5,
                                )
                              ],
                            ),
                            //color: Colors.green,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BasicPlan()));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Image.asset(
                                    'assets/images/location (1).png',
                                    height: 40,
                                    width: 40,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'Address',
                                    style: BeHealthyTheme.kProfileFont.copyWith(
                                        fontSize: 14,
                                        color: BeHealthyTheme.kMainOrange),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            height: 95,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: BeHealthyTheme.kLightOrange,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Colors.black12,
                                  blurRadius: 5,
                                )
                              ],
                            ),
                            //color: Colors.green,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Image.asset(
                                  'assets/images/translation.png',
                                  height: 40,
                                  width: 40,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  'Language',
                                  style: BeHealthyTheme.kProfileFont.copyWith(
                                      fontSize: 14,
                                      color: BeHealthyTheme.kMainOrange),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            height: 95,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: BeHealthyTheme.kLightOrange,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Colors.black12,
                                  blurRadius: 5,
                                )
                              ],
                            ),
                            //color: Colors.green,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Image.asset(
                                  'assets/images/support (1).png',
                                  height: 40,
                                  width: 40,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  'Support',
                                  style: BeHealthyTheme.kProfileFont.copyWith(
                                      fontSize: 14,
                                      color: BeHealthyTheme.kMainOrange),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.clear();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                            child: Container(
                              height: 95,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                border: Border.all(
                                    color: BeHealthyTheme.kMainOrange),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Colors.black12,
                                    blurRadius: 5,
                                  )
                                ],
                              ),
                              //color: Colors.green,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Image.asset(
                                    'assets/images/exit.png',
                                    height: 27,
                                    width: 27,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'Logout',
                                    style: BeHealthyTheme.kProfileFont.copyWith(
                                        fontSize: 14,
                                        color: BeHealthyTheme.kMainOrange),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
