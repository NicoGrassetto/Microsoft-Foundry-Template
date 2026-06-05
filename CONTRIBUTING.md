# Contributing

Thank you for taking the time to improve the Microsoft Foundry Agent Service Starter Kit.

## Before You Start

- Read the README for the current project structure, prerequisites, and quick-start flow.
- Check existing issues or discussions before opening a new one.
- Keep changes focused. Separate unrelated fixes into separate pull requests.
- Do not commit secrets, generated credentials, tenant identifiers, subscription identifiers, or local environment files.

## Development Setup

Install the prerequisites listed in the README, then work from the repository root.

Common commands:

```powershell
azd up
python -m src.main
```

To test the model deployment selector without writing azd environment values or deploying resources:

```powershell
.\hooks\preprovision.ps1 -Location eastus -NonInteractive -DryRun
```

## Making Changes

1. Create a branch from the default branch.
2. Make the smallest practical change that solves the problem.
3. Update documentation when behavior, configuration, commands, or prerequisites change.
4. Add or update tests when the change affects runtime behavior.
5. Run the most relevant validation before opening a pull request.

For infrastructure changes, validate Bicep where possible:

```powershell
az bicep build --stdout --file infra/main.bicep
```

## Pull Requests

Pull requests should include:

- A short summary of the change.
- The reason for the change.
- Validation performed, including commands run or why validation was not possible.
- Screenshots or logs for user-visible behavior when useful, with secrets removed.

## Issues

When opening an issue, include:

- What you expected to happen.
- What actually happened.
- Steps to reproduce.
- Relevant environment details, such as OS, Azure CLI version, azd version, and Python version.

For security issues, follow SECURITY.md instead of opening a public issue with details.

## License

By contributing to this repository, you agree that your contributions will be licensed under the MIT License unless explicitly stated otherwise.