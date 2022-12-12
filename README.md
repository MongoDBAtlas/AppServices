<img src="https://companieslogo.com/img/orig/MDB_BIG-ad812c6c.png?t=1648915248" width="50%" title="Github_Logo"/> <br>

# MongoDB Atlas AppServices
Atlas의 App Services를 이용한 웹 애플리케이션과 모바일 애플리케이션 입니다.
웹애플리케이션은 Vue를 이용하며 모바일은 Flutter를 이용하여 구현 됩니다.

![Architecture](/images/image01.png)

애플리케이션은 Task를 등록 하는 것으로 컬렉션 이름은 userTask로 하여 줍니다.
데이터는 다음과 같은 형태로 등록 하여 줍니다.

````json
 {
    dueDate: '2022-11-25',
    isCompleted: false,
    isImportant: true,
    memo: 'Building Mobile Application with Flutter SDK',
    priority: 'top',
    task: 'Writing up what is App Services',
    title: 'Preparing MongoDB Day'
  }
````

## Serverless Back end (Functions)
Vue로 개발된 web application으로 사용자의 Task에 대한 CRUD를 제공 합니다. Front-end는 Vue로 구현되어 Docker로  배포 하며 App Service의 Function이 백엔드에서 CRUD 관련 서비스를 제공 합니다.
[Vue-app](https://github.com/MongoDBAtlas/AppServices/tree/main/vue-app)

## Mobile Device Sync
Flutter를 이용해 개발된 모바일 애플리케이션으로 사용자의 task에 대한 CRUD를 모바일로 제공합니다. 모바일 특성상 애플리케이션 자체 데이터베이스(Realm database)를 이용해 데이터를 처리 합니다. Realm database는 자동으로 App Services백엔드와 연결 하여 필요한 데이터를 동기화 하고 데이터 변경이 발생한 경우 변경 내용을 전달 하여 주며 또한 변경된 내용을 받는 양 방향 데이터를 동기화 하여 줍니다.
[Mobile-app](https://github.com/MongoDBAtlas/AppServices/tree/main/mobile-app)