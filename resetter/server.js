'use strict';
/**
 * Jumphost resetter (internal service).
 *
 * When an exam session is terminated, the facilitator calls POST /reset and
 * this service recreates the exam jumphost containers (ckad9999 / ckad9988 /
 * ckad9977) from their images, so the next session starts from a pristine
 * filesystem: every file created and every system change made during the
 * previous session is discarded. Named volumes (e.g. the shared kube-config)
 * are kept and re-attached.
 *
 * Each container is recreated from its own inspected configuration (image,
 * hostname, environment, privileged mode, mounts, network aliases, compose
 * labels), so Docker Compose keeps treating it as the same service.
 *
 * Security: this service holds the Docker socket, so it is internal-only (no
 * published ports), takes no parameters, and only ever touches the services
 * named in RESET_SERVICES that belong to its own Compose project.
 */
const http = require('http');

const SOCKET = process.env.DOCKER_SOCKET || '/var/run/docker.sock';
const SERVICES = (process.env.RESET_SERVICES || 'jumphost,jumphost-2,jumphost-3')
  .split(',').map((s) => s.trim()).filter(Boolean);
const PORT = parseInt(process.env.PORT || '3000', 10);
const STOP_TIMEOUT = parseInt(process.env.STOP_TIMEOUT || '5', 10);

function log(msg) {
  console.log(`[${new Date().toISOString()}] ${msg}`);
}

/** Minimal Docker Engine API client over the unix socket. */
function docker(method, path, body) {
  return new Promise((resolve, reject) => {
    const data = body === undefined ? undefined : JSON.stringify(body);
    const req = http.request({
      socketPath: SOCKET,
      path,
      method,
      headers: data ? { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(data) } : {},
    }, (res) => {
      let buf = '';
      res.on('data', (c) => { buf += c; });
      res.on('end', () => {
        let json = null;
        try { json = buf ? JSON.parse(buf) : null; } catch (_) { json = buf; }
        if (res.statusCode >= 400) {
          reject(new Error(`${method} ${path} -> ${res.statusCode}: ${(json && json.message) || buf}`));
        } else {
          resolve(json);
        }
      });
    });
    req.on('error', reject);
    req.setTimeout(120000, () => req.destroy(new Error(`${method} ${path} timed out`)));
    if (data) req.write(data);
    req.end();
  });
}

const filters = (f) => encodeURIComponent(JSON.stringify(f));

/** Compose project this resetter belongs to (so only our own stack is touched). */
async function ownProject() {
  try {
    const self = await docker('GET', `/containers/${encodeURIComponent(process.env.HOSTNAME || '')}/json`);
    return (self.Config.Labels || {})['com.docker.compose.project'] || null;
  } catch (_) {
    return null;
  }
}

/** Build the /containers/create body that reproduces an inspected container. */
function buildCreateBody(info) {
  const shortId = info.Id.slice(0, 12);
  const body = {
    ...info.Config,
    HostConfig: info.HostConfig,
    NetworkingConfig: { EndpointsConfig: {} },
  };
  const endpoints = Object.entries((info.NetworkSettings && info.NetworkSettings.Networks) || {})
    .map(([name, n]) => {
      const cfg = { Aliases: (n.Aliases || []).filter((a) => a !== shortId && a !== info.Id) };
      if (n.IPAMConfig) cfg.IPAMConfig = n.IPAMConfig;
      if (n.Links) cfg.Links = n.Links;
      if (n.DriverOpts) cfg.DriverOpts = n.DriverOpts;
      return { name, cfg };
    });
  // Older API versions accept only one network at create time; connect the rest after.
  if (endpoints[0]) body.NetworkingConfig.EndpointsConfig[endpoints[0].name] = endpoints[0].cfg;
  return { name: info.Name.replace(/^\//, ''), body, extraNetworks: endpoints.slice(1) };
}

/** Stop + remove + recreate + start one container. */
async function recreate(info) {
  const { name, body, extraNetworks } = buildCreateBody(info);
  const service = (info.Config.Labels || {})['com.docker.compose.service'] || name;
  log(`recreating ${service} (${name})`);
  await docker('POST', `/containers/${info.Id}/stop?t=${STOP_TIMEOUT}`);
  // v=true drops anonymous volumes only; named volumes (kube-config, exam-assets) survive
  await docker('DELETE', `/containers/${info.Id}?force=true&v=true`);
  const created = await docker('POST', `/containers/create?name=${encodeURIComponent(name)}`, body);
  for (const n of extraNetworks) {
    await docker('POST', `/networks/${encodeURIComponent(n.name)}/connect`, { Container: created.Id, EndpointConfig: n.cfg });
  }
  await docker('POST', `/containers/${created.Id}/start`);
  log(`recreated ${service} -> ${created.Id.slice(0, 12)}`);
  return { service, name, id: created.Id.slice(0, 12) };
}

/** Find the jumphost containers of our project and recreate them in parallel. */
async function resetAll() {
  const project = await ownProject();
  const labelFilter = project ? [`com.docker.compose.project=${project}`] : [];
  const list = await docker('GET', `/containers/json?all=1&filters=${filters({ label: labelFilter })}`);
  const targets = list.filter((c) => SERVICES.includes((c.Labels || {})['com.docker.compose.service']));
  const found = targets.map((c) => c.Labels['com.docker.compose.service']);
  const missing = SERVICES.filter((s) => !found.includes(s));
  const infos = await Promise.all(targets.map((c) => docker('GET', `/containers/${c.Id}/json`)));
  const results = await Promise.allSettled(infos.map(recreate));
  const reset = results.filter((r) => r.status === 'fulfilled').map((r) => r.value);
  const failed = results.filter((r) => r.status === 'rejected').map((r) => r.reason.message);
  return { project, reset, missing, failed };
}

let busy = false;

function send(res, code, obj) {
  res.writeHead(code, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify(obj));
}

function start() {
  http.createServer(async (req, res) => {
    if (req.method === 'GET' && req.url === '/health') return send(res, 200, { ok: true, services: SERVICES });
    if (req.method !== 'POST' || req.url !== '/reset') return send(res, 404, { error: 'not found' });
    if (busy) return send(res, 409, { error: 'reset already in progress' });
    busy = true;
    const t0 = Date.now();
    try {
      const out = await resetAll();
      out.durationMs = Date.now() - t0;
      log(`reset done: ${JSON.stringify(out)}`);
      send(res, out.failed.length ? 500 : 200, out);
    } catch (e) {
      log(`reset failed: ${e.message}`);
      send(res, 500, { error: e.message });
    } finally {
      busy = false;
    }
  }).listen(PORT, () => log(`jumphost resetter listening on :${PORT} (services: ${SERVICES.join(', ')})`));
}

if (require.main === module) start();

module.exports = { buildCreateBody, recreate, resetAll, docker };
