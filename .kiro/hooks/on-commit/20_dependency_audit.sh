#!/bin/bash
# Dependency Security Audit Hook
# يفحص التبعيات بحثاً عن ثغرات أمنية معروفة

set -e

echo "🔍 Running Dependency Security Audit..."

# فحص package.json إذا كان موجوداً
if [ -f "package.json" ]; then
    echo "📦 Checking npm dependencies..."
    if command -v npm &> /dev/null; then
        npm audit --audit-level=high || {
            echo "❌ High severity vulnerabilities found in npm dependencies!"
            echo "Run 'npm audit fix' to resolve issues"
            exit 1
        }
    fi
fi

# فحص requirements.txt إذا كان موجوداً
if [ -f "requirements.txt" ]; then
    echo "🐍 Checking Python dependencies..."
    if command -v safety &> /dev/null; then
        safety check --file requirements.txt || {
            echo "❌ Vulnerabilities found in Python dependencies!"
            exit 1
        }
    fi
fi

# فحص go.mod إذا كان موجوداً
if [ -f "go.mod" ]; then
    echo "🔷 Checking Go dependencies..."
    if command -v govulncheck &> /dev/null; then
        govulncheck ./... || {
            echo "❌ Vulnerabilities found in Go dependencies!"
            exit 1
        }
    fi
fi

# فحص Cargo.toml إذا كان موجوداً
if [ -f "Cargo.toml" ]; then
    echo "🦀 Checking Rust dependencies..."
    if command -v cargo-audit &> /dev/null; then
        cargo audit || {
            echo "❌ Vulnerabilities found in Rust dependencies!"
            exit 1
        }
    fi
fi

echo "✅ Dependency audit passed"
exit 0
