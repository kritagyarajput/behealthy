import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;
  static final table = 'planmealcustinvoiceHD';
  static final columnId = '_id';
  static final columntenentId = 'tenentId';
  static final columnmytransid = 'mytransid';
  static final columnlocationId = 'locationId';
  static final columncustomerId = 'customerId';
  static final columnplanid = 'planid';
  static final columndayNumber = 'dayNumber';
  static final columntransId = 'transId';
  static final columncontractId = 'contractId';
  static final columndefaultDriverId = 'defaultDriverId';
  static final columncontractDate = 'contractDate';
  static final columnweekofDay = 'weekofDay';
  static final columnstartDate = 'startDate';
  static final columnendDate = 'endDate';
  static final columntotalSubDays = 'totalSubDays';
  static final columndeliveredDays = 'deliveredDays';
  static final columnnExtDeliveryDate = 'nExtDeliveryDate';
  static final columnnExtDeliveryNum = 'nExtDeliveryNum';
  static final columnweek1TotalCount = 'week1TotalCount';
  static final columnweek1Count = 'week1Count';
  static final columnweek2Count = 'week2Count';
  static final columnweek2TotalCount = 'week2TotalCount';
  static final columnweek3Count = 'week3Count';
  static final columnweek3TotalCount = 'week3TotalCount';
  static final columnweek4Count = 'week4Count';
  static final columnweek4TotalCount = 'week4TotalCount';
  static final columnweek5Count = 'week5Count';
  static final columnweek5TotalCount = 'week5TotalCount';
  static final columncontractTotalCount = 'contractTotalCount';
  static final columncontractSelectedCount = 'contractSelectedCount';
  static final columnisFullPlanCopied = 'isFullPlanCopied';
  static final columnsubscriptionOnHold = 'subscriptionOnHold';
  static final columnholdDate = 'holdDate';
  static final columnunHoldDate = 'unHoldDate';
  static final columnholdbyuser = 'holdbyuser';
  static final columnholdREmark = 'holdREmark';
  static final columnsubscriptonDayNumber = 'subscriptonDayNumber';
  static final columntotalPrice = 'totalPrice';
  static final columnshortRemark = 'shortRemark';
  static final columnactive = 'active';
  static final columncrupId = 'crupId';
  static final columnchangesDate = 'changesDate';
  static final columndriverId = 'driverId';
  static final columncStatus = 'cStatus';
  static final columnuploadDate = 'uploadDate';
  static final columnuploadby = 'uploadby';
  static final columnsyncDate = 'syncDate';
  static final columnsyncby = 'syncby';
  static final columnsynId = 'synId';
  static final columnpaymentStatus = 'paymentStatus';
  static final columnsyncStatus = 'syncStatus';
  static final columnlocalId = 'localId';
  static final columnofflineStatus = 'offlineStatus';
  static final columnallergies = 'allergies';
  static final columncarbs = 'carbs';
  static final columnprotein = 'protein';
  static final columnremarks = 'remarks';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

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
          $columntenentId INTEGER,
          $columnmytransid INTEGER,
          $columnlocationId INTEGER,
          $columncustomerId INTEGER,
          $columnplanid INTEGER,
          $columndayNumber INTEGER,
          $columntransId INTEGER,
          $columncontractId TEXT,
          $columndefaultDriverId INTEGER,
          $columncontractDate TEXT,
          $columnweekofDay TEXT,
          $columnstartDate TEXT,
          $columnendDate TEXT,
          $columntotalSubDays INTEGER,
          $columndeliveredDays INTEGER,
          $columnnExtDeliveryDate TEXT,
          $columnnExtDeliveryNum INTEGER,
          $columnweek1TotalCount INTEGER,
          $columnweek1Count INTEGER,
          $columnweek2Count INTEGER,
          $columnweek2TotalCount INTEGER,
          $columnweek3Count INTEGER,
          $columnweek3TotalCount INTEGER,
          $columnweek4Count INTEGER,
          $columnweek4TotalCount INTEGER,
          $columnweek5Count INTEGER,
          $columnweek5TotalCount INTEGER,
          $columncontractTotalCount INTEGER,
          $columncontractSelectedCount INTEGER,
          $columnisFullPlanCopied TEXT,
          $columnsubscriptionOnHold TEXT,
          $columnholdDate TEXT,
          $columnunHoldDate TEXT,
          $columnholdbyuser INTEGER,
          $columnholdREmark TEXT,
          $columnsubscriptonDayNumber INTEGER,
          $columntotalPrice DOUBLE,
          $columnshortRemark TEXT,
          $columnactive TEXT,
          $columncrupId INTEGER,
          $columnchangesDate TEXT,
          $columndriverId INTEGER,
          $columncStatus TEXT,
          $columnuploadDate TEXT,
          $columnuploadby TEXT,
          $columnsyncDate TEXT,
          $columnsyncby TEXT,
          $columnsynId INTEGER,
          $columnpaymentStatus TEXT,
          $columnsyncStatus TEXT,
          $columnlocalId INTEGER,
          $columnofflineStatus TEXT,
          $columnallergies TEXT,
          $columncarbs INTEGER,
          $columnprotein INTEGER,
          $columnremarks TEXT
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
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
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
