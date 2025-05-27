<template>
  <v-container>
    <v-card class="pa-4">
      <v-card-title>Личный кабинет</v-card-title>
      <v-card-text>
        <v-text-field v-model="user.name" label="ФИО" readonly outlined></v-text-field>
        <v-text-field v-model="user.email" label="Email" readonly outlined></v-text-field>
        <v-btn color="primary" disabled @click="editProfile">Редактировать</v-btn>
      </v-card-text>
    </v-card>

    <v-card class="pa-4 mt-4">
      <v-card-title>Прикрепленные документы</v-card-title>
      <v-card-text>
        <v-list>
          <v-list-item v-for="doc in documents" :key="doc.id">
            <v-list-item-content>
              <v-list-item-title>
                <a :href="getDocumentUrl(doc.file_path)" target="_blank" rel="noopener noreferrer">
                  {{ doc.file_name }}
                </a>
              </v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list>
        <v-file-input label="Загрузить новый документ" accept="application/pdf" @change="uploadFile"></v-file-input>
      </v-card-text>
    </v-card>

    <v-card class="pa-4 mt-4">
      <v-card-title>Профориентационный тест</v-card-title>
      <v-card-text>
        <v-btn color="success" to="/proftest">Пройти тест</v-btn>
      </v-card-text>
    </v-card>

    <v-card class="pa-4 mt-4" v-if="testResult">
      <v-card-title>Ваш последний результат RIASEC</v-card-title>
      <v-card-text>
        <p><strong>Тип:</strong> {{ testResult.type }}</p>
        <p>{{ testResult.description }}</p>
        <p><strong>Профессии:</strong> {{ testResult.professions.join(', ') }}</p>
        <p><strong>Университеты:</strong></p>
        <ul>
          <li v-for="(u, i) in testResult.universities" :key="i">
            {{ u.name }} – {{ u.programs.join(', ') }}
          </li>
        </ul>
      </v-card-text>
    </v-card>

    <!-- Карточка для списка заявок -->
    <v-card v-if="applications.length"  class="pa-4 mt-4">
      <v-card-title>Ваши поданные заявки</v-card-title>
      <v-card-text>
        <v-data-table :headers="applicationHeaders" :items="applications" class="mt-2">
          <!-- eslint-disable-next-line vue/valid-v-slot -->
          <template v-slot:item.status="{ item }">
            <v-chip :color="getStatusColor(item.status)" dark>{{ getStatusText(item.status) }}</v-chip>
          </template>
        </v-data-table>
      </v-card-text>
    </v-card>
  </v-container>
</template>

<script>
import axios from 'axios';

const host = "http://localhost:3000";

export default {
  data() {
    return {
      user: { name: '', email: '' },
      documents: [],
      applications: [],
      applicationHeaders: [
        { text: "Университет", value: "university_name" },
        { text: "Статус", value: "status" }
      ],
      testResult: null,
    };
  },
  computed: {

  },
  mounted() {
    this.fetchUserData();
    this.fetchDocuments();
    this.fetchApplications();
    this.fetchTestResult();
  },
  methods: {
    async fetchUserData() {
      try {
        const userId = localStorage.getItem('userId');
        const response = await axios.get(`${host}/api/user/${userId}`);
        this.user = response.data;
      } catch (error) {
        console.error('Ошибка загрузки данных пользователя:', error);
      }
    },
    async getUserId() {
      try {
        const response = await axios.get(`${host}/api/profile`);
        return response.data.userId;
      } catch (error) {
        console.error("Ошибка получения userId:", error);
        return null;
      }
    },
    async fetchDocuments() {
      try {
        const userId = localStorage.getItem('userId');
        const response = await axios.get(`${host}/api/user-documents/${userId}`);
        this.documents = response.data;
      } catch (error) {
        console.error('Ошибка загрузки документов:', error);
      }
    },
    getDocumentUrl(filePath) {
      return filePath ? `${host}/${filePath}` : '#';
    },
    async uploadFile(event) {
      const file = event;
      if (!file) return;
      const formData = new FormData();
      formData.append('file', file);
      formData.append('userId', localStorage.getItem('userId'));
      formData.append('fileName', file.name);
      try {
        await axios.post(`${host}/api/user-documents/`, formData, {
          headers: { 'Content-Type': 'multipart/form-data' }
        });
        this.fetchDocuments();
      } catch (error) {
        console.error('Ошибка загрузки файла:', error);
      }
    },
    editProfile() {
      this.$router.push('/profile-edit');
    },
    async fetchApplications() {
      try {
        const userId = localStorage.getItem("userId");
        if (!userId) throw new Error("User ID не найден в localStorage");

        const response = await axios.get(`${host}/api/applications/${userId}`);
        this.applications = response.data.map(app => ({
          university_name: app.university_name,
          status: app.status
        }));
      } catch (error) {
        console.error("Ошибка загрузки заявок:", error);
      }
    },
    getStatusColor(status) {
      return status === "accepted" ? "green" : status === "in process" ? "yellow" : "red";
    },
    getStatusText(status) {
      return status === "accepted" ? "Принято" : status === "in process" ? "В процессе" : "Отклонено";
    },
    async fetchTestResult() {
      try {
        const userId = localStorage.getItem('userId');
        const response = await axios.get(`http://localhost:3000/api/results/${userId}`);
        if (response.data) {
          this.testResult = {
            ...response.data,
            professions: response.data.professions,
            universities: response.data.universities,
          };
        }
      } catch (error) {
        console.error('Ошибка получения результата теста:', error);
      }
    }
  }
};
</script>

<style scoped>
.v-container {
  max-width: 600px;
  margin: auto;
}
input[type="radio"] {
  accent-color: #2563eb;
}
</style>
