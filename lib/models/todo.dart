class Todo{
  int id;
  String title;
  String description;
  String category;
  String todoDate;
  int isFinished;

  todoMap(){
    var map = Map<String,dynamic>();
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['category'] = category;
    map['todoDate'] = todoDate;
    map['isFinished'] = isFinished;

    return map;
  }
}