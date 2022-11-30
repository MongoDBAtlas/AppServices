<template>
  <div
    class="h-screen w-screen bg-indigo-900 bg-opacity-30 z-30 top-0 fixed transform scale-105 transition-all ease-in-out duration-100"
    :class="isModal ? 'block' : 'hidden'"
  >
    <div
      class="flex flex-col justify-center items-center h-full w-full open-nav"
      @click="onClose"
    >
      <div class="flex justify-end w-11/12 lg:w-1/2 2xl:w-6/12">
        <div
          role="button"
          class="cursor-pointer w-6 h-6 rounded-full flex items-center justify-center bg-white"
          @click="handleModal()"
        >
          <CloseIcon />
        </div>
      </div>
      <section
        class="w-11/12 lg:w-1/2 2xl:w-6/12 bg-white flex justify-center items-center mt-5 rounded-lg"
      >
        <div class="w-11/12 py-8">
          <h2 class="capitalize text-xl text-gray-500 font-medium mb-4">
            {{ isEdit ? 'Edit Task' : 'add task' }}
          </h2>
          <form @submit.prevent="onSubmitForm">
            <fieldset class="mb-4">
              <label class="block text-sm text-gray-500 capitalize mb-1"
                >Title</label
              >
              <input
                type="text"
                name="name"
                v-model="title"
                required
                class="w-full h-10 border border-gray-500 rounded-sm px-4"
              />
            </fieldset>
            <fieldset class="mb-4">
              <label class="block text-sm text-gray-500 capitalize mb-1"
                >Task</label
              >
              <input
                type="text"
                name="task"
                v-model="task"
                required
                class="w-full h-10 border border-gray-500 rounded-sm px-4"
              />
            </fieldset>
            <fieldset class="mb-4">
              <label class="block text-sm text-gray-500 capitalize mb-1"
                >Memo</label
              >
              <input
                type="text"
                name="memo"
                v-model="memo"
                class="w-full h-10 border border-gray-500 rounded-sm px-4"
              />
            </fieldset>
            <fieldset class="mb-4">
              <label class="block text-sm text-gray-500 capitalize mb-1"
                >Due Data</label
              >
              <input
                type="text"
                name="dueDate"
                v-model="dueDate"
                class="w-full h-10 border border-gray-500 rounded-sm px-4"
              />
            </fieldset>
            <fieldset class="mb-4">
              <label class="block text-sm text-gray-500 capitalize mb-1"
                >Priority: {{priority}}</label
              >
              
              <select v-model="priority">
        <option value="top">Top</option>
        <option value="normal">Normal</option>
        <option value="low">Low</option>
      </select>
            </fieldset>
             <fieldset class="mb-4">
              <label class="block text-sm text-gray-500 capitalize mb-1">Important</label>
              <input type="checkbox" id="isImportant" v-model="isImportant" />
              <label for="checkbox">{{ isImportant }}</label>
                
                <label class="block text-sm text-gray-500 capitalize mb-1">Completed</label>
                <input type="checkbox" id="isCompleted" v-model="isCompleted" />
              <label for="checkbox">{{ isCompleted }}</label>
              
            </fieldset>
            <button
              class="text-white capitalize px-6 py-2 bg-green-900 rounded-md w-full"
            >
              save
            </button>
          </form>
        </div>
      </section>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, PropType } from 'vue';
import CloseIcon from '@/assets/svg/CloseIcon.vue';
import { IUser } from '@/models/user.interface';
import { app, credentials } from '@/utils/mongo.client';
import { BSON } from 'realm-web';
export default defineComponent({
  name: 'Modal',
  components: { CloseIcon },
  props: {
    isModal: Boolean,
    isEdit: Boolean,
    handleModal: Function,
    updateUserValue: Function as PropType<(value: any) => void>,
    editingId: String,
  },
  data: () => ({
    task: '',
    memo: '',
    dueDate: '',
    isImportant: false,
    isCompleted: false,
    priority: '',
    title: '',
  }),
  methods: {
    onClose(e: Event) {
      const target = e.target as HTMLDivElement;
      if (target.classList.contains('open-nav')) {
        this.handleModal!(false);
      }
    },
    async onSubmitForm() {
      const user: Realm.User = await app.logIn(credentials);
      if (this.isEdit) {
        const edit: Promise<IUser> = user.functions.updateUserTask(
          new BSON.ObjectID(this.editingId).toString(),
          this.task,
          this.memo,
          this.dueDate,
          this.isImportant,
          this.isCompleted,
          this.priority,
          this.title
        );
        edit.then((resp) => {
          this.updateUserValue!(resp._id!);
          this.task = '';
          this.memo = '';
          this.dueDate = '';
          this.isImportant = false;
          this.isCompleted = false;
          this.priority = '';
          this.title = '';
          this.handleModal!(false);
        });
      } else {
        const create = user.functions.createUserTask(
          this.task,
          this.memo,
          this.dueDate,
          this.isImportant,
          this.isCompleted,
          this.priority,
          this.title
        );
        create.then((resp) => {
          this.updateUserValue!(resp.insertedId);
          this.task = '';
          this.memo = '';
          this.dueDate = '';
          this.isImportant = false;
          this.isCompleted = false;
          this.priority = '';
          this.title = '';
        });
      }
    },
    async getAUser() {
      const user: Realm.User = await app.logIn(credentials);
      const getUser: Promise<IUser> = user.functions.getSingleTask(
        new BSON.ObjectID(this.editingId).toString()
      );
      getUser.then((resp) => {
        this.task = resp.task;
        this.memo = resp.memo;
        this.dueDate = resp.dueDate;
        this.isImportant = resp.isImportant;
        this.isCompleted = resp.isCompleted;
        this.priority = resp.priority;
        this.title = resp.title;
      });
    },
  },
  watch: {
    isEdit(latestValue) {
      if (latestValue === true) {
        this.getAUser();
      } else {
        this.task = '';
          this.memo = '';
          this.dueDate = '';
          this.isImportant = false;
          this.isCompleted = false;
          this.priority = '';
          this.title = '';
      }
    },
  },
});
</script>