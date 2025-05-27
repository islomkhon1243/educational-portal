<template>
  <div class="logout-page">
    <v-container>
      <v-row justify="center">
        <v-col cols="12" md="6" class="text-center">
          <h1>Выход...</h1>
          <p>Вы успешно вышли со своего аккаунта.</p>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import axios from "axios";
axios.defaults.withCredentials = true;

const host = "http://localhost:3000";

export default {
  name: 'LogoutPage',
  mounted() {
    this.logoutUser();
  },
  methods: {
    async logoutUser() {
      // Remove the token from local storage
      try {
        await axios.post(`${host}/api/logout`);
        localStorage.removeItem('userId');
      } catch (error) {
        this.errorMessage = 'Не получилось выйти!';
      }

      // Optionally, you can also redirect to the home page after logging out
      this.$router.push('/');
    },
  },
};
</script>

<style scoped>
.logout-page {
  padding: 50px 0;
}
</style>