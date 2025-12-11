# Engineering Philosophy

**Project:** [Your Project Name]  
**Status:** ✅ Active  
**Last Updated:** December 11, 2025

---

## Core Principles

### 1. **COLLABORATION FIRST** - Mandatory ⭐

**No execution without explicit user approval**

Before any code changes, file modifications, or command execution:

- Explain what you plan to do and why
- Present your approach for review
- Wait for explicit confirmation like "proceed" or "start"
- Get consensus before continuing

**Only Exception:** Analysis, file reading, and explanations are allowed without permission.

### 2. **Zero-Trust Security First**

- No compromise on security at any stage
- Apply Zero-Trust principles: "Never trust, always verify"
- Supply Chain Security mandatory for all dependencies
- Container Security Scanning before every deployment
- Artifact Signing to ensure integrity
- Reference: `.kiro/reference/full-standards.md#security`

### 3. **Spec-Driven Development with EARS**

- Every work starts with clear specification written using EARS methodology
- Reject any request without defined and measured spec
- Use EARS (Easy Approach to Requirements Syntax) for clarity
- **EARS Example**: "When user clicks login, the system shall validate credentials and if valid, then redirect to dashboard"

### 4. **KEEP IT SIMPLE, STUPID (KISS)** ⭐

- Don't over-engineer, don't over-abstract, don't complicate
- If there's a simple solution that works, use it
- Every abstraction must justify its existence
- Complexity only when it solves a real problem

### 5. **Quality Measured by DORA/SPACE Standards**

- Clean and tested code (70%+ coverage)
- Follow standards in `.kiro/standards/`
- **DORA Metrics**: Lead Time < 1 day, Change Failure Rate < 15%
- **SPACE Framework**: Focus on Satisfaction, Performance, Activity, Communication, Efficiency
- Continuously measure and improve Developer Productivity

### 6. **ENGLISH FOR CODE** ⭐

All code, comments, documentation, variable names, function names must be in English unless the existing document is in another language. This ensures maintainability and international collaboration.

### 7. **Unified Team Identity**

- Use consistent team naming throughout project
- Reference: `.kiro/steering/core/team-identity.md`

### 8. **Engineering Excellence through Metrics**

- **DORA Metrics (DevOps Performance)**:

  - Deployment Frequency: Daily deployments target
  - Lead Time for Changes: < 1 day
  - Change Failure Rate: < 15%
  - Time to Recovery: < 1 hour

- **SPACE Framework (Developer Productivity)**:
  - **Satisfaction**: Developer happiness and well-being
  - **Performance**: Quality and reliability of outputs
  - **Activity**: Development work and collaboration
  - **Communication**: Information flow and knowledge sharing
  - **Efficiency**: Minimal friction and interruptions

---

## Linus Torvalds Approach

### Philosophy

- ✅ Practical solutions over theoretical idealism
- ✅ Obviously correct code over clever tricks
- ✅ Maintainability over short-term convenience
- ✅ Question every dependency and complexity
- ✅ "Show me the code" - but ask permission first

### Practical Principles

1. **Pragmatic Solutions** - practical solutions that work
2. **Obviously Correct Code** - clearly correct code
3. **Maintainability First** - maintainability first
4. **Question Everything** - question everything
5. **Show, Don't Tell** - show, don't tell

---

## Core Rules

### Development

- ✅ **Collaboration First** - explicit approval before any execution
- ✅ **KISS** - simplicity first
- ✅ Spec mandatory before any work
- ✅ Follow standards in `standards/`
- ✅ Mandatory testing (70%+)
- ✅ Mandatory documentation for public APIs
- ✅ English for code - mandatory

### Security

- ✅ No secrets in code
- ✅ Use secure storage
- ✅ Validate all inputs
- ✅ Hash passwords

### Quality

- ✅ Clean Code principles
- ✅ SOLID principles
- ✅ DRY principle
- ✅ Test coverage 70%+
- ✅ Obviously correct code
- ✅ Maintainability first

---

## Priorities

1. **Collaboration** - always ask permission
2. **Simplicity** - KISS principle
3. **Security** - no compromise
4. **Quality** - clean code
5. **Maintenance** - clear code

---

For complete details: `.kiro/reference/full-standards.md`
