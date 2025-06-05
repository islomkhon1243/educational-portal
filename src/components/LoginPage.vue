<template>
  <div class="login-page">
    <h2>Вход</h2>
    <form @submit.prevent="loginUser">
      <input v-model="email" type="email" placeholder="Email" required class="input-field" />
      <input v-model="password" type="password" placeholder="Пароль" required class="input-field" />
      <button type="submit" class="button">Вход</button>
    </form>
    <p v-if="errorMessage" class="error">{{ errorMessage }}</p>
<!--    <button @click="redirectToEgov" class="button egov-button">Войти через eGov.kz</button>-->
  </div>
</template>

<script>
import axios from 'axios';
axios.defaults.withCredentials = true;

const host = "https://educational-portal-a3vu.onrender.com";

export default {
  data() {
    return {
      email: '',
      password: '',
      errorMessage: ''
    };
  },
  methods: {
    async loginUser() {
      try {
        const response = await axios.post(`${host}/api/login`, {
          email: this.email,
          password: this.password,
          withCredentials: true
        });
        localStorage.setItem('userId', response.data.userId);
        this.$router.push({name: 'Universities'});
      } catch (error) {
        this.errorMessage = 'Invalid email or password!';
      }
    },
    // redirectToEgov() {
    //   const clientId = 'ВАШ_CLIENT_ID';
    //   const redirectUri = encodeURIComponent('http://localhost:3000/api/egov/callback');
    //   const scope = 'openid profile';
    //   const state = Math.random().toString(36).substring(2); // можно сохранить state в сессии
    //   const url = `https://idp.egov.kz/oauth2/authorize?response_type=code&client_id=${clientId}&redirect_uri=${redirectUri}&scope=${scope}&state=${state}`;
    //   window.location.href = url;
    // }
  }
};
</script>

<style scoped>
.login-page {
  max-width: 400px;
  margin: 8vh auto;
  padding: 5vh 6vw;
  border-radius: 12px;
  box-shadow: 0 0 12px rgba(0, 0, 0, 0.1);
  background-color: #ffffff;
  box-sizing: border-box;
}

.input-field {
  width: 100%;
  padding: 12px;
  margin: 12px 0;
  border: 1px solid #ccc;
  border-radius: 6px;
  font-size: 1rem;
  box-sizing: border-box;
}

.button {
  width: 100%;
  background-color: #4A90E2;
  color: white;
  padding: 14px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 1rem;
  font-weight: 500;
  transition: background-color 0.3s;
  box-sizing: border-box;
}

.button:hover {
  background-color: #357ABD;
}

.error {
  color: red;
  margin-top: 12px;
  font-size: 0.95rem;
  text-align: center;
}

/* 🔄 Адаптивные стили */
@media (max-width: 600px) {
  .login-page {
    padding: 4vh 5vw;
    margin: 6vh auto;
    border-radius: 8px;
  }

  .input-field,
  .button {
    font-size: 0.95rem;
    padding: 12px;
  }
}

@media (min-width: 1024px) {
  .login-page {
    max-width: 500px;
    padding: 6vh 4vw;
  }

  .input-field,
  .button {
    font-size: 1.05rem;
    padding: 16px;
  }
}
</style>
