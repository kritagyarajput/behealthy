import 'dart:async';
import 'package:behealthy/constants.dart';
import 'package:behealthy/databaseTesting.dart';
import 'package:behealthy/homePage.dart';
import 'package:behealthy/loginScreen.dart';
import 'package:behealthy/mealsAvailable.dart';
import 'package:behealthy/package_details.dart';
import 'package:behealthy/plansAvailable.dart';
import 'package:behealthy/profile.dart';
import 'package:behealthy/signup.dart';
import 'package:behealthy/subMenuScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_checkout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<int, Color> color = {
    50: Color.fromRGBO(255, 150, 41, .1),
    100: Color.fromRGBO(255, 150, 41, .2),
    200: Color.fromRGBO(255, 150, 41, .3),
    300: Color.fromRGBO(255, 150, 41, .4),
    400: Color.fromRGBO(255, 150, 41, .5),
    500: Color.fromRGBO(255, 150, 41, .6),
    600: Color.fromRGBO(255, 150, 41, .7),
    700: Color.fromRGBO(255, 150, 41, .8),
    800: Color.fromRGBO(255, 150, 41, .9),
    900: Color.fromRGBO(255, 150, 41, 1),
  };
  MaterialColor colorCustom;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    colorCustom = MaterialColor(0xffFF9629, color);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Be Healthy',
      theme: ThemeData(
        primarySwatch: colorCustom,
      ),
      //add the login validation checker
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPage();
  }

  getPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('custID') != null) {
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      });
    } else {
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => PlansAvailableScreen()));
      });
    }
  }

  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Material(
      color: BeHealthyTheme.kMainOrange,
      child: SafeArea(
        child: Stack(alignment: AlignmentDirectional.center, children: [
          Positioned(
              top: MediaQuery.of(context).size.height * 0.7,
              child: Image(
                image: AssetImage('assets/images/splash_background.png'),
                width: MediaQuery.of(context).size.width,
              )),
          Positioned(
              bottom: 10,
              child: Text(
                'Copyright by BeHealthy Kuwait 2021',
                style: BeHealthyTheme.kDhaaTextStyle,
              )),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    height: 219,
                    width: 219,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(150)),
                  ),
                  Container(
                    height: 182,
                    width: 182,
                    decoration: BoxDecoration(
                        color: BeHealthyTheme.kInsideCard,
                        borderRadius: BorderRadius.circular(150)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/images/bh_logo.png'),
                          height: 83,
                          width: 82,
                        ),
                        Text(
                          'كن بصحة جيدة',
                          style: BeHealthyTheme.kMainTextStyle
                              .copyWith(fontSize: 22),
                        ),
                        Text(
                          'Be Healthy',
                          style: BeHealthyTheme.kMainTextStyle
                              .copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Build 2.0.1\nDate: ${date.day}.${date.month}.${date.year}\nBy DE Kuwait',
                  textAlign: TextAlign.center,
                  style: BeHealthyTheme.kMainTextStyle
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
