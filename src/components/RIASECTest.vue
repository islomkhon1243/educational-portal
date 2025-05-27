<template>
  <v-container class="pa-6" max-width="800">
    <v-row justify="center">
      <v-col cols="12">
        <h1 class="text-h4 font-weight-bold text-center mb-6">
          RIASEC Профориентационный Тест
        </h1>

        <h6 class="text-h6 font-weight-light text-center mb-6">
          1-полностью не согласен, 2-не согласен, 3-возможно, 4-согласен, 5-полностью согласен
        </h6>

        <v-alert v-if="loading" type="info" class="text-center">
          Загрузка вопросов...
        </v-alert>

        <v-form v-else @submit.prevent="submitAnswers">
          <v-card
              v-for="(question, index) in questions"
              :key="question.id"
              class="mb-4"
              outlined
          >
            <v-card-title class="subtitle-1 font-weight-medium">
              {{ index + 1 }}. {{ question.statement }}
            </v-card-title>
            <v-card-text>
              <v-radio-group
                  v-model="answers[index]"
                  :mandatory="true"
                  row
              >
                <v-radio
                    v-for="n in 5"
                    :key="n"
                    :label="n.toString()"
                    :value="n"
                    color="primary"
                ></v-radio>
              </v-radio-group>
            </v-card-text>
          </v-card>

          <v-btn
              type="submit"
              color="primary"
              class="mt-4"
              large
              block
          >
            Завершить тест
          </v-btn>
        </v-form>

        <!-- Диалоговое окно с результатом -->
        <v-dialog v-model="dialog" max-width="600">
          <v-card>
            <v-card-title class="headline">Ваши результаты</v-card-title>
            <v-card-text>
              <div v-if="results">
                <h3 class="text-lg font-semibold">Тип: {{ results.type }}</h3>
                <p>{{ results.description }}</p>
                <h4 class="mt-4 font-medium">Подходящие профессии:</h4>
                <ul>
                  <li v-for="(profession, index) in results.professions" :key="index">
                    {{ profession }}
                  </li>
                </ul>
                <h4 class="mt-4 font-medium">Вузы в Казахстане:</h4>
                <ul>
                  <li v-for="(university, index) in results.universities" :key="index">
                    {{ university.name }} - Программы: {{ university.programs.join(", ") }}
                  </li>
                </ul>
              </div>
            </v-card-text>
            <v-card-actions>
              <v-btn color="primary" @click="dialog = false">Закрыть</v-btn>
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
import axios from "axios";

export default {
  name: 'RIASECTest',
  data() {
    return {
      questions: [],
      answers: [],
      results: null,
      loading: true,
      dialog: false,  // Контролирует отображение диалога
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

      // Определяем тип с наибольшим баллом
      const highestScoreType = Object.keys(scores).reduce((a, b) => (scores[a] > scores[b] ? a : b));

      // Подтягиваем результат из JSON по типу
      this.results = resultData.find(result => result.type === highestScoreType);

      await this.saveResultToDB(highestScoreType, this.results);

      // Открываем диалог с результатами
      this.dialog = true;
    },
    async saveResultToDB(type, result) {
      try {
        const userId = localStorage.getItem('userId');
        await axios.post('http://localhost:3000/api/results', {
          userId,
          type,
          description: result.description,
          professions: result.professions,
          universities: result.universities
        });
      } catch (err) {
        console.error('Ошибка сохранения результата теста:', err);
      }
    }
  },
};
</script>
