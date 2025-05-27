<template>
  <v-container>
    <v-row>
      <v-col cols="12">
        <v-text-field
            v-model="searchQuery"
            label="Search resources"
            @input="searchResources"
            prepend-icon="mdi-magnify"
        ></v-text-field>
      </v-col>
    </v-row>
    <v-row>
      <v-col
          v-for="resource in filteredResources"
          :key="resource.id"
          cols="12" sm="6" md="4"
      >
        <v-card>
          <v-card-title>{{ resource.title }}</v-card-title>
          <v-card-subtitle>{{ resource.category }}</v-card-subtitle>
          <v-card-text>{{ resource.description }}</v-card-text>
          <v-card-actions>
            <v-btn color="primary" :href="resource.url" target="_blank">Learn More</v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      resources: [],
      searchQuery: '',
      filteredResources: []
    };
  },
  mounted() {
    this.fetchResources();
  },
  methods: {
    async fetchResources() {
      try {
        const response = await axios.get('http://localhost:3000/api/resources');
        this.resources = response.data;
        this.filteredResources = this.resources;
      } catch (error) {
        console.error("Error fetching resources:", error);
      }
    },
    searchResources() {
      this.filteredResources = this.resources.filter(resource =>
          resource.title.toLowerCase().includes(this.searchQuery.toLowerCase())
      );
    }
  }
};
</script>

<style>
.v-card {
  transition: transform 0.2s;
}
.v-card:hover {
  transform: scale(1.05);
}
</style>