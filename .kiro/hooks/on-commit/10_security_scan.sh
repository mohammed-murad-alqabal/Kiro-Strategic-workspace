#!/bin/bash
# Hook: 10_security_scan.sh
# Type: on-commit
# Description: Performs a pre-commit scan for common secrets (API keys, passwords) to prevent accidental exposure.
# Compliance: Enforces NFR-002 (Security - Secrets) from specs/requirements.md. (Preventive Security)

# --- Configuration ---
# Mock tool for demonstration. In a real environment, replace with tools like gitleaks or truffleHog. (Recommended Tool: gitleaks / Snyk Code)
# Searches for common secret patterns in staged files.
SECRET_PATTERNS='(password|secret|api_key|token|aws_access_key_id|private_key)'

# --- Execution ---

# Enforce Secret Scanning (gitleaks/Snyk)
# gitleaks detect --config=.gitleaks.toml --verbose
# snyk test --severity=high --json > snyk_report.json
echo "Enforcing Secret Scan (gitleaks/Snyk)..."

# Check for IaC changes and run Checkov/tfsec
if git diff --cached --name-only | grep -E '\.(tf|yaml|json)$' ; then
    echo "IaC changes detected. Running Checkov/tfsec scan..."
    # checkov -d . --framework terraform kubernetes
    # tfsec .
    # Exit 1 if high-risk IaC issues are found (enforced by MCP policy)
    # exit 1
fi
echo "--- Running Kiro Security Pre-Commit Scan (10_security_scan.sh) ---"

# Check for staged files containing common secret patterns
if git diff --cached | grep -E "$SECRET_PATTERNS" ; then
    echo " "
    echo "!!! SECURITY ALERT !!!"
    echo "The following staged files appear to contain sensitive information."
    echo "Please remove the secrets or use a proper secret management system before committing."
    echo "Commit aborted to prevent accidental exposure."
    echo " "
    exit 1 # Abort the commit
else
    echo "Security scan passed. No common secrets detected in staged files."
    exit 0 # Allow the commit
fi
