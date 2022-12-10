import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';
import '../model.dart';
import '../main.dart';


class detailView extends StatelessWidget {
  final UserTask? usertask;
  const detailView({Key? key, this.usertask}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    void _deleteTasks(UserTask deleteTask) async {
      MyApp.allTasksRealm.write(() {
        MyApp.allTasksRealm.delete(deleteTask);
      });

    }

    return Scaffold(
      appBar: AppBar( title: Text("Task Detail")),
      body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                Padding(padding: EdgeInsets.all(30),
                  child: Text('MongoDB Task Manager Detail', style: TextStyle(fontSize:20,fontWeight: FontWeight.bold, color: Colors.blue),
                      textAlign: TextAlign.left),),
                Padding(padding: EdgeInsets.only(left: 5,top: 15),
                  child: Text('Title :', style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left),),
                Padding(padding: EdgeInsets.only(left: 5),
                  child: Text('${usertask!.title}', style: TextStyle(fontSize:20),
                      textAlign: TextAlign.left),),

                Padding(padding: EdgeInsets.only(left: 5,top: 15),
                    child: Text('Task :', style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left),
                ),
                Padding(padding: EdgeInsets.only(left: 5),
                  child: Text('${usertask!.task}', style: TextStyle(fontSize:20),
                      textAlign: TextAlign.left),
                ),
                Padding(padding: EdgeInsets.only(left: 5,top: 15),
                    child: Text('Memo : ', style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left),
                ),
                Padding(padding: EdgeInsets.only(left: 5),
                  child: Text('${usertask!.memo}', style: TextStyle(fontSize:20),
                      textAlign: TextAlign.left),
                ),
                Padding(padding: EdgeInsets.only(left: 5,top: 15),
                    child: Text('Due Date :', style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left),
                ),
                Padding(padding: EdgeInsets.only(left: 5),
                  child: Text('${usertask!.dueDate}', style: TextStyle(fontSize:20),
                      textAlign: TextAlign.left),
                ),
                Padding(padding: EdgeInsets.only(left: 5, top: 15),
                  child: Text("Priority :", style: TextStyle(fontSize:20,fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                ),
                Padding(padding: EdgeInsets.only(left: 5),
                  child: Text("${usertask!.priority}", style: TextStyle(fontSize:20),
                      textAlign: TextAlign.left),
                ),
                Padding(padding: EdgeInsets.only(left: 5,top: 15),
                    child: Text('Important :', style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left),),
                Padding(padding: EdgeInsets.only(left: 5),
                  child: Text('${usertask!.isImportant}', style: TextStyle(fontSize:20),
                      textAlign: TextAlign.left),),
                Padding(padding: EdgeInsets.only(left: 5,top: 15),
                    child: Text('Completed ', style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left),),
                Padding(padding: EdgeInsets.only(left: 5,bottom: 20),
                  child: Text('${usertask!.isCompleted}', style: TextStyle(fontSize:20),
                      textAlign: TextAlign.left),
                ),
                Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Go back'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        AlertDialog dialog = AlertDialog(
                          title: Text('Delete Task'),
                          content: Text('Delete the task ${usertask!.title}', style: TextStyle(fontSize: 20)),
                          actions: [
                            ElevatedButton(onPressed: (){
                              _deleteTasks(usertask!);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApp() ));
                            }, child: Text("YES")),
                            ElevatedButton(onPressed: (){
                              Navigator.of(context).pop();
                            }, child: Text("NO")),
                          ],
                        );
                        showDialog(context: context, builder: (BuildContext context) => dialog);
                      },
                      child: Text('Delete'),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ), //Checkbox Row



              ]
          )
      ),
    );
  }
}
