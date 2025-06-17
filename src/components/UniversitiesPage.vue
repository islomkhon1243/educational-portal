<template>
  <div class="universities-page">
    <!-- Заголовок + Поиск -->
    <div class="header-section">
      <h2>Список университетов</h2>
      <input
          v-model="searchQuery"
          type="text"
          class="search-input"
          placeholder="Поиск университета..."
      />
    </div>

    <!-- Галерея -->
    <div class="university-gallery">
      <div
          class="university-card"
          v-for="university in filteredUniversities"
          :key="university.id"
          @click="goToUniversityDetails(university.id)"
      >
        <div class="favorite-icon" @click.stop="toggleFavorite(university)">
          <v-icon :color="university.favorite ? 'red' : 'grey'">
            {{ university.favorite ? 'mdi-heart' : 'mdi-heart-outline' }}
          </v-icon>
        </div>
        <img :src="university.image_url" alt="University Image" class="university-image" />
        <h3>{{ university.name }}</h3>
      </div>
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
              <strong>Бот:</strong>
              <div v-html="msg.content" class="bot-response"></div>
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
  </div>
</template>

<script>
import axios from 'axios';
import { VIcon } from 'vuetify/lib/components';

axios.defaults.withCredentials = true;
const host = "https://educational-portal-a3vu.onrender.com";
const FAVORITES_KEY = 'favorites';

export default {
  components: {
    VIcon,
  },
  data() {
    return {
      universities: [],
      searchQuery: '',
      favoriteIds: [], // Список избранных ID
      drawer: false,
      userInput: '',
      messages: []
    };
  },
  computed: {
    filteredUniversities() {
      const query = this.searchQuery.toLowerCase().trim();

      // Фильтрация по поиску
      const filtered = this.universities.filter((uni) =>
          uni.name.toLowerCase().includes(query)
      );

      // Сортировка: сначала избранные
      return filtered.sort((a, b) => {
        const aFav = this.favoriteIds.includes(a.id);
        const bFav = this.favoriteIds.includes(b.id);
        if (aFav && !bFav) return -1;
        if (!aFav && bFav) return 1;
        return 0;
      });
    },
  },
  mounted() {
    this.loadFavoritesFromLocalStorage();
    this.fetchUniversities();
    const saved = localStorage.getItem('futurum_chat');
    if (saved) {
      const parsed = JSON.parse(saved);
      const oneHour = 60 * 60 * 1000;
      const now = Date.now();
      
      // Проверка срока действия
      if (now - parsed.timestamp < oneHour) {
        this.messages = parsed.messages;
      } else {
        localStorage.removeItem('futurum_chat');
      }
    }
  },
  watch: {
    messages: {
      handler(newMessages) {
        localStorage.setItem(
          'futurum_chat',
          JSON.stringify({
            timestamp: Date.now(),
            messages: newMessages
          })
        );
      },
      deep: true
    }
  },
  methods: {
    // Загружаем список избранных ID из localStorage
    loadFavoritesFromLocalStorage() {
      const stored = localStorage.getItem(FAVORITES_KEY);
      this.favoriteIds = stored ? JSON.parse(stored) : [];
    },

    // Сохраняем текущие избранные ID в localStorage
    saveFavoritesToLocalStorage() {
      localStorage.setItem(FAVORITES_KEY, JSON.stringify(this.favoriteIds));
    },

    // Получаем университеты и применяем избранное
    async fetchUniversities() {
      try {
        const response = await axios.get(`${host}/api/universities`);
        this.universities = response.data.map((u) => ({
          ...u,
          favorite: this.favoriteIds.includes(u.id),
        }));
      } catch (error) {
        console.error("Error fetching universities:", error);
      }
    },

    goToUniversityDetails(id) {
      this.$router.push({ name: 'UniversityDetails', params: { id } });
    },

    toggleFavorite(university) {
      university.favorite = !university.favorite;

      if (university.favorite) {
        this.favoriteIds.push(university.id);
      } else {
        this.favoriteIds = this.favoriteIds.filter(id => id !== university.id);
      }

      this.saveFavoritesToLocalStorage();
    },

    async sendToBot() {
      const question = this.userInput.trim();
      if (!question) return;
    
      // Отображаем сообщение пользователя
      this.messages.push({ role: 'user', content: question });
      this.userInput = '';
    
      try {
        const systemPrompt = `Ты — умный и дружелюбный AI-помощник, встроенный в портал профориентации абитуриентов Futurum.
    Ты помогаешь школьникам выбирать университет, профессию, проходные баллы, дедлайны и отвечаешь на общие вопросы по поступлению в Казахстане.
    Отвечай дружелюбно, кратко и структурированно. Используй HTML-формат: <h3>, <p>, <ul>, <li>, <a> и <strong>.`;
    
        const res = await axios.post(`${host}/api/ai`, {
          systemPrompt,
          userPrompt: question
        });
    
        const answer = res.data.response || '<p>Нет ответа.</p>';
    
        this.messages.push({
          role: 'bot',
          content: answer
        });
      } catch (e) {
        this.messages.push({
          role: 'bot',
          content: '<p>Произошла ошибка при получении ответа 😞</p>'
        });
      }
    },
  },
};
</script>

