import 'package:flutter/material.dart';
import 'package:todo_app/helpers/drawer_navigation.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/screens/todo_screen.dart';
import 'package:todo_app/services/todo_services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TodoServices _todoService;

  List<Todo> _todoList = List<Todo>();

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  Future<dynamic> _dynamicTodos(){
    return getAllTodos();
  }

  getAllTodos()async{
    _todoService = TodoServices();
    _todoList = List<Todo>();
    var todos =  await _todoService.readTodo();
    todos.forEach((value){
      setState(() {
        var model = Todo();
        model.id = value['id'];
        model.title = value['title'];
        model.description = value['description'];
        model.todoDate = value['todoDate'];
        model.category = value['category'];
        model.isFinished = value['isFinished'];
        _todoList.add(model);
      });
    });
    return _todoList;
  }

  _showSuccessMessage(message){
    var _snackbar = SnackBar(content: message,backgroundColor: Colors.blue,);
    _globalKey.currentState.showSnackBar(_snackbar);
  }

  _deleteTodo(BuildContext context,String title,categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: Text('Delete $title'),
            actions: <Widget>[
              FlatButton(
                onPressed: () async {
                  var result = await _todoService.deleteTodo(categoryId);
                  if (result > 0){
                    Navigator.of(context).pop();
                    _dynamicTodos();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('TODO App'),
      ),
      drawer: DrawerNavigation(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TodoScreen()));
        },
      ),
      body: FutureBuilder(
        future: _dynamicTodos(),
        builder: (context,snapshot){
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context,index){
              return Card(
                elevation: 0.7,
                margin: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 10
                ),
                child: ListTile(
                  leading: Text(snapshot.data[index].todoDate),
                  title: Text(snapshot.data[index].title),
                  subtitle: Text(snapshot.data[index].description),
                  trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: (){
                        _deleteTodo(context,snapshot.data[index].title,_todoList[index].id);
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
