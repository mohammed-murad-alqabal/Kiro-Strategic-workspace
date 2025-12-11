# Kiro Workspace Index

**Author:** [Your Development Team Name]  
**Date:** December 11, 2025  
**Status:** 📋 **Complete workspace reference**

---

## 🗂️ Directory Structure

### Core Components

| Directory      | Purpose               | Key Files              |
| -------------- | --------------------- | ---------------------- |
| **agents/**    | AI Agent Layers       | L1/L2/L3 architecture  |
| **audit/**     | Security & Compliance | Logs and reports       |
| **docs/**      | Documentation         | Plans, reports, guides |
| **hooks/**     | Automation            | Git hooks, triggers    |
| **metrics/**   | Performance Data      | DORA/SPACE metrics     |
| **settings/**  | Configuration         | MCP, editor settings   |
| **steering/**  | Philosophy & Guidance | Core principles        |
| **templates/** | Code Templates        | EARS, metrics, docs    |

### Quick Access

#### 🎯 Getting Started

- [Philosophy](.kiro/steering/core/philosophy.md) - Core principles
- [Quick Reference](.kiro/steering/core/quick-reference.md) - Essential info
- [Team Identity](.kiro/steering/core/team-identity.md) - Team standards

#### 🔒 Security

- [Security Best Practices](.kiro/steering/technologies/security-best-practices.md)
- [Zero-Trust Scan Hook](.kiro/hooks/on-commit/security-zero-trust-scan.sh)

#### 📊 Metrics

- [DORA/SPACE Framework](.kiro/templates/dora-space-metrics.md)
- [Metrics Collection Hook](.kiro/hooks/on-push/dora-metrics-collection.sh)

#### 📋 Requirements

- [EARS Template](.kiro/templates/ears-requirements.md)

#### ⚙️ Configuration

- [MCP Settings](.kiro/settings/mcp.json)

---

## 🚀 Workflow Overview

### 1. Project Setup

1. Customize team identity and project name
2. Configure MCP servers for your stack
3. Set up development environment
4. Initialize git repository

### 2. Development Cycle

1. Create EARS requirements
2. Implement with security scanning
3. Commit with automated quality checks
4. Push with DORA metrics collection
5. Deploy with zero-trust verification

### 3. Continuous Improvement

1. Monitor DORA/SPACE metrics
2. Review security audit logs
3. Optimize based on performance data
4. Update standards and practices

---

## 📈 Metrics Dashboard

### Current Status

- **Security Scans**: [View Logs](.kiro/audit/security-scan.log)
- **DORA Metrics**: [Latest Summary](.kiro/metrics/latest-push-summary.md)
- **Quality Metrics**: [Code Quality](.kiro/metrics/code-quality.log)

### Targets

- **Lead Time**: < 1 day
- **Deployment Frequency**: Daily
- **Change Failure Rate**: < 15%
- **Recovery Time**: < 1 hour
- **Test Coverage**: > 70%
- **Developer Satisfaction**: > 7.5/10

---

## 🔧 Customization Guide

### For Your Team

1. Replace `[Your Development Team Name]` with actual team name
2. Replace `[Your Project Name]` with actual project name
3. Update technology-specific configurations
4. Customize metrics targets
5. Add team-specific standards

### For Your Stack

1. Add technology-specific steering files
2. Configure appropriate MCP servers
3. Create stack-specific hooks
4. Update templates for your languages
5. Customize quality gates

---

**Last Updated:** December 11, 2025  
**Maintained By:** [Your Development Team Name]
