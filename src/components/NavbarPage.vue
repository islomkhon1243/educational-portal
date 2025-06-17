<template>
  <v-app-bar app>
    <v-toolbar-title class="mr-4 ml-4">Futurum</v-toolbar-title>

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
        <span v-if="firstname">{{ firstname }}</span>
        <span v-else>Guest</span>
      </v-btn>
      <v-btn text v-if="isAuthenticated" to="/logout">Выйти</v-btn>
      <v-btn text v-if="!isAuthenticated" to="/login">Вход</v-btn>
      <v-btn text v-if="!isAuthenticated" to="/register">Зарегистрироваться</v-btn>
    </div>

    <!-- Навигационная панель для мобильных -->
    <div class="d-flex d-md-none">
      <v-menu bottom left offset-y>
        <template #activator="{ on, attrs }">
          <v-btn icon v-bind="attrs" v-on="on">
            <v-icon>mdi-menu</v-icon>
          </v-btn>
        </template>

        <v-list dense>
          <v-list-item to="/universities">
            <v-list-item-title>Университеты</v-list-item-title>
          </v-list-item>
          <v-list-item to="/articles">
            <v-list-item-title>Статьи</v-list-item-title>
          </v-list-item>
          <v-list-item to="/calendar">
            <v-list-item-title>Календарь</v-list-item-title>
          </v-list-item>

          <v-divider></v-divider>

          <template v-if="isAuthenticated">
            <v-list-item to="/dashboard">
              <v-list-item-title>{{ firstname || 'Гость' }}</v-list-item-title>
            </v-list-item>
            <v-list-item to="/logout">
              <v-list-item-title>Выйти</v-list-item-title>
            </v-list-item>
          </template>
          <template v-else>
            <v-list-item to="/login">
              <v-list-item-title>Вход</v-list-item-title>
            </v-list-item>
            <v-list-item to="/register">
              <v-list-item-title>Зарегистрироваться</v-list-item-title>
            </v-list-item>
          </template>
        </v-list>
      </v-menu>
    </div>

    <!-- Плавающий чат-бот внизу справа -->
    <div
      v-if="drawer"
      class="chat-bot-window"
    >
      <v-card width="350" elevation="10" class="pa-2">
        <v-card-title class="text-h6">🤖 Помощник Futurum</v-card-title>
        <v-card-text style="height: 300px; overflow-y: auto;">
          <div v-for="(msg, i) in messages" :key="i" class="my-2">
            <div v-if="msg.role === 'user'" class="text-right">
              <strong>Вы:</strong> {{ msg.content }}
            </div>
            <div v-else class="text-left">
              <strong>Бот:</strong> {{ msg.content }}
            </div>
          </div>
        </v-card-text>
        <v-divider />
        <v-card-actions>
          <v-text-field
            v-model="userInput"
            label="Ваш вопрос..."
            hide-details
            dense
            class="flex-grow-1"
            @keyup.enter="sendToBot"
          />
          <v-btn icon @click="sendToBot">
            <v-icon>mdi-send</v-icon>
          </v-btn>
        </v-card-actions>
      </v-card>
    </div>
    
    <!-- Кнопка открытия чата -->
    <v-btn icon fixed bottom right class="chat-toggle-btn" @click="drawer = !drawer">
      <v-icon>{{ drawer ? 'mdi-close' : 'mdi-chat' }}</v-icon>
    </v-btn>
  </v-app-bar>
</template>

<script>
import axios from 'axios';
axios.defaults.withCredentials = true;

const host = "https://educational-portal-a3vu.onrender.com";

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
      firstname: '',
      userId: '',
      isAuthenticated: false,
      drawer: false, // состояние для бургер-меню
      userInput: '',
      messages: [
        { role: 'bot', content: 'Привет! Я бот Futurum. Задай мне вопрос по сайту или профориентации 🚀' }
      ],
    };
  },
  mounted() {
    this.checkAuthentication();
  },
  watch: {
    $route() {
      this.checkAuthentication();
    }
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
          this.userId = response.data.userId;
    
          localStorage.setItem('userId', this.userId); // гарантируем
    
          await this.getUsername(); // ГАРАНТИРОВАННЫЙ вызов
        } else {
          this.isAuthenticated = false;
          this.firstname = '';
        }
      } catch (error) {
        this.isAuthenticated = false;
        console.error("Ошибка аутентификации:", error);
      }
    },
    async getUsername() {
      try {
        const response = await axios.get(`${host}/api/user/${this.userId}`, {
          withCredentials: true
        });
    
        if (response.data.firstname) {
          this.firstname = response.data.firstname;
        }
      } catch (error) {
        console.error('Ошибка получения username:', error);
      }
    },
    async sendToBot() {
      const question = this.userInput.trim();
      if (!question) return;
    
      this.messages.push({ role: 'user', content: question });
      this.userInput = '';
    
      try {
        const systemPrompt = `Ты — умный и дружелюбный AI-помощник, встроенный в портал профориентации абитуриентов Futurum. 
    Ты помогаешь школьникам выбирать университет, профессию, проходные баллы, дедлайны и отвечаешь на общие вопросы по поступлению в Казахстане. Отвечай кратко, понятно, дружелюбно.`;
    
        const res = await axios.post(`${host}/api/ai`, {
          systemPrompt,
          userPrompt: question
        });
    
        this.messages.push({
          role: 'bot',
          content: res.data.response || 'Нет ответа.'
        });
      } catch (e) {
        console.error("Ошибка общения с ботом:", e);
        this.messages.push({ role: 'bot', content: 'Произошла ошибка при получении ответа 😞' });
      }
    },
  },
};
</script>

<style scoped>
.v-btn {
  min-width: auto;
}

.username-btn {
  font-weight: 700;
  color: #1976D2;
  border-bottom: 2px solid #1976D2;
  cursor: default;
}

.username-list-item {
  font-weight: 700;
  color: #1976D2;
}

.chat-bot-window {
  position: fixed;
  bottom: 80px;
  right: 20px;
  z-index: 9999;
}

.chat-toggle-btn {
  position: fixed;
  bottom: 20px;
  right: 20px;
  z-index: 10000;
  background-color: #1976D2;
  color: white;
}
</style>
