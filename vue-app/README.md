<img src="https://companieslogo.com/img/orig/MDB_BIG-ad812c6c.png?t=1648915248" width="50%" title="Github_Logo"/> <br>

# Serverless Back end (Functions)
Business Logic을 포함하는 App Services를 Atlas에 생성하고 Front End를 위한 웹애플리케이션을 Vue.js를 이용하여 개발 하고 Docker로 실행 하여 줍니다.

![Architecture](/vue-app/images/image01.png)

## App Services 
Atlas Console에 로그인 후 App Services Tab에서 새로운 Application을 생성 합니다.   
생성 옵션에서 Link your Database에서 연결할 Atlas의 Database Cluster를 선택 하여 줍니다.   
또한 Advanced configuration에서 Application이 배치될 위치를 지정 할 수 있습니다. 한개의 Region에만 배포 하거나 Global하게 배포가 가능 합니다. Database Cluster의 위치 및 클라이언트의 위치를 고려한 배치를 선택 하면 네트워크 레이턴시를 최적화 할 수 있습니다. 이번 구성에서는 Global 로 하고 Virginia를 선택 하여 줍니다. (선택하지 않으면 현재 위치와 가장 가까운 곳으로 자동 선택 됩니다) .  
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

## Vue JS Code
생성한 App Services에 대한 설정을 한 후 Docker image를 생성 합니다.    
환경 정보를 위해 .env 파일을 생성 하고 다음과 같이 작성 하여 줍니다.    

```` javascript
VUE_APP_REALM_APP_ID=appservice-abcd
VUE_APP_API_KEY=abcdefghijklmnopqrstuvwxyz
```` 

API_key는 App Services에서 생성한 Key 이며 VUE_APP_REALM_APP_ID은 생성한 App Services의 ID 입니다.
이를 App Services에서 확인 할 수 있습니다.
![Env](/vue-app/images/image09.png)

App Services의 Function 과 UI의 호출은 App.vue의 106 라인에서 확인 할 수 있습니다.
user.functions.*** 로 하여 호출 되며 해당 이름이 app services에 등록된 functions 이름과 동일 해야 합니다.
```` javascript
async getListOfUsers() {
      const user: Realm.User = await app.logIn(credentials);
      const listOfUser: Promise<IUser[]> = user.functions.getAllTasks();
      listOfUser.then((resp) => {

        console.log(resp);
        this.users = resp;
      });
    },
````

데이터가 생성을 확인 하기 위해서는 components/Modal.vue에서 확인 할 수 있습니다.
Functions에 등록된 이름과 파라미터가 순서대로 되어 있는지 확인 합니다.
```` javascript
 {
        const create = user.functions.createUserTask(
          this.task,
          this.memo,
          this.dueDate,
          this.isImportant,
          this.isCompleted,
          this.priority,
          this.title
        );
````

Docker image 생성을 위해 docker-composer를 실행 하여 줍니다.

```` shell
$ docker build -t vuejs-app:1.0 .   
[+] Building 54.6s (17/17) FINISHED                                                                                                                                           
 => [internal] load build definition from Dockerfile                                                                                                                     0.0s
 => => transferring dockerfile: 37B                                                                                                                                      0.0s
 => [internal] load .dockerignore                                                                                                                                        0.0s
 => => transferring context: 2B                                                                                                                                          0.0s
 => [internal] load metadata for docker.io/library/nginx:alpine                                                                                                          1.8s
 => [internal] load metadata for docker.io/library/node:lts-alpine                                                                                                       1.7s
 => [internal] load build context                                                                                                                                       14.0s
 => => transferring context: 298.98MB                                                                                                                                   13.8s
 => [production-stage 1/5] FROM docker.io/library/nginx:alpine@sha256:455c39afebd4d98ef26dd70284aa86e6810b0485af5f4f222b19b89758cabf1e                                   0.0s
 => [build-stage 1/6] FROM docker.io/library/node:lts-alpine@sha256:9eff44230b2fdcca57a73b8f908c8029e72d24dd05cac5339c79d3dedf6b208b                                     0.0s
 => CACHED [build-stage 2/6] WORKDIR /app                                                                                                                                0.0s
 => CACHED [build-stage 3/6] COPY package*.json ./                                                                                                                       0.0s
 => CACHED [build-stage 4/6] RUN npm install                                                                                                                             0.0s
 => [build-stage 5/6] COPY . .                                                                                                                                           5.0s
 => [build-stage 6/6] RUN npm run build                                                                                                                                 32.9s
 => CACHED [production-stage 2/5] RUN rm -rf /usr/share/nginx/html/*                                                                                                     0.0s 
 => CACHED [production-stage 3/5] COPY --from=build-stage /app/dist /usr/share/nginx/html                                                                                0.0s 
 => CACHED [production-stage 4/5] RUN rm /etc/nginx/conf.d/default.conf                                                                                                  0.0s 
 => CACHED [production-stage 5/5] COPY docker/nginx/nginx.conf /etc/nginx/conf.d                                                                                         0.0s 
 => exporting to image                                                                                                                                                   0.0s 
 => => exporting layers                                                                                                                                                  0.0s 
 => => writing image sha256:14319c4bdeabf7afdd458c384cb88d838ae2acb0fa962231767abad8fed18f50                                                                             0.0s
 => => naming to docker.io/library/vuejs-app:1.0                                                                                                                         0.0s

Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them
````

Docker를 실행 하기 전에 CROS를 허용 하여 주기 위해 App Services로 들어 갑니다.
App Settings 메뉴를 클릭 하면 Allowed Request Origins를 등록 할 수 있습니다. Vuejs-app가 실행 되는 서버의 IP를 등록 하여 줍니다. 

![Env](/vue-app/images/image10.png)


Docker 컨테이너를 수행 하여 줍니다. 컨테이너는 8080 포트로 nginx로 서비하도록 되어 있습니다. 일반 http 포트(80)으로 서비스 하기 위해 포트 매핑을 하여 줍니다. (해당 포트가 사용 중인 경우 다른 포트 사용이 가능 합니다. 이 경우 CORS의 origin에 포트를 포함한 주소를 기록해야 합니다.)


```` shell
$ docker run -it -p 80:8080 vuejs-app:1.0
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: /etc/nginx/conf.d/default.conf is not a file or does not exist
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2022/11/30 05:54:50 [notice] 1#1: using the "epoll" event method
2022/11/30 05:54:50 [notice] 1#1: nginx/1.23.1
2022/11/30 05:54:50 [notice] 1#1: built by gcc 11.2.1 20220219 (Alpine 11.2.1_git20220219) 
2022/11/30 05:54:50 [notice] 1#1: OS: Linux 5.4.17-2136.310.7.1.el8uek.x86_64
2022/11/30 05:54:50 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2022/11/30 05:54:50 [notice] 1#1: start worker processes
2022/11/30 05:54:50 [notice] 1#1: start worker process 22
2022/11/30 05:54:50 [notice] 1#1: start worker process 23
175.196.74.118 - - [30/Nov/2022:05:55:17 +0000] "GET / HTTP/1.1" 200 852 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36" "-"
175.196.74.118 - - [30/Nov/2022:05:55:17 +0000] "GET / HTTP/1.1" 200 852 "http://222.122.119.105/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36" "-"
````

![Web App](/vue-app/images/image11.png)

데이터 생성 및 수정의 정상 동작 여부를 확인 합니다.