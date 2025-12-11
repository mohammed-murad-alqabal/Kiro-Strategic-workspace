# Naming Conventions

**Project:** [Your Project Name]  
**Status:** ✅ Active

---

## Basic Rules

### Files and Folders

- **Format:** `snake_case`
- **Example:** `customer_repository.js`, `invoice_model.py`

### Classes and Types

- **Format:** `PascalCase`
- **Example:** `CustomerRepository`, `InvoiceStatus`

### Functions and Methods

- **Format:** `camelCase`
- **Example:** `getAllCustomers()`, `validateEmail()`

### Variables and Properties

- **Format:** `camelCase`
- **Example:** `customerName`, `invoiceCount`

### Constants

- **Format:** `UPPER_CASE` or `camelCase` (depending on language)
- **Example:** `MAX_RETRIES`, `API_TIMEOUT`

### Private Members

- **Format:** `_prefix` or language-specific convention
- **Example:** `_privateToken`, `_validateInput()`

---

## Common Mistakes

| ❌ Wrong                | ✅ Correct                   |
| :---------------------- | :--------------------------- |
| `CustomerRepository.js` | `customer_repository.js`     |
| `customer_repository`   | `CustomerRepository` (class) |
| `GetAllCustomers()`     | `getAllCustomers()`          |
| `max_retries`           | `MAX_RETRIES` (constant)     |

---

## Additional Rules

### Component Names

- Use clear prefixes: `AppButton`, `CustomerCard`
- Avoid generic names: ❌ `Button`, ✅ `AppButton`

### Service Names

- Use appropriate suffixes: `customerService`, `authProvider`

### Test Files

- Same name as source + test suffix
- Example: `customer_repository.js` → `customer_repository.test.js`

---

**For Detailed Examples:** `.kiro/reference/naming-examples.md`
