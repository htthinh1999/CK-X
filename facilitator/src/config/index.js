require('dotenv').config();

const config = {
  port: process.env.PORT || 3000,
  env: process.env.NODE_ENV || 'development',
  
  ssh: {
    host: process.env.SSH_HOST || 'jumphost',
    port: parseInt(process.env.SSH_PORT || '22', 10),
    username: process.env.SSH_USERNAME || 'candidate',
    // Password is optional as jumphost allows passwordless authentication
    password: process.env.SSH_PASSWORD,
    privateKeyPath: process.env.SSH_PRIVATE_KEY_PATH,
  },
  
  logging: {
    level: process.env.LOG_LEVEL || 'info',
  },

  remoteDesktop: {
    host: process.env.REMOTE_DESKTOP_HOST || 'remote-desktop',
    port: process.env.REMOTE_DESKTOP_PORT || 5000
  },

  // Reset of the exam jumphosts when a session is terminated (see resetter/).
  reset: {
    url: process.env.RESETTER_URL || 'http://resetter:3000',
    timeoutMs: parseInt(process.env.RESET_TIMEOUT_MS || '180000', 10),
    // SSH hosts that must answer again before cleanup is reported complete
    hosts: (process.env.JUMPHOST_POOL || 'jumphost,ckad9988,ckad9977')
      .split(',').map((s) => s.trim()).filter(Boolean),
    sshReadyTimeoutMs: parseInt(process.env.RESET_SSH_READY_TIMEOUT_MS || '120000', 10),
  },
};

module.exports = config; 