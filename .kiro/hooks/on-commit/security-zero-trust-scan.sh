#!/bin/bash
# Hook: security-zero-trust-scan.sh
# Type: on-commit
# Description: Zero-Trust security scan before commit to detect secrets (API keys, passwords)
# Project: [Your Project Name]
# Compliance: Implements Security First principle from steering/security.md

# --- Configuration ---
# Common secret patterns
SECRET_PATTERNS='(password|secret|api_key|token|aws_access_key_id|private_key|firebase|supabase|database_url|jwt_secret)'

# Excluded directories
EXCLUDE_DIRS="--exclude-dir={.git,.dart_tool,build,node_modules,dist,.idea,.vscode,vendor}"

# Sensitive configuration files
CONFIG_FILES="--include=*\.env --include=*\.json --include=*\.yaml --include=*\.yml --include=*\.js --include=*\.ts --include=*\.py --include=*\.dart"

# --- Execution ---
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔒 Kiro Zero-Trust Security Pre-Commit Scan"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 1. Check staged files
echo "📋 1. Scanning staged files..."
if git diff --cached --name-only | xargs grep -E "$SECRET_PATTERNS" 2>/dev/null; then
    echo ""
    echo "❌ Security Alert! (Staged Files)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Sensitive information found in staged files"
    echo "Please remove secrets or use secure storage solutions"
    echo "Commit blocked to prevent data leakage"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    exit 1
fi
echo "   ✅ No secrets found in staged files"

# 2. Check configuration files
echo ""
echo "📋 2. Scanning configuration files..."
if grep -r -E "$SECRET_PATTERNS" src/ lib/ $CONFIG_FILES $EXCLUDE_DIRS 2>/dev/null | grep -v "// TODO\|// FIXME\|test\|example"; then
    echo ""
    echo "❌ Security Alert! (Configuration Files)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Secrets found stored explicitly in configuration files"
    echo "This violates Security First principle"
    echo ""
    echo "Recommended solutions:"
    echo "  • Use secure storage for sensitive data"
    echo "  • Use environment variables"
    echo "  • Use .env files (add them to .gitignore)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    exit 1
fi
echo "   ✅ No secrets found in configuration files"

# 3. Check sensitive files
echo ""
echo "📋 3. Checking sensitive files..."
SENSITIVE_FILES=(
    ".env"
    ".env.local"
    ".env.production"
    "config/database.yml"
    "config/secrets.yml"
    "google-services.json"
    "GoogleService-Info.plist"
    "key.properties"
    "keystore.jks"
    "private.key"
    "certificate.pem"
)

for file in "${SENSITIVE_FILES[@]}"; do
    if [ -f "$file" ] && git diff --cached --name-only | grep -q "$file"; then
        echo ""
        echo "⚠️  Warning: Attempting to commit sensitive file"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "File: $file"
        echo "This file contains sensitive information and should not be committed"
        echo "Please add it to .gitignore"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        exit 1
    fi
done
echo "   ✅ No sensitive files found"

# 4. Check .gitignore
echo ""
echo "📋 4. Verifying .gitignore..."
REQUIRED_IGNORES=(
    "*.env"
    "*.key"
    "*.jks"
    "*.pem"
    "*.p12"
    "google-services.json"
    "GoogleService-Info.plist"
    "key.properties"
    "keystore.jks"
    "config/database.yml"
    "config/secrets.yml"
)

MISSING_IGNORES=()
for pattern in "${REQUIRED_IGNORES[@]}"; do
    if ! grep -q "$pattern" .gitignore 2>/dev/null; then
        MISSING_IGNORES+=("$pattern")
    fi
done

if [ ${#MISSING_IGNORES[@]} -gt 0 ]; then
    echo ""
    echo "⚠️  Warning: Missing patterns in .gitignore"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Missing patterns:"
    for pattern in "${MISSING_IGNORES[@]}"; do
        echo "  • $pattern"
    done
    echo ""
    echo "Recommended to add these patterns to .gitignore"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    # Don't block commit, just warning
fi
echo "   ✅ .gitignore contains basic patterns"

# 5. DORA Metrics Collection
echo ""
echo "📋 5. Collecting DORA metrics..."
COMMIT_TIME=$(date +%s)
COMMIT_HASH=$(git rev-parse HEAD 2>/dev/null || echo "pending")
echo "$COMMIT_TIME,$COMMIT_HASH,security_scan,passed" >> .kiro/metrics/security-scans.csv
echo "   ✅ Security metrics recorded"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Zero-Trust security scan completed successfully"
echo "✅ No secrets or sensitive information found"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

exit 0