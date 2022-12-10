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
Vue로 개발된 UI를 Docker를 이용하여 배포 하며 App Service의 Function을 호출하여 데이터를 처리 합니다.

## Mobile Device Sync
Flutter를 이용해 개발된 모바일 애플리케이션과 Atlas 간의 자동으로 데이터를 동기화 하여 줍니다.