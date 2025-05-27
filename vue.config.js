const { defineConfig } = require('@vue/cli-service')
const host = 'localhost';
module.exports = defineConfig({
  devServer: {
    host: host,
    port: 8080,
    https: false
  },
  transpileDependencies: [
    'vuetify'
  ]
})
