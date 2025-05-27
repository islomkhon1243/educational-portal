<template>
  <v-app>
    <v-container>
      <v-card class="mx-auto" max-width="400" outlined>
        <v-card-title class="text-center">Админ панель</v-card-title>
        <v-card-text>
          <v-form @submit.prevent="login">
            <v-text-field v-model="email" label="Email" type="email" required></v-text-field>
            <v-text-field v-model="password" label="Пароль" type="password" required></v-text-field>
            <v-btn type="submit" color="primary" block>Войти</v-btn>
          </v-form>
        </v-card-text>
      </v-card>
    </v-container>
  </v-app>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      email: '',
      password: ''
    };
  },
  methods: {
    async login() {
      try {
        const response = await axios.post('http://localhost:3000/api/admin/login', {
          email: this.email,
          password: this.password
        });
        localStorage.setItem('token', response.data.token);
        localStorage.setItem('userStatus', response.data.userStatus);
        this.$router.push('/admin/universities');
      } catch (error) {
        console.error('Ошибка авторизации:', error);
      }
    }
  }
};
</script>

<style scoped>
.v-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}
</style>
