# Snyk Security Plugin for Antigravity

Snyk integrates static application security testing (SAST), software composition analysis (SCA), container security, Infrastructure-as-Code (IaC) auditing, and secret detection directly into Antigravity.

## What's Included

- **MCP Server** — Connects Antigravity to the local authenticated Snyk CLI (`v1.1308.4`) with 15 security tools
- **Skills** — A `snyk-security` skill with structured workflows for vulnerability discovery, access control auditing, and automated remediation

## Available Tools

### snyk_code_scan
Runs Static Application Security Testing (SAST) on source code to detect injection flaws, broken access control, IDOR, mass assignment, and insecure cryptography.

### snyk_sca_scan
Audits project manifests (`package.json`, `requirements.txt`, `go.mod`, `Cargo.toml`, `pom.xml`) against the Snyk vulnerability database for known CVEs and transitive dependency risks.

### snyk_secret_scan
Scans repositories and configuration files for leaked credentials, API tokens, and private keys.

### snyk_iac_scan & snyk_container_scan
Audits Dockerfiles, Kubernetes manifests, and Terraform configurations for cloud misconfigurations.

## Usage Examples

- "Run a full Snyk security audit on this backend and prioritize critical vulnerabilities"
- "Scan `package.json` for vulnerable dependencies and recommend safe upgrade paths"
- "Check all authentication and membership routes for privilege escalation flaws"
