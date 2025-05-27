import Vue from 'vue';
import App from './App.vue';
import router from './router'; // Ensure this points to your router setup
import vuetify from './plugins/vuetify'

Vue.config.productionTip = false;

new Vue({
  // Make sure the router is included here
  router,

  vuetify,
  render: h => h(App)
}).$mount('#app');