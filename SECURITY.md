# Security Policy for Kiro-Strategic-Blueprint Workspace

This document outlines the security policies and procedures for the Kiro-Strategic-Blueprint workspace, emphasizing proactive security measures and automated enforcement.

## 1. Reporting a Vulnerability

If you discover a security vulnerability, please report it immediately to `security@[اسم_فريق_التطوير].com`.

## 2. Proactive Security Enforcement (Shift-Left)

Security is enforced automatically through the Model Context Protocol (MCP) and Git Hooks, aligning with the principle of **Pre-Merge Gating**.

| Security Area | Enforcement Mechanism | MCP Server | Policy in `mcp.json` |
| :--- | :--- | :--- | :--- |
| **Secret Management** | Git Hooks (`on-commit`) and Static Analysis | `snyk-vuln-scan` / `iac-scan` | `policies.secrets.allowed_in_repo: false` |
| **Supply Chain Integrity** | Artifact Signing and Verification | `artifact-sign` (cosign) | `policies.enforcement.block_on: artifact_not_signed` |
| **Container Security** | Image Scanning for Vulnerabilities | `container-scan` (Trivy) | `policies.enforcement.block_on: container_scan_failed` |
| **Infrastructure as Code (IaC)** | Static Analysis for Misconfigurations | `iac-scan` (Checkov/tfsec) | `policies.enforcement.block_on: iac_scan_high_risk` |

## 3. Advanced Security Configuration (`SECURITY_ADVANCED.md`)

For detailed configuration of security tools, secret rotation, and agent access control lists (ACLs), please refer to the `SECURITY_ADVANCED.md` file and the `mcp.json` configuration.

## 4. Agent Access Control (ACLs)

Access to sensitive MCP servers (e.g., `vault`, `artifact-sign`) is restricted by default. Only explicitly allowed agents (defined in `mcp.json` under `acl.per_server`) can interact with these systems. This minimizes the blast radius in case of agent compromise.
