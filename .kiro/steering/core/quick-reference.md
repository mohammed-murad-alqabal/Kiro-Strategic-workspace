# Quick Reference

**Project:** [Your Project Name]  
**Status:** ✅ Active

---

## Naming Conventions

| Element       | Format     | Example                  |
| :------------ | :--------- | :----------------------- |
| Files/Folders | snake_case | `customer_repository.js` |
| Classes       | PascalCase | `CustomerRepository`     |
| Functions     | camelCase  | `getAllCustomers()`      |
| Variables     | camelCase  | `customerList`           |
| Constants     | UPPER_CASE | `MAX_RETRIES`            |
| Private       | \_prefix   | `_privateMethod()`       |

**Details:** `.kiro/standards/naming.md`

---

## Quality Standards

### Basic Standards

- Test coverage: **70%+**
- Max line length: **80**
- Max complexity: **10**
- DRY principle: **Mandatory**

### SOLID Principles

- Single Responsibility
- Open/Closed
- Liskov Substitution
- Interface Segregation
- Dependency Inversion

**Details:** `.kiro/standards/code-quality.md`

---

## Security Requirements

### Mandatory Rules

- ❌ No secrets in code
- ✅ Use secure storage solutions
- ✅ Validate all inputs
- ✅ Hash passwords (SHA-256+)
- ✅ Encrypt sensitive data

**Details:** `.kiro/guides/security-guide.md`

---

## Testing Standards

### Types

- **Unit Tests**: 70%+ coverage
- **Integration Tests**: critical paths
- **End-to-End Tests**: user journeys

### Rules

- Test every public function
- Use mocks for dependencies
- Independent and fast tests

**Details:** `.kiro/standards/testing.md`

---

## Documentation Standards

### Mandatory

- Document all public APIs
- Include examples in documentation
- Explain parameters and return values

### Language

- **English**: For technical terms and code
- **Local Language**: For user-facing content (if applicable)

**Details:** `.kiro/standards/documentation.md`

---

## Development Best Practices

### Architecture

- Use appropriate design patterns
- Clean Architecture (layered approach)
- Feature-first organization
- Proper state management
- Efficient data persistence

**Details:** `.kiro/guides/development-guide.md`

---

## Git Workflow

### Commit Messages

```
type(scope): description

feat: add new feature
fix: fix bug
docs: update documentation
```

### Branching

- `main`: always stable
- `feature/*`: for new features
- `fix/*`: for bug fixes

**Details:** `.kiro/guides/git-guide.md`

---

## DORA/SPACE Metrics

### DORA Targets

- **Deployment Frequency**: Daily
- **Lead Time**: < 1 day
- **Change Failure Rate**: < 15%
- **Recovery Time**: < 1 hour

### SPACE Dimensions

- **Satisfaction**: Developer happiness (Target: 7.5+/10)
- **Performance**: Code quality and reliability
- **Activity**: Development work patterns
- **Communication**: Information flow effectiveness
- **Efficiency**: Minimal friction and interruptions

**Details:** `.kiro/templates/dora-space-metrics.md`

---

## Zero-Trust Security

### Core Principles

- ❌ Never trust, always verify
- ✅ Continuous authentication
- ✅ Least privilege access
- ✅ Supply chain security
- ✅ Artifact signing

**Details:** `.kiro/steering/technologies/security-best-practices.md`

---

**For Complete References:** `.kiro/reference/`
