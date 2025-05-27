<template>
  <div class="universities-page">
    <h2 class="ml-16">Список университетов</h2>
    <div class="university-gallery">
      <div
          class="university-card"
          v-for="university in universities"
          :key="university.id"
          @click="goToUniversityDetails(university.id)"
      >
        <img :src="university.image_url" alt="University Image" class="university-image" />
        <h3>{{ university.name }}</h3>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
axios.defaults.withCredentials = true;

const host = "http://localhost:3000";

export default {
  data() {
    return {
      universities: []
    };
  },
  mounted() {
    this.fetchUniversities();
  },
  methods: {
    async fetchUniversities() {
      try {
        const response = await axios.get(`${host}/api/universities`);
        this.universities = response.data;
      } catch (error) {
        console.error("Error fetching universities:", error);
      }
    },
    goToUniversityDetails(id) {
      this.$router.push({ name: 'UniversityDetails', params: { id } });
    }
  }
};
</script>

<style scoped>
.universities-page {
  padding: 5vh 4vw;
  box-sizing: border-box;
}

.university-gallery {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 24px;
  justify-content: center;
  margin-top: 24px;
}

.university-card {
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

/* Заголовок */
h2.ml-16 {
  margin-left: 0;
  font-size: 2rem;
  text-align: center;
  margin-bottom: 24px;
}

/* Адаптивность */
@media (max-width: 768px) {
  .university-card {
    padding: 12px;
  }

  .university-image {
    height: 140px;
  }

  h2.ml-16 {
    font-size: 1.6rem;
    margin-bottom: 16px;
  }
}

@media (max-width: 480px) {
  .university-gallery {
    grid-template-columns: 1fr;
  }

  .university-image {
    height: 130px;
  }

  h2.ml-16 {
    font-size: 1.4rem;
  }
}
</style>