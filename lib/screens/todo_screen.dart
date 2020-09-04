import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/category_services.dart';
import 'package:todo_app/services/todo_services.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var _titleController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _dateController = TextEditingController();

  var _selectedValue;
  var _categories = List<DropdownMenuItem>();

  DateTime _dateTime = DateTime.now();

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  _todoDatePicker(BuildContext context) async {
    var _datePicker = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if(_datePicker!=null){
      setState(() {
        _dateTime = _datePicker;
        _dateController.text = DateFormat("yyyy-MM-dd").format(_dateTime);
      });
    }
  }

  _loadCategories() async {
    var categoryServices = CategoryServices();
    var categories = await categoryServices.readCategory();
    categories.forEach((element) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(element['name']),
          value: element['name'],
        ));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
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
        title: Text('TODO - List'),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Your title",
                labelText: "Title",
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: "Your duration",
                labelText: "Duration",
              ),
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                  hintText: "Date",
                  labelText: "Pick date",
                  prefixIcon: InkWell(
                    onTap: () {
                      _todoDatePicker(context);
                    },
                    child: Icon(Icons.calendar_today),
                  )),
            ),
            DropdownButtonFormField(
              hint: Text('Categories'),
              value: _selectedValue,
              items: _categories,
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            SizedBox(
              height: 15,
            ),
            RaisedButton(
              color: Colors.blue,
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async{
                var todoObject = Todo();
                todoObject.title = _titleController.text;
                todoObject.description = _descriptionController.text;
                todoObject.todoDate = _dateController.text;
                todoObject.category = _selectedValue.toString();
                todoObject.isFinished = 0;

                var _todoService = TodoServices();
                var result = await _todoService.saveTodo(todoObject);

                print(result);
                if(result > 0){
                  Navigator.pop(context);
                  Future.delayed(Duration(milliseconds: 600),(){
                    _showSuccessMessage(Text('Schedule created successfully'));
                  });
                }

              },
            ),
          ],
        ),
      ),
    );
  }
}