<style scoped>
.universities-page {
  padding: 5vh 4vw;
  box-sizing: border-box;
}

.header-section {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-bottom: 24px;
}

.header-section h2 {
  font-size: 2rem;
  text-align: center;
}

.search-input {
  width: 100%;
  max-width: 100%;
  padding: 10px 16px;
  border: 1px solid #ccc;
  border-radius: 8px;
  font-size: 1rem;
  transition: border-color 0.3s ease;
}

.search-input:focus {
  outline: none;
  border-color: #1976d2;
}

.university-gallery {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 24px;
  justify-content: center;
}

.university-card {
  position: relative;
  border: 1px solid #ccc;
  border-radius: 10px;
  padding: 16px;
  background-color: white;
  text-align: center;
  cursor: pointer;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.university-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 6px 18px rgba(0, 0, 0, 0.2);
}

.university-image {
  width: 100%;
  height: 160px;
  object-fit: cover;
  border-radius: 8px;
  margin-bottom: 16px;
}

/* Иконка сердечко в правом верхнем углу карточки */
.favorite-icon {
  position: absolute;
  top: 10px;
  right: 10px;
  z-index: 10;
  font-size: 24px;
  cursor: pointer;
  user-select: none;
  transition: color 0.3s ease;
}

.favorite-icon:hover {
  color: red;
}

.chat-bot-window {
  position: fixed;
  bottom: 80px;
  right: 20px;
  z-index: 9999;
}

.chat-toggle-btn {
  position: fixed;
  bottom: 40px;
  right: 40px;
  z-index: 10000;
  background-color: #1976D2;
  color: white;
  font-size: 28px; /* увеличено с обычных 20px */
  width: 64px;
  height: 64px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.bot-response {
  background: #f9f9f9;
  padding: 10px 14px;
  border-radius: 8px;
  font-size: 14px;
  line-height: 1.6;
}

.bot-response h3 {
  margin-top: 0.5rem;
  font-size: 16px;
  font-weight: bold;
}

.bot-response ul {
  margin-left: 1rem;
  padding-left: 1rem;
}

.bot-response li {
  margin-bottom: 6px;
}

/* Адаптивность */
@media (max-width: 768px) {
  .university-card {
    padding: 12px;
  }

  .university-image {
    height: 140px;
  }

  .header-section h2 {
    font-size: 1.6rem;
  }
}

@media (max-width: 480px) {
  .university-gallery {
    grid-template-columns: 1fr;
  }

  .university-image {
    height: 130px;
  }

  .header-section h2 {
    font-size: 1.4rem;
  }

  .search-input {
    font-size: 0.9rem;
    padding: 8px 12px;
  }
}
</style>
