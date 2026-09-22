
![Master Kubernetes the Right Way (2)](https://github.com/user-attachments/assets/16edd8d8-5f96-4422-8659-3bb490b77204)

# CK-X Simulator 🚀

> **Notice — this is a fork, not the original project.**
> This repository does not claim ownership of the platform or the exam content. It is a fork that **combines two open-source projects**, and all credit goes to their authors and communities 🙏
>
> - **[CK-X Simulator](https://github.com/sailor-sh/CK-X)** — by **[Sailor.sh](https://github.com/sailor-sh)**. The Kubernetes certification practice platform this repository is built on. Licensed under the Business Source License 1.1.
> - **[ckad-dojo](https://github.com/TiPunchLabs/ckad-dojo)** — by **Xavier Guéret / [TiPunch Labs](https://ckad-dojo.tipunchlabs.fr/)**. The source of the 20 CKAD exam simulations added here as labs **`ckad-003` … `ckad-022`**. Licensed under **CC BY-NC-SA 4.0** (© 2025 Xavier Guéret).
>
> See the [Lab Creation Guide](docs/how-to-add-new-labs.md) for how the ckad-dojo exams were mapped into CK-X labs.

> 🤖 **Supported by [Claude](https://claude.ai/code)** — Anthropic's Claude Code.

A powerful Kubernetes certification practice environment that provides a realistic exam-like experience for kubernetess exam preparation.

## Major Features

- **Realistic exam environment** with web-based interface and remote desktop support
- Comprehensive practice labs for **CKAD, CKA, CKS**, and other Kubernetes certifications
- **Smart evaluation system** with real-time solution verification
- **Docker-based deployment** for easy setup and consistent environment
- **Timed exam mode** with real exam-like conditions and countdown timer 

## Installation

The added CKAD exams are bundled into the images at build time, so install this fork by **building from source**. The upstream published images do **not** include these labs, so build locally rather than using the upstream one-line installer.

```bash
# Clone this repository
git clone https://github.com/htthinh1999/CK-X.git
cd CK-X

# Build all images from source (this bundles the exams) and start the stack
./compose-deploy.sh
```

`compose-deploy.sh` builds every image locally, starts the services, waits for the Kubernetes cluster to be ready, and prints the access URL. When it finishes, open **http://localhost:30080** in your browser.

Prefer plain Docker Compose (or on Windows)? Run the equivalent directly:

```bash
docker compose up -d --build
```

then open **http://localhost:30080**. To stop the stack, run `docker compose down --volumes --remove-orphans`.

> **Requirements:** Docker and the Docker Compose plugin. On Windows, enable WSL2 in Docker Desktop and run the commands from a WSL / Git Bash shell.

### Detailed deployment
For prerequisites, management commands, and troubleshooting, see the [Deployment Guide](scripts/COMPOSE-DEPLOY.md).

## Disclaimer

CK-X is an independent tool, not affiliated with CNCF, Linux Foundation, or PSI. We do not guarantee exam success. Please read our [Privacy Policy](docs/PRIVACY_POLICY.md) and [Terms of Service](docs/TERMS_OF_SERVICE.md) for more details about data collection, usage, and limitations.

## License

The platform code is licensed under the Business Source License 1.1 (BSL 1.1). Personal, educational, research, and non-production use is allowed, but commercial/production usage and SaaS monetization require a separate commercial license from Sailor.sh. See the `LICENSE` file for full terms.

**Imported CKAD labs:** the exam content under `facilitator/assets/exams/ckad/003` … `022` is derived from [ckad-dojo](https://github.com/TiPunchLabs/ckad-dojo) and is licensed under [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)](https://creativecommons.org/licenses/by-nc-sa/4.0/) © 2025 Xavier Guéret. Those labs were modified (converted to the CK-X lab format) and, per the ShareAlike terms, remain under CC BY-NC-SA 4.0.
