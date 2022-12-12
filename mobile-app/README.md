<img src="https://companieslogo.com/img/orig/MDB_BIG-ad812c6c.png?t=1648915248" width="50%" title="Github_Logo"/> <br>

# Mobile Device Sync
Moboile 애플리케이션을 위한 Backend Application Service로 Mobile 애플리케이션이 사용하는 내장 데이터 베이스 Realm과 Atlas 간의 데이터 동기화 서비스를 제공합니다.    
Mobile 애플리케이션에서 생성, 변경되는 데이터에 대한 백엔드로 전달을 책임져 줌으로 Mobile 애플리케이션의 개발 복잡도를 해소 하여 줍니다. 관련된 서비스는 데이터 동기화를 위한 기본 서비스 Device Sync 및 동기화 필드 권한 체크 등을 위한 Access Rule관리를 포함 합니다.    

![Architecture](/mobile-app/images/image01.png)

## App Services Device Sync
Atlas Console에 로그인 후 App Services Tab에서 새로운 Application을 생성 혹은 사용 중인 Application을 클릭  합니다.   

우선 동기화 대상 컬렉션에 대한 접근 권한을 설정 하기 위해 Rules을 등록 해야 합니다.

Data Access 메뉴 중 Rules를 선택 하면 연결 가능한 컬레션의 리스트를 볼 수 있습니다. 대상 컬렉션을 선택 후 readAndWriteAll 권한을 추가 하여 줍니다.


![Rules](/mobile-app/images/image02.png)


저장 후 Add present role을 하고 나서 배포 하여 줍니다.

저장 후 각 동기화 과정에서 필드별 권한 관리를 위해 Schema를 선택 후 Generate a Schema를 수행합니다.


![Schema](/mobile-app/images/image03.png)

기존 존재 하는 데이터를 샘플링하여 JSON Schema 가 생성됩니다. 각 필드의 이름과 데이터 타입등의 정보가 자동 생성 됩니다. 추가로 필수로 입력되야 하는 항목과 Primary 필드 등을 지정 할 수 있습니다.

필수 입력 값으로 id,dueDate 를 지정 하여 줍니다. (나머지 필드는 Optional 이 됩니다.)

````json
{
  "title": "userTask",
  "properties": {
    "_id": {
      "bsonType": "objectId"
    },
    "dueDate": {
      "bsonType": "string"
    },
    "isCompleted": {
      "bsonType": "bool"
    },
    "isImportant": {
      "bsonType": "bool"
    },
    "memo": {
      "bsonType": "string"
    },
    "priority": {
      "bsonType": "string"
    },
    "task": {
      "bsonType": "string"
    },
    "title": {
      "bsonType": "string"
    }
  },
  "required": [
    "_id",
    "dueDate"
  ]
}
````

설정 정보를 저장 합니다.

연결된 데이터를 저장 하기 위한 권한 설정이 완료 되었음으로 Device Sync에서 동기화를 설정 합니다.     
Device Sync 에서 Enable Syncing을 선택 합니다.

![DeviceSync](/mobile-app/images/image04.png)

Schema는 기존에 생성하였음으로 생성하지 않는 옵션으로 선택 합니다.

동기화 옵션을 Flexible을 선택 합니다. 동기화 대상 클러스터를 선택 합니다.

동기화를 위한 Query 가능한 필드를 선택합니다. 조회 조건으로 isCompleted, isImportant를 추가해 줍니다. 애플리케이션에서 해당 조건으로 검색된 결과를 보여주기 위함입니다.


![DeviceSyncQuery](/mobile-app/images/image05.png)

마지막으로 읽기 쓰기 권한 설정을 합니다.
전체 데이터에 대해 읽기 스기를 진행 할 것임으로 Users can read and write all data 를 선택 합니다.


![DeviceSyncQuery](/mobile-app/images/image06.png)

저장 후 Enable Sync 를 클릭 후 배포 하여 최종 완료 합니다.

저장이 완료 되면 동기화가 진행 되며 상단에 상태 정보가 나오며 동기화를 중단 혹은 중지 시킬 수 있습니다.


![DeviceSyncQuery](/mobile-app/images/image07.png)

## Flutter Application
Android Studio를 설치 하고 프로젝트를 로드 합니다.     
Device Sync와 연결을 위해 AppService ID를 /lib/main.dart 에 등록 하여 줍니다.

````dart
void main() async {
  const String appId = "<<app id>>";

  WidgetsFlutterBinding.ensureInitialized();

  MyApp.allTasksRealm = await createRealm(appId, CollectionType.allTasks);
  MyApp.importantTasksRealm = await createRealm(appId, CollectionType.importantTasks);
  MyApp.normalTasksRealm = await createRealm(appId, CollectionType.normalTasks);

  //final allTaskSub = realm.subscriptions.

  runApp(const MyApp());
}

````

또한 로그인 관련 정보를 수정 하여 줍니다. 기존 vue-app 에서 API-key를 생성 하였음으로 이를 활용 합니다. (Anonymous를 이용 하는 것도 가능하며 별도 로그인 화면을 구성하여 ID/Password로 로그인 하도록 할 수 있습니다.)


````dart
Future<Realm> createRealm(String appId, CollectionType collectionType) async {
  final appConfig = AppConfiguration(appId);
  final app = App(appConfig);
  //final user = await app.logIn(Credentials.anonymous());
  final user = await app.logIn(Credentials.apiKey("<<API Key>>"));

  final flxConfig = Configuration.flexibleSync(user, [UserTask.schema], path: await absolutePath("db_${collectionType.name}.realm"));
  var realm = Realm(flxConfig);
  print("Created local realm db at: ${realm.config.path}");
````

Flutter 개발과 관련한 정보는 다음 사이트에서 확인 할 수 있습니다.    
[Flutter SDK](https://www.mongodb.com/docs/realm/sdk/flutter/)


가상 디바이스를 실행 하고 애프리케이션을 배포 합니다.

애플리케이션을 실행 하면 userTask 컬렉션과 동기화가 됩니다.
초기 화면은 컬렉션 내 데이터에 대한 상태값입니다. 총 Task 개수와 isImportant 이 True 인 것의 개수와 False인 것의 개수를 보여 줍니다.

![Android](/mobile-app/images/image08.png)

하단의 두번재 메뉴를 클릭하면 리스트로 데이터를 조회 할 수 있습니다.


![Android](/mobile-app/images/image09.png)

리스트 한건을 클릭 하면 상세 정보와 삭제가 가능한 화면을 볼수 있습니다.


![Android](/mobile-app/images/image10.png)

하단의 +버튼을 클릭 하면 새로운 데이터를 생성할 수 있습니다. 데이터가 생성되면 데이터가 동기화되어 Atlas에 데이터가 등록 됩니다.

데모영상  


[![Watch the video](/mobile-app/images/image11.png)](https://youtu.be/84KlOODFJpk)
