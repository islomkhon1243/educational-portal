<template>
  <v-container>
    <v-form @submit.prevent="registerApplicant">
      <v-text-field
          v-model="name"
          label="Your Name"
          required
      ></v-text-field>
      <v-text-field
          v-model="email"
          label="Your Email"
          type="email"
          required
      ></v-text-field>
      <v-text-field
          v-model="password"
          label="Password"
          type="password"
          required
      ></v-text-field>
      <v-btn type="submit" color="success">Register</v-btn>
    </v-form>
  </v-container>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      name: '',
      email: '',
      password: ''
    };
  },
  methods: {
    async registerApplicant() {
      try {
        const response = await axios.post('http://localhost:3000/api/register', {
          name: this.name,
          email: this.email,
          password: this.password
        });
        alert(`Registered successfully: ${response.data.name}`);
        this.name = '';
        this.email = '';
        this.password = '';
      } catch (error) {
        console.error("Error registering applicant:", error);
      }
    }
  }
};
</script>

<style>
.v-btn {
  margin-top: 20px;
}
</style>