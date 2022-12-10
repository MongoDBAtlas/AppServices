import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';
import 'model.dart';

import 'sub/listPage.dart';
import 'sub/MainPage.dart';
import 'sub/newTask.dart';


void main() async {
  const String appId = "appservice-xozpi";

  WidgetsFlutterBinding.ensureInitialized();

  MyApp.allTasksRealm = await createRealm(appId, CollectionType.allTasks);
  MyApp.importantTasksRealm = await createRealm(appId, CollectionType.importantTasks);
  MyApp.normalTasksRealm = await createRealm(appId, CollectionType.normalTasks);

  //final allTaskSub = realm.subscriptions.

  runApp(const MyApp());
}

enum CollectionType { allTasks, importantTasks, normalTasks }

Future<Realm> createRealm(String appId, CollectionType collectionType) async {
  final appConfig = AppConfiguration(appId);
  final app = App(appConfig);
  //final user = await app.logIn(Credentials.anonymous());
  final user = await app.logIn(Credentials.apiKey("rsUtGs6641jsElj7GhqEkKYlwyyysYJJvgfJPRIABmUegDnP8VTW694eM8cfUyIF"));

  final flxConfig = Configuration.flexibleSync(user, [UserTask.schema], path: await absolutePath("db_${collectionType.name}.realm"));
  var realm = Realm(flxConfig);
  print("Created local realm db at: ${realm.config.path}");

  final RealmResults<UserTask> query;
  if (collectionType == CollectionType.allTasks) {
    query = realm.all<UserTask>();
  } else {
    query = realm.query<UserTask>(r'isImportant == $0', [collectionType == CollectionType.importantTasks]);
  }

  realm.subscriptions.update((mutableSubscriptions) {
    mutableSubscriptions.add(query);
  });
  await realm.subscriptions.waitForSynchronization();
  print("Syncronization completed for realm: ${realm.config.path}");
  return realm;
}

Future<String> absolutePath(String fileName) async {
  final appDocsDirectory = await getApplicationDocumentsDirectory();
  final realmDirectory = '${appDocsDirectory.path}/mongodb-realm';
  if (!Directory(realmDirectory).existsSync()) {
    await Directory(realmDirectory).create(recursive: true);
  }
  return "$realmDirectory/$fileName";
}

class MyApp extends StatelessWidget {
  static late Realm allTasksRealm;
  static late Realm importantTasksRealm;
  static late Realm normalTasksRealm;

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MongoDB Day - Seoul',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'MongoDB Atlas App Service'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
with SingleTickerProviderStateMixin {

  late final StreamSubscription _subscription;

  TabController? controller;

  @override
  void initState()
  {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: TabBarView(
          children: <Widget>[
            MainPage(title: widget.title),
            listView(),
            NewTaskPage(),
          ],
          controller: controller,
        ),
      bottomNavigationBar: TabBar(tabs: <Tab> [
        Tab(icon: Icon(Icons.account_balance, color: Colors.blue),text: "Main"),
        Tab(icon: Icon(Icons.account_tree, color: Colors.blue), text: "List"),
        Tab(icon: Icon(Icons.add_box, color: Colors.blue), text: "Add")
      ],
        controller: controller,
      ),
    );
  }
}
