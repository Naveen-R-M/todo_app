import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/screens/home.dart';
import 'package:todo_app/services/category_services.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _categoryEditController = TextEditingController();
  var _descriptionEditController = TextEditingController();
  var _categoryServices = CategoryServices();
  var _category = Category();

  List<Category> _categoryList = List<Category>();

  var category;

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  Future<dynamic> dynamicCategories() {
    return getAllCategories();
  }

  getAllCategories() async {
    _categoryList = List<Category>();
    var categories = await _categoryServices.readCategory();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category["name"];
        categoryModel.description = category["description"];
        categoryModel.id = category["id"];
        _categoryList.add(categoryModel);
      });
    });
    return _categoryList;
  }

  _editCategories(BuildContext context, categoryId) async {
    category = await _categoryServices.readCategoryById(categoryId);
    setState(() {
      _categoryEditController.text = category[0]["name"] ?? 'No name';
      _descriptionEditController.text =
          category[0]["description"] ?? "No description";
    });
    _editFromDialog(context);
  }

  _showFromDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: Text('Categories Form'),
            actions: <Widget>[
              FlatButton(
                onPressed: () async {
                  if (_categoryController.text.length != 0) {
                    if (_descriptionController.text.length != 0) {
                      _category.name = _categoryController.text;
                      _category.description = _descriptionController.text;
                      var result =
                          await _categoryServices.saveCategory(_category);
                      if(result>0){
                        _showSuccessMessage(Text("Data saved successfully"));
                        getAllCategories();
                      }
                    }
                  }
                  Navigator.pop(context);
                },
                child: Text('Save'),
                color: Colors.green,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
                color: Colors.red,
              ),
            ],
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _categoryController,
                    decoration: InputDecoration(
                        labelText: 'Category', hintText: 'Write a category'),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Write a description'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _editFromDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: Text('Edit Categories Form'),
            actions: <Widget>[
              FlatButton(
                onPressed: () async {
                  if (_categoryEditController.text.length != 0) {
                    if (_descriptionEditController.text.length != 0) {
                      _category.id = category[0]["id"];
                      _category.name = _categoryEditController.text;
                      _category.description = _descriptionEditController.text;
                      var result =
                          await _categoryServices.updateCategory(_category);
                      if(result>0){
                        _showSuccessMessage(Text("Data updated successfully"));
                      }
                    }
                  }
                  Navigator.of(context).pop();
                },
                child: Text('Update'),
                color: Colors.green,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
                color: Colors.red,
              ),
            ],
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _categoryEditController,
                    decoration: InputDecoration(
                        labelText: 'Category', hintText: 'Write a category'),
                  ),
                  TextField(
                    controller: _descriptionEditController,
                    decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Write a description'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _deleteFromDialog(BuildContext context,String title,categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: Text('Delete $title'),
            actions: <Widget>[
              FlatButton(
                onPressed: () async {
                  var result = await _categoryServices.deleteCategory(categoryId);
                  if (result > 0){
                    Navigator.of(context).pop();
                    dynamicCategories();
                    _showSuccessMessage(Text("$title deleted Successfully"));
                  }
                },
                child: Text('Delete'),
                color: Colors.red,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
                color: Colors.green,
              ),
            ],
          );
        });
  }

  _showSuccessMessage(message){
    var _snackbar = SnackBar(content: message,backgroundColor: Colors.blue,);
    _globalKey.currentState.showSnackBar(_snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: RaisedButton(
            elevation: 0.0,
            color: Colors.blue,
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen()));
            }),
        title: Text('Categories'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _categoryController.text = '';
            _descriptionController.text = '';
          });
          _showFromDialog(context);
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: dynamicCategories(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 0.7,
                margin: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 10
                ),
                child: ListTile(
                  leading: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        _editCategories(context, snapshot.data[index].id);
                      }),
                  title: Text(snapshot.data[index].name),
                  subtitle: Text(snapshot.data[index].description),
                  trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: (){
                        _deleteFromDialog(context,snapshot.data[index].name,_categoryList[index].id);
                      }),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
