import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class MoreHdDb {
  static final _databaseName = "MoreHd.db";
  static final _databaseVersion = 1;
  static final table = 'planmealcustinvoicemoreHD';
  static final columnId = '_id';
  static final tenentid = 'tenentId';
  static final mytransid = 'mytransid';
  static final mealtype = 'mealtype';
  static final planid = 'planid';
  static final customized = 'customized';
  static final uom = 'uom';
  static final totalmealallowed = 'totalmealallowed';
  static final weekmealallowed = 'weekmealallowed';
  static final planingram = 'planingram';
  static final mealfixflexible = 'mealfixflexible';
  static final mealingram = 'mealingram';
  static final planbasecost = 'planbasecost';
  static final itembasecost = 'itembasecost';
  static final basemeal = 'basemeal';
  static final extrameal = 'extrameal';
  static final extramealcost = 'extramealcost';
  static final amt = 'amt';
  static final uploaddate = 'uploaddate';
  static final uploadby = 'uploadby';
  static final syncdate = 'syncdate';
  static final syncby = 'syncby';
  static final synid = 'synid';
  static final totalamount = 'totalamount';
  static final paidamount = 'paidamount';
  static final alloweekend = 'alloweekend';
  static final updatedate = 'updatedate';

  // make this a singleton class
  MoreHdDb._privateConstructor();
  static final MoreHdDb instance = MoreHdDb._privateConstructor();

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
          $tenentid INTEGER , 
          $mytransid INTEGER , 
          $mealtype TEXT , 
          $planid INTEGER , 
          $customized TEXT , 
          $uom INTEGER , 
          $totalmealallowed INTEGER , 
          $weekmealallowed INTEGER , 
          $planingram TEXT , 
          $mealfixflexible TEXT , 
          $mealingram TEXT , 
          $planbasecost DOUBLE , 
          $itembasecost DOUBLE , 
          $basemeal INTEGER , 
          $extrameal INTEGER , 
          $extramealcost DOUBLE , 
          $amt DOUBLE , 
          $uploaddate TEXT , 
          $uploadby TEXT , 
          $syncdate TEXT , 
          $syncby TEXT , 
          $synid INTEGER ,
          $totalamount DOUBLE , 
          $paidamount DOUBLE , 
          $alloweekend INTEGER , 
          $updatedate TEXT
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
