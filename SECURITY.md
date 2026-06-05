# Security Policy

## Reporting a Vulnerability

Please report suspected security vulnerabilities privately. Do not open a public issue with exploit details, secrets, tenant identifiers, subscription identifiers, tokens, keys, or other sensitive information.

Preferred reporting path:

1. Use GitHub private vulnerability reporting or GitHub Security Advisories for this repository, if available.
2. If private reporting is not available, open a public issue that only asks for a maintainer security contact. Do not include technical details until a private channel is established.

When reporting, please include:

- A clear description of the vulnerability and its impact.
- Steps to reproduce, proof-of-concept details, or affected configuration, when safe to share privately.
- Any relevant logs, screenshots, or error messages with secrets removed.
- Suggested remediation, if you have one.

Maintainers will review reports as quickly as possible and may ask for additional information before confirming impact or publishing a fix.

## Supported Versions

This starter kit does not currently maintain separate release branches. Security fixes are applied to the default branch unless otherwise noted.

## Safe Handling

This project may interact with Azure resources and AI services. Treat environment files, deployment outputs, subscription identifiers, model endpoints, API keys, and generated credentials as sensitive. Never commit secrets to the repository.