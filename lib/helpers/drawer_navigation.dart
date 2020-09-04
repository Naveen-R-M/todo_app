import 'package:flutter/material.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/screens/categories.dart';
import 'package:todo_app/screens/home.dart';
import 'package:todo_app/screens/todos_category.dart';
import 'package:todo_app/services/category_services.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  List<Widget> _categoryList = List<Widget>();
  CategoryServices _categoryServices = CategoryServices();

  getAllCategories() async {
    var categories = await _categoryServices.readCategory();
    categories.forEach((value) {
      setState(() {
        var cat = Category();
        cat.id = value["id"];
        var idd = cat.id;
        _categoryList.add(InkWell(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TodosCategory(category: value["name"],))),
          child: ListTile(
            title: Text(
              '$idd' + ')  ' + value['name'],
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ));
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              accountName: Text('#Trojans'),
              accountEmail: Text('hashtrojans@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('images/batman.jpg'),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              leading: Icon(
                Icons.home,
                color: Colors.blue,
              ),
              title: Text(
                'Home',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CategoriesScreen()));
              },
              leading: Icon(
                Icons.category,
                color: Colors.blue,
              ),
              title: Text(
                'Categories',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Divider(),
            Column(
              children: _categoryList,
            )
          ],
        ),
      ),
    );
  }
}
