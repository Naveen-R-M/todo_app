import 'package:todo_app/models/todo.dart';
import 'package:todo_app/repositories/database_connection.dart';
import 'package:todo_app/repositories/repository.dart';

class TodoServices{
  Repository _repository;
  TodoServices(){
    _repository = Repository();
  }
  saveTodo(Todo todo) async {
    return await _repository.insertData(
        DatabaseConenction.TABLE1, todo.todoMap());
  }
  readTodo()async{
    return await _repository.fetchData(DatabaseConenction.TABLE1);
  }

  deleteTodo(categoryId) async{
    return await _repository.deleteData(DatabaseConenction.TABLE1,categoryId);
  }
  
  readByCategory(category)async{
    return await _repository.fetchDataByCategory(DatabaseConenction.TABLE1, 'category', category);
  }
}