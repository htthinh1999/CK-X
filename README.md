
![Master Kubernetes the Right Way (2)](https://github.com/user-attachments/assets/16edd8d8-5f96-4422-8659-3bb490b77204)

# CK-X Simulator 🚀


A powerful Kubernetes certification practice environment that provides a realistic exam-like experience for kubernetess exam preparation.

> 🧩 **Combined project:** this repository merges two open-source projects — the [CK-X Simulator](https://github.com/sailor-sh/CK-X) platform and the [ckad-dojo](https://github.com/TiPunchLabs/ckad-dojo) CKAD exam simulations — so the complete ckad-dojo exam set can be practised inside CK-X. See [Credits & Combined Sources](#credits--combined-sources).
>
> 🤖 **Supported by [Claude](https://claude.ai/code)** — Anthropic's Claude Code.

## Major Features

- **Realistic exam environment** with web-based interface and remote desktop support
- Comprehensive practice labs for **CKAD, CKA, CKS**, and other Kubernetes certifications
- **Smart evaluation system** with real-time solution verification
- **Docker-based deployment** for easy setup and consistent environment
- **Timed exam mode** with real exam-like conditions and countdown timer 


## 

Watch live demo video showcasing the CK-X Simulator in action:

[![CK-X Simulator Demo](https://img.youtube.com/vi/EQVGhF8x7R4/0.jpg)](https://www.youtube.com/watch?v=EQVGhF8x7R4)

## Installation

#### Linux & macOS
```bash
curl -fsSL https://raw.githubusercontent.com/sailor-sh/CK-X/master/scripts/install.sh | bash
```

#### Windows ( make sure WSL2 is enabled in the docker desktop )
```powershell
irm  https://raw.githubusercontent.com/sailor-sh/CK-X/master/scripts/install.ps1 | iex
```

### Manual Installation
For detailed installation instructions, please refer to our [Deployment Guide](scripts/COMPOSE-DEPLOY.md).

## Community & Support

- Join our [Discord Community](https://discord.gg/6FPQMXNgG9) for discussions and support
- Feature requests and pull requests are welcome

## Adding New Labs

Check our [Lab Creation Guide](docs/how-to-add-new-labs.md) for instructions on adding new labs.

## Contributing

We welcome contributions! Whether you want to:
- Add new practice labs
- Improve existing features
- Fix bugs
- Enhance documentation


## Disclaimer

CK-X is an independent tool, not affiliated with CNCF, Linux Foundation, or PSI. We do not guarantee exam success. Please read our [Privacy Policy](docs/PRIVACY_POLICY.md) and [Terms of Service](docs/TERMS_OF_SERVICE.md) for more details about data collection, usage, and limitations.

## Credits & Combined Sources

This repository stands on the shoulders of two excellent open-source projects. Huge thanks to their authors and communities 🙏

- **[CK-X Simulator](https://github.com/sailor-sh/CK-X)** — by **[Sailor.sh](https://github.com/sailor-sh)**. The Kubernetes certification practice platform this project is built on: the web UI, remote desktop, KIND-based cluster, jumphost, and the smart evaluation engine. Licensed under the Business Source License 1.1.
- **[ckad-dojo](https://github.com/TiPunchLabs/ckad-dojo)** — by **Xavier Guéret / [TiPunch Labs](https://ckad-dojo.tipunchlabs.fr/)**. The source of the 20 full CKAD exam simulations that are now available here as labs **`ckad-003` … `ckad-022`**. These labs were adapted into the CK-X lab format (question, verification, and setup scripts, with file paths and scoring re-mapped to the CK-X runtime) and remain licensed under **CC BY-NC-SA 4.0** (© 2025 Xavier Guéret).

How the ckad-dojo exams were mapped into CK-X labs is documented in the [Lab Creation Guide](docs/how-to-add-new-labs.md).

> 🤖 **Supported by Claude.** The ckad-dojo → CK-X conversion of these 20 simulations, the content-fidelity audit, and ongoing maintenance were carried out with the support of [Claude](https://claude.ai/code) (Anthropic's Claude Code).

## Acknowledgments

- [DIND](https://www.docker.com/)
- [K3D](https://k3d.io/stable/)
- [Node](https://nodejs.org/en)
- [Nginx](https://nginx.org/)
- [ConSol-Vnc](https://github.com/ConSol/docker-headless-vnc-container/)

## License

This project is licensed under the Business Source License 1.1 (BSL 1.1). Personal, educational, research, and non-production use is allowed, but commercial/production usage and SaaS monetization require a separate commercial license from Sailor.sh. See the `LICENSE` file for full terms.

**Imported CKAD labs:** the exam content under `facilitator/assets/exams/ckad/003` … `022` is derived from [ckad-dojo](https://github.com/TiPunchLabs/ckad-dojo) and is licensed under [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)](https://creativecommons.org/licenses/by-nc-sa/4.0/) © 2025 Xavier Guéret. Those labs were modified (converted to the CK-X lab format) and, per the ShareAlike terms, remain under CC BY-NC-SA 4.0.
