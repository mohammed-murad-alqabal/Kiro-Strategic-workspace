# Tasks: User Onboarding Flow

This task list is derived from the requirements and design specifications and should be used by the Kiro Agent for implementation.

## 1. Backend Implementation (Server)

| Task ID | Description | Component | Status |
| :--- | :--- | :--- | :--- |
| **T-001** | Implement the `RegistrationHandler` API endpoint (`/api/register`) including input validation and password hashing (Argon2). | `server/handlers/` | To Do |
| **T-002** | Update the `User` data model to include `status` (Enum: Pending, Active) and `verification_token`. | `server/models/` | To Do |
| **T-003** | Implement the `EmailService` to generate secure, time-limited verification tokens and send the verification email. | `server/services/` | To Do |
| **T-004** | Implement the `VerificationController` API endpoint (`/api/verify`) to validate the token and update the user status to 'Active'. | `server/controllers/` | To Do |
| **T-005** | Implement rate limiting on `/api/register` and `/api/verify` endpoints. | `server/middleware/` | To Do |

## 2. Frontend Implementation (Client)

| Task ID | Description | Component | Status |
| :--- | :--- | :--- | :--- |
| **T-006** | Develop the `RegistrationForm` component with client-side validation. | `client/components/` | To Do |
| **T-007** | Develop the `ProfileSetupScreen` component for mandatory display name and profile picture input. | `client/screens/` | To Do |
| **T-008** | Implement the routing logic to redirect the user to the `ProfileSetupScreen` upon successful verification. | `client/router/` | To Do |

## 3. Testing and Quality Assurance

| Task ID | Description | Component | Status |
| :--- | :--- | :--- | :--- |
| **T-009** | Write unit tests for all functions in `RegistrationHandler` and `VerificationController`. | `server/tests/` | To Do |
| **T-010** | Write integration tests to cover the full registration-verification-redirect flow. | `server/tests/` | To Do |
| **T-011** | Verify that test coverage for the new code meets the NFR of 85%. | QA | To Do |
