// import 'package:behealthy/cart_checkout.dart';
import 'dart:convert';
import 'package:behealthy/providers/planmealcustinvoiceDb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:behealthy/constants.dart';
import 'package:behealthy/homePage.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;

class MealSelection extends StatefulWidget {
  @override
  _MealSelectionState createState() => _MealSelectionState();
}

//api will be https://foodapi.pos53.com/api/Food/PlanmealsetupKitchen_Get

class _MealSelectionState extends State<MealSelection> {
  String _selectedDate;
  int totalWeek;
  String _chosenWeek = 'Week 1';
  List weekDate = [];
  List weekDay = [];
  List expectedDelDayList = [];
  var expectedDelDay;
  List deliveryIdList = [];
  var deliveryId = 1;
  int selectedIndex;
  int selectedWeekNumber = 1;
  String selectedMealType = '1401';
  int mealIndex = 0;
  final planmealcustinvoicedbhelper = PlanmealCustInvoiceDB.instance;
  var transid;
  var planid;
  var mealType;
  List selectedMeals = [];
  List mealsList = [];
  List allowedMealsList = [];
  // bool mealsCompleted;
  getMenuFromMealtType(mealtype) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime date = DateTime.now().add(const Duration(days: 2));
    http.Response response = await http.post(
        Uri.parse(
            'https://foodapi.pos53.com/api/Food/PlanmealsetupKitchen_Get'),
        body: {
          'TenentID': '14',
          'PlanID': '${prefs.get('id')}',
          'MealType': mealtype,
          'Date': _selectedDate == null
              ? '${date.month} - ${date.day} - ${date.year}'
              : _selectedDate
        });
    if (jsonDecode(response.body)['status'] == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      return jsonDecode(response.body);
    }
  }

  _queryDeliveryId(rEdd) async {
    deliveryIdList.clear();
    final rows = await planmealcustinvoicedbhelper.queryDeliveryID(rEdd);
    // print('Delivery IDs:');
    // rows.forEach(print);
    rows.forEach((element) {
      deliveryIdList.add(element['deliveryId']);
    });
  }

  _queryMealTypes() async {
    List mealsTypeList = [];
    final rows = await planmealcustinvoicedbhelper.queryMealTypes();
    rows.forEach(print);
    rows.forEach((element) {
      mealsTypeList.add(element['mealType']);
    });
    return mealsTypeList;
  }

  void _query(int selectedWeek) async {
    weekDate.clear();
    weekDay.clear();
    expectedDelDayList.clear();
    final allRows = await planmealcustinvoicedbhelper.queryAllRows(
        selectedWeek, selectedMealType);
    // print('Query all rows:');
    // allRows.forEach(print);
    allRows.forEach((element) {
      setState(() {
        totalWeek = element['totalWeek'];
      });
    });
    allRows.forEach((element) {
      weekDate.add(element['expectedDelDate']);
      weekDay.add(element['nameOfDay']);
      expectedDelDayList.add(element['expectedDeliveryDay']);
    });
    generateWeekList(totalWeek);
    generateMealTitleList();
    // print(totalWeek);
  }

  _querySelected(int rTenentId, int rMyTransId, int rDeliveryId,
      int rExpectedDeliveryDay, int rPlanid, int rMealtype) async {
    final rows = await planmealcustinvoicedbhelper.querySelected(rTenentId,
        rMyTransId, rDeliveryId, rExpectedDeliveryDay, rPlanid, rMealtype);
    print('Switch5 query:');
    rows.forEach(print);
    rows.forEach((element) {
      selectedMeals.add(element['switch5']);
    });
    return rows;
  }

  generateWeekList(int weeks) {
    List<String> listofWeeks = [];
    for (int i = 1; i <= weeks; i++) {
      listofWeeks.add('Week $i');
    }
    return listofWeeks;
  }

  getInstances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      return prefs;
    } else {
      return null;
    }
  }

  initData() async {
    var prefs = await getInstances();
    transid = prefs.get('myTransId');
    planid = prefs.get('id');
  }

  generateMealTitleList() async {
    var prefs = await getInstances();
    var planid = prefs.get('id');
    mealsList.clear();
    final String response =
        await rootBundle.loadString('assets/json/getpackagewithplanmeal.json');
    var rData = jsonDecode(response.toString());
    rData[planid.toString()].forEach((element) {
      if (element['planid'] == planid) {
        mealsList.add(element['Meal_Eng']);
      }
    });
  }

  giveAllowedMeals() async {
    var prefs = await getInstances();
    var planid = prefs.get('id');
    allowedMealsList.clear();
    final String response =
        await rootBundle.loadString('assets/json/getpackagewithplanmeal.json');
    var rData = jsonDecode(response.toString());
    rData[planid.toString()].forEach((element) {
      if (element['planid'] == planid) {
        allowedMealsList.add(element['Allowed_Meal']);
      }
    });
    print('allowed meals list:$allowedMealsList');
  }

  int breakfastCount = 0;
  int lunchCount = 0;
  int dinnerCount = 0;
  int snackCount = 0;
  int saladCount = 0;

  checkFunctionBreakfast(var snap, bool value, int allowedM) {
    if (breakfastCount > allowedM) {
      return false;
    } else {
      if (value == true) {
        updateRow(snap);
        setState(() {
          breakfastCount++;
        });
      } else {
        //update db with null values
        setState(() {
          breakfastCount--;
        });
      }
    }
  }

  updateRow(var snap) async {
    final rows = _querySelected(
        14, transid, deliveryId, expectedDelDay, planid, snap['MealType']);
    var id = snap != null
        ? await planmealcustinvoicedbhelper.updateUsingRawQuery(
            snap['MYPRODID'],
            snap['UOM'],
            snap['Item_cost'],
            snap['Calories'],
            snap['Protein'],
            snap['Carbs'],
            snap['Fat'],
            snap['ItemWeight'],
            snap['ProdName1'],
            'Note by user',
            'Note by user for short remark',
            14,
            transid,
            deliveryId,
            expectedDelDay,
            planid,
            snap['MealType'])
        : await planmealcustinvoicedbhelper.updateUsingRawQuery(
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            14,
            transid,
            deliveryId,
            expectedDelDay,
            planid,
            snap['MealType']);
    print('Number of rows changed:$id');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
    _query(selectedWeekNumber);
    _queryDeliveryId(1);
    _queryMealTypes();
    giveAllowedMeals();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    Size medq = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomAppBar(
          color: BeHealthyTheme.kMainOrange.withOpacity(0.27),
          elevation: 100,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  displayBottomSheet();
                },
                child: Image.asset(
                  'assets/images/Group 99.png',
                  width: 30,
                  height: 30,
                  color: BeHealthyTheme.kMainOrange,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  // _queryDeliveryId(expectedDelDay);

                  // var data = await planmealcustinvoicedbhelper.querySomeRows(
                  //     selectedWeekNumber, selectedMealType, _selectedDate);
                  // print('Selected Query:');
                  // data.forEach(print);
                  // _query(3);
                  // generateWeekList(totalWeek);
                  // generateMealTitleList();
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => CartCheckout()));
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 12),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 150,
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.greenAccent[400],
                        borderRadius: BorderRadius.circular(25)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue ',
                          style: BeHealthyTheme.kMainTextStyle
                              .copyWith(fontSize: 18, color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Meal Selection',
                        style: BeHealthyTheme.kMainTextStyle.copyWith(
                            color: BeHealthyTheme.kMainOrange,
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(
                        'اختيار الوجبة',
                        style: BeHealthyTheme.kMainTextStyle.copyWith(
                          fontSize: 23,
                          color: BeHealthyTheme.kMainOrange,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: medq.width - 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: BeHealthyTheme.kMainOrange,
                            ),
                            child: DropdownButton<String>(
                              focusColor: Colors.white,
                              value: _chosenWeek,
                              dropdownColor: BeHealthyTheme.kMainOrange,
                              underline: Container(),
                              elevation: 0,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              iconDisabledColor: Colors.white,
                              //elevation: 5,
                              iconEnabledColor: Colors.black,
                              items: generateWeekList(totalWeek)
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      value,
                                      style: BeHealthyTheme.kMainTextStyle
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String value) async {
                                await _queryDeliveryId(expectedDelDay);
                                setState(() {
                                  _chosenWeek = value;
                                  switch (value) {
                                    case 'Week 1':
                                      {
                                        _query(1);
                                        selectedWeekNumber = 1;
                                      }
                                      break;
                                    case 'Week 2':
                                      {
                                        _query(2);
                                        selectedWeekNumber = 2;
                                      }
                                      break;
                                    case 'Week 3':
                                      {
                                        _query(3);
                                        selectedWeekNumber = 3;
                                      }
                                      break;
                                    case 'Week 4':
                                      {
                                        _query(4);
                                        selectedWeekNumber = 4;
                                      }
                                      break;
                                    case 'Week 5':
                                      {
                                        _query(5);
                                        selectedWeekNumber = 5;
                                      }
                                      break;
                                    default:
                                      {
                                        _query(1);
                                        selectedWeekNumber = 1;
                                      }
                                      break;
                                  }
                                  selectedIndex = null;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        // margin: EdgeInsets.symmetric(vertical: 10),
                        width: medq.width,
                        height: medq.height * 0.09,
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: weekDate.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 5),
                                child: GestureDetector(
                                  onTap: () async {
                                    print(weekDate.length);
                                    setState(() {
                                      selectedIndex = index;
                                      _selectedDate = weekDate[index];
                                      expectedDelDay =
                                          expectedDelDayList[index];
                                    });
                                    await _queryDeliveryId(expectedDelDay);
                                    setState(() {
                                      deliveryId = deliveryIdList[0];
                                      selectedMeals.clear();
                                    });
                                    print(
                                        'Delivery ID Changed:$deliveryId from $deliveryIdList');
                                    print(
                                        'Expected DAY Changed:$expectedDelDay from $expectedDelDayList');
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: selectedIndex == index
                                          ? BeHealthyTheme.kMainOrange
                                          : BeHealthyTheme.kMainOrange
                                              .withOpacity(0.11),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${weekDate[index].substring(3, 5)}',
                                            style: BeHealthyTheme.kDhaaTextStyle
                                                .copyWith(
                                                    color:
                                                        selectedIndex == index
                                                            ? Colors.white
                                                            : BeHealthyTheme
                                                                .kMainOrange,
                                                    fontSize: 25),
                                          ),
                                          Text(
                                            '${weekDay[index]}',
                                            style: BeHealthyTheme.kDhaaTextStyle
                                                .copyWith(
                                                    color:
                                                        selectedIndex == index
                                                            ? Colors.white
                                                            : BeHealthyTheme
                                                                .kMainOrange,
                                                    fontSize: 14),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    // FutureBuilder(
                    //   future: _queryMealTypes(),
                    //   builder: (context, snap) {
                    //     if (snap.connectionState == ConnectionState.waiting) {
                    //       return Center(
                    //         child: CircularProgressIndicator(),
                    //       );
                    //     } else {
                    //       if (!snap.hasData)
                    //         return Center(
                    //           child: CircularProgressIndicator(),
                    //         );
                    //       else
                    //         return Container(
                    //           height: medq.height *
                    //               0.28 *
                    //               double.parse(snap.data.length.toString()),
                    //           width: medq.width,
                    //           child: ListView.builder(
                    //               itemCount: snap.data.length,
                    //               itemBuilder: (context, index) {
                    //                 return FutureBuilder(
                    //                   future: getMenuFromMealtType(
                    //                       '${snap.data[index]}'),
                    //                   builder: (context, snapshot) {
                    //                     if (snapshot.connectionState ==
                    //                         ConnectionState.waiting) {
                    //                       return Center(
                    //                           child:
                    //                               CircularProgressIndicator());
                    //                     } else {
                    //                       if (snapshot.hasData) {
                    //                         // final List<Item> _data =
                    //                         //     generateItems(snapshot.data);
                    //                         return Padding(
                    //                           padding:
                    //                               const EdgeInsets.all(8.0),
                    //                           child: Container(
                    //                             // decoration: BoxDecoration(
                    //                             //     borderRadius: BorderRadius.circular(15),
                    //                             //     color: BeHealthyTheme.kMainOrange
                    //                             //         .withOpacity(0.11)),
                    //                             child: Column(
                    //                               children: [
                    //                                 Text(
                    //                                   '${snap.data[index]}',
                    //                                   style: BeHealthyTheme
                    //                                       .kMainTextStyle
                    //                                       .copyWith(
                    //                                           color: BeHealthyTheme
                    //                                               .kMainOrange,
                    //                                           fontSize: 22),
                    //                                 ),
                    //                                 Container(
                    //                                   height:
                    //                                       medq.height * 0.25,
                    //                                   child: ListView(
                    //                                     scrollDirection:
                    //                                         Axis.horizontal,
                    //                                     children: snapshot.data
                    //                                         .map<Widget>(
                    //                                             (var product) {
                    //                                       return CustomGridItem(
                    //                                         title:
                    //                                             '${product['ProdName1']}',
                    //                                         imageUrl: product[
                    //                                             'ProdName3'],
                    //                                       );
                    //                                     }).toList(),
                    //                                   ),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           ),
                    //                         );
                    //                       } else {
                    //                         return Text(
                    //                           'Network Error',
                    //                           style:
                    //                               BeHealthyTheme.kMainTextStyle,
                    //                         );
                    //                       }
                    //                     }
                    //                   },
                    //                 );
                    //               }),
                    //         );
                    //     }
                    //   },
                    // ),
                    FutureBuilder(
                      future: getMenuFromMealtType('1401'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          if (snapshot.hasData) {
                            // final List<Item> _data =
                            //     generateItems(snapshot.data);
                            int am = allowedMealsList[0];
                            selectedMealType = '1401';
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(15),
                                //     color: BeHealthyTheme.kMainOrange
                                //         .withOpacity(0.11)),
                                child: Column(
                                  children: [
                                    Text(
                                      'Breakfast   $am',
                                      style: BeHealthyTheme.kMainTextStyle
                                          .copyWith(
                                              color: BeHealthyTheme.kMainOrange,
                                              fontSize: 22),
                                    ),
                                    Container(
                                      height: medq.height * 0.25,
                                      width: medq.width,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: snapshot.data
                                            .map<Widget>((var product) {
                                          return CustomGridItem(
                                            title: '${product['ProdName1']}',
                                            imageUrl: product['ProdName3'],
                                            onTap: () async {
                                              await updateRow(product);
                                              // checkFunction(, snap, value, allowedM)
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Text(
                              'Network Error',
                              style: BeHealthyTheme.kMainTextStyle,
                            );
                          }
                        }
                      },
                    ),

                    FutureBuilder(
                      future: getMenuFromMealtType('1402'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          if (snapshot.hasData) {
                            int am = allowedMealsList[1];
                            // final List<Item> _data =
                            //     generateItems(snapshot.data);
                            selectedMealType = '1402';
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(15),
                                //     color: BeHealthyTheme.kMainOrange
                                //         .withOpacity(0.11)),
                                child: Column(
                                  children: [
                                    Text(
                                      'Lunch  $am',
                                      style: BeHealthyTheme.kMainTextStyle
                                          .copyWith(
                                              color: BeHealthyTheme.kMainOrange,
                                              fontSize: 22),
                                    ),
                                    Container(
                                      height: medq.height * 0.25,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: snapshot.data
                                            .map<Widget>((var product) {
                                          return CustomGridItem(
                                            title: '${product['ProdName1']}',
                                            imageUrl: product['ProdName3'],
                                            onTap: () async {
                                              await updateRow(product);
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Text(
                              'Network Error',
                              style: BeHealthyTheme.kMainTextStyle,
                            );
                          }
                        }
                      },
                    ),
                    FutureBuilder(
                      future: getMenuFromMealtType('1403'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          if (snapshot.hasData) {
                            // final List<Item> _data =
                            //     generateItems(snapshot.data);
                            int am = allowedMealsList[2];
                            selectedMealType = '1403';

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(15),
                                //     color: BeHealthyTheme.kMainOrange
                                //         .withOpacity(0.11)),
                                child: Column(
                                  children: [
                                    Text(
                                      'Dinner   $am',
                                      style: BeHealthyTheme.kMainTextStyle
                                          .copyWith(
                                              color: BeHealthyTheme.kMainOrange,
                                              fontSize: 22),
                                    ),
                                    Container(
                                      height: medq.height * 0.25,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: snapshot.data
                                            .map<Widget>((var product) {
                                          return CustomGridItem(
                                            title: '${product['ProdName1']}',
                                            imageUrl: product['ProdName3'],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Text(
                              'Network Error',
                              style: BeHealthyTheme.kMainTextStyle,
                            );
                          }
                        }
                      },
                    ),
                    FutureBuilder(
                      future: getMenuFromMealtType('1404'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          if (snapshot.hasData) {
                            // final List<Item> _data =
                            //     generateItems(snapshot.data);

                            int am = allowedMealsList[3];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(15),
                                //     color: BeHealthyTheme.kMainOrange
                                //         .withOpacity(0.11)),
                                child: Column(
                                  children: [
                                    Text(
                                      'Snack   $am',
                                      style: BeHealthyTheme.kMainTextStyle
                                          .copyWith(
                                              color: BeHealthyTheme.kMainOrange,
                                              fontSize: 22),
                                    ),
                                    Container(
                                      height: medq.height * 0.25,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: snapshot.data
                                            .map<Widget>((var product) {
                                          return CustomGridItem(
                                            title: '${product['ProdName1']}',
                                            imageUrl: product['ProdName3'],
                                            onTap: () {
                                              selectedMealType = '1404';
                                              print(selectedMealType);
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Text(
                              'Network Error',
                              style: BeHealthyTheme.kMainTextStyle,
                            );
                          }
                        }
                      },
                    ),
                    FutureBuilder(
                      future: getMenuFromMealtType('1405'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          if (snapshot.hasData) {
                            // final List<Item> _data =
                            //     generateItems(snapshot.data);

                            int am = allowedMealsList[4];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(15),
                                //     color: BeHealthyTheme.kMainOrange
                                //         .withOpacity(0.11)),
                                child: Column(
                                  children: [
                                    Text(
                                      'Salad   $am',
                                      style: BeHealthyTheme.kMainTextStyle
                                          .copyWith(
                                              color: BeHealthyTheme.kMainOrange,
                                              fontSize: 22),
                                    ),
                                    Container(
                                      height: medq.height * 0.25,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: snapshot.data
                                            .map<Widget>((var product) {
                                          return CustomGridItem(
                                            title: '${product['ProdName1']}',
                                            imageUrl: product['ProdName3'],
                                            onTap: () {
                                              selectedMealType = '1405';
                                              print(selectedMealType);
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Text(
                              'Network Error',
                              style: BeHealthyTheme.kMainTextStyle,
                            );
                          }
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void displayBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        'assets/images/Group 99.png',
                        width: 30,
                        height: 30,
                        color: BeHealthyTheme.kMainOrange,
                      )),
                  GestureDetector(
                    onTap: () {
                      // _query();
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => CartCheckout()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 12),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 150,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: BeHealthyTheme.kMainOrange,
                            borderRadius: BorderRadius.circular(25)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue ',
                              style: BeHealthyTheme.kMainTextStyle
                                  .copyWith(fontSize: 18, color: Colors.white),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  MaterialButton(
                    onPressed: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width - 300,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: BeHealthyTheme.kLightOrange,
                          borderRadius: BorderRadius.circular(25)),
                      child: Text(
                        'Spicy',
                        style: BeHealthyTheme.kMainTextStyle.copyWith(
                            fontSize: 13, color: BeHealthyTheme.kMainOrange),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width - 300,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                      child: Text(
                        'Non-Spicy',
                        style: BeHealthyTheme.kMainTextStyle.copyWith(
                            fontSize: 13, color: BeHealthyTheme.kMainOrange),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  MaterialButton(
                    onPressed: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width - 300,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: BeHealthyTheme.kLightOrange,
                          borderRadius: BorderRadius.circular(25)),
                      child: Text(
                        'Salt',
                        style: BeHealthyTheme.kMainTextStyle.copyWith(
                            fontSize: 13, color: BeHealthyTheme.kMainOrange),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width - 300,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                      child: Text(
                        'No Salt',
                        style: BeHealthyTheme.kMainTextStyle.copyWith(
                            fontSize: 13, color: BeHealthyTheme.kMainOrange),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Cooking Directions',
                  style: BeHealthyTheme.kMainTextStyle
                      .copyWith(fontSize: 18, color: Color(0xff707070)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 150,
                  child: TextFormField(
                    maxLines: 5,
                    cursorColor: BeHealthyTheme.kMainOrange,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
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
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}

class Item {
  Item({
    @required this.title,
    this.isSelected = false,
  });

  String title;
  bool isSelected;
}

List<Item> generateItems(List list) {
  return List<Item>.generate(list.length, (int index) {
    return Item(
      title: '${list[index]['ProdName1']}',
    );
  });
}

class CustomGridItem extends StatefulWidget {
  final String title;
  final String desc;
  final Function onTap;
  final bool isCompleted;
  final String imageUrl;
  CustomGridItem(
      {this.title,
      this.desc,
      this.onTap,
      this.isCompleted = false,
      this.imageUrl});
  @override
  _CustomGridItemState createState() => _CustomGridItemState();
}

class _CustomGridItemState extends State<CustomGridItem> {
  bool mealsCompleted;
  @override
  void initState() {
    mealsCompleted = widget.isCompleted;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
            color: BeHealthyTheme.kMainOrange.withOpacity(0.11),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: Image(
                    height: MediaQuery.of(context).size.height * 0.11,
                    width: MediaQuery.of(context).size.width * 0.5,
                    fit: BoxFit.cover,
                    image: widget.imageUrl != null
                        ? NetworkImage(widget.imageUrl)
                        : AssetImage('assets/images/haha2.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    widget.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: BeHealthyTheme.kMainTextStyle.copyWith(
                        fontSize: 14, color: BeHealthyTheme.kMainOrange),
                  ),
                ),
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   child: Text(
            //     desc,
            //     textAlign: TextAlign.start,
            //     style: BeHealthyTheme.kDhaaTextStyle.copyWith(fontSize: 10),
            //   ),
            // )
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: widget.onTap,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(70),
                            bottomRight: Radius.circular(20)),
                        color: BeHealthyTheme.kMainOrange.withOpacity(0.27)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: Icon(
                        mealsCompleted ? Icons.done : Icons.add,
                        size: 30,
                        color: mealsCompleted
                            ? Colors.green
                            : BeHealthyTheme.kMainOrange,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
