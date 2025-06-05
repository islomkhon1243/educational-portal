<template>
  <v-container>
    <h2 class="text-center title">Календарь приемных комиссий университетов</h2>

    <!-- Кнопки переключения месяцев -->
    <v-row justify="center" class="my-4">
      <v-btn icon @click="prevMonth">
        <v-icon>mdi-chevron-left</v-icon>
      </v-btn>
      <h3 class="mx-3 text-h6 month-title">{{ formatMonth(focus) }}</h3>
      <v-btn icon @click="nextMonth">
        <v-icon>mdi-chevron-right</v-icon>
      </v-btn>
    </v-row>

    <!-- Календарь -->
    <v-calendar
        v-model="focus"
        type="month"
        :events="events"
        @click:event="showEventDetails"
    ></v-calendar>

    <!-- Диалоговое окно с информацией о университете -->
    <v-dialog v-model="dialog" max-width="600px">
      <v-card v-if="selectedEvent">
        <v-card-title>{{ selectedEvent.name }}</v-card-title>
        <v-card-text>
          <p><strong>Локация:</strong> {{ selectedEvent.location }}</p>
          <p><strong>Основан:</strong> {{ selectedEvent.established }}</p>
          <p>
            <strong>Описание:</strong>
            <router-link
                v-if="selectedEvent?.id"
                :to="`/universities/${selectedEvent.id}`"
                class="text-decoration-underline"
                style="color: #1976d2;"
            >
              Перейти на страницу университета
            </router-link>
          </p>
          <p><strong>Приемная комиссия:</strong> {{ formatDate(selectedEvent.start) }} - {{ formatDate(selectedEvent.end) }}</p>
        </v-card-text>
        <v-card-actions>
          <v-btn color="primary" text @click="dialog = false">Закрыть</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script>
import axios from 'axios';

const host = "https://educational-portal-a3vu.onrender.com";

export default {
  data() {
    return {
      focus: new Date().toISOString().substr(0, 10), // Текущий месяц
      events: [],
      dialog: false,
      selectedEvent: null, // Хранит данные о выбранном университете
    };
  },
  mounted() {
    this.fetchAdmissionPeriods();
  },
  methods: {
    async fetchAdmissionPeriods() {
      try {
        const response = await axios.get(`${host}/api/universities`);

        const colorPalette = [
          '#1976D2', // синий
          '#388E3C', // зелёный
          '#F57C00', // оранжевый
          '#C2185B', // розовый
          '#7B1FA2', // фиолетовый
          '#0097A7', // голубой
          '#FBC02D', // жёлтый
          '#E64A19', // кирпичный
          '#512DA8', // индиго
          '#455A64', // серый
        ];

        this.events = response.data.map((university, index) => ({
          id: university.id,
          name: university.name,
          location: university.location,
          established: university.established,
          start: university.admission_start.split('T')[0],
          end: university.admission_end.split('T')[0],
          color: colorPalette[index % colorPalette.length], // 💡 разные цвета по индексу
        }));
      } catch (error) {
        console.error('Error fetching university data:', error);
      }
    },
    showEventDetails({ event }) {
      this.selectedEvent = event;
      this.dialog = true;
    },
    formatDate(dateString) {
      if (!dateString) return '';
      const date = new Date(dateString);
      return new Intl.DateTimeFormat('ru-RU', {
        day: 'numeric',
        month: 'long',
        year: 'numeric'
      }).format(date);
    },
    formatMonth(dateString) {
      const date = new Date(dateString);
      return new Intl.DateTimeFormat('ru-RU', { month: 'long', year: 'numeric' }).format(date);
    },
    prevMonth() {
      const date = new Date(this.focus);
      date.setMonth(date.getMonth() - 1);
      this.focus = date.toISOString().substr(0, 10);
    },
    nextMonth() {
      const date = new Date(this.focus);
      date.setMonth(date.getMonth() + 1);
      this.focus = date.toISOString().substr(0, 10);
    },
  }
};
</script>

<style scoped>
/* Отступы между строками заголовков */
.title {
  margin-bottom: 20px;
}

.month-title {
  margin-bottom: 10px;
}
</style>
