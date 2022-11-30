import * as Realm from 'realm-web';

const REALM_APP_ID = process.env.VUE_APP_REALM_APP_ID;
const VUE_APP_API_KEY = process.env.VUE_APP_API_KEY;
console.log("REALM_APP_ID"+REALM_APP_ID);
export const app: Realm.App = new Realm.App({ id: REALM_APP_ID! });
export const credentials = Realm.Credentials.apiKey(VUE_APP_API_KEY);
//export const credentials = Realm.Credentials.anonymous();