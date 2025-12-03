# sqlc Integration Example: Type-Safe Database Access

This example demonstrates how to use [sqlc](https://sqlc.dev/) to generate type-safe Go or Python code from SQL queries. This is essential for reducing runtime errors and improving developer flow, aligning with the **SPACE Framework** (Flow and Efficiency).

## Architectural Relevance (MLOps/Analytics)

*   **Type Safety:** Ensures that database interactions are type-safe at compile time, which is critical for data integrity in MLOps feature stores and analytical backends.
*   **Decoupling:** Separates SQL logic from application code, making both easier to test and maintain.
*   **Data Integrity:** By enforcing strict schema and query definitions, `sqlc` helps maintain high data quality, a prerequisite for reliable MLOps models.

## Files

| File | Purpose |
| :--- | :--- |
| `sqlc.yaml` | sqlc configuration file. Defines the target language, package name, and paths to queries and schema. |
| `schema.sql` | Example SQL schema defining database tables (e.g., `users`, `features`). |
| `query.sql` | Example SQL queries that `sqlc` will use to generate Go/Python code. |
| `README.md` | This documentation. |

## Kiro Integration

The `sqlc` generation process should be integrated into the build pipeline to ensure that any change to `schema.sql` or `query.sql` automatically updates the generated code.

**Example Hook Command:**
```bash
# Run sqlc to generate code
sqlc generate
# Check for uncommitted generated files in a pre-commit hook
git diff --exit-code --name-only -- generated/
```
