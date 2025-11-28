# Design: User Onboarding Flow

## 1. Component Design
The onboarding flow will utilize the following components:

| Component | Location | Responsibility |
| :--- | :--- | :--- |
| **RegistrationHandler** | `server/handlers/` | Handles user registration API calls, password hashing, and initial database entry. |
| **EmailService** | `server/services/` | Responsible for generating verification tokens and sending emails. |
| **VerificationController** | `server/controllers/` | Validates the token received from the verification link and updates user status. |
| **RegistrationForm** | `client/components/` | Frontend component for user input and validation. |
| **ProfileSetupScreen** | `client/screens/` | Frontend screen for mandatory profile information input. |

## 2. Data Model Changes
The `User` database model requires the following fields:

| Field | Type | Constraints | Purpose |
| :--- | :--- | :--- | :--- |
| `email` | String | Unique, Required | User's unique identifier. |
| `password_hash` | String | Required | Securely stored password hash. |
| `status` | Enum | Required (Pending, Active) | Tracks the verification status. |
| `verification_token` | String | Optional | Token used for email verification. |
| `display_name` | String | Optional | User's chosen display name. |

## 3. Sequence Diagram (Conceptual)
The sequence of operations for a successful registration and verification:

1.  **Client:** Submits RegistrationForm data to `/api/register`.
2.  **Server (RegistrationHandler):**
    *   Hashes password.
    *   Generates `verification_token`.
    *   Saves User (Status: Pending).
    *   Calls **EmailService** to send verification email.
3.  **User:** Clicks verification link (`/api/verify?token=...`).
4.  **Server (VerificationController):**
    *   Validates token and expiration.
    *   Updates User Status to 'Active'.
    *   Redirects Client to ProfileSetupScreen.

## 4. Security Considerations
*   **Token Expiration:** Verification tokens **MUST** expire after 24 hours.
*   **Rate Limiting:** The `/api/register` and `/api/verify` endpoints **MUST** be rate-limited to prevent brute-force attacks.
*   **Input Validation:** Strict server-side validation **MUST** be performed on all input fields.
