<template>
  <v-container class="home-page" fluid>
    <v-row justify="center">
      <v-col cols="12" md="8" class="text-center">
        <h1>Добро пожаловать на образовательный портал</h1>
        <p>Ваш путь к знаниям начинается здесь!</p>
        <v-btn @click="goToLogin" class="ma-2" color="primary">Вход</v-btn>
        <v-btn @click="goToRegister" class="ma-2" color="success">Регистрация</v-btn>
        <v-btn @click="continueWithoutLogin" class="ma-2" color="grey" outlined>
          Продолжить без входа
        </v-btn>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  methods: {
    goToLogin() {
      this.$router.push({name: 'Login'});
    },
    goToRegister() {
      this.$router.push({name: 'Register'});
    },
    continueWithoutLogin() {
      this.$router.push({name: 'Universities'});
    },
  }
};
</script>

<style scoped>
.home-page {
  text-align: center;
  padding: 5vh 2vw;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  box-sizing: border-box;
}

@media (max-width: 600px) {
  .home-page {
    padding: 3vh 5vw;
  }

  .home-page h1 {
    font-size: 1.6rem;
  }

  .home-page p {
    font-size: 1rem;
  }
}

@media (min-width: 601px) and (max-width: 1024px) {
  .home-page h1 {
    font-size: 2rem;
  }

  .home-page p {
    font-size: 1.2rem;
  }
}

@media (min-width: 1025px) {
  .home-page h1 {
    font-size: 2.5rem;
  }

  .home-page p {
    font-size: 1.4rem;
  }
}

/* Улучшим стили кнопок Vuetify */
.v-btn {
  font-size: 1rem;
  padding: 12px 24px;
  white-space: normal;
  word-break: break-word;
}

@media (max-width: 600px) {
  .v-btn {
    width: 100%;
    font-size: 0.95rem;
    padding: 10px 18px;
  }
}
</style>