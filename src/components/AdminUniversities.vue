<template>
  <div>
    <h2>Университеты</h2>
    <table>
      <thead>
      <tr>
        <th>Название университета</th>
        <th>Город</th>
        <th>Страна</th>
        <th>Активность</th>
        <th>Действия</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="(university) in universities" :key="university.id">
        <td><input v-model="university.name" /></td>
        <td><input v-model="university.location" /></td>
        <td><input v-model="university.description" /></td>
        <td>
          <button @click="saveChanges(university.id)">Сохранить</button>
        </td>
      </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      universities: [],
    };
  },
  mounted() {
    this.fetchUniversities();
  },
  methods: {
    async fetchUniversities() {
      try {
        const response = await axios.get("/api/universities");
        this.universities = response.data;
      } catch (error) {
        console.error("Ошибка при получении данных университетов:", error);
      }
    },
    async saveChanges(universityId) {
      const updatedUniversity = this.universities.find(u => u.id === universityId);

      try {
        await axios.put(`/api/universities/${universityId}`, updatedUniversity);
        alert("Данные успешно обновлены!");
      } catch (error) {
        console.error("Ошибка при сохранении изменений:", error);
        alert("Не удалось сохранить изменения.");
      }
    }
  }
};
</script>

<style scoped>
table {
  width: 100%;
  border-collapse: collapse;
}

th, td {
  padding: 8px;
  text-align: left;
  border: 1px solid #ddd;
}

input, select {
  width: 100%;
  padding: 4px;
  box-sizing: border-box;
}
</style>
