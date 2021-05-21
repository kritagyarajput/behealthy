import 'dart:convert';
import 'package:behealthy/package_details.dart';
import 'package:behealthy/providers/moreHdDb.dart';
import 'package:behealthy/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:behealthy/constants.dart';
import 'package:behealthy/homePage.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'providers/dbhelper.dart';

class BasicPlan extends StatefulWidget {
  @override
  _BasicPlanState createState() => _BasicPlanState();
}

class _BasicPlanState extends State<BasicPlan> {
  bool value = false;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  bool showCalendar = false;
  var dataForSql;
  int myTransId;
  final dbHelper = DatabaseHelper.instance;
  final moredbHelper = MoreHdDb.instance;
  int totalMealAllowed = 0;
  List rList = [];

  getInstances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      return prefs;
    } else {
      return null;
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      selectableDayPredicate: (dateTime) =>
          dateTime.weekday == 3 ? false : true,
      context: context,
      initialDate: _focusedDay, // Refer step 1
      firstDate: kFirstDay,
      lastDate: kLastDay,
    );
    if (picked != null && picked != _selectedDay) {
      setState(() {
        _selectedDay = picked;
      });
    }
  }

  // _selectDateWithHolidays(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(
  //     context: context,
  //     initialDate: _focusedDay, // Refer step 1
  //     firstDate: kFirstDay,
  //     lastDate: kLastDay,
  //   );
  //   if (picked != null && picked != _selectedDay) {
  //     setState(() {
  //       _selectedDay = picked;
  //     });
  //   }
  // }

  generateCustomerContract() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime requiredDate = _selectedDay != null ? _selectedDay : _focusedDay;
    DateTime beginDate = requiredDate.add(const Duration(days: 2));
    http.Response response = await http.post(
        Uri.parse(
            'https://foodapi.pos53.com/api/Food/GenerateCustomerContract'),
        body: {
          'PlanId': '${prefs.get('id')}',
          'TenentID': '14',
          'CustomerId': '${prefs.get('custID')}',
          'ContractDate':
              '${requiredDate.month}/${requiredDate.day}/${requiredDate.year}',
          'BeginDate': '${beginDate.month}/${beginDate.day}/${beginDate.year}',
          'AllowWeekend': '$value'
        });
    if (jsonDecode(response.body)['status'] == 200) {
      return jsonDecode(response.body);
    } else if (jsonDecode(response.body)['status'] == 400) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }

  void _deletemoreHd() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await moredbHelper.queryRowCount();
    final rowsDeleted = await moredbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach(print);
  }

  void _querymore() async {
    final allRows = await moredbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach(print);
  }

  _deleteTable() async {
    final res = await dbHelper.deleteTable();
    final res2 = await moredbHelper.deleteTable();
    print("RES:$res");
    print('RES2:$res2');
  }

  _insert() async {
    // row to insert
    // _delete();
    Map<String, dynamic> row = {
      // DatabaseHelper.columnId: 1,
      DatabaseHelper.columntenentId: dataForSql['TenentID'],
      DatabaseHelper.columnmytransid: myTransId,
      DatabaseHelper.columnlocationId: dataForSql['LOCATION_ID'],
      DatabaseHelper.columncustomerId: dataForSql['CustomerID'],
      DatabaseHelper.columnplanid: dataForSql['planid'],
      DatabaseHelper.columndayNumber: dataForSql['DayNumber'],
      DatabaseHelper.columntransId: dataForSql['TransID'],
      DatabaseHelper.columncontractId: dataForSql['ContractID'],
      DatabaseHelper.columndefaultDriverId: dataForSql['DefaultDriverID'],
      DatabaseHelper.columncontractDate: dataForSql['ContractDate'],
      DatabaseHelper.columnweekofDay: dataForSql['WeekofDay'],
      DatabaseHelper.columnstartDate: dataForSql['StartDate'],
      DatabaseHelper.columnendDate: dataForSql['EndDate'],
      DatabaseHelper.columntotalSubDays: dataForSql['TotalSubDays'],
      DatabaseHelper.columndeliveredDays: dataForSql['DeliveredDays'],
      DatabaseHelper.columnnExtDeliveryDate: dataForSql['NExtDeliveryDate'],
      DatabaseHelper.columnnExtDeliveryNum: dataForSql['NExtDeliveryNum'],
      DatabaseHelper.columnweek1TotalCount: dataForSql['Week1TotalCount'],
      DatabaseHelper.columnweek1Count: dataForSql['Week1Count'],
      DatabaseHelper.columnweek2Count: dataForSql['Week2Count'],
      DatabaseHelper.columnweek2TotalCount: dataForSql['Week2TotalCount'],
      DatabaseHelper.columnweek3Count: dataForSql['Week3Count'],
      DatabaseHelper.columnweek3TotalCount: dataForSql['Week3TotalCount'],
      DatabaseHelper.columnweek4Count: dataForSql['Week4Count'],
      DatabaseHelper.columnweek4TotalCount: dataForSql['Week4TotalCount'],
      DatabaseHelper.columnweek5Count: dataForSql['Week5Count'],
      DatabaseHelper.columnweek5TotalCount: dataForSql['Week5TotalCount'],
      DatabaseHelper.columncontractTotalCount: dataForSql['ContractTotalCount'],
      DatabaseHelper.columncontractSelectedCount:
          dataForSql['ContractSelectedCount'],
      DatabaseHelper.columnisFullPlanCopied: dataForSql['IsFullPlanCopied'],
      DatabaseHelper.columnsubscriptionOnHold: dataForSql['SubscriptionOnHold'],
      DatabaseHelper.columnholdDate: dataForSql['HoldDate'],
      DatabaseHelper.columnunHoldDate: dataForSql['UnHoldDate'],
      DatabaseHelper.columnholdbyuser: dataForSql['Holdbyuser'],
      DatabaseHelper.columnholdREmark: dataForSql['HoldREmark'],
      DatabaseHelper.columnsubscriptonDayNumber:
          dataForSql['SubscriptonDayNumber'],
      DatabaseHelper.columntotalPrice: dataForSql['Total_price'],
      DatabaseHelper.columnshortRemark: dataForSql['ShortRemark'],
      DatabaseHelper.columnactive: dataForSql['ACTIVE'],
      DatabaseHelper.columncrupId: dataForSql['CRUP_ID'],
      DatabaseHelper.columnchangesDate: dataForSql['ChangesDate'],
      DatabaseHelper.columndriverId: dataForSql['DriverID'],
      DatabaseHelper.columncStatus: dataForSql['CStatus'],
      DatabaseHelper.columnuploadDate: dataForSql['UploadDate'],
      DatabaseHelper.columnuploadby: dataForSql['Uploadby'],
      DatabaseHelper.columnsyncDate: dataForSql['SyncDate'],
      DatabaseHelper.columnsyncby: dataForSql['Syncby'],
      DatabaseHelper.columnsynId: dataForSql['SynID'],
      DatabaseHelper.columnpaymentStatus: dataForSql['PaymentStatus'],
      DatabaseHelper.columnsyncStatus: dataForSql['syncStatus'],
      DatabaseHelper.columnlocalId: dataForSql['LocalID'],
      DatabaseHelper.columnofflineStatus: dataForSql['OfflineStatus'],
      DatabaseHelper.columnallergies: dataForSql['Allergies'],
      DatabaseHelper.columncarbs: dataForSql['Carbs'],
      DatabaseHelper.columnprotein: dataForSql['Protein'],
      DatabaseHelper.columnremarks: dataForSql['Remarks'],
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
    try {
      dataForSql['MYTRANSID'] = myTransId;
      http.Response res = await http.post(
          Uri.parse(
              'https://foodapi.pos53.com/api/Food/PlanmealcustinvoiceHD_Save'),
          body: {
            "\$id": '2',
            "TenentID": '${dataForSql['TenentID']}',
            "MYTRANSID": '$myTransId',
            "LOCATION_ID": '${dataForSql['LOCATION_ID']}',
            "CustomerID": '${dataForSql['CustomerID']}',
            "planid": '${dataForSql['planid']}',
            "DayNumber": '${dataForSql['DayNumber']}',
            "TransID": '$myTransId',
            "ContractID": '$myTransId',
            "DefaultDriverID": '${dataForSql['DefaultDriverID']}',
            "ContractDate": '${dataForSql['ContractDate']}',
            "WeekofDay": '${dataForSql['WeekofDay']}',
            "StartDate": '${dataForSql['StartDate']}',
            "EndDate": '${dataForSql['EndDate']}',
            "TotalSubDays": '${dataForSql['TotalSubDays']}',
            "DeliveredDays": '${dataForSql['DeliveredDays']}',
            "NExtDeliveryDate": '${dataForSql['NExtDeliveryDate']}',
            "NExtDeliveryNum": '${dataForSql['NExtDeliveryNum']}',
            "Week1TotalCount": '${dataForSql['Week1TotalCount']}',
            "Week1Count": '${dataForSql['Week1Count']}',
            "Week2Count": '${dataForSql['Week2Count']}',
            "Week2TotalCount": '${dataForSql['Week2TotalCount']}',
            "Week3Count": '${dataForSql['Week3Count']}',
            "Week3TotalCount": '${dataForSql['Week3TotalCount']}',
            "Week4Count": '${dataForSql['Week4Count']}',
            "Week4TotalCount": '${dataForSql['Week4TotalCount']}',
            "Week5Count": '${dataForSql['Week5Count']}',
            "Week5TotalCount": '${dataForSql['Week5TotalCount']}',
            "ContractTotalCount": '${dataForSql['ContractTotalCount']}',
            "ContractSelectedCount": '${dataForSql['ContractSelectedCount']}',
            "IsFullPlanCopied": '${dataForSql['IsFullPlanCopied']}',
            "SubscriptionOnHold": '${dataForSql['SubscriptionOnHold']}',
            "HoldDate": '${dataForSql['HoldDate']}',
            "UnHoldDate": '${dataForSql['UnHoldDate']}',
            "Holdbyuser": '${dataForSql['Holdbyuser']}',
            "HoldREmark": '${dataForSql['HoldREmark']}',
            "SubscriptonDayNumber": '${dataForSql['SubscriptonDayNumber']}',
            "Total_price": '${dataForSql['Total_price']}',
            "ShortRemark": '${dataForSql['ShortRemark']}',
            "ACTIVE": '${dataForSql['ACTIVE']}',
            "CRUP_ID": '${dataForSql['CRUP_ID']}',
            "ChangesDate": '${dataForSql['ChangesDate']}',
            "DriverID": '${dataForSql['DriverID']}',
            "CStatus": '${dataForSql['CStatus']}',
            "UploadDate": '${dataForSql['UploadDate']}',
            "Uploadby": '${dataForSql['Uploadby']}',
            "SyncDate": '${dataForSql['SyncDate']}',
            "Syncby": '${dataForSql['Syncby']}',
            "SynID": '${dataForSql['SynID']}',
            "PaymentStatus": '${dataForSql['PaymentStatus']}',
            "syncStatus": '${dataForSql['syncStatus']}',
            "LocalID": '${dataForSql['LocalID']}',
            "OfflineStatus": '${dataForSql['OfflineStatus']}',
            "Allergies": '${dataForSql['Allergies']}',
            "Carbs": '${dataForSql['Carbs']}',
            "Protein": '${dataForSql['Protein']}',
            "Remarks": '${dataForSql['Remarks']}'
          });
      print({
        "\$id": '2',
        "TenentID": '${dataForSql['TenentID']}',
        "MYTRANSID": '$myTransId',
        "LOCATION_ID": '${dataForSql['LOCATION_ID']}',
        "CustomerID": '${dataForSql['CustomerID']}',
        "planid": '${dataForSql['planid']}',
        "DayNumber": '${dataForSql['DayNumber']}',
        "TransID": '$myTransId',
        "ContractID": '$myTransId',
        "DefaultDriverID": '${dataForSql['DefaultDriverID']}',
        "ContractDate": '${dataForSql['ContractDate']}',
        "WeekofDay": '${dataForSql['WeekofDay']}',
        "StartDate": '${dataForSql['StartDate']}',
        "EndDate": '${dataForSql['EndDate']}',
        "TotalSubDays": '${dataForSql['TotalSubDays']}',
        "DeliveredDays": '${dataForSql['DeliveredDays']}',
        "NExtDeliveryDate": '${dataForSql['NExtDeliveryDate']}',
        "NExtDeliveryNum": '${dataForSql['NExtDeliveryNum']}',
        "Week1TotalCount": '${dataForSql['Week1TotalCount']}',
        "Week1Count": '${dataForSql['Week1Count']}',
        "Week2Count": '${dataForSql['Week2Count']}',
        "Week2TotalCount": '${dataForSql['Week2TotalCount']}',
        "Week3Count": '${dataForSql['Week3Count']}',
        "Week3TotalCount": '${dataForSql['Week3TotalCount']}',
        "Week4Count": '${dataForSql['Week4Count']}',
        "Week4TotalCount": '${dataForSql['Week4TotalCount']}',
        "Week5Count": '${dataForSql['Week5Count']}',
        "Week5TotalCount": '${dataForSql['Week5TotalCount']}',
        "ContractTotalCount": '${dataForSql['ContractTotalCount']}',
        "ContractSelectedCount": '${dataForSql['ContractSelectedCount']}',
        "IsFullPlanCopied": '${dataForSql['IsFullPlanCopied']}',
        "SubscriptionOnHold": '${dataForSql['SubscriptionOnHold']}',
        "HoldDate": '${dataForSql['HoldDate']}',
        "UnHoldDate": '${dataForSql['UnHoldDate']}',
        "Holdbyuser": '${dataForSql['Holdbyuser']}',
        "HoldREmark": '${dataForSql['HoldREmark']}',
        "SubscriptonDayNumber": '${dataForSql['SubscriptonDayNumber']}',
        "Total_price": '${dataForSql['Total_price']}',
        "ShortRemark": '${dataForSql['ShortRemark']}',
        "ACTIVE": '${dataForSql['ACTIVE']}',
        "CRUP_ID": '${dataForSql['CRUP_ID']}',
        "ChangesDate": '${dataForSql['ChangesDate']}',
        "DriverID": '${dataForSql['DriverID']}',
        "CStatus": '${dataForSql['CStatus']}',
        "UploadDate": '${dataForSql['UploadDate']}',
        "Uploadby": '${dataForSql['Uploadby']}',
        "SyncDate": '${dataForSql['SyncDate']}',
        "Syncby": '${dataForSql['Syncby']}',
        "SynID": '${dataForSql['SynID']}',
        "PaymentStatus": '${dataForSql['PaymentStatus']}',
        "syncStatus": '${dataForSql['syncStatus']}',
        "LocalID": '${dataForSql['LocalID']}',
        "OfflineStatus": '${dataForSql['OfflineStatus']}',
        "Allergies": '${dataForSql['Allergies']}',
        "Carbs": '${dataForSql['Carbs']}',
        "Protein": '${dataForSql['Protein']}',
        "Remarks": '${dataForSql['Remarks']}'
      });
      print('Hd Save: ${res.body}');
      Toast.show(jsonDecode(res.body)['message'], context, duration: 6);
    } catch (e) {
      print(e);
    }
  }

  _insertMoreHd() async {
    await planmealCustinvoiveMoreHd();
    int i = 1;
    rList.forEach((element) async {
      Map<String, dynamic> newRow = {
        // MoreHdDb.columnId: i++,
        MoreHdDb.tenentid: element['TenentID'],
        MoreHdDb.mytransid: myTransId,
        MoreHdDb.mealtype: element['MealType'],
        MoreHdDb.planid: element['planid'],
        MoreHdDb.customized: null,
        MoreHdDb.uom: element['UOM'],
        MoreHdDb.totalmealallowed: element['MealAllowed'],
        MoreHdDb.weekmealallowed: null,
        MoreHdDb.planingram: element['PlanInGram'],
        MoreHdDb.mealfixflexible: element['MealFixFlexible'],
        MoreHdDb.mealingram: element['MealInGram'],
        MoreHdDb.planbasecost: element['PlanBasecost'],
        MoreHdDb.itembasecost: element['ItemBasecost'],
        MoreHdDb.basemeal: element['MealAllowed'],
        MoreHdDb.extrameal: null,
        MoreHdDb.extramealcost: null,
        MoreHdDb.amt: element['PlanBasecost'],
        MoreHdDb.uploaddate: element['UploadDate'],
        MoreHdDb.uploadby: element['Uploadby'],
        MoreHdDb.syncdate: element['SyncDate'],
        MoreHdDb.syncby: null,
        MoreHdDb.synid: element['SynID'],
        MoreHdDb.totalamount: element['PlanBasecost'],
        MoreHdDb.paidamount: null,
        MoreHdDb.alloweekend: value,
        MoreHdDb.updatedate:
            '${_focusedDay.month}/${_focusedDay.day}/${_focusedDay.year}'
      };
      try {
        final id = await moredbHelper.insert(newRow);
        print('inserted row in more hd id: $id');
      } catch (e) {
        Toast.show(e.toString(), context, duration: 3);
      }
      var body = {
        "\$id": "${i++}",
        "TenentID": '${element['TenentID']}',
        "MYTRANSID": '$myTransId',
        "MealType": '${element['MealType']}',
        "PlanId": '${element['planid']}',
        "Customized": "null",
        "MealFixFlexible": '${element['MealFixFlexible']}',
        "UOM": '${element['UOM']}',
        "TotalMealAllowed": '$totalMealAllowed',
        "WeekMealAllowed": "null",
        "PlanInGram": '${element['PlanInGram']}',
        "MealInGram": '${element['MealInGram']}',
        "PlanBasecost": '${element['PlanBasecost']}',
        "ItemBasecost": '${element['ItemBasecost']}',
        "BaseMeal": '${element['MealAllowed']}',
        "ExtraMeal": "null",
        "ExtraMealCost": "null",
        "Amt": '${element['PlanBasecost']}',
        "UploadDate": '${element['UploadDate']}',
        "Uploadby": '${element['Uploadby']}',
        "SyncDate": '${element['SyncDate']}',
        "Syncby": "null",
        "SynID": '${element['SynID']}',
        "TotalAmount": '${element['PlanBasecost']}',
        "PaidAmount": "null",
        "AlloWeekend": '$value',
        "UpdateDate":
            '${_focusedDay.month}/${_focusedDay.day}/${_focusedDay.year}'
      };
      http.Response res = await http.post(
          Uri.parse(
              'https://foodapi.pos53.com/api/Food/PlanmealcustinvoiceMoreHD_Save'),
          body: body);
      print('More Hd Save $i :${res.body}');
      Toast.show(jsonDecode(res.body)['message'], context, duration: 6);
    });
  }

  getNextMyTransId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response respo = await http.post(
        Uri.parse('https://foodapi.pos53.com/api/Food/GetNextMyTransId'),
        body: {'TenantID': '14'});
    if (jsonDecode(respo.body)['status'] == 200) {
      print(jsonDecode(respo.body)['data'][0]['MYTRANSID']);
      prefs.setInt('myTransId', jsonDecode(respo.body)['data'][0]['MYTRANSID']);
      myTransId = jsonDecode(respo.body)['data'][0]['MYTRANSID'];
    } else {
      print(jsonDecode(respo.body)['message']);
    }
  }

  getpackageWithPlanId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id = preferences.get('id');
    http.Response response = await http.post(
        Uri.parse('https://foodapi.pos53.com/api/Food/GetpackageMeal'),
        body: {'TenentID': '14', 'PlanId': '${id.toString()}'});
    if (jsonDecode(response.body)['status'] == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  planmealCustinvoiveMoreHd() async {
    var prefs = await getInstances();
    var planid = prefs.get('id');
    final String response =
        await rootBundle.loadString('assets/json/data.json');
    var rData = jsonDecode(response.toString());
    rData['planmeal'].forEach((element) {
      if (element['planid'] == planid.toString()) {
        rList.add(element);
      }
    });
    rList.forEach((element) {
      totalMealAllowed += int.parse(element['MealAllowed']);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNextMyTransId();
  }

  @override
  Widget build(BuildContext context) {
    Size medq = MediaQuery.of(context).size;
    return Material(
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () async => true,
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Positioned(
                  top: -medq.height * 0.53,
                  child: Image(
                    image: AssetImage('assets/images/Path 29.png'),
                  )),
              Positioned(
                top: medq.height / 25,
                left: 0,
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 25,
                    ),
                    onPressed: () {
                      // Navigator.pop(context);
                    }),
              ),
              Positioned(
                top: medq.height / 20,
                left: medq.width / 10,
                child: FutureBuilder(
                    future: getInstances(),
                    builder: (context, snap) {
                      if (snap.hasData) {
                        var planTitle = snap.data.get('planTitle');
                        var arabicName = snap.data.get('arabicName');
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              planTitle.toString(),
                              style: BeHealthyTheme.kMainTextStyle
                                  .copyWith(fontSize: 19, color: Colors.white),
                            ),
                            Text(
                              arabicName.toString(),
                              style: BeHealthyTheme.kMainTextStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        );
                      } else {
                        return Text('ERROR');
                      }
                    }),
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
                child: FutureBuilder(
                    future: generateCustomerContract(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: EdgeInsets.only(top: medq.height * 0.3),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        if (snapshot.data['status'] == 200) {
                          dataForSql =
                              snapshot.data['data']['planmealinvoiceHD'];
                          return Container(
                            height: medq.height * 0.65,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        border: Border.all(
                                            color: BeHealthyTheme.kMainOrange),
                                        color: Colors.white),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/calendar (2).png',
                                                width: 30,
                                                height: 30,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Begin Date',
                                                style: BeHealthyTheme
                                                    .kProfileFont
                                                    .copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 15.0),
                                          child: Text(
                                            // '${_selectedDay == null ? _focusedDay.month : _selectedDay.month}/${_selectedDay == null ? _focusedDay.day : _selectedDay.day}/${_selectedDay == null ? _focusedDay.year : _selectedDay.year}',
                                            '${snapshot.data['data']['StartDate']}',
                                            style: BeHealthyTheme.kProfileFont
                                                .copyWith(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                    color: BeHealthyTheme
                                                        .kMainOrange),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                Text(
                                  'Delivery starts 2 days after the selected Date',
                                  style: BeHealthyTheme.kDhaaTextStyle,
                                ),
                                //non editable field

                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      border: Border.all(
                                          color: BeHealthyTheme.kMainOrange),
                                      color: Colors.white),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/calendar (2).png',
                                              width: 30,
                                              height: 30,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'End Date',
                                              style: BeHealthyTheme.kProfileFont
                                                  .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: Text(
                                          '${snapshot.data['data']['EndDate']}',
                                          style: BeHealthyTheme.kProfileFont
                                              .copyWith(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: BeHealthyTheme
                                                      .kMainOrange),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    CupertinoSwitch(
                                        activeColor: BeHealthyTheme.kMainOrange,
                                        value: this.value,
                                        onChanged: (value) {
                                          setState(() {
                                            this.value = value;
                                          });
                                        }),
                                    SizedBox(
                                      width: 5,
                                    ), //SizedBox
                                    Text(
                                      'Deliver me on Holidays',
                                      style: BeHealthyTheme.kProfileFont
                                          .copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 3),
                                          color: Colors.black12,
                                          blurRadius: 12,
                                        )
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                '${snapshot.data['data']['TotalWeek']}',
                                                style: BeHealthyTheme
                                                    .kMainTextStyle
                                                    .copyWith(
                                                        color: BeHealthyTheme
                                                            .kMainOrange,
                                                        fontSize: 30)),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Text('Weeks',
                                                style: BeHealthyTheme
                                                    .kDhaaTextStyle
                                                    .copyWith(
                                                        color: Colors.black87,
                                                        fontSize: 20)),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                '${snapshot.data['data']['DaysTotal']}',
                                                style: BeHealthyTheme
                                                    .kMainTextStyle
                                                    .copyWith(
                                                        color: BeHealthyTheme
                                                            .kMainOrange,
                                                        fontSize: 30)),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Text('Days',
                                                style: BeHealthyTheme
                                                    .kDhaaTextStyle
                                                    .copyWith(
                                                        color: Colors.black87,
                                                        fontSize: 20)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                FutureBuilder(
                                    future: getpackageWithPlanId(),
                                    builder: (context, snapshot) {
                                      if (snapshot.data != null) {
                                        return BottomContainer(
                                          am1: snapshot.data['data'][0]
                                              ['AllowedMeal'],
                                          am2: snapshot.data['data'][1]
                                              ['AllowedMeal'],
                                          am3: snapshot.data['data'][2]
                                              ['AllowedMeal'],
                                          am4: snapshot.data['data'][3]
                                              ['AllowedMeal'],
                                          am5: snapshot.data['data'][4]
                                              ['AllowedMeal'],
                                        );
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    }),
                                GestureDetector(
                                  onTap: () async {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          Future.delayed(Duration(seconds: 5),
                                              () {
                                            try {
                                              _insert();
                                              _insertMoreHd().then((value) {
                                                rList.clear();
                                              });
                                            } catch (e) {
                                              Toast.show(
                                                  "Your Plan is Already Active",
                                                  context,
                                                  duration: 5);
                                            }
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PackageDetails(
                                                          genratedContract:
                                                              snapshot.data,
                                                        )));
                                          });
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        });
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    height: 45,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: BeHealthyTheme.kMainOrange,
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Text(
                                      'Confirm',
                                      style: BeHealthyTheme.kMainTextStyle
                                          .copyWith(
                                              fontSize: 18,
                                              color: Colors.white),
                                    ),
                                  ),
                                ),
                                // Row(
                                //   children: [
                                //     MaterialButton(
                                //       onPressed: _delete,
                                //       child: Text('hd delete(don\'t press)'),
                                //     ),
                                //     MaterialButton(
                                //       onPressed: _query,
                                //       child: Text(
                                //           'hd Another query(don\'t press)'),
                                //     ),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     MaterialButton(
                                //       onPressed: _deletemoreHd,
                                //       child: Text(' more delete(don\'t press)'),
                                //     ),
                                //     MaterialButton(
                                //       onPressed: _querymore,
                                //       child: Text(
                                //           ' more Another query(don\'t press)'),
                                //     ),
                                //   ],
                                // )
                              ],
                            ),
                          );
                        } else if (snapshot.data['status'] == 400) {
                          return Container(
                            alignment: Alignment.center,
                            height: medq.height * 0.65,
                            child: Center(
                              child: Text('${snapshot.data['message']}'),
                            ),
                          );
                        } else {
                          return Container(
                            alignment: Alignment.center,
                            height: medq.height * 0.65,
                            child: Center(
                              child: Text('${snapshot.data['message']}'),
                            ),
                          );
                        }
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BottomContainer extends StatelessWidget {
  final int am1;
  final int am2;
  final int am3;
  final int am4;
  final int am5;
  const BottomContainer({
    this.am1,
    this.am2,
    this.am3,
    this.am4,
    this.am5,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3),
              color: Colors.black12,
              blurRadius: 12,
            )
          ],
          color: BeHealthyTheme.kLightOrange),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/images/Breakfast.png',
                  width: 50,
                  height: 50,
                ),
                Text(
                  '$am1',
                  style: BeHealthyTheme.kProfileFont.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: BeHealthyTheme.kMainOrange),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/images/Lunch.png',
                  width: 50,
                  height: 50,
                ),
                Text(
                  '$am2',
                  style: BeHealthyTheme.kProfileFont.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: BeHealthyTheme.kMainOrange),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/images/Dinner.png',
                  width: 50,
                  height: 50,
                ),
                Text(
                  '$am3',
                  style: BeHealthyTheme.kProfileFont.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: BeHealthyTheme.kMainOrange),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/images/Snack.png',
                  width: 50,
                  height: 50,
                ),
                Text(
                  '$am4',
                  style: BeHealthyTheme.kProfileFont.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: BeHealthyTheme.kMainOrange),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/images/Salad.png',
                  width: 50,
                  height: 50,
                ),
                Text(
                  '$am5',
                  style: BeHealthyTheme.kProfileFont.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: BeHealthyTheme.kMainOrange),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
