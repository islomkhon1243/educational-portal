<template>
  <v-app-bar app>
    <v-toolbar-title class="mr-4 ml-4">Futurum</v-toolbar-title>

    <!-- Меню для планшетов и десктопов -->
    <div class="d-none d-md-flex">
      <v-btn text to="/universities">Университеты</v-btn>
      <v-btn text to="/articles">Статьи</v-btn>
      <v-btn text to="/calendar">Календарь</v-btn>
    </div>

    <v-spacer></v-spacer>

    <!-- Авторизация - десктоп -->
    <div class="d-none d-md-flex align-center">
      <v-btn text to="/dashboard" v-if="isAuthenticated" class="username-btn">
        <span v-if="firstname">{{ firstname }}</span>
        <span v-else>Guest</span>
      </v-btn>
      <v-btn text v-if="isAuthenticated" to="/logout">Выйти</v-btn>
      <v-btn text v-if="!isAuthenticated" to="/login">Вход</v-btn>
      <v-btn text v-if="!isAuthenticated" to="/register">Зарегистрироваться</v-btn>
    </div>

    <!-- Навигационная панель для мобильных -->
    <div class="d-flex d-md-none">
      <v-menu
        bottom
        left
        offset-y
        content-class="mobile-menu-content"
        attach="body"
      >
        <template #activator="{ on, attrs }">
          <v-btn icon v-bind="attrs" v-on="on">
            <v-icon>mdi-menu</v-icon>
          </v-btn>
        </template>
    
        <v-list dense>
          <v-list-item to="/universities">
            <v-list-item-title>Университеты</v-list-item-title>
          </v-list-item>
          <v-list-item to="/articles">
            <v-list-item-title>Статьи</v-list-item-title>
          </v-list-item>
          <v-list-item to="/calendar">
            <v-list-item-title>Календарь</v-list-item-title>
          </v-list-item>
    
          <v-divider></v-divider>
    
          <template v-if="isAuthenticated">
            <v-list-item to="/dashboard">
              <v-list-item-title class="username-list-item">
                {{ firstname || 'Гость' }}
              </v-list-item-title>
            </v-list-item>
            <v-list-item to="/logout">
              <v-list-item-title>Выйти</v-list-item-title>
            </v-list-item>
          </template>
          <template v-else>
            <v-list-item to="/login">
              <v-list-item-title>Вход</v-list-item-title>
            </v-list-item>
            <v-list-item to="/register">
              <v-list-item-title>Зарегистрироваться</v-list-item-title>
            </v-list-item>
          </template>
        </v-list>
      </v-menu>
    </div>
  </v-app-bar>
</template>

<style scoped>
.v-btn {
  min-width: auto;
}

.username-btn {
  font-weight: 700;
  color: #1976D2;
  border-bottom: 2px solid #1976D2;
  cursor: default;
}

/* Обеспечить z-index для меню */
.mobile-menu-content {
  z-index: 3000 !important; /* выше стандартного z-index элементов vuetify */
  position: absolute !important;
}

/* Управление отображением по брейкпоинтам */
.d-md-none {
  display: none;
}

@media (max-width: 960px) {
  .d-md-none {
    display: inline-flex !important;
  }
  .d-md-flex {
    display: none !important;
  }
}
</style>
