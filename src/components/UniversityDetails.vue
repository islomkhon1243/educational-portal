<template>
  <div class="university-details">
    <!-- Кнопка Назад и Иконка Избранного -->
    <div class="top-bar">
      <v-btn plain @click="backToUniversities" class="back-button">
        <v-icon left>mdi-arrow-left</v-icon>
        Назад
      </v-btn>

      <!-- Иконка избранного -->
      <v-btn icon @click="toggleFavorite" :color="isFavorite ? 'red' : 'grey'">
        <v-icon>{{ isFavorite ? 'mdi-heart' : 'mdi-heart-outline' }}</v-icon>
      </v-btn>
    </div>

    <!-- Основная информация -->
    <h2 class="university-title">{{ university.name }}</h2>
    <img :src="university.image_url" alt="University Image" class="university-image" />

    <!-- 4 Блока: Локация, Основан, Тип, Рейтинг -->
    <div class="info-blocks">
      <div class="info-item">
        <strong>Локация:</strong>
        <p>{{ university.location }}</p>
      </div>
      <div class="info-item">
        <strong>Основан:</strong>
        <p>{{ university.established }}</p>
      </div>
      <div class="info-item">
        <strong>Тип:</strong>
        <p>{{ university.type }}</p>
      </div>
      <div class="info-item">
        <strong>Рейтинг:</strong>
        <p>{{ university.rating }}</p>
      </div>
    </div>

    <!-- Основной контент: слева - специальности и тд, справа - достижения и отзывы -->
    <div class="main-content">
      <!-- Левая часть 60% -->
      <div class="left-side">
        <h3>Факультеты и направления</h3>
        <ul>
          <li v-for="(faculty, index) in (university.faculties || '').split('\n')" :key="'faculty-' + index">
            {{ faculty }}
          </li>
        </ul>

