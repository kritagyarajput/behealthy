import 'package:behealthy/constants.dart';
import 'package:behealthy/mainScreen.dart';
import 'package:behealthy/mealPlan.dart';
import 'package:behealthy/profile.dart';
import 'package:behealthy/searchScreen.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _currentIndex = 0;
  List screen = [
    MainScreen(),
    SearchScreen(),
    MealPlan(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          SalomonBottomBarItem(
            selectedColor: BeHealthyTheme.kMainOrange.withOpacity(0.3),
            icon: Image(
              height: 25,
              width: 25,
              image: AssetImage('assets/images/Untitled-2.png'),
            ),
            title: Text(
              'Be Healthy',
              style: TextStyle(color: Colors.black),
            ),
          ),
          SalomonBottomBarItem(
            selectedColor: BeHealthyTheme.kMainOrange.withOpacity(0.2),
            icon: Icon(
              Icons.search,
              size: 25,
              color: BeHealthyTheme.kMainOrange,
            ),
            title: Text(
              'Search',
              style: TextStyle(color: Colors.black),
            ),
          ),
          SalomonBottomBarItem(
            selectedColor: BeHealthyTheme.kMainOrange.withOpacity(0.2),
            icon: Image(
              color: BeHealthyTheme.kMainOrange,
              height: 25,
              width: 25,
              image: AssetImage('assets/images/take-away.png'),
            ),
            title: Text(
              'Meal Plan',
              style: TextStyle(color: Colors.black),
            ),
          ),
          SalomonBottomBarItem(
            selectedColor: BeHealthyTheme.kMainOrange.withOpacity(0.2),
            icon: Image(
              color: BeHealthyTheme.kMainOrange,
              height: 25,
              width: 25,
              image: AssetImage('assets/images/person.png'),
            ),
            title: Text(
              'Profile',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: screen[_currentIndex],
    );
  }
}
