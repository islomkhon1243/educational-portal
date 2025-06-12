<template>
  <v-container>
    <h2 class="text-center my-4">Полезные статьи</h2>

    <!-- Поиск статей -->
    <v-text-field
        v-model="searchQuery"
        label="Поиск статей..."
        outlined
        dense
        class="mb-4"
    ></v-text-field>

    <!-- Кнопка + поле генерации статьи -->
    <div class="mb-6">
      <v-btn color="success" @click="showInput = !showInput" class="mb-2">
        {{ showInput ? 'Отмена' : 'Создать статью' }}
      </v-btn>

      <div v-if="showInput">
        <v-text-field
            v-model="customTopic"
            label="Введите тему статьи"
            outlined
            dense
            class="mt-2"
        ></v-text-field>
        <v-btn
            color="primary"
            @click="fetchAIArticle(customTopic)"
            :disabled="!customTopic || loading"
        >
          <v-progress-circular
              v-if="loading"
              indeterminate
              color="white"
              size="20"
              class="mr-2"
          />
          Сгенерировать статью
        </v-btn>
      </div>
    </div>

    <!-- Сетка с карточками статей -->
    <v-row>
      <v-col
          v-for="article in filteredArticles"
          :key="article.id"
          cols="12"
          md="6"
          lg="4"
      >
        <v-card class="article-card">
          <v-card-title>{{ article.title }}</v-card-title>
          <v-card-subtitle>{{ article.category }}</v-card-subtitle>
          <v-card-text>
            {{ truncateText(article.description, 100) }}
          </v-card-text>
          <v-card-actions>
            <v-btn color="primary" @click="openArticle(article)">
              Подробно
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>

    <!-- Диалог с полной статьей -->
    <v-dialog v-model="dialog" max-width="800px">
      <v-card v-if="selectedArticle">
        <v-card-title>{{ selectedArticle.title }}</v-card-title>
        <v-card-subtitle class="mb-2">{{ selectedArticle.category }}</v-card-subtitle>
        <v-card-text v-html="formattedContent"></v-card-text>
        <v-card-actions>
          <v-btn color="primary" text @click="dialog = false">Закрыть</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Уведомление -->
    <v-snackbar v-model="snackbar" :timeout="3000" top color="success">
      {{ snackbarText }}
    </v-snackbar>
  </v-container>
</template>

<script>
import axios from 'axios';

const host = "https://educational-portal-a3vu.onrender.com";

export default {
  data() {
    return {
      articles: [],
      searchQuery: '',
      dialog: false,
      selectedArticle: null,
      showInput: false,
      customTopic: '',
      snackbar: false,
      snackbarText: '',
      loading: false,
    };
  },
  computed: {
    filteredArticles() {
      return this.articles.filter(article =>
          article.title.toLowerCase().includes(this.searchQuery.toLowerCase())
      );
    },
    formattedContent() {
      if (!this.selectedArticle || !this.selectedArticle.content)
        return "<p>Нет данных</p>";

      return this.selectedArticle.content
          .replace(/\n/g, "<br>")
          .replace(/###\s*(.+)/g, "<h3>$1</h3>")
          .replace(/\*\*(.+?)\*\*/g, "<b>$1</b>");
    },
  },
  mounted() {
    this.fetchArticles();
    // this.generateDailyArticles();
  },
  methods: {
    async fetchArticles() {
      try {
        const response = await axios.get(`${host}/api/articles`);
        this.articles = response.data;
      } catch (error) {
        console.error('Error fetching articles:', error);
      }
    },
    openArticle(article) {
      this.selectedArticle = article;
      this.dialog = true;
    },
    truncateText(text, length) {
      return text.length > length ? text.substring(0, length) + '...' : text;
    },
    async fetchAIArticle(topic = '') {
      if (!topic) {
        this.snackbarText = "Пожалуйста, введите тему статьи.";
        this.snackbar = true;
        return;
      }

      this.loading = true;
      try {
        const response = await fetch(`${host}/api/ai`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            systemPrompt: "Ты журналист, пиши интересные и полезные статьи.",
            userPrompt: `Напиши статью на тему: "${topic}". Без лишних фраз. Пиши по делу, на русском языке. Отвечай только если запрос связан с образованием и поступлением и тд.`,
          }),
        });

        const data = await response.json();
        if (!data.response) {
          this.snackbarText = "Ошибка генерации статьи.";
          this.snackbar = true;
          return;
        }

        const translatedText = await this.translateText(data.response);
        const firstLine = translatedText.split('\n')[0].trim();
        const articleTitle = firstLine || 'Без названия';

        const saveSuccess = await this.saveArticleToDB(articleTitle, translatedText);

        if (saveSuccess) {
          await this.loadArticles();
          this.snackbarText = "Статья успешно создана!";
          this.snackbar = true;
          this.customTopic = '';
          this.showInput = false;
        } else {
          this.snackbarText = "Ошибка при сохранении статьи.";
          this.snackbar = true;
        }

      } catch (error) {
        console.error("Ошибка генерации статьи:", error);
        this.snackbarText = "Произошла ошибка при генерации.";
        this.snackbar = true;
      } finally {
        this.loading = false;
      }
    },
    async translateText(text) {
      try {
        const response = await fetch(`${host}/api/translate`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            text: text,
            targetLang: "ru",
          }),
        });

        const data = await response.json();
        return data.translatedText || text;
      } catch (error) {
        console.error("Ошибка перевода:", error);
        return text;
      }
    },
    async saveArticleToDB(title, content) {
      try {
        const response = await fetch(`${host}/api/articles`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            title: `Статья про ${title}`,
            category: "AI Generated",
            description: content.substring(0, 100) + "...",
            content: content
          }),
        });

        return response.ok;
      } catch (error) {
        console.error("Ошибка сохранения статьи в БД:", error);
        return false;
      }
    },
    async loadArticles() {
      try {
        const response = await fetch(`${host}/api/articles`);
        const data = await response.json();
        this.articles = data || [];
      } catch (error) {
        console.error("Ошибка загрузки статей:", error);
      }
    },
    // async generateDailyArticles() {
    //   await this.fetchAIArticle();
    // },
  },
};
</script>

<style scoped>
.article-card {
  transition: transform 0.2s ease-in-out;
}
.article-card:hover {
  transform: scale(1.03);
}
</style>
