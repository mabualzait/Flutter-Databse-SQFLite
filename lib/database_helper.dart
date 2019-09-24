import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'models/user.dart';

class DatabaseHelper {
  final String tableUser = "userTable";
  final String columnId = "id";
  final String columnName = "username";
  final String columnPassword = "password";

  //Singlton
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  //internal can be any name
  DatabaseHelper.internal();

  //to cashe all the states of the Database  - better for memory
  //not create new DB helper
  factory DatabaseHelper() => _instance;

  //Database reference
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    // from here video 2
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "maindb.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  /*
    id | username | password
    ------------------------
    1  | malik    | 123

   */
  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableUser($columnId INTEGER PRIMARY KEY, $columnName TEXT, $columnPassword TEXT)");
  }

  //CRUD - Create Read Update DELETE

  //READ
  Future<int> saveUser(User user) async {
    //will call get db from above
    var dbClient = await db;
    //result of insert is number
    int result = await dbClient.insert(tableUser, user.toMap());
    return result;
  }

  //GET USERS
  Future<List> getAllUsers() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableUser");
    return result.toList();
  }

  //GET Count

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableUser"));
  }

  Future<User> getUser(int userId) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableUser WHERE $columnId = $userId");
    if (result.length == 0) return null;
    return new User.fromMap(result.first);
    //END of Video 2
  }

  Future<int> deleteUser(int userId) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableUser, where: "$columnId = ?", whereArgs: [userId]);
  }

  Future<int> updateUser(User user) async {
    var dbClient = await db;
    return await dbClient.update(tableUser, user.toMap(),
        where: "$columnId = ? ", whereArgs: [user.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
//End of Video 3
}
