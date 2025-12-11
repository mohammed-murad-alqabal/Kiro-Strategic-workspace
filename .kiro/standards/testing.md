# Testing Standards

**Project:** [Your Project Name]  
**Status:** ✅ Active

---

## Test Types

### Unit Tests

- **Purpose:** Test isolated functions and classes
- **Coverage:** 70%+
- **Speed:** Very fast

### Integration Tests

- **Purpose:** Test component interactions
- **Coverage:** Critical paths
- **Speed:** Fast to medium

### End-to-End Tests

- **Purpose:** Test complete user flows
- **Coverage:** User journeys
- **Speed:** Medium to slow

---

## Basic Rules

### Mandatory

- ✅ Test every public function
- ✅ Test normal and edge cases
- ✅ Use mocks for dependencies
- ✅ Independent tests

### Prohibited

- ❌ Tests that depend on each other
- ❌ Slow tests (> 30 seconds total)
- ❌ Using real external data
- ❌ Mocks just to make tests pass

---

## Structure

### Test Organization

```
test/
├── unit/          # Unit tests
├── integration/   # Integration tests
└── e2e/          # End-to-end tests
```

### File Naming

```
customer_repository.js → customer_repository.test.js
UserService.py → test_user_service.py
```

---

## Best Practices

### Setup and Teardown

```javascript
beforeEach(() => {
  // Setup before each test
});

afterEach(() => {
  // Cleanup after each test
});
```

### Clear Names

```javascript
test("should add customer successfully", () => {
  // ...
});
```

### Assertions

```javascript
expect(result).not.toBeNull();
expect(customers.length).toBe(1);
expect(() => validate("")).toThrow();
```

---

## Execution

### Commands

```bash
npm test                    # All tests
npm test -- --coverage     # With coverage
npm test unit/             # Specific tests
```

---

**For Examples:** `.kiro/reference/testing-examples.md`
