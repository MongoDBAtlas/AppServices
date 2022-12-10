import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';
import '../model.dart';
import '../main.dart';



class NewTaskPage extends StatefulWidget {
  NewTaskPage({Key? key, title}) : super(key: key);

  @override
  State<NewTaskPage> createState() => _NewTaskPage();
}

class _NewTaskPage extends State<NewTaskPage> {
  final titleController = TextEditingController();
  final taskController = TextEditingController();
  final memoController = TextEditingController();
  final dueDateController = TextEditingController();
  String? _priority = "";
  bool? _important = false;
  bool? _completed = false;

  _priorityChange(String? value)
  {
    setState(() {
      _priority= value;
    });
  }

  void _createNewTasks(UserTask newTask) async {
    MyApp.allTasksRealm.write(() {
      MyApp.allTasksRealm.add(newTask);
    });

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget> [
              Padding(
                padding: EdgeInsets.all(30),
                child: Text("New Task",style: TextStyle(fontSize:20,fontWeight: FontWeight.bold, color: Colors.blue)),
              ),

              const Padding(
                padding:  EdgeInsets.only(top: 5, left: 10),
                child: Text('Title :', style: TextStyle(fontSize:18,fontWeight: FontWeight.bold), textAlign: TextAlign.start),
              ),

              TextField(controller: titleController, keyboardType: TextInputType.text, maxLines: 1),

              const Padding(
                padding: EdgeInsets.only(top: 15, left: 10),
                child: Text('Task :', style: TextStyle(fontSize:18,fontWeight: FontWeight.bold), textAlign: TextAlign.start),
              ),
              TextField(controller: taskController, keyboardType: TextInputType.text, maxLines: 1),

              const Padding(
                padding: EdgeInsets.only(top: 15, left: 10),
                child: Text('Memo :', style: TextStyle(fontSize:18,fontWeight: FontWeight.bold), textAlign: TextAlign.start),
              ),
              TextField(controller: memoController, keyboardType: TextInputType.text, maxLines: 2),

              const Padding(
                padding: EdgeInsets.only(top: 15, left: 10),
                child: Text('Due Date :', style: TextStyle(fontSize:18,fontWeight: FontWeight.bold), textAlign: TextAlign.start),
              ),

              TextField(controller: dueDateController, keyboardType: TextInputType.text, maxLines: 1),

              const Padding(
                padding: EdgeInsets.only(top: 15, left: 10),
                child: Text('Priority :', style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
              ),
              Row(
                children: <Widget> [
                  Radio(value: 'top', groupValue: _priority, onChanged: _priorityChange),
                  const Text('Top'),
                  Radio(value: 'normal', groupValue: _priority, onChanged: _priorityChange),
                  const Text('Normal'),
                  Radio(value: 'low', groupValue: _priority, onChanged: _priorityChange),
                  const Text('Low'),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('Important : '),
                  Checkbox(value: _important, onChanged: (bool? check) {
                    setState(() {
                      _important = check;
                    });
                  }
                  ),
                  Text('Completed : '),
                  Checkbox(value: _completed, onChanged: (bool? check) {
                    setState(() {
                      _completed = check;
                    });
                  }
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ), //Checkbox Row

              Container(
                padding: EdgeInsets.only(left: 140, top: 30),
                child:
              ElevatedButton(onPressed: () {
                UserTask newTask = new UserTask(ObjectId(), dueDateController.value.text,
                    isCompleted: _completed,
                    isImportant: _important,
                    memo: memoController.value.text,
                    task: taskController.value.text,
                    title: titleController.value.text,
                    priority: _priority
                );
                AlertDialog dialog = AlertDialog(
                  title: Text('New Task'),
                  content: Text('Add new task ${newTask.title}', style: TextStyle(fontSize: 20)),
                  actions: [
                    ElevatedButton(onPressed: (){
                      _createNewTasks(newTask);
                      Navigator.of(context).pop();
                      //Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApp() ));
                    }, child: Text("YES")),
                    ElevatedButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, child: Text("NO")),
                  ],
                );
                showDialog(context: context, builder: (BuildContext context) => dialog);
              }, child: Text("Add New Task"))

              ),
            ],


        ),
        ),
    );
  }
}
