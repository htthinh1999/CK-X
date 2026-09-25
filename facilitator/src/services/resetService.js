/**
 * Reset Service
 *
 * Returns every exam jumphost (ckad9999 / ckad9988 / ckad9977) to a pristine
 * state when a session is terminated, so files and system changes made during
 * one session never leak into the next.
 *
 * The internal `resetter` service recreates the jumphost containers from their
 * images (see resetter/server.js); this service calls it and then waits until
 * SSH answers on every jumphost again. If the resetter is unavailable, it falls
 * back to a best-effort in-place cleanup of every jumphost over SSH.
 */

const axios = require('axios');
const config = require('../config');
const logger = require('../utils/logger');
const sshService = require('./sshService');

// Best-effort cleanup used only when the containers cannot be recreated.
const FALLBACK_CLEANUP = [
  'rm -rf /tmp/exam /tmp/exam-env /home/candidate/exam /home/candidate/.exam-cluster',
  'docker rm -f $(docker ps -aq) >/dev/null 2>&1',
  'docker system prune -af --volumes >/dev/null 2>&1',
  'true',
].join('; ');

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

/** Wait until `host` accepts SSH and runs a command, or the deadline passes. */
async function waitForSsh(host, deadline) {
  let lastError = 'timeout';
  while (Date.now() < deadline) {
    try {
      const r = await sshService.executeCommand('true', host);
      if (r.exitCode === 0) return true;
      lastError = `exit ${r.exitCode}`;
    } catch (e) {
      lastError = e.message;
    }
    await sleep(2000);
  }
  logger.warn(`Jumphost ${host} did not answer over SSH after reset: ${lastError}`);
  return false;
}

async function waitForAll() {
  const deadline = Date.now() + config.reset.sshReadyTimeoutMs;
  const ready = await Promise.all(config.reset.hosts.map((h) => waitForSsh(h, deadline)));
  return Object.fromEntries(config.reset.hosts.map((h, i) => [h, ready[i]]));
}

async function fallbackCleanup(reason) {
  logger.warn(`Recreating jumphosts failed (${reason}); falling back to in-place cleanup over SSH`);
  for (const host of config.reset.hosts) {
    try {
      await sshService.executeCommand(FALLBACK_CLEANUP, host);
    } catch (e) {
      logger.error(`Fallback cleanup on ${host} failed`, { error: e.message });
    }
  }
}

/**
 * Reset all jumphosts. Never throws; returns a summary for logging.
 * @returns {Promise<Object>}
 */
async function resetJumphosts() {
  const t0 = Date.now();
  try {
    const { data } = await axios.post(`${config.reset.url}/reset`, null, { timeout: config.reset.timeoutMs });
    logger.info('Jumphosts recreated from their images', data);
    const sshReady = await waitForAll();
    return { method: 'recreate', ...data, sshReady, totalMs: Date.now() - t0 };
  } catch (err) {
    if (err.response && err.response.status === 409) {
      // A reset is already running (e.g. terminate clicked twice): just wait for it.
      logger.info('Jumphost reset already in progress; waiting for the jumphosts to come back');
      return { method: 'recreate', inProgress: true, sshReady: await waitForAll(), totalMs: Date.now() - t0 };
    }
    const reason = (err.response && err.response.data && JSON.stringify(err.response.data)) || err.message;
    await fallbackCleanup(reason);
    return { method: 'fallback', error: reason, totalMs: Date.now() - t0 };
  }
}

module.exports = {
  resetJumphosts,
  FALLBACK_CLEANUP,
};
