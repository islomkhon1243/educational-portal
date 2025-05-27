<template>
  <v-app>
    <v-main>
      <div v-if="userStatus === 'admin'">
        <!-- Структура для админа -->
        <AdminNavbar />
      </div>
      <div v-else>
        <!-- Структура для обычного пользователя -->
        <NavbarPage />
        <router-view />
      </div>
    </v-main>
  </v-app>
</template>

<script>
import NavbarPage from "@/components/NavbarPage.vue";
import AdminNavbar from "@/components/AdminNavbar.vue";

export default {
  name: 'App',
  components: {NavbarPage, AdminNavbar},
  data() {
    return {
      userStatus: localStorage.getItem('userStatus') // Загружаем статус пользователя из localStorage
    };
  },
};
</script>

<style>
/* Добавьте стили для разных частей страницы, если необходимо */
</style>
