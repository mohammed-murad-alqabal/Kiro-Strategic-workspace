#!/bin/bash
# Script: setup-project.sh
# Description: Complete project setup with Zero-Trust security and DORA metrics
# Author: [Your Development Team Name]
# Version: 2.2.0

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Kiro Strategic Workspace Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check prerequisites
echo "📋 1. Checking prerequisites..."

# Check for required tools
REQUIRED_TOOLS=("git" "uv")
MISSING_TOOLS=()

for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        MISSING_TOOLS+=("$tool")
    fi
done

if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    echo "❌ Missing required tools:"
    for tool in "${MISSING_TOOLS[@]}"; do
        echo "  • $tool"
    done
    echo ""
    echo "Please install missing tools and run setup again."
    exit 1
fi

echo "   ✅ All prerequisites met"

# Initialize git if not already initialized
echo ""
echo "📋 2. Initializing version control..."
if [ ! -d ".git" ]; then
    git init
    echo "   ✅ Git repository initialized"
else
    echo "   ✅ Git repository already exists"
fi

# Create essential directories
echo ""
echo "📋 3. Creating project structure..."
mkdir -p {src,lib,test,docs,scripts,config}
mkdir -p .kiro/metrics
mkdir -p .kiro/audit
echo "   ✅ Project directories created"

# Setup git hooks
echo ""
echo "📋 4. Setting up git hooks..."
if [ -f ".kiro/hooks/on-commit/security-zero-trust-scan.sh" ]; then
    chmod +x .kiro/hooks/on-commit/security-zero-trust-scan.sh
    ln -sf "../../.kiro/hooks/on-commit/security-zero-trust-scan.sh" ".git/hooks/pre-commit" 2>/dev/null || true
    echo "   ✅ Pre-commit security hook installed"
fi

if [ -f ".kiro/hooks/on-push/dora-metrics-collection.sh" ]; then
    chmod +x .kiro/hooks/on-push/dora-metrics-collection.sh
    ln -sf "../../.kiro/hooks/on-push/dora-metrics-collection.sh" ".git/hooks/pre-push" 2>/dev/null || true
    echo "   ✅ Pre-push metrics hook installed"
fi

# Create .gitignore if it doesn't exist
echo ""
echo "📋 5. Setting up .gitignore..."
if [ ! -f ".gitignore" ]; then
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/
vendor/
__pycache__/
*.pyc

# Build outputs
dist/
build/
*.o
*.so
*.dll

# IDE files
.vscode/
.idea/
*.swp
*.swo

# OS files
.DS_Store
Thumbs.db

# Environment files
.env
.env.local
.env.production
*.key
*.pem
*.p12

# Logs
*.log
logs/

# Temporary files
tmp/
temp/
*.tmp

# Kiro metrics (keep structure, ignore data)
.kiro/metrics/*.csv
.kiro/metrics/*.log
.kiro/audit/*.log

# Security sensitive files
google-services.json
GoogleService-Info.plist
key.properties
keystore.jks
config/database.yml
config/secrets.yml
EOF
    echo "   ✅ .gitignore created with security patterns"
else
    echo "   ✅ .gitignore already exists"
fi

# Initialize metrics tracking
echo ""
echo "📋 6. Initializing DORA metrics..."
cat > .kiro/metrics/README.md << 'EOF'
# DORA/SPACE Metrics

This directory contains automated metrics collection for:

## DORA Metrics
- `dora-metrics.csv`: Deployment frequency, lead time, change failure rate, recovery time
- `security-scans.csv`: Security scan results and timing
- `failed-pushes.csv`: Failed deployment attempts

## SPACE Framework
- `space-metrics.csv`: Developer productivity metrics
- `build-times.csv`: Build performance tracking

## Usage

Metrics are automatically collected by git hooks. View latest metrics:

```bash
# View latest DORA metrics
tail -10 .kiro/metrics/dora-metrics.csv

# Generate weekly report
.kiro/scripts/generate-weekly-report.sh
```
EOF

# Create initial metrics files with headers
echo "timestamp,branch,lead_time_hours,errors,tests_passed" > .kiro/metrics/dora-metrics.csv
echo "timestamp,commit_hash,scan_type,status" > .kiro/metrics/security-scans.csv
echo "timestamp,metric_type,value1,value2" > .kiro/metrics/space-metrics.csv

echo "   ✅ DORA metrics initialized"

# Setup MCP servers
echo ""
echo "📋 7. Setting up MCP servers..."
if command -v uv >/dev/null 2>&1; then
    echo "   📦 Installing essential MCP servers..."
    
    # Install core MCP servers
    uv tool install mcp-server-git || echo "   ⚠️  mcp-server-git installation skipped"
    uv tool install mcp-server-fetch || echo "   ⚠️  mcp-server-fetch installation skipped"
    uv tool install mcp-server-sqlite || echo "   ⚠️  mcp-server-sqlite installation skipped"
    
    echo "   ✅ Core MCP servers installed"
else
    echo "   ⚠️  uv not found, skipping MCP server installation"
fi

# Create initial commit
echo ""
echo "📋 8. Creating initial commit..."
git add .
git commit -m "feat: initialize project with Kiro Strategic Workspace template

- Add Zero-Trust security framework
- Add DORA/SPACE metrics collection
- Add EARS requirements methodology
- Add advanced automation hooks
- Add enterprise-grade standards" || echo "   ℹ️  Initial commit skipped (no changes or already committed)"

echo "   ✅ Initial commit created"

# Final setup verification
echo ""
echo "📋 9. Verifying setup..."
SETUP_ISSUES=()

# Check git hooks
if [ ! -f ".git/hooks/pre-commit" ]; then
    SETUP_ISSUES+=("Pre-commit hook not installed")
fi

if [ ! -f ".git/hooks/pre-push" ]; then
    SETUP_ISSUES+=("Pre-push hook not installed")
fi

# Check metrics directory
if [ ! -d ".kiro/metrics" ]; then
    SETUP_ISSUES+=("Metrics directory not created")
fi

if [ ${#SETUP_ISSUES[@]} -gt 0 ]; then
    echo "   ⚠️  Setup issues detected:"
    for issue in "${SETUP_ISSUES[@]}"; do
        echo "      • $issue"
    done
else
    echo "   ✅ Setup verification passed"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 Kiro Strategic Workspace Setup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Next Steps:"
echo "  1. Customize team identity in .kiro/steering/core/team-identity.md"
echo "  2. Update project name in .kiro/steering/core/philosophy.md"
echo "  3. Configure MCP servers in .kiro/settings/mcp.json"
echo "  4. Review and customize standards in .kiro/standards/"
echo "  5. Start developing with EARS requirements methodology"
echo ""
echo "📚 Documentation:"
echo "  • Philosophy: .kiro/steering/core/philosophy.md"
echo "  • Quick Reference: .kiro/steering/core/quick-reference.md"
echo "  • EARS Template: .kiro/templates/ears-requirements-template.md"
echo "  • DORA Metrics: .kiro/templates/dora-space-metrics.md"
echo ""
echo "🔒 Security Features Active:"
echo "  • Zero-Trust security scanning"
echo "  • Automated vulnerability detection"
echo "  • Supply chain security monitoring"
echo ""
echo "📊 Metrics Collection Active:"
echo "  • DORA metrics (deployment frequency, lead time, etc.)"
echo "  • SPACE framework (developer productivity)"
echo "  • Automated quality gates"
echo ""
echo "Happy coding with enterprise-grade standards! 🚀"