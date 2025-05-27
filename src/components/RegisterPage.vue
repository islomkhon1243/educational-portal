<template>
  <div class="register-page">
    <h2 v-if="!isVerifying">Регистрация</h2>
    <h2 v-else>Введите код подтверждения</h2>

    <form v-if="!isVerifying" @submit.prevent="sendVerification">
      <input v-model="name" placeholder="Ваше имя" required class="input-field" />
      <input v-model="email" type="email" placeholder="Ваш email" required class="input-field" />
      <input v-model="password" type="password" placeholder="Пароль" required class="input-field" />
      <button type="submit" class="button">Отправить код подтверждения</button>
    </form>

    <form v-else @submit.prevent="verifyCode">
      <input v-model="verificationCode" placeholder="Enter Code" required class="input-field" />
      <button type="submit" class="button">Подтвердить и зарегистрироваться</button>
    </form>

    <p v-if="successMessage" class="success">{{ successMessage }}</p>
    <p v-if="errorMessage" class="error">{{ errorMessage }}</p>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      name: '',
      email: '',
      password: '',
      verificationCode: '',
      isVerifying: false,
      successMessage: '',
      errorMessage: ''
    };
  },
  methods: {
    async sendVerification() {
      try {
        await axios.post('http://localhost:3000/api/send-verification', { email: this.email });
        this.isVerifying = true;
        this.successMessage = 'Verification code sent to your email.';
        this.errorMessage = '';
      } catch (error) {
        if (error.response && error.response.status === 400) {
          // Если ошибка 400, выводим сообщение о существующем пользователе
          this.errorMessage = 'User with this email already exists.';
        } else {
          // Для других ошибок
          this.errorMessage = 'Failed to send verification code.';
        }
      }
    },
    async verifyCode() {
      try {
        await axios.post('http://localhost:3000/api/verify-code', {
          email: this.email,
          code: this.verificationCode,
          name: this.name,
          password: this.password
        });
        this.successMessage = 'Registration successful! Please log in.';
        this.errorMessage = '';
        setTimeout(() => {
          this.$router.push({ name: 'Login' });
        }, 2000);
      } catch (error) {
        this.errorMessage = 'Verification failed!';
      }
    }
  }
};
</script>

<style scoped>
.register-page {
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
  font-size: 0.95rem;
  margin-top: 12px;
  text-align: center;
}

.success {
  color: green;
  font-size: 0.95rem;
  margin-top: 12px;
  text-align: center;
}

/* 🔄 Адаптивность */
@media (max-width: 600px) {
  .register-page {
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
  .register-page {
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
