<img src="https://companieslogo.com/img/orig/MDB_BIG-ad812c6c.png?t=1648915248" width="50%" title="Github_Logo"/> <br>

# Serverless Back end (Functions)
Business Logic을 포함하는 App Services를 Atlas에 생성하고 Front End를 위한 웹애플리케이션을 Vue.js를 이용하여 개발 하고 Docker로 실행 하여 줍니다.

![Architecture](/vue-app/images/image01.png)

## App Services 
Atlas Console에 로그인 후 App Services Tab에서 새로운 Application을 생성 합니다.
생성 옵션에서 Link your Database에서 연결할 Atlas의 Database Cluster를 선택 하여 줍니다. 
또한 Advanced configuration에서 Application이 배치될 위치를 지정 할 수 있습니다. 한개의 Region에만 배포 하거나 Global하게 배포가 가능 합니다. Database Cluster의 위치 및 클라이언트의 위치를 고려한 배치를 선택 하면 네트워크 레이턴시를 최적화 할 수 있습니다. 이번 구성에서는 Global 로 하고 Virginia를 선택 하여 줍니다. (선택하지 않으면 현재 위치와 가장 가까운 곳으로 자동 선택 됩니다)
![AppServices](/vue-app/images/image02.png)


비즈니스 로직, 즉 Atlas Database Cluster에 데이터를 생성, 수정, 삭제, 조회 등을 진행할 서비스를 생성 합니다. 다양한 방법으로 작성이 가능 하나 Serverless 형태로 운영 할 것임으로 Functions에서 관련한 서비스를 생성 하여 줍니다. 메뉴 중 Functions를 클릭 하고 새로운 function을 등록 합니다.
![Functions](/vue-app/images/image03.png)

연결된 database cluster에서 데이터베이스 mdb에 userTask 컬렉션에 데이터를 CRUD하는 간단한 코드입니다.

Settings에서 인증과 관련된 선택을 할 수 있습니다. 인증은 생성한 App Services의 인증을 이용할 것임으로 Application Authentication을 선택 합니다.

![Settings](/vue-app/images/image04.png)
Function Editor 에서 다음 코드를 입력 하여 줍니다.

createUserTask
```` javascript
exports = function(task, memo, dueDate, isImportant, isCompleted, priority, title){
let collection = context.services.get("mongodb-atlas").db("mdb").collection("userTask");
console.log("Create Task");

if (priority=="top") isImportant = true;

const generatedObjectId = new BSON.ObjectId();
    let newTask = collection.insertOne({"_id": generatedObjectId,"title": title, "task": task, "memo": memo,"dueDate": dueDate, "isImportant": isImportant, "isCompleted": isCompleted,"priority":priority });
    return newTask;
};
````

updateUserTask
```` javascript
exports = function(id,task, memo, dueDate, isImportant, isCompleted, priority, title){
let collection = context.services.get("mongodb-atlas").db("mdb").collection("userTask");
console.log("Update Task");

let updated = collection.findOneAndUpdate(
        {_id: BSON.ObjectId(id)},
        { $set: { "task": task, "memo": memo, "dueDate": dueDate,"isImportant": isImportant, "isCompleted": isCompleted, "priority": priority, "title": title } },
        { returnNewDocument: true }
      );
      return updated;
};
````

deleteUserTask
```` javascript
exports = function(arg){
  let collection = context.services.get("mongodb-atlas").db("mdb").collection("userTask");
  let deleteTask = collection.deleteOne({_id: BSON.ObjectId(arg)});
  return deleteTask;
};
````


getAllTasks
```` javascript
exports = function(arg){
  let collection = context.services.get("mongodb-atlas").db("mdb").collection("userTask");
  
  return collection.find({});
};
````

getSingleTask

```` javascript
exports = function(arg){
    let collection = context.services.get("mongodb-atlas").db("mdb").collection("userTask");
    return collection.findOne({_id: BSON.ObjectId(arg)});
};
````

저장을 하면 해당 Function이 생성이 되나 이에 대한 배포가 필요 합니다. 저장 후 Review Draft & Deploy를 클릭 하여 배포 하여 줍니다.

![Deploy](/vue-app/images/image05.png)


## App Services Authentication
생성한 app Services에 대한 인증 방법을 선택 합니다. 다양한 인증 방법을 제공하고 있으며 이에 맞는 인증을 애플리케이션에서 제공 하여야 합니다.
![Authentication](/vue-app/images/image06.png)

애플리케이션에서 별도로 인증을 위한 로그인을 구현 하지 않고 사전에 발급한 API Key를 이용하여 로그인 할 것임으로 이를 활성화 하여 줍니다.

Authentication 메뉴에서 Authencation Providers에서 API Keys를 활성화 하여 줍니다. Anonymous의 경우 인증과정 없이 사용 할 수 있음으로 필요한 경우 이를 활성화 합니다.

![Authentication](/vue-app/images/image07.png)

활성화를 선택 한 후 저장하면 Draft 형태로 저장 되는 것임으로 반드시 배포를 하여 주어야 합니다. 배포가 완료 되면 해당 인증 방법을 사용 할 수 있습니다.

API Key를 활성화 하면 인증용 키를 발급 할 수 있습니다. 생성된 이후 다시 키를 조회 할 수 없음으로 주의하여 보관하여야 합니다.
![API Key](/vue-app/images/image08.png)



## Mobile Device Sync
Flutter를 이용해 개발된 모바일 애플리케이션과 Atlas 간의 자동으로 데이터를 동기화 하여 줍니다.ion 