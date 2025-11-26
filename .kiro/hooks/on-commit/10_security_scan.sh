#!/bin/bash
# Hook: 10_security_scan.sh
# Type: on-commit
# Description: Performs a pre-commit scan for common secrets (API keys, passwords) to prevent accidental exposure, including in configuration files.
# Compliance: Enforces FR-3 (Preventive Security Scanning) from specs/requirements.md and S-CONF-001 from steering/security.md.

# --- Configuration ---
# Searches for common secret patterns in staged files.
SECRET_PATTERNS='(password|secret|api_key|token|aws_access_key_id|private_key)'

# --- Execution ---
echo "--- Running Kiro Security Pre-Commit Scan (10_security_scan.sh) ---"

# 1. Check for staged files containing common secret patterns
echo "1. Scanning staged files for secrets..."
if git diff --cached | grep -E "$SECRET_PATTERNS" ; then
    echo " "
    echo "!!! SECURITY ALERT (Staged Files) !!!"
    echo "The following staged files appear to contain sensitive information."
    echo "Please remove the secrets or use a proper secret management system before committing."
    echo "Commit aborted to prevent accidental exposure."
    echo " "
    exit 1 # Abort the commit
fi

# 2. Check configuration files in .kiro/settings/ and .kiro/prompts/ for hardcoded secrets
# This is a secondary check to enforce S-CONF-001 from steering/security.md
echo "2. Scanning .kiro/ configuration files for hardcoded secrets..."
if grep -r -E "$SECRET_PATTERNS" .kiro/settings/ .kiro/prompts/ --exclude-dir={.git,node_modules} ; then
    echo " "
    echo "!!! SECURITY ALERT (Configuration Files) !!!"
    echo "Hardcoded secrets were found in .kiro/ configuration files."
    echo "This violates the Security First principle (S-CONF-001). Use environment variables or a secret manager."
    echo "Commit aborted."
    echo " "
    exit 1 # Abort the commit
fi

echo "Security scan passed. No common secrets detected."
exit 0 # Allow the commit
