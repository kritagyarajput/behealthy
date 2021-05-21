import 'package:behealthy/utils.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'constants.dart';

class MealPlan extends StatefulWidget {
  @override
  _MealPlanState createState() => _MealPlanState();
}

class _MealPlanState extends State<MealPlan> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  bool _lunchSelected = true;
  bool _dinnerSelected = false;
  bool _soupSelected = false;
  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image(
                      image: AssetImage('assets/images/location.png'),
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
                              .copyWith(fontWeight: FontWeight.w100),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
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
                        labelText: "Search",
                        labelStyle: BeHealthyTheme.kInputFieldTextStyle),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: BeHealthyTheme.kMainOrange.withOpacity(0.11)),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TableCalendar(
                    calendarStyle: CalendarStyle(
                      defaultDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      selectedDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: BeHealthyTheme.kMainOrange),
                      todayDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: BeHealthyTheme.kMainOrange.withOpacity(0.55)),
                    ),
                    firstDay: kFirstDay,
                    lastDay: kLastDay,
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      // Use `selectedDayPredicate` to determine which day is currently selected.
                      // If this returns true, then `day` will be marked as selected.

                      // Using `isSameDay` is recommended to disregard
                      // the time-part of compared DateTime objects.
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        // Call `setState()` when updating the selected day
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      }
                    },
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        // Call `setState()` when updating calendar format
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      // No need to call `setState()` here
                      _focusedDay = focusedDay;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _lunchSelected = true;
                        _dinnerSelected = false;
                        _soupSelected = false;
                      });
                    },
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: _lunchSelected
                                ? BeHealthyTheme.kMainOrange.withOpacity(0.11)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(
                                'Lunch',
                                style: BeHealthyTheme.kMainTextStyle.copyWith(
                                    fontSize: 18, color: Color(0xff707070)),
                              ),
                              _lunchSelected
                                  ? Container(
                                      height: 3,
                                      width: 20,
                                      color: BeHealthyTheme.kMainOrange,
                                    )
                                  : Text(''),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _lunchSelected = false;
                        _dinnerSelected = true;
                        _soupSelected = false;
                      });
                    },
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: _dinnerSelected
                                ? BeHealthyTheme.kMainOrange.withOpacity(0.11)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(
                                'Dinner',
                                style: BeHealthyTheme.kMainTextStyle.copyWith(
                                    fontSize: 18, color: Color(0xff707070)),
                              ),
                              _dinnerSelected
                                  ? Container(
                                      height: 3,
                                      width: 20,
                                      color: BeHealthyTheme.kMainOrange,
                                    )
                                  : Text(''),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _lunchSelected = false;
                        _dinnerSelected = false;
                        _soupSelected = true;
                      });
                    },
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: _soupSelected
                                ? BeHealthyTheme.kMainOrange.withOpacity(0.11)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(
                                'Soup',
                                style: BeHealthyTheme.kMainTextStyle.copyWith(
                                    fontSize: 18, color: Color(0xff707070)),
                              ),
                              _soupSelected
                                  ? Container(
                                      height: 3,
                                      width: 20,
                                      color: BeHealthyTheme.kMainOrange,
                                    )
                                  : Text(''),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              _lunchSelected ? lunchMenu(context) : Container(),
              _dinnerSelected ? dinnerMenu(context) : Container(),
              _soupSelected ? soupMenu(context) : Container(),
            ],
          ),
        ),
      ),
    ));
  }

  Padding lunchMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Salad',
            style: BeHealthyTheme.kMainTextStyle
                .copyWith(color: Color(0xff707070), fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return CustomGridItem();
                }),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Hamburgers',
            style: BeHealthyTheme.kMainTextStyle
                .copyWith(color: Color(0xff707070), fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return CustomGridItem();
                }),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Kebab',
            style: BeHealthyTheme.kMainTextStyle
                .copyWith(color: Color(0xff707070), fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return CustomGridItem();
                }),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Meal of the day',
            style: BeHealthyTheme.kMainTextStyle
                .copyWith(color: Color(0xff707070), fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return CustomGridItem();
                }),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Padding dinnerMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chicken',
            style: BeHealthyTheme.kMainTextStyle
                .copyWith(color: Color(0xff707070), fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return CustomGridItem();
                }),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Kebab',
            style: BeHealthyTheme.kMainTextStyle
                .copyWith(color: Color(0xff707070), fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return CustomGridItem();
                }),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Kebab',
            style: BeHealthyTheme.kMainTextStyle
                .copyWith(color: Color(0xff707070), fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return CustomGridItem();
                }),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Meal of the day',
            style: BeHealthyTheme.kMainTextStyle
                .copyWith(color: Color(0xff707070), fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return CustomGridItem();
                }),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Padding soupMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Soup',
            style: BeHealthyTheme.kMainTextStyle
                .copyWith(color: Color(0xff707070), fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return CustomGridItem();
                }),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Chicken',
            style: BeHealthyTheme.kMainTextStyle
                .copyWith(color: Color(0xff707070), fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return CustomGridItem();
                }),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Kebab',
            style: BeHealthyTheme.kMainTextStyle
                .copyWith(color: Color(0xff707070), fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return CustomGridItem();
                }),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Meal of the day',
            style: BeHealthyTheme.kMainTextStyle
                .copyWith(color: Color(0xff707070), fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return CustomGridItem();
                }),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}

class CustomGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(70),
                        bottomRight: Radius.circular(20)),
                    color: BeHealthyTheme.kMainOrange.withOpacity(0.27)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Icon(
                    Icons.add,
                    size: 30,
                    color: BeHealthyTheme.kMainOrange,
                  ),
                ),
              )),
          Container(
            decoration: BoxDecoration(
                color: BeHealthyTheme.kMainOrange.withOpacity(0.11),
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                    image: AssetImage('assets/images/haha2.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'الخطة الأساسية',
                    style: BeHealthyTheme.kMainTextStyle.copyWith(
                        fontSize: 22, color: BeHealthyTheme.kMainOrange),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Lorem Ipsum, Lorem Ipsum,\nLorem Ipsum, ',
                    textAlign: TextAlign.start,
                    style: BeHealthyTheme.kDhaaTextStyle.copyWith(fontSize: 10),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
