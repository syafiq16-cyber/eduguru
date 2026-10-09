const path = require('path');

module.exports = {
  apps: [{
    name: "eduguru",
    script: "server.js",
    cwd: path.resolve(__dirname, "backend"),
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: "1G",
    env: {
      NODE_ENV: "production",
      PORT: process.env.PORT || 3002
    }
  }]
};
