<template>
  <div class="">
    <header
      class="h-16 w-full bg-green-200 px-6 flex justify-between items-center"
    >
    <img src="@/assets/images/mongoDB_logo.png" width="240"/>
      <h1 class="text-xl text-green-900">MongoDB Atlas - App Service : Task Management</h1>
      <button
        class="text-lg text-white capitalize px-6 py-2 bg-green-900 rounded-md"
        @click="handleModal(true)"
      >
        create
      </button>
    </header>
    <section className="mt-10 flex justify-center px-6">
      <ul className="w-full">
        <li
          v-for="user in users"
          :key="user._id"
          className="border-2 p-2 mb-2 rounded-lg flex items-center"
        >
          <table border="0" width="100%">
            <tr>
              <td width="10%">
                <h1 v-if= "user.priority == 'top'"><img src="@/assets/images/top.png" width="50"/></h1>
                <h1 v-else-if="user.priority == 'normal'"><img src="@/assets/images/normal.png" width="50"/></h1>
                <h1 v-else><img src="@/assets/images/low.png" width="50"/></h1>
              </td>
              <td width="70%">
                <section className="">
            <h2 className="capitalize font-semibold mb-1">{{ user.title }}</h2>
            <p className="capitalize text-gray-500 mb-1">{{ user.dueDate }}</p>
            <p className="capitalize text-green-900 font-medium text-sm mb-2">
              {{ user.task }}
            </p>
            </section>
              </td>
              <td width="20%">
                <div className="flex">
              <button
                className="text-sm text-green-900 capitalize px-4 py-2 mr-4 border border-green-500 rounded-md"
                @click="deleteAUser(user._id)"
              >
                delete
              </button>
              <button
                className="text-sm text-white capitalize px-4 py-2 bg-green-900 rounded-md"
                @click="handleEditClick(user._id)"
              >
              <!--button
                className="text-sm text-white capitalize px-4 py-2 bg-indigo-900 rounded-md"
                @click="handleEditClick(user._id)"
              -->
                edit
              </button>
            </div>


              </td>
            </tr>
          </table>
        </li>
      </ul>
    </section>
    <Modal
      :isModal="isModal"
      :isEdit="isEdit"
      :handleModal="handleModal"
      :updateUserValue="updateUserValue"
      :editingId="editingId"
    />
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import UserIcon from '@/assets/svg/UserIcon.vue';
import Modal from '@/components/Modal.vue';
import { IUser } from '@/models/user.interface';
import { app, credentials } from '@/utils/mongo.client';
import { BSON } from 'realm-web';
export default defineComponent({
  name: 'App',
  components: {
    UserIcon,
    Modal,
  },
  data: () => ({
    isModal: false,
    isEdit: false,
    users: [] as IUser[],
    userValue: '',
    editingId: '',
    mongodb: "/assets/images/MongoDB_Logo.svg.png"
  }),
  methods: {
    handleModal(state: boolean) {
      this.isModal = state;
      this.isEdit = false;
    },
    handleEditClick(id: string) {
      this.isModal = true;
      this.isEdit = true;
      this.editingId = id;
    },
    async getListOfUsers() {
      const user: Realm.User = await app.logIn(credentials);
      const listOfUser: Promise<IUser[]> = user.functions.getAllTasks();
      listOfUser.then((resp) => {

        console.log(resp);
        this.users = resp;
      });
    },
    updateUserValue(value: any) {
      this.userValue = value;
    },
    async deleteAUser(id: string) {
      const user: Realm.User = await app.logIn(credentials);
      const delUser = user.functions.deleteUserTask(
        new BSON.ObjectID(id).toString()
      );
      delUser.then((resp) => {
        this.updateUserValue(resp.deletedCount);
      });
    },
  },
  watch: {
    userValue(latestValue) {
      if (latestValue !== '') {
        this.getListOfUsers();
      }
    },
  },
  mounted() {
    this.getListOfUsers();
  },
});
</script>

<style></style>