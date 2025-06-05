<template>
  <v-app>
    <NavbarPage />
    <v-main>
      <router-view />
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
