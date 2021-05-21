import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class PlanmealCustInvoiceDB {
  static final _databaseName = "Planmealcustinvoice.db";
  static final _databaseVersion = 1;
  static final table = 'planmealcustinvoice';
  static final columnId = '_id';
  static final tenentId = 'tenentId';
  static final mytransid = 'mytransid';
  static final deliveryId = 'deliveryId';
  static final myprodid = 'myprodid';
  static final uom = 'uom';
  static final locationId = 'locationId';
  static final customerId = 'customerId';
  static final planid = 'planid';
  static final mealType = 'mealType';
  static final prodName1 = 'prodName1';
  static final oprationDay = 'oprationDay';
  static final dayNumber = 'dayNumber';
  static final transId = 'transId';
  static final contractId = 'contractId';
  static final weekofDay = 'weekofDay';
  static final nameOfDay = 'nameOfDay';
  static final totalWeek = 'totalWeek';
  static final noOfWeek = 'noOfWeek';
  static final displayWeek = 'displayWeek';
  static final totalDeliveryDay = 'totalDeliveryDay';
  static final actualDeliveryDay = 'actualDeliveryDay';
  static final expectedDeliveryDay = 'expectedDeliveryDay';
  static final deliveryTime = 'deliveryTime';
  static final deliveryMeal = 'deliveryMeal';
  static final driverId = 'driverId';
  static final startDate = 'startDate';
  static final endDate = 'endDate';
  static final expectedDelDate = 'expectedDelDate';
  static final actualDelDate = 'actualDelDate';
  static final nExtDeliveryDate = 'nExtDeliveryDate';
  static final returnReason = 'returnReason';
  static final reasonDate = 'reasonDate';
  static final productionDate = 'productionDate';
  static final chiefId = 'chiefId';
  static final subscriptonDayNumber = 'subscriptonDayNumber';
  static final calories = 'calories';
  static final protein = 'protein';
  static final fat = 'fat';
  static final itemWeight = 'itemWeight';
  static final carbs = 'carbs';
  static final qty = 'qty';
  static final itemCost = 'itemCost';
  static final itemPrice = 'itemPrice';
  static final totalprice = 'totalprice';
  static final shortRemark = 'shortRemark';
  static final active = 'active';
  static final crupid = 'crupid';
  static final changesDate = 'changesDate';
  static final deliverySequence = 'deliverySequence';
  static final switch1 = 'switch1';
  static final switch2 = 'switch2';
  static final switch3 = 'switch3';
  static final switch4 = 'switch4';
  static final switch5 = 'switch5';
  static final status = 'status';
  static final uploadDate = 'uploadDate';
  static final uploadby = 'uploadby';
  static final syncDate = 'syncDate';
  static final syncby = 'syncby';
  static final synId = 'synId';
  static final syncStatus = 'syncStatus';
  static final localId = 'localId';
  static final offlineStatus = 'offlineStatus';

  // make this a singleton class
  PlanmealCustInvoiceDB._privateConstructor();
  static final PlanmealCustInvoiceDB instance =
      PlanmealCustInvoiceDB._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $tenentId INTEGER,
          $mytransid INTEGER,
          $deliveryId INTEGER,
          $myprodid INTEGER,
          $uom INTEGER,
          $locationId INTEGER,
          $customerId INTEGER,
          $planid INTEGER,
          $mealType INTEGER,
          $prodName1 TEXT,
          $oprationDay INTEGER,
          $dayNumber INTEGER,
          $transId INTEGER,
          $contractId TEXT,
          $weekofDay TEXT,
          $nameOfDay TEXT,
          $totalWeek INTEGER,
          $noOfWeek INTEGER,
          $displayWeek INTEGER,
          $totalDeliveryDay INTEGER,
          $actualDeliveryDay INTEGER,
          $expectedDeliveryDay INTEGER,
          $deliveryTime INTEGER,
          $deliveryMeal INTEGER,
          $driverId INTEGER,
          $startDate TEXT,
          $endDate TEXT,
          $expectedDelDate TEXT,
          $actualDelDate TEXT,
          $nExtDeliveryDate TEXT,
          $returnReason INTEGER,
          $reasonDate TEXT,
          $productionDate TEXT,
          $chiefId INTEGER,
          $subscriptonDayNumber INTEGER,
          $calories DOUBLE,
          $protein DOUBLE,
          $fat DOUBLE,
          $itemWeight DOUBLE,
          $carbs DOUBLE,
          $qty INTEGER,
          $itemCost DOUBLE,
          $itemPrice DOUBLE,
          $totalprice DOUBLE,
          $shortRemark TEXT,
          $active TEXT,
          $crupid INTEGER,
          $changesDate TEXT,
          $deliverySequence INTEGER,
          $switch1 INTEGER,
          $switch2 INTEGER,
          $switch3 TEXT,
          $switch4 TEXT,
          $switch5 TEXT,
          $status TEXT,
          $uploadDate TEXT,
          $uploadby TEXT,
          $syncDate TEXT,
          $syncby TEXT,
          $synId INTEGER,
          $syncStatus TEXT,
          $localId INTEGER,
          $offlineStatus TEXT
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(
      int weekNumber, rMealType) async {
    Database db = await instance.database;
    return await db.rawQuery(
        'SELECT DISTINCT $expectedDelDate, $nameOfDay, $totalWeek, $expectedDeliveryDay, $deliveryId FROM $table WHERE $noOfWeek=$weekNumber AND $mealType=$rMealType');
  }

  Future<List<Map<String, dynamic>>> querySomeRows(
      int weekNumber, rMealType, String rEDD) async {
    Database db = await instance.database;
    print(weekNumber);
    print(rMealType);
    print(rEDD);
    return await db.rawQuery('''SELECT * 
        FROM $table 
        WHERE $noOfWeek=$weekNumber AND $mealType=$rMealType''');
  }

  queryDeliveryID(rEDDay) async {
    Database db = await instance.database;
    return await db.rawQuery(
        'SELECT DISTINCT $deliveryId FROM $table WHERE $expectedDeliveryDay=$rEDDay');
  }

  queryMealTypes() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT DISTINCT $mealType FROM $table');
  }

  Future<List<Map<String, dynamic>>> querySelected(
      int rTenentId,
      int rMyTransId,
      int rDeliveryId,
      int rExpectedDeliveryDay,
      int rPlanid,
      int rMealtype) async {
    Database db = await instance.database;
    print('Received Tenent Id=$rTenentId');
    print('Received TransId=$rMyTransId');
    print('Received Delivery Id=$rDeliveryId');
    print('Received Expected Del Day=$rExpectedDeliveryDay');
    print('Received Plan Id=$rPlanid');
    print('Received Meal Type=$rMealtype');
    return await db.rawQuery('''SELECT * FROM $table WHERE 
           $expectedDeliveryDay = $rExpectedDeliveryDay AND 
           $tenentId = $rTenentId AND  
           $mytransid = $rMyTransId AND 
           $planid = $rPlanid AND 
           $mealType = $rMealtype AND 
           $deliveryId = $rDeliveryId''');
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  updateUsingRawQuery(
      int rProdId,
      int rUOM,
      double rItemCost,
      double rCalories,
      double rProtein,
      double rCarbs,
      double rFat,
      double rItemWeight,
      String rSwitch5,
      String rProdName1,
      String rShortRemark,
      int rTenentId,
      int rMyTransId,
      int rDeliveryId,
      int rExpectedDeliveryDay,
      int rPlanid,
      int rMealtype) async {
    Database db = await instance.database;
    // print(rTenentId);
    // print(rMyTransId);
    // print(rDeliveryId);
    // print(rExpectedDeliveryDay);
    // print(rPlanid);
    // print(rMealtype);
    return await db.rawUpdate('''UPDATE $table
           SET 
           $myprodid = ?,
           $uom = ?,
           $itemCost = ?,
           $calories = ?,
           $protein = ?,
           $carbs = ?,
           $fat = ?,
           $itemWeight = ?,
           $switch5 = ?,
           $prodName1 = ?,
           $shortRemark = ? 
           WHERE 
           $expectedDeliveryDay = ? AND 
           $tenentId = ? AND  
           $mytransid = ? AND 
           $planid = ? AND 
           $mealType = ? AND 
           $deliveryId = ?
         ''', [
      '$rProdId',
      '$rUOM',
      '$rItemCost',
      '$rCalories',
      '$rProtein',
      '$rCarbs',
      '$rFat',
      '$rItemWeight',
      '$rSwitch5',
      '$rProdName1',
      '$rShortRemark',
      '$rExpectedDeliveryDay',
      '$rTenentId',
      '$rMyTransId',
      '$rPlanid',
      '$rMealtype',
      '$rDeliveryId'
    ]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  delete(int id) async {
    Database db = await instance.database;
    return await db.rawQuery("DELETE FROM $table WHERE $columnId=$id");
  }

  deleteTable() async {
    Database db = await instance.database;
    return await db.rawQuery('DROP TABLE $table');
  }
}