<!--        <h3>Проходные баллы</h3>-->
<!--        <ul>-->
<!--          <li v-for="(score, index) in (university.scores || '').split('\n')" :key="'score-' + index">-->
<!--            {{ score }}-->
<!--          </li>-->
<!--        </ul>-->

        <h3>Проходные баллы</h3>
        <table class="score-table" v-if="parsedScores.length">
          <thead>
          <tr>
            <th>Группа ОП</th>
            <th>Название</th>
            <th>Минимальный балл</th>
            <th>Количество грантов</th>
          </tr>
          </thead>
          <tbody>
          <tr v-for="(item, index) in parsedScores" :key="'row-' + index">
            <td>{{ item.code }}</td>
            <td>{{ item.name }}</td>
            <td>{{ item.score }}</td>
            <td>{{ item.grants }}</td>
          </tr>
          </tbody>
        </table>
        <p v-else>Нет данных для отображения.</p>

        <h3>Гранты и скидки</h3>
        <ul>
          <li v-for="(grant, index) in (university.grants || '').split('\n')" :key="'grant-' + index">
            {{ grant }}
          </li>
        </ul>

        <h3>Условия поступления</h3>
        <ul>
          <li v-for="(condition, index) in (university.conditions || '').split('\n')" :key="'condition-' + index">
            {{ condition }}
          </li>
        </ul>
      </div>

      <!-- Правая часть 40% -->
      <div class="right-side">
        <h3>Отзывы студентов</h3>
        <ul>
          <li v-for="(review, index) in (university.reviews || '').split('\n')" :key="'review-' + index">
            {{ review }}
          </li>
        </ul>

        <h3>Достижения университета</h3>
        <ul>
          <li v-for="(achievement, index) in (university.achievements || '').split('\n')" :key="'achievement-' + index">
            {{ achievement }}
          </li>
        </ul>

        <h3>Дополнительная информация</h3>
        <div style="max-width: 100%; overflow-wrap: break-word; word-break: break-word;">
          <a :href="university.additional" target="_blank" style="color: #007bff; text-decoration: underline;">
            {{ university.additional }}
          </a>
        </div>
      </div>
    </div>

    <!-- Описание университета -->
    <div class="description-section">
      <h3>Описание университета</h3>
      <p>{{ university.description }}</p>
    </div>

    <!-- Яндекс Карта -->
    <div id="yandex-map-container" style="width: 100%; height: 400px; margin-top: 20px;"></div>

    <!-- Форма подачи заявки -->
    <v-btn v-if="isAuthenticated && isFormAvailable && isCheckedUser" color="primary" @click="openDialog">
      Открыть форму для подачи заявки
    </v-btn>
    <v-dialog v-model="dialog" max-width="600px">
      <v-card>
        <v-card-title>
          <span class="headline">Форма для заявки</span>
        </v-card-title>
        <v-card-text>
          <v-form @submit.prevent="submitApplication">
            <v-text-field v-model="applicant.lastname" label="Ваша фамилия" required outlined></v-text-field>
            <v-text-field v-model="applicant.firstname" label="Ваше имя" required outlined></v-text-field>
            <v-text-field v-model="applicant.middlename" label="Ваше отчество" outlined></v-text-field>
            <v-text-field v-model="applicant.email" label="Ваша почта" type="email" required outlined></v-text-field>
            <v-textarea v-model="applicant.personalStatement" label="Личное заявление" required outlined rows="4"></v-textarea>
            <v-file-input
              v-model="fileEducation"
              label="Документ об образовании (подлинник)(PDF)"
              accept="application/pdf"
              outlined
              :disabled="selectedDocument1"
              @change="handleFileUpload('fileEducation')"
            />
            <v-select
                v-if="userDocuments.length > 0"
                v-model="selectedDocument1"
                :items="userDocuments"
                item-text="file_name"
                item-value="file_path"
                label="Выбрать существующий документ"
                outlined
            />
            <v-divider style="margin-bottom: 20px"></v-divider>
            <v-file-input
              v-model="fileID"
              label="Копия документа, удостоверяющего личность (PDF)"
              accept="application/pdf"
              outlined
              :disabled="selectedDocument2"
              @change="handleFileUpload('fileID')"
            />
            <v-select
                v-if="userDocuments.length > 0"
                v-model="selectedDocument1"
                :items="userDocuments"
                item-text="file_name"
                item-value="file_path"
                label="Выбрать существующий документ"
                outlined
            />
            <v-divider style="margin-bottom: 20px"></v-divider>
            <v-file-input
              v-model="fileMedical"
              label="Медицинская справка по форме 075-У (PDF)"
              accept="application/pdf"
              outlined
              :disabled="selectedDocument3"
              @change="handleFileUpload('fileMedical')"
            />
            <v-select
                v-if="userDocuments.length > 0"
                v-model="selectedDocument1"
                :items="userDocuments"
                item-text="file_name"
                item-value="file_path"
                label="Выбрать существующий документ"
                outlined
            />
            <v-divider style="margin-bottom: 20px"></v-divider>
            <v-file-input
              v-model="fileENT"
              label="Сертификат единого национального тестирования (PDF)"
              accept="application/pdf"
              outlined
              :disabled="selectedDocument4"
              @change="handleFileUpload('fileENT')"
            />
            <v-select
                v-if="userDocuments.length > 0"
                v-model="selectedDocument1"
                :items="userDocuments"
                item-text="file_name"
                item-value="file_path"
                label="Выбрать существующий документ"
                outlined
            />
            <v-btn type="submit" color="primary" class="submit-button">Отправить заявку</v-btn>
          </v-form>
        </v-card-text>
        <v-card-actions>
          <v-btn color="grey" @click="closeDialog">Отмена</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <p v-if="message" class="message">{{ message }}</p>
    <p v-if="!isAuthenticated" class="message">Пожалуйста, войдите, чтобы подать заявку.</p>
    <p v-if="!isFormAvailable" class="message">Приемная комиссия закрыта.</p>
    <p v-if="!isCheckedUser" class="message">{{ errorMessage }}</p>
  </div>
</template>

<script>
import axios from 'axios';

const host = "https://educational-portal-a3vu.onrender.com";

