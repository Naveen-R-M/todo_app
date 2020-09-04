import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConenction{
  static String DATABASE = 'sqflite.db';
  static String TABLE = 'Category';
  static String TABLE1 = 'Todo';
  setDatabase()async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path,DATABASE);
    var database = openDatabase(path,version: 1,onCreate: _onCreateDatabase);
    return database;
  }
  _onCreateDatabase(Database database , int version)async{
    await database.execute("CREATE TABLE $TABLE(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT , description TEXT)");
    await database.execute("CREATE TABLE $TABLE1(id INTEGER PRIMARY KEY , title TEXT , description TEXT , category TEXT , todoDate TEXT , isFinished INTEGER)");
  }

}