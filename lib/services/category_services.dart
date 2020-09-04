import 'package:todo_app/models/category.dart';
import 'package:todo_app/repositories/database_connection.dart';
import 'package:todo_app/repositories/repository.dart';

class CategoryServices {
  Repository _repository;
  CategoryServices() {
    _repository = Repository();
  }
  saveCategory(Category category) async {
    return await _repository.insertData(
        DatabaseConenction.TABLE, category.categoryMap());
  }
  readCategory()async{
    return await _repository.fetchData(DatabaseConenction.TABLE);
  }

  readCategoryById(categoryId) async{
    return await _repository.fetchDataById(DatabaseConenction.TABLE,categoryId);
  }

  updateCategory(Category category) async{
    return await _repository.updateData(DatabaseConenction.TABLE,category.categoryMap());
  }

  deleteCategory(categoryId) async{
    return await _repository.deleteData(DatabaseConenction.TABLE,categoryId);
  }
}
