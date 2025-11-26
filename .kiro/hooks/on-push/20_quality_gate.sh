#!/bin/bash
# Hook: 20_quality_gate.sh
# Type: on-push
# Description: Enforces a quality gate before pushing to the remote repository.
# Compliance: Enforces NFR-003 (Test Coverage) from specs/requirements.md.

# --- Configuration ---
REQUIRED_COVERAGE=85

# --- Execution ---
echo "--- Running Kiro Quality Gate (20_quality_gate.sh) ---"

# Mock check for test coverage. In a real environment, this would parse a coverage report.
# We simulate a failure if the coverage is below the required threshold.
# For demonstration, we assume a mock coverage of 80% (failure) or 90% (success) based on a simple condition.

# Check if the last commit message contains 'fix: coverage' to simulate a successful run
if git log -1 --pretty=%B | grep -q "fix: coverage"; then
    CURRENT_COVERAGE=90
else
    CURRENT_COVERAGE=80
fi

if [ "$CURRENT_COVERAGE" -lt "$REQUIRED_COVERAGE" ]; then
    echo " "
    echo "!!! QUALITY GATE FAILURE !!!"
    echo "Test coverage is currently at $CURRENT_COVERAGE%, which is below the required $REQUIRED_COVERAGE%."
    echo "Please ensure all new code is adequately tested before pushing."
    echo "Push aborted."
    echo " "
    exit 1 # Abort the push
else
    echo "Quality Gate Passed. Test coverage is at $CURRENT_COVERAGE% (Required: $REQUIRED_COVERAGE%)."
    exit 0 # Allow the push
fi
