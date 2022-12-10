import 'dart:async';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexible_sync/sub/detailPage.dart';

import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';
import '../model.dart';
import '../main.dart';
import 'detailPage.dart';

class listView extends StatefulWidget {
  const listView({Key? key}) : super(key: key);

  @override
  State<listView> createState() => _listViewState();
}

class _listViewState extends State<listView> {
  //late final StreamSubscription _subscription;
  late RealmResults<UserTask> _results;
  late List<UserTask> _userList = new List.empty(growable: true);
  late final StreamSubscription _subscription;

  @override
  void initState()
  {
    super.initState();
    _results = MyApp.allTasksRealm.all<UserTask>();
    _subscription = MyApp.allTasksRealm.all<UserTask>().changes.listen((c) {
      c.inserted; // indexes of inserted objects
      for (int index in c.inserted) {
        setState(() {
          _results = MyApp.allTasksRealm.all<UserTask>();

          print("Data is inserted ${index}, ${c.inserted.toString()} ${MyApp.allTasksRealm.all<UserTask>().length}");

        });
      }
      for (int index in c.deleted) {
        setState(() {
          _results = MyApp.allTasksRealm.all<UserTask>();

          print("Data is deleted ${index}, ${c.inserted.toString()} ${MyApp.allTasksRealm.all<UserTask>().length}");

        });
      }
      for (int index in c.modified) {
        setState(() {
          _results = MyApp.allTasksRealm.all<UserTask>();

          print("Data is deleted ${index}, ${c.inserted.toString()} ${MyApp.allTasksRealm.all<UserTask>().length}");

        });
      }
      c.newModified; // indexes of modified objects
      c.results; // the full List of objects

    });
  }


  @override
  void dispose() {
    //_subscription.cancel();
    super.dispose();
  }
  String _getImagePath(String level)
  {
    String imagePath = "";
    if (level == "top")
      imagePath = "repo/images/top.png";
    else if (level == "normal")
      imagePath = "repo/images/middle.png";
    else
      imagePath = "repo/images/low.png";
    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: _results.length ==0 ? Text ('There is no Task', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,)
              : ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                return Card(

                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => detailView(usertask: _results[index]) ));
                    },

                      child: Row(

                        children: <Widget> [
                          Image.asset(
                            _getImagePath(_results[index].priority!),
                            height: 40,
                            width: 40,
                            fit: BoxFit.contain,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 5),
                              child: Text("${_results[index].title!} ", style: TextStyle(fontSize:18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              )),
                              Padding(padding: EdgeInsets.only(left: 5),
                                  child: Text("Due date is  ${_results[index].dueDate} ", style: TextStyle(fontSize:16, color: Colors.blue),
                                    textAlign: TextAlign.left,
                                  )),

                              Padding(padding: EdgeInsets.only(left: 5),
                              child: Text("Task : ${_results[index].task!} ", style: TextStyle(fontSize:16),
                                textAlign: TextAlign.left,
                              )),

                            ],
                          ),

                        ],

                      )

                  ),

                  );
              }

          )
        ),

      ),
    );
  }
}