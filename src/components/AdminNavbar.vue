<template>
  <v-app>
    <v-navigation-drawer app>
      <v-list>
        <v-list-item-group>
          <v-list-item to="/admin/universities">
            <v-list-item-icon>
              <v-icon>mdi-school</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>Университеты</v-list-item-title>
            </v-list-item-content>
          </v-list-item>

          <v-list-item to="/admin/articles">
            <v-list-item-icon>
              <v-icon>mdi-file-document</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>Статьи</v-list-item-title>
            </v-list-item-content>
          </v-list-item>

          <v-list-item to="/admin/calendar">
            <v-list-item-icon>
              <v-icon>mdi-calendar</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>Календарь</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list-item-group>
      </v-list>
    </v-navigation-drawer>

    <v-main>
      <v-container>
        <router-view></router-view>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
export default {
  name: "AdminNavigation"
};
</script>

<style scoped>
.v-list-item {
  cursor: pointer;
}
</style>
