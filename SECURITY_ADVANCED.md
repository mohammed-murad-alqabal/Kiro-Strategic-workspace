# Advanced Security Configuration: Kiro-Strategic-Blueprint

This document provides detailed instructions for configuring the advanced security features outlined in `SECURITY.md`, focusing on the Model Context Protocol (MCP) servers and the enforcement of security policies.

## 1. Secret Management Integration

The workspace is configured to use external secret stores. **Raw secrets must never be committed to the repository.**

*   **MCP Server:** `vault` (Placeholder for HashiCorp Vault, AWS Secrets Manager, etc.)
*   **Configuration:** Refer to `mcp.json` -> `mcpServers.vault`.
*   **Action Required:** Replace all `SECRET_REF:<path>` placeholders in `mcp.json` with actual paths to your secret manager.

## 2. Supply Chain Integrity (cosign)

Artifacts must be signed to ensure provenance and integrity.

*   **MCP Server:** `artifact-sign`
*   **Tool:** [cosign](https://docs.sigstore.dev/cosign/overview/)
*   **Enforcement:** The `policies.enforcement` section in `mcp.json` is configured to **block deployment** if the artifact signature verification fails (`artifact_not_signed`).

## 3. Vulnerability Scanning (Snyk & Trivy)

The workspace uses a multi-layered scanning approach.

| Target | Tool | MCP Server | Enforcement Stage |
| :--- | :--- | :--- | :--- |
| **Code & Dependencies** | Snyk (or similar) | `snyk-vuln-scan` | Pre-Merge (via CI/Hooks) |
| **Container Images** | Trivy (or similar) | `container-scan` | Pre-Deploy (via CI/Hooks) |
| **IaC (Terraform, K8s)** | Checkov/tfsec | `iac-scan` | Pre-Merge & Pre-Deploy |

**Action Required:** Configure the necessary API tokens (e.g., `SNYK_TOKEN`) as `SECRET_REF` in `mcp.json` before running the corresponding MCP servers.

## 4. Agent Access Control Lists (ACLs)

The `acl` section in `mcp.json` implements a **deny-by-default** policy.

*   **Purpose:** To prevent agents from accessing sensitive operations (like signing artifacts or accessing secrets) unless explicitly permitted.
*   **Example:** The `ci-helper` agent is explicitly allowed to use `snyk-vuln-scan` and `artifact-sign`, but a generic `docs-updater` agent is not.

**Action Required:** Audit and update the `acl.per_server` section whenever a new agent or a new sensitive MCP server is introduced.
