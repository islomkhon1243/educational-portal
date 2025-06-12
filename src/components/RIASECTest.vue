<template>
  <v-container class="pa-4 pa-sm-6" :style="{ maxWidth: '100%', maxHeight: '100%' }">
    <v-row justify="center">
      <v-col cols="12" md="10" lg="8" xl="6">
        <!-- Заголовок -->
        <h1 class="text-h5 text-sm-h4 font-weight-bold text-center mb-4 mb-sm-6">
          RIASEC Профориентационный Тест
        </h1>

        <!-- Инструкция -->
        <h6 class="text-body-2 text-sm-h6 font-weight-light text-center mb-4 mb-sm-6">
          Оцените утверждение от 1 (не согласен) до 5 (полностью согласен)
        </h6>

        <!-- Прогресс -->
        <v-progress-linear
            :value="((currentIndex + 1) / questions.length) * 100"
            height="6"
            color="primary"
            class="mb-4"
        />

        <!-- Загрузка -->
        <v-alert v-if="loading" type="info" class="text-center">
          Загрузка вопросов...
        </v-alert>

        <!-- Один вопрос -->
        <v-card v-else outlined>
          <v-card-title class="subtitle-2 subtitle-sm-1 font-weight-medium">
            {{ currentIndex + 1 }}. {{ questions[currentIndex].statement }}
          </v-card-title>
          <v-card-text>
            <v-radio-group
                v-model="answers[currentIndex]"
                row
                :mandatory="true"
                class="d-flex flex-wrap justify-space-between"
            >
              <v-radio
                  v-for="n in 5"
                  :key="n"
                  :label="n.toString()"
                  :value="n"
                  color="primary"
                  class="ma-1"
              />
            </v-radio-group>
          </v-card-text>
        </v-card>

        <!-- Кнопки -->
        <div class="d-flex justify-start mt-4" style="gap: 12px; flex-wrap: wrap">
          <v-btn
              :disabled="currentIndex === 0"
              @click="prevQuestion"
              class="flex-grow-1 flex-sm-grow-0"
          >
            Назад
          </v-btn>
          <v-btn
              color="primary"
              @click="nextOrSubmit"
              class="flex-grow-1 flex-sm-grow-0"
          >
            {{ currentIndex === questions.length - 1 ? 'Завершить' : 'Далее' }}
          </v-btn>
        </div>

        <!-- Результаты -->
        <v-dialog v-model="dialog" max-width="600">
          <v-card>
            <v-card-title class="headline">Ваш результат</v-card-title>
            <v-card-text>
              <div v-if="results">
                <h3 class="text-h6 font-weight-bold mb-2">Тип: {{ results.type }}</h3>
                <p>{{ results.description }}</p>

                <h4 class="text-subtitle-1 mt-4 font-weight-medium">Подходящие профессии:</h4>
                <v-list dense>
                  <v-list-item
                      v-for="(profession, index) in results.professions"
                      :key="index"
                  >
                    <v-list-item-content>{{ profession }}</v-list-item-content>
                  </v-list-item>
                </v-list>

                <h4 class="text-subtitle-1 mt-4 font-weight-medium">Вузы в Казахстане:</h4>
                <v-list dense>
                  <v-list-item
                      v-for="(university, index) in results.universities"
                      :key="index"
                  >
                    <v-list-item-content>
                      {{ university.name }} — Программы: {{ university.programs.join(", ") }}
                    </v-list-item-content>
                  </v-list-item>
                </v-list>
              </div>
            </v-card-text>
            <v-card-actions>
              <v-btn color="primary" @click="goToDashboard" block>
                Закрыть
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import questionsData from '@/assets/RIASEC_test_questions.json';
import resultData from '@/assets/RIASEC_result_data.json';
import axios from 'axios';

const host = "https://educational-portal-a3vu.onrender.com";
  
export default {
  name: 'RIASECTest',
  data() {
    return {
      questions: [],
      answers: [],
      currentIndex: 0,
      results: null,
      loading: true,
      dialog: false,
    };
  },
  mounted() {
    this.loadQuestions();
  },
  methods: {
    loadQuestions() {
      this.questions = questionsData;
      this.answers = Array(questionsData.length).fill(null);
      this.loading = false;
    },
    prevQuestion() {
      if (this.currentIndex > 0) this.currentIndex--;
    },
    nextOrSubmit() {
      if (this.answers[this.currentIndex] === null) return;
      if (this.currentIndex < this.questions.length - 1) {
        this.currentIndex++;
      } else {
        this.submitAnswers();
      }
    },
    async submitAnswers() {
      const scores = {
        Realistic: 0,
        Investigative: 0,
        Artistic: 0,
        Social: 0,
        Enterprising: 0,
        Conventional: 0,
      };

      this.questions.forEach((q, i) => {
        const value = this.answers[i];
        if (value !== null && q.type in scores) {
          scores[q.type] += value;
        }
      });

      const highestType = Object.keys(scores).reduce((a, b) => scores[a] > scores[b] ? a : b);
      this.results = resultData.find(r => r.type === highestType);
      await this.saveResultToDB(highestType, this.results);
      this.dialog = true;
    },
    async saveResultToDB(type, result) {
      try {
        const userId = localStorage.getItem('userId');
        await axios.post(`${host}/api/results`, {
          userId,
          type,
          description: result.description,
          professions: result.professions,
          universities: result.universities
        });
      } catch (err) {
        console.error('Ошибка сохранения результата:', err);
      }
    },
    goToDashboard() {
      this.$router.push('/dashboard');
    }
  }
};
</script>