export default {
  data() {
    return {
      university: {},
      applicant: { lastname: '', firstname: '', middlename: '', email: '', personalStatement: '' },
      fileEducation: null,
      fileID: null,
      fileMedical: null,
      fileENT: null,
      selectedDocument1: null,
      selectedDocument2: null,
      selectedDocument3: null,
      selectedDocument4: null,
      userDocuments: [], // Массив для хранения документов пользователя
      message: '',
      isAuthenticated: false, // Переменная для отслеживания авторизации
      isFormAvailable: false, // Переменная для отслеживания доступности формы
      isCheckedUser: false,   // Переменная для отслеживания прав пользователя
      dialog: false, // Переменная для управления состоянием диалогового окна
      errorMessage: '',
      isFavorite: false
    };
  },
  computed: {
    parsedScores() {
      const lines = (this.university.scores || '').split('\n');
      return lines
          .filter(line => line.trim())
          .map(line => {
            const match = line.trim().match(/^(\S+)\s+(.*?)(\d+)\s+(\d+)$/);
            if (!match) return null;

            const [, code, rawName, score, grants] = match;
            const name = rawName.trim();

            return {
              code,
              name,
              score,
              grants
            };
          })
          .filter(item => item !== null);
    }
  },
  mounted() {
    this.fetchUniversityDetails();
    this.checkAuthentication(); // Проверяем авторизацию при монтировании
    this.fetchUserDocuments(); // Загружаем документы пользователя
    this.checkUser();
    this.checkFavorite();
    this.favorites = JSON.parse(localStorage.getItem('favorites') || '[]');
  },
  methods: {
    async fetchUniversityDetails() {
      try {
        const response = await axios.get(`${host}/api/universities/${this.$route.params.id}`);
        this.university = response.data;
        this.checkApplicationPeriod(); // Проверяем доступность формы на основе дат

        this.loadYandexMap();
      } catch (error) {
        console.error("Error fetching university details:", error);
      }
    },
    checkAuthentication() {
      const userId = localStorage.getItem('userId'); // Получаем id пользователя из localStorage
      if (userId) {
        this.isAuthenticated = true; // Если токен существует, считаем пользователя авторизованным
        this.fetchUserData(userId); // Запрашиваем данные пользователя, если он авторизован
      }
    },
    async fetchUserData(userId) {
      try {
        const response = await axios.get(`${host}/api/user/${userId}`);
        // Заполняем поля формы данными пользователя
        this.applicant.lastname = response.data.lastname;
        this.applicant.firstname = response.data.firstname;
        this.applicant.middlename = response.data.middlename;
        this.applicant.email = response.data.email;
      } catch (error) {
        console.error("Error fetching user data:", error);
      }
    },
    async fetchUserDocuments() {
      const userId = localStorage.getItem('userId');
      try {
        const response = await axios.get(`${host}/api/user-documents/${userId}`);
        this.userDocuments = response.data; // Сохраняем документы пользователя
      } catch (error) {
        console.error("Error fetching user documents:", error);
      }
    },
    checkApplicationPeriod() {
      const currentDate = new Date();
      const admissionStart = new Date(this.university.admission_start);
      const admissionEnd = new Date(this.university.admission_end);

      // Проверяем, находится ли текущая дата в пределах периода подачи заявок
      if (currentDate >= admissionStart && currentDate <= admissionEnd) {
        this.isFormAvailable = true;
      } else {
        this.isFormAvailable = false;
      }
    },
    openDialog() {
      this.dialog = true; // Открыть диалоговое окно
    },
    closeDialog() {
      this.dialog = false; // Закрыть диалоговое окно
    },
    handleFileUpload(type) {
      switch (type) {
        case 'fileEducation':
          // обработка fileEducation
          break;
        case 'fileID':
          // обработка fileID
          break;
        case 'fileMedical':
          // обработка fileMedical
          break;
        case 'fileENT':
          // обработка fileENT
          break;
      }
    },
    async submitApplication() {
      const userId = localStorage.getItem("userId");
      const formData = new FormData();
      formData.append('lastname', this.applicant.lastname);
      formData.append('firstname', this.applicant.firstname);
      formData.append('middlename', this.applicant.middlename);
      formData.append('email', this.applicant.email);
      formData.append('personalStatement', this.applicant.personalStatement);
      formData.append('userId', userId);

      // Если файл выбран, добавляем его в форму
      if (this.file) {
        formData.append('file', this.file);
      }

      // Если выбран документ из списка, передаем только путь к файлу
      if (this.selectedDocument1) {
        formData.append('selectedFilePath', this.selectedDocument1); // Добавляем путь, а не сам файл
      }
      if (this.selectedDocument2) {
        formData.append('selectedFilePath', this.selectedDocument2); // Добавляем путь, а не сам файл
      }
      if (this.selectedDocument3) {
        formData.append('selectedFilePath', this.selectedDocument3); // Добавляем путь, а не сам файл
      }
      if (this.selectedDocument4) {
        formData.append('selectedFilePath', this.selectedDocument4); // Добавляем путь, а не сам файл
      }

      try {
        // Отправляем форму на сервер
        await axios.post(`${host}/api/applications/${this.university.id}`, formData, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        });

        this.message = 'Заявка успешно отправлена!';
        this.resetForm();
        this.closeDialog(); // Закрыть диалоговое окно после отправки
      } catch (error) {
        console.error("Ошибка при отправке заявки:", error);

        if (error.response) {
          const status = error.response.status;

          if (status === 403) {
            this.message = 'Вы достигли лимита заявок (максимум 4 заявки).';
          } else if (status === 409) {
            this.message = 'Вы уже подали заявление в этот университет.';
          } else {
            this.message = 'Не удалось отправить заявку. Попробуйте еще раз позже.';
          }
        } else {
          this.message = 'Ошибка сети. Проверьте подключение.';
        }
      }
    },
    resetForm() {
      this.applicant.lastname = '';
      this.applicant.firstname = '';
      this.applicant.middlename = '';
      this.applicant.email = '';
      this.applicant.personalStatement = '';
      this.file = null;
      this.selectedDocument = null;
    },
    backToUniversities() {
      this.$router.push({ name: 'Universities' });
    },
    async checkUser() {
      const userId = localStorage.getItem("userId");
      const formData = new FormData();
      formData.append('userId', userId);

      try {
        // Отправляем форму на сервер
        await axios.get(`${host}/api/applications/checkUser/${this.$route.params.id}`, {
          headers: {
            'Content-Type': 'multipart/form-data'
          },
          params: { userId }
        });
        // Если ошибок нет, включаем форму
        this.isCheckedUser = true;
        this.errorMessage = '';

      } catch (error) {
        console.error("Ошибка при получении данных:", error);

        if (error.response) {
          const status = error.response.status;

          if (status === 403) {
            this.errorMessage = 'Вы достигли лимита заявок (максимум 4 заявки).';
          } else if (status === 409) {
            this.errorMessage = 'Вы уже подали заявление в этот университет.';
          }

          // Блокируем форму, если есть ошибка
          this.isCheckedUser = false;
        } else {
          this.errorMessage = 'Ошибка сети. Проверьте подключение.';
          this.isCheckedUser = false;
        }
      }
    },
    loadYandexMap() {
      if (this.university.map) {
        const script = document.createElement('script');
        script.type = 'text/javascript';
        script.charset = 'utf-8';
        script.async = true;
        script.src = this.university.map;

        document.getElementById('yandex-map-container').innerHTML = ''; // Очищаем контейнер на всякий случай
        document.getElementById('yandex-map-container').appendChild(script);
      }
    },
    checkFavorite() {
      const favorites = JSON.parse(localStorage.getItem('favorites') || '[]');
      const currentId = this.$route.params.id;
      this.isFavorite = favorites.includes(currentId);
    },
    toggleFavorite() {
      const favorites = JSON.parse(localStorage.getItem('favorites') || '[]');
      const currentId = this.$route.params.id;

      if (favorites.includes(currentId)) {
        // Удаляем из избранного
        const updated = favorites.filter(id => id !== currentId);
        localStorage.setItem('favorites', JSON.stringify(updated));
        this.isFavorite = false;
      } else {
        // Добавляем в избранное
        favorites.push(currentId);
        localStorage.setItem('favorites', JSON.stringify(favorites));
        this.isFavorite = true;
      }
    }
  }
};
</script>

