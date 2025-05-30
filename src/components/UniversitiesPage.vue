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
  </div>
</template>

<script>
import axios from 'axios';
import { VIcon } from 'vuetify/lib/components';

axios.defaults.withCredentials = true;
const host = `${window.location.origin}`;
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
