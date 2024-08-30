const { defineConfig } = require("@vue/cli-service");
module.exports = defineConfig({
  transpileDependencies: true,
  publicPath: "./", // Use relative paths to ensure compatibility with file:// protocol
});
