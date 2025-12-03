# ArgoCD/GitOps Integration Example: Declarative Deployment

This example demonstrates the use of ArgoCD for GitOps-style declarative deployment, ensuring that the state of the infrastructure and applications is always synchronized with the configuration defined in Git. This is crucial for achieving high deployment frequency and low change failure rate (DORA Metrics).

## Architectural Relevance (MLOps/Analytics)

*   **Reproducibility:** All deployment configurations (including MLOps model serving endpoints) are version-controlled, ensuring that any environment can be reproduced reliably.
*   **Auditability:** Every change to the production environment is tracked via Git commits, providing a clear audit trail for compliance and debugging.
*   **Automated Rollouts:** ArgoCD automates the deployment process, allowing for faster and safer rollouts of new models or analytical services.

## Files

| File | Purpose |
| :--- | :--- |
| `app.yaml` | Example ArgoCD Application definition, pointing to the Git repository where the Kubernetes manifests are stored. |
| `README.md` | This documentation. |

## Kiro Integration

The `argocd` server adapter is already defined conceptually in `mcp.json`. Kiro agents can use this adapter to:
1.  **Trigger Sync:** Automatically trigger an ArgoCD sync operation after a successful CI/CD pipeline run.
2.  **Check Health:** Query the health status of deployed applications to inform the agent's decision-making process.

**Example MCP Call (Conceptual):**
```json
{
  "server": "argocd",
  "capability": "gitops_sync",
  "args": {
    "app": "my-kiro-app"
  }
}
```
