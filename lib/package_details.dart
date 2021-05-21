import 'dart:convert';

import 'package:behealthy/meal_selection.dart';
import 'package:behealthy/providers/planmealcustinvoiceDb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:behealthy/constants.dart';
import 'package:behealthy/homePage.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class PackageDetails extends StatefulWidget {
  final genratedContract;
  PackageDetails({this.genratedContract});
  @override
  _PackageDetailsState createState() => _PackageDetailsState();
}

class _PackageDetailsState extends State<PackageDetails> {
  String planTitle;
  final planmealCustInvoiceDB = PlanmealCustInvoiceDB.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await planmealCustInvoiceDB.queryRowCount();
    final rowsDeleted = await planmealCustInvoiceDB.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }

  void _query() async {
    final allRows = await planmealCustInvoiceDB.queryAllRows(1,1401);
    print('query all rows:');
    allRows.forEach(print);
  }

  _insertinPlanMealCustinvoiceDb(List allData) {
    int i = 1;
    allData.forEach((element) {
      Map<String, dynamic> newRow = {
        // PlanmealCustInvoiceDB.columnId: i++,
        PlanmealCustInvoiceDB.tenentId: element['TenentID'],
        PlanmealCustInvoiceDB.mytransid: element['MYTRANSID'],
        PlanmealCustInvoiceDB.deliveryId: element['DeliveryID'],
        PlanmealCustInvoiceDB.myprodid: element['MYPRODID'],
        PlanmealCustInvoiceDB.uom: element['UOM'],
        PlanmealCustInvoiceDB.locationId: element['LOCATION_ID'],
        PlanmealCustInvoiceDB.customerId: element['CustomerID'],
        PlanmealCustInvoiceDB.planid: element['planid'],
        PlanmealCustInvoiceDB.mealType: element['MealType'],
        PlanmealCustInvoiceDB.prodName1: element['ProdName1'],
        PlanmealCustInvoiceDB.oprationDay: element['OprationDay'],
        PlanmealCustInvoiceDB.dayNumber: element['DayNumber'],
        PlanmealCustInvoiceDB.transId: element['TransID'],
        PlanmealCustInvoiceDB.contractId: element['ContractID'],
        PlanmealCustInvoiceDB.weekofDay: element['WeekofDay'],
        PlanmealCustInvoiceDB.nameOfDay: element['NameOfDay'],
        PlanmealCustInvoiceDB.totalWeek: element['TotalWeek'],
        PlanmealCustInvoiceDB.noOfWeek: element['NoOfWeek'],
        PlanmealCustInvoiceDB.displayWeek: element['DisplayWeek'],
        PlanmealCustInvoiceDB.totalDeliveryDay: element['TotalDeliveryDay'],
        PlanmealCustInvoiceDB.actualDeliveryDay: element['ActualDeliveryDay'],
        PlanmealCustInvoiceDB.expectedDeliveryDay:
            element['ExpectedDeliveryDay'],
        PlanmealCustInvoiceDB.deliveryTime: element['DeliveryTime'],
        PlanmealCustInvoiceDB.deliveryMeal: element['DeliveryMeal'],
        PlanmealCustInvoiceDB.driverId: element['DriverID'],
        PlanmealCustInvoiceDB.startDate: element['StartDate'],
        PlanmealCustInvoiceDB.endDate: element['EndDate'],
        PlanmealCustInvoiceDB.expectedDelDate: element['ExpectedDelDate'],
        PlanmealCustInvoiceDB.actualDelDate: element['ActualDelDate'],
        PlanmealCustInvoiceDB.nExtDeliveryDate: element['NExtDeliveryDate'],
        PlanmealCustInvoiceDB.returnReason: element['ReturnReason'],
        PlanmealCustInvoiceDB.reasonDate: element['ReasonDate'],
        PlanmealCustInvoiceDB.productionDate: element['ProductionDate'],
        PlanmealCustInvoiceDB.chiefId: element['chiefID'],
        PlanmealCustInvoiceDB.subscriptonDayNumber:
            element['SubscriptonDayNumber'],
        PlanmealCustInvoiceDB.calories: element['Calories'],
        PlanmealCustInvoiceDB.protein: element['Protein'],
        PlanmealCustInvoiceDB.fat: element['Fat'],
        PlanmealCustInvoiceDB.itemWeight: element['ItemWeight'],
        PlanmealCustInvoiceDB.carbs: element['Carbs'],
        PlanmealCustInvoiceDB.qty: element['Qty'],
        PlanmealCustInvoiceDB.itemCost: element['Item_cost'],
        PlanmealCustInvoiceDB.itemPrice: element['Item_price'],
        PlanmealCustInvoiceDB.totalprice: element['Totalprice'],
        PlanmealCustInvoiceDB.shortRemark: element['ShortRemark'],
        PlanmealCustInvoiceDB.active: element['ACTIVE'],
        PlanmealCustInvoiceDB.crupid: element['CRUPID'],
        PlanmealCustInvoiceDB.changesDate: element['ChangesDate'],
        PlanmealCustInvoiceDB.deliverySequence: element['DeliverySequence'],
        PlanmealCustInvoiceDB.switch1: element['Switch1'],
        PlanmealCustInvoiceDB.switch2: element['Switch2'],
        PlanmealCustInvoiceDB.switch3: element['Switch3'],
        PlanmealCustInvoiceDB.switch4: element['Switch4'],
        PlanmealCustInvoiceDB.switch5: element['Switch5'],
        PlanmealCustInvoiceDB.status: element['Status'],
        PlanmealCustInvoiceDB.uploadDate: element['UploadDate'],
        PlanmealCustInvoiceDB.uploadby: element['Uploadby'],
        PlanmealCustInvoiceDB.syncDate: element['SyncDate'],
        PlanmealCustInvoiceDB.syncby: element['Syncby'],
        PlanmealCustInvoiceDB.synId: element['SynID'],
        PlanmealCustInvoiceDB.syncStatus: element['syncStatus'],
        PlanmealCustInvoiceDB.localId: element['LocalID'],
        PlanmealCustInvoiceDB.offlineStatus: element['OfflineStatus']
      };
      try {
        final id = planmealCustInvoiceDB.insert(newRow);
        print('Row inserted in planmealcustinvoice db:$id');
      } catch (e) {
        print(e);
      }
    });
  }

  _getPlanMealCustInvoice() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var mytransid = preferences.get('myTransId');
    print('MytransId:$mytransid');
    http.Response response = await http.post(
        Uri.parse(
            'https://foodapi.pos53.com/api/Food/GenerateCustomerContractDetails'),
        body: {'TenentID': '14', 'MyTransID': '$mytransid'});
    print(response.body);
    if (jsonDecode(response.body)['status'] == 200) {
      var data = jsonDecode(response.body)['data'];
      _insertinPlanMealCustinvoiceDb(data);
    }
  }

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
    Size medq = MediaQuery.of(context).size;
    return Material(
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () async => false,
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Positioned(
                  top: -medq.height * 0.53,
                  child: Image(
                    image: AssetImage('assets/images/Path 29.png'),
                  )),
              // Positioned(
              //   top: medq.height / 25,
              //   left: 0,
              //   child: IconButton(
              //       icon: Icon(
              //         Icons.arrow_back_ios,
              //         color: Colors.white,
              //         size: 25,
              //       ),
              //       onPressed: () {
              //         Navigator.pop(context);
              //       }),
              // ),
              Positioned(
                top: medq.height / 20,
                left: medq.width / 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Package Details',
                      style: BeHealthyTheme.kMainTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'حزمة من التفاصيل',
                      style: BeHealthyTheme.kMainTextStyle
                          .copyWith(fontSize: 19, color: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FutureBuilder(
                        future: shardPref(),
                        builder: (context, snapshot) {
                          var name = snapshot.data.get('planTitle');
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              return Text(
                                name.toString(),
                                style: BeHealthyTheme.kMainTextStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              );
                            } else {
                              return Text('Error');
                            }
                          } else {
                            return Text(' ');
                          }
                        }),
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
                  bottom: 0,
                  child:
                      Image(image: AssetImage('assets/images/Untitled-1.png'))),
              Positioned(
                top: medq.height * 0.25,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 3),
                              color: Colors.black12,
                              blurRadius: 12,
                            )
                          ],
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            // Text(
                            //   'Ramdan Basic Plan',
                            //   style: BeHealthyTheme.kMainTextStyle.copyWith(
                            //       fontSize: 22,
                            //       color: BeHealthyTheme.kMainOrange),
                            // ),
                            // SizedBox(
                            //   height: 15,
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 25),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/Dinner.png',
                                        width: 45,
                                        height: 45,
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        'Quantity',
                                        style: BeHealthyTheme.kProfileFont
                                            .copyWith(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        '${widget.genratedContract['data']['DaysTotal']}',
                                        style: BeHealthyTheme.kMainTextStyle
                                            .copyWith(
                                                fontSize: 22,
                                                color:
                                                    BeHealthyTheme.kMainOrange),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    height: 60,
                                    child: VerticalDivider(
                                      color: Colors.black26,
                                      width: 20,
                                    )),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/send.png',
                                      width: 48,
                                      height: 49,
                                    ),
                                    SizedBox(
                                      height: 0,
                                    ),
                                    Text(
                                      'Amount',
                                      style: BeHealthyTheme.kProfileFont
                                          .copyWith(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${widget.genratedContract['data']['PlanPrice']} Kd',
                                      style: BeHealthyTheme.kMainTextStyle
                                          .copyWith(
                                              fontSize: 22,
                                              color:
                                                  BeHealthyTheme.kMainOrange),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height: 60,
                                    child: VerticalDivider(
                                      color: Colors.black26,
                                      width: 20,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/take-away (3).png',
                                        width: 45,
                                        height: 45,
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        'Customer ID',
                                        style: BeHealthyTheme.kProfileFont
                                            .copyWith(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        '${widget.genratedContract['data']['planmealinvoiceHD']['TransID']}',
                                        style: BeHealthyTheme.kMainTextStyle
                                            .copyWith(
                                                fontSize: 22,
                                                color:
                                                    BeHealthyTheme.kMainOrange),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 8, left: 8, right: 15),
                              child: Container(
                                height: 100,

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
                                      'assets/images/check (2).png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${widget.genratedContract['data']['planmealinvoiceHD']['PaymentStatus']}',
                                      style: BeHealthyTheme.kProfileFont
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 8, left: 23),
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.green),
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
                                      'assets/images/whatsapp.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Whatsapp',
                                      style: BeHealthyTheme.kProfileFont
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 8, left: 8, right: 15),
                              child: Container(
                                height: 100,
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
                                      'assets/images/support (1).png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Support',
                                      style: BeHealthyTheme.kProfileFont
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 8, left: 23),
                              child: Container(
                                height: 100,
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
                                      'assets/images/card.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Pay Now',
                                      style: BeHealthyTheme.kProfileFont
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    GestureDetector(
                      onTap: () {
                        _getPlanMealCustInvoice();
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 9), () async {
                                // try {
                                // } catch (e) {
                                //   print(e);
                                // }
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MealSelection()));
                              });
                              return Center(child: CircularProgressIndicator());
                            });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 100,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: BeHealthyTheme.kMainOrange,
                            borderRadius: BorderRadius.circular(25)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue',
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
                    // MaterialButton(
                    //   onPressed: _delete,
                    //   child: Text('Delete Rows'),
                    // ),
                    // MaterialButton(
                    //   onPressed: _query,
                    //   child: Text('Query Rows'),
                    // ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
