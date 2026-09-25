# CK-X Simulator Deployment Guide

This guide provides instructions for deploying the CK-X Simulator on different operating systems.

## Prerequisites

- Docker Desktop (Windows/Mac) or Docker Engine (Linux) with the Docker Compose plugin
- Internet connection (to pull images and Helm charts)
- Host port `30080` available

### System requirements

| Resource  | Minimum | Recommended |
| --------- | ------- | ----------- |
| RAM       | 8 GB    | 16 GB       |
| CPU       | 4 cores | 6–8 cores   |
| Free disk | 20 GB   | 40 GB       |

- **Minimum** is enough for the full stack and the standard single-cluster labs
  (CKAD / CKA / CKS / Docker / Helm).
- **Recommended** is for the multi-cluster exams (the CKAD and CKA multi-cluster
  labs start 2–3 k3d clusters at once), which need the extra RAM and CPU headroom.

## Install (build from source)

This fork adds new CKAD exams that are **bundled into the images at build time**, so install by building locally. The upstream published images do not include these labs, so do **not** use the upstream one-line installer or `docker compose pull`.

1. Clone this repository:
   ```bash
   git clone https://github.com/htthinh1999/CK-X.git
   cd CK-X
   ```

2. Build all images and start the stack. Either use the helper script:
   ```bash
   ./compose-deploy.sh
   ```
   which builds every image from source, starts the services, waits for the Kubernetes cluster, and prints the access URL — or run Docker Compose directly:
   ```bash
   docker compose up -d --build
   ```

> On Windows, enable WSL2 in Docker Desktop and run these commands from a WSL / Git Bash shell.

## Post-Installation

After successful installation, you can access CK-X Simulator at:
```
http://localhost:30080
```

## Managing CK-X Simulator

### Start Services
```bash
docker compose up -d
```

### Stop Services
```bash
docker compose down
```

### View Logs
```bash
docker compose logs -f
```

### Update
```bash
git pull
docker compose up -d --build
```

## Troubleshooting

### Common Issues

1. **Port 30080 Already in Use**
   - Check what's using the port: 
     - Windows: `netstat -ano | findstr :30080`
     - Linux/Mac: `lsof -i :30080`
   - Stop the conflicting service or change the port in docker-compose.yml

2. **Docker Not Running**
   - Windows/Mac: Start Docker Desktop
   - Linux: `sudo systemctl start docker`

3. **Permission Issues**
   - Windows: Run PowerShell as Administrator
   - Linux: Add user to docker group or use sudo

4. **Services Not Starting**
   - Check logs: `docker compose logs -f`
   - Ensure sufficient system resources

5. **Jumphosts not reset after "Terminate session"**
   - The `resetter` service recreates the jumphost containers and needs the Docker socket (`/var/run/docker.sock`, mounted by `docker-compose.yaml`).
   - Rootless Docker: start the stack with `DOCKER_SOCKET=$XDG_RUNTIME_DIR/docker.sock docker compose up -d --build`.
   - Check `docker compose logs resetter`. If it can't reach Docker, the facilitator falls back to a best-effort cleanup over SSH.

### Getting Help

If you encounter issues:
1. Check the logs: `docker compose logs -f`
2. Visit our [GitHub Issues](https://github.com/htthinh1999/CK-X/issues)
3. Contact support with logs and system information

## Uninstallation

To completely remove CK-X Simulator:

```bash
# Stop and remove containers
docker compose down

# Remove the cloned repository
cd ..
rm -rf CK-X
```
