<template>
  <v-app-bar app>
    <v-toolbar-title class="mr-4 ml-4">Futurum</v-toolbar-title>

    <!-- Кнопка бургера для мобильных -->
    <v-app-bar-nav-icon @click="drawer = !drawer" class="d-md-none"></v-app-bar-nav-icon>

    <!-- Меню для планшетов и десктопов -->
    <div class="d-none d-md-flex">
      <v-btn text to="/universities">Университеты</v-btn>
      <v-btn text to="/articles">Статьи</v-btn>
      <v-btn text to="/calendar">Календарь</v-btn>
    </div>

    <v-spacer></v-spacer>

    <!-- Авторизация - десктоп -->
    <div class="d-none d-md-flex align-center">
      <v-btn text to="/dashboard" v-if="isAuthenticated" class="username-btn">
        <span v-if="username">{{ username }}</span>
        <span v-else>Guest</span>
      </v-btn>
      <v-btn text v-if="isAuthenticated" to="/logout">Выйти</v-btn>
      <v-btn text v-if="!isAuthenticated" to="/login">Вход</v-btn>
      <v-btn text v-if="!isAuthenticated" to="/register">Зарегистрироваться</v-btn>
    </div>

    <!-- Навигационная панель для мобильных -->
    <v-navigation-drawer
        v-model="drawer"
        app
        temporary
        class="d-md-none"
    >
      <v-list nav dense>
        <v-list-item to="/universities" @click="drawer = false">
          <v-list-item-title>Университеты</v-list-item-title>
        </v-list-item>
        <v-list-item to="/articles" @click="drawer = false">
          <v-list-item-title>Статьи</v-list-item-title>
        </v-list-item>
        <v-list-item to="/calendar" @click="drawer = false">
          <v-list-item-title>Календарь</v-list-item-title>
        </v-list-item>

        <v-divider></v-divider>

        <v-list-item to="/dashboard" v-if="isAuthenticated" @click="drawer = false">
          <v-list-item-title>{{ username || 'Guest' }}</v-list-item-title>
        </v-list-item>
        <v-list-item to="/logout" v-if="isAuthenticated" @click="drawer = false">
          <v-list-item-title>Выйти</v-list-item-title>
        </v-list-item>
        <v-list-item to="/login" v-if="!isAuthenticated" @click="drawer = false">
          <v-list-item-title>Вход</v-list-item-title>
        </v-list-item>
        <v-list-item to="/register" v-if="!isAuthenticated" @click="drawer = false">
          <v-list-item-title>Зарегистрироваться</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
  </v-app-bar>
</template>

<script>
import axios from 'axios';
axios.defaults.withCredentials = true;

const host = "http://localhost:3000";

const getTokenFromCookies = () => {
  const cookies = document.cookie.split("; ");
  const tokenCookie = cookies.find(row => row.startsWith("token="));
  return tokenCookie ? tokenCookie.split("=")[1] : null;
};

const token = getTokenFromCookies();

export default {
  name: 'NavbarPage',
  data() {
    return {
      username: '',
      userId: '',
      isAuthenticated: false,
      drawer: false, // состояние для бургер-меню
    };
  },
  mounted() {
    this.checkAuthentication();
  },
  watch: {
    '$route': 'checkAuthentication',
  },
  methods: {
    async checkAuthentication() {
      try {
        const response = await axios.get(`${host}/api/profile`, {
          withCredentials: true,
          headers: {
            "Cookie": `token=${token}`
          }
        });

        if (response.data.userId) {
          this.isAuthenticated = true;
          await this.getUsername();
        } else {
          this.isAuthenticated = false;
        }
      } catch (error) {
        this.isAuthenticated = false;
        console.error("Ошибка аутентификации:", error);
      }
    },
    async getUsername() {
      try {
        const userId = localStorage.getItem('userId');
        const response = await axios.get(`${host}/api/user/${userId}`, {
          withCredentials: true
        });
        if (response.data.email) {
          this.username = response.data.email.split('@')[0];
        }
      } catch (error) {
        console.error('Error fetching username:', error);
      }
    },
  },
};
</script>

<style scoped>
/* Убираем стандартный margin для кнопок, чтобы они выглядели компактнее */
.v-btn {
  min-width: auto;
}

.username-btn {
  font-weight: 700; /* Жирный шрифт */
  color: #1976D2; /* Синий цвет, например */
  border-bottom: 2px solid #1976D2; /* Нижняя линия для акцента */
  cursor: default; /* Курсор по умолчанию, если не кликабельно */
}

/* Для мобильного меню drawer: */

.username-list-item {
  font-weight: 700;
  color: #1976D2;
}

/* Скрыть бургер-иконку на больших экранах */
.d-md-none {
  display: none;
}

@media (max-width: 960px) {
  .d-md-none {
    display: inline-flex !important;
  }
  .d-md-flex {
    display: none !important;
  }
}
</style>
