import 'package:flutter/material.dart';
import 'package:workin_with_database/database_helper.dart';
import 'package:workin_with_database/models/user.dart';

List _users;
void main() async {
  var db = new DatabaseHelper();
  int savedUserId = await db.saveUser(new User("Sameer","123"));
//  print(savedUserId);
  _users = await db.getAllUsers();
  for(int i =0 ; i< _users.length ; i++){
    User user =User.map(_users[i]);
    print("Username = ${user.username}");
  }
  runApp(new MaterialApp(
    title: 'Database',
    home: new Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Database'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
    );
  }
}
