import 'dart:async';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';
import '../model.dart';
import '../main.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key, title}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage>{
  int _allTasksCount = MyApp.allTasksRealm.all<UserTask>().length;
  int _importantTasksCount = MyApp.allTasksRealm.query<UserTask>('isImportant == true').length;
  int _normalTasksCount = MyApp.allTasksRealm.query<UserTask>('isImportant == false').length;
  late final StreamSubscription _subscription;

  @override
  void initState()
  {
    super.initState();
    _subscription = MyApp.allTasksRealm.all<UserTask>().changes.listen((c) {
      c.inserted; // indexes of inserted objects
      for (int index in c.inserted) {
        setState(() {
          _allTasksCount = MyApp.allTasksRealm.all<UserTask>().length;
          _importantTasksCount = MyApp.allTasksRealm.query<UserTask>('isImportant == true').length;
          _normalTasksCount = MyApp.allTasksRealm.query<UserTask>('isImportant == false').length;

          print("Data is inserted ${index}, ${c.inserted.toString()} ${MyApp.allTasksRealm.all<UserTask>().length}");

        });
      }
      for (int index in c.deleted) {
        setState(() {
          _allTasksCount = MyApp.allTasksRealm.all<UserTask>().length;
          _importantTasksCount = MyApp.allTasksRealm.query<UserTask>('isImportant == true').length;
          _normalTasksCount = MyApp.allTasksRealm.query<UserTask>('isImportant == false').length;
          print("Data is deleted ${_allTasksCount}, ${_importantTasksCount} ${_normalTasksCount}");

          print("Data is deleted ${index}, ${c.inserted.toString()} ${MyApp.allTasksRealm.all<UserTask>().length}");

        });
      }
      for (int index in c.modified) {
        setState(() {
          _allTasksCount = MyApp.allTasksRealm.all<UserTask>().length;
          _importantTasksCount = MyApp.allTasksRealm.query<UserTask>('isImportant == true').length;
          _normalTasksCount = MyApp.allTasksRealm.query<UserTask>('isImportant == false').length;
          print("Data is deleted ${_allTasksCount}, ${_importantTasksCount} ${_normalTasksCount}");

          print("Data is deleted ${index}, ${c.inserted.toString()} ${MyApp.allTasksRealm.all<UserTask>().length}");

        });
      }
      c.newModified; // indexes of modified objects
      c.results; // the full List of objects

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding:  EdgeInsets.only(top: 5,  bottom: 30),
              child: Text("Task Manager", style: TextStyle(fontWeight:FontWeight.bold, fontSize: 30)),
            ),

            Image.asset('repo/images/MongoDB_Logo.svg.png', width:200,height:50, fit: BoxFit.fill),

            const Padding(
              padding:  EdgeInsets.only(top: 20),
              child: Text('All tasks count:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            Text('$_allTasksCount', style: Theme.of(context).textTheme.headline4),

            const Padding(
              padding:  EdgeInsets.only(top: 10),
              child: Text('Important tasks count:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red,fontSize: 20)),
            ),
            Text('$_importantTasksCount', style: Theme.of(context).textTheme.headline4),

            const Padding(
              padding:  EdgeInsets.only(top: 10),
              child: Text('Normal tasks count:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,fontSize: 20)),
            ),

            Text('$_normalTasksCount', style: Theme.of(context).textTheme.headline4),
          ],
        ),
      ),
    );
  }
}
