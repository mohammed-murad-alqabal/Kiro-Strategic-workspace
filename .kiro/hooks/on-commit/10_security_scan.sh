#!/bin/bash
# Hook: 10_security_scan.sh
# Type: on-commit
# Description: Performs a pre-commit scan for common secrets (API keys, passwords) to prevent accidental exposure.
# Compliance: Enforces FR-3 (Preventive Security Scanning) from specs/requirements.md.

# --- Configuration ---
# Searches for common secret patterns in staged files.
SECRET_PATTERNS='(password|secret|api_key|token|aws_access_key_id|private_key)'

# --- Execution ---
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
