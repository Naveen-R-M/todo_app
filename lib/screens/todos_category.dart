import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/todo_services.dart';

class TodosCategory extends StatefulWidget {
  final String category;
  TodosCategory({this.category});
  @override
  _TodosCategoryState createState() => _TodosCategoryState();
}

class _TodosCategoryState extends State<TodosCategory> {
  List<Todo> _todoList = List<Todo>();
  var _todoService = TodoServices();
  getTodosByCategory()async{
    var todos = await _todoService.readByCategory(this.widget.category);
    todos.forEach((value){
      setState(() {
        var model = Todo();
        model.title = value['title'];
        model.description = value['description'];
        model.todoDate = value['todoDate'];
        _todoList.add(model);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTodosByCategory();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODOs by Categories'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _todoList.length,
              itemBuilder: (context,index){
                return Card(
                  elevation: 0.7,
                  margin: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 10
                  ),
                  child: ListTile(
                    leading: Text(_todoList[index].todoDate ?? "No Date"),
                    title: Text(_todoList[index].title ?? "No title"),
                    subtitle: Text(_todoList[index].description ?? "No description"),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
