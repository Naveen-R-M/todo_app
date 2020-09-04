import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/repositories/database_connection.dart';

class Repository{
  DatabaseConenction _databaseConenction;
  Repository(){
    _databaseConenction = DatabaseConenction();
  }
  static Database _database;

  Future<Database> get database async{
    if (_database!=null){
      return _database;
    }
    _database = await _databaseConenction.setDatabase();
    return _database;
  }
  insertData(table,data) async{
    var connection = await database;
    return await connection.insert(table, data);
  }
  fetchData(table)async{
    var connection = await database;
    return await connection.query(table);
  }

  fetchDataById(String table, categoryId) async{
    var connection = await database;
    return await connection.query(table,where: "id=?",whereArgs: [categoryId]);
  }

  updateData(String table, data) async{
    var connection = await database;
    return await connection.update(table,data,where: "id=?",whereArgs: [data["id"]]);
  }

  deleteData(String table, categoryId) async{
    var connection = await database;
    return await connection.rawDelete("DELETE FROM $table WHERE id = $categoryId");
//    return await connection.delete(table,where: "id=?",whereArgs: [categoryId]);
  }

  fetchDataByCategory(table,column,columnValue)async{
    var connection = await database;
    return await connection.query(table,where: '$column=?',whereArgs: [columnValue]);
  }
}