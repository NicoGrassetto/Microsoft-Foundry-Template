# Microsoft Foundry Template

<p align="center">
  <img src="assets/logo.png" alt="Microsoft Foundry logo" width="150">
</p>

As a Microsoft Solutions Engineer, I'm often asked to spin up demos, PoCs, and pilots on Microsoft Foundry, so I'm sharing the template I reach for every time. It keeps evolving alongside new Microsoft announcements, but the structure always reflects practices I've found efficient and reliable. I deliberately keep it high level so it can accommodate any tool, agent, or scenario. It's not production-ready, but you'll find plenty of LLMOps and GenAIOps features along the way. It's also IDE-agnostic and Python-first — and always will be.

Got a suggestion? Check out [Contributing.md](CONTRIBUTING.md). And feel free to reach out: 
- customers at ngrassetto@microsoft.com
- everyone else at nicograssetto@gmail.com. 
  
Hope it helps. Cheers!

This template can be used for Microsft Foundry: `PoCs`, `Demos`, `Pilots`, `Hackathons`, `Learning`, `Workshops` among others.

## 🚀 Get started
## 📦 What's in this repository

| Surface | What it is | Best for |
| --- | --- | --- |
| 📥 **[Releases](https://github.com/microsoft/discovery/releases)** | Signed Windows installers and release notes for the Discovery app. | Downloading the latest build of the app. |
| 🤖 **[`agents/`](https://github.com/microsoft/discovery/blob/main/agents)** | Catalog of AI research agents (1P and 3P) surfaced in Discovery. Each entry contains a `metadata.yaml`, `agent.yaml`, `README.md`, and optional `tools/`. | Browsing what's available, or contributing a new agent. |
| 📑 **[`docs/`](https://github.com/microsoft/discovery/blob/main/docs)** | Documentation and pointers for both Microsoft Discovery and the Discovery app, including documentation for authoring guides and schemas. | Learning more about Discovery experiences and best practices. |
| 🎥 **[How to videos](https://github.com/microsoft/discovery/blob/main/docs/how-to-videos/README.md)** | Curated how-to video content for Discovery workflows and onboarding. | Watching guided walkthroughs and quick task demos. |
| 🧰 **[`starter-kits/`](https://github.com/microsoft/discovery/blob/main/starter-kits)** | Catalog of starter kits — `kit.json` manifests that bundle one or more catalog agents into a launchable scenario. | Browsing pre-built workflows, or publishing a new kit. |
| 💬 **[Discussions](https://github.com/microsoft/discovery/discussions)** | Q&A, Ideas, Bugs, and Show-and-tell — the single place for everything from "how do I…?" to bug reports, ideas, and sharing what you've built. | Asking questions, suggesting ideas, sharing what you've built, and reporting bugs. |
| 🧪 **[`.github/skills/`](https://github.com/microsoft/discovery/blob/main/.github/skills)** | Three Copilot skills auto-discovered by Copilot CLI and VS Code Copilot Chat — for browsing the catalog and deploying agents / starter kits to **Microsoft Discovery services** (cloud, via Microsoft Foundry). Not used by the local Discovery app today. | Researchers and developers integrating the catalog into a Microsoft Foundry workflow. |

## 📚 Resources

- **[Microsoft Foundry documentation](https://learn.microsoft.com/en-us/azure/foundry/)** — concepts, quickstarts, and how-to guides.
- **[REST API reference](https://learn.microsoft.com/en-us/rest/api/aifoundry/)** — the Microsoft Foundry REST API.
- **[Bicep reference](https://learn.microsoft.com/en-us/azure/templates/microsoft.cognitiveservices/accounts)** — deploy Microsoft Foundry (`Microsoft.CognitiveServices/accounts`) as infrastructure as code.

### 🎓 Certifications

Worth a look if you want to level up your Foundry, AI, and GitHub skills.

- **[Azure AI Apps and Agents Developer Associate (beta)](https://learn.microsoft.com/en-us/credentials/certifications/azure-ai-apps-and-agents-developer-associate/?practice-assessment-type=certification)** — build, manage, and deploy agents and AI solutions on Microsoft Foundry with Python (exam AI-103).
- **[Azure AI Cloud Developer Associate (beta)](https://learn.microsoft.com/en-us/credentials/certifications/azure-ai-cloud-developer-associate/?practice-assessment-type=certification)** — back-end services, containers, data, and the full lifecycle for AI solutions on Azure (exam AI-200).
- **[Machine Learning Operations Engineer Associate](https://learn.microsoft.com/en-us/credentials/certifications/operationalizing-machine-learning-and-generative-ai-solutions/?practice-assessment-type=certification)** — MLOps and GenAIOps infrastructure with Azure Machine Learning and Foundry (exam AI-300).

- **[GitHub Foundations](https://learn.microsoft.com/en-us/credentials/certifications/github-foundations/?WT.mc_id=certposter_poster_wwl&practice-assessment-type=certification)** — core GitHub collaboration, repositories, and workflows.
- **[GitHub Administration](https://learn.microsoft.com/en-us/credentials/certifications/github-administration/?WT.mc_id=certposter_poster_wwl&practice-assessment-type=certification)** — managing and configuring GitHub organizations and repositories.
- **[GitHub Actions](https://learn.microsoft.com/en-us/credentials/certifications/github-actions/?WT.mc_id=certposter_poster_wwl&practice-assessment-type=certification)** — automating workflows and CI/CD pipelines with GitHub Actions.
- **[GitHub Copilot](https://learn.microsoft.com/en-us/credentials/certifications/github-copilot/?WT.mc_id=certposter_poster_wwl&practice-assessment-type=certification)** — using GitHub Copilot effectively across the development workflow.
- **[GitHub Certified: Agentic AI Developer (beta)](https://learn.microsoft.com/en-us/credentials/certifications/agentic-ai-developer/?practice-assessment-type=certification)** — operating, governing, and orchestrating AI agents in production SDLC workflows with GitHub as the control plane (exam GH-600).

## My setup
My setup (often asked by customers)

OpenCode
GitHub & GitHub Copilot
Hermes agent from Noure 
Keyboard: Keychron K8 Pro