<style scoped>
.university-details {
  padding: 20px;
  max-width: 1200px;
  margin: auto;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  box-sizing: border-box;
}

.top-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 10px;
}

.university-title {
  text-align: center;
  margin: 20px 0;
  font-size: 2rem;
  word-break: break-word;
}

.university-image {
  width: 100%;
  height: 300px;
  object-fit: cover;
  border-radius: 12px;
  margin-bottom: 20px;
}

.info-blocks {
  display: flex;
  justify-content: space-around;
  margin-bottom: 30px;
  flex-wrap: wrap;
  gap: 15px;
}

.info-item {
  text-align: center;
  flex: 1 1 150px;
  min-width: 120px;
  word-break: break-word;
}

.main-content {
  display: flex;
  gap: 20px;
  margin-bottom: 30px;
  flex-wrap: nowrap; /* запрещаем перенос, чтобы справа осталась колонка */
}

.left-side {
  flex: 0 0 60%;
  min-width: 280px;
}

.right-side {
  flex: 0 0 40%;
  min-width: 250px;
}

.description-section {
  margin-bottom: 30px;
  word-break: break-word;
}

h3 {
  margin-bottom: 1em;
  margin-top: 1em;
}

table.score-table {
  width: 100%;
  border-collapse: collapse;
  text-align: center;
}

table.score-table th,
table.score-table td {
  padding: 8px;
  border: 1px solid #ccc;
  text-align: center;
}

/* Адаптивность */

/* Планшеты и меньше: меняем на вертикальный стек с разделением */
@media (max-width: 1024px) {
  .main-content {
    flex-wrap: wrap; /* теперь разрешаем перенос */
  }
  .left-side,
  .right-side {
    flex: 1 1 100%;
    min-width: auto;
  }
}

/* Мобильные телефоны */
@media (max-width: 600px) {
  .top-bar {
    flex-direction: column;
    align-items: flex-start;
  }
  .university-title {
    font-size: 1.5rem;
  }
  .info-blocks {
    flex-direction: column;
    gap: 10px;
  }
  .info-item {
    flex: 1 1 100%;
  }
  .university-image {
    height: 200px;
  }
}

/* Очень маленькие экраны */
@media (max-width: 360px) {
  .university-title {
    font-size: 1.3rem;
  }
  .university-image {
    height: 150px;
  }
}
</style>
