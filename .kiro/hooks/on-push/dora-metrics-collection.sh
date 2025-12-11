#!/bin/bash
# Hook: dora-metrics-collection.sh
# Type: on-push
# Description: DORA metrics collection and quality gate before push
# Project: [Your Project Name]
# Compliance: Implements Quality First principle from steering/philosophy.md

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Kiro DORA Metrics & Quality Gate"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Error counter
ERRORS=0
PUSH_TIME=$(date +%s)
BRANCH=$(git branch --show-current)

# Create metrics directory if it doesn't exist
mkdir -p .kiro/metrics

# 1. Code Formatting Check
echo "📋 1. Code formatting check..."
if command -v dart >/dev/null 2>&1; then
    if ! dart format --set-exit-if-changed lib/ test/ 2>/dev/null; then
        echo "   ❌ Code is not properly formatted"
        echo "   💡 Run: dart format lib/ test/"
        ERRORS=$((ERRORS + 1))
    else
        echo "   ✅ Formatting is correct"
    fi
elif command -v prettier >/dev/null 2>&1; then
    if ! prettier --check src/ 2>/dev/null; then
        echo "   ❌ Code is not properly formatted"
        echo "   💡 Run: prettier --write src/"
        ERRORS=$((ERRORS + 1))
    else
        echo "   ✅ Formatting is correct"
    fi
elif command -v black >/dev/null 2>&1; then
    if ! black --check . 2>/dev/null; then
        echo "   ❌ Code is not properly formatted"
        echo "   💡 Run: black ."
        ERRORS=$((ERRORS + 1))
    else
        echo "   ✅ Formatting is correct"
    fi
else
    echo "   ⚠️  No formatter found (dart, prettier, or black)"
fi

# 2. Static Analysis
echo ""
echo "📋 2. Static analysis..."
if command -v flutter >/dev/null 2>&1; then
    ANALYZE_OUTPUT=$(flutter analyze 2>&1)
    ANALYZE_EXIT=$?
elif command -v eslint >/dev/null 2>&1; then
    ANALYZE_OUTPUT=$(eslint src/ 2>&1)
    ANALYZE_EXIT=$?
elif command -v pylint >/dev/null 2>&1; then
    ANALYZE_OUTPUT=$(pylint src/ 2>&1)
    ANALYZE_EXIT=$?
else
    echo "   ⚠️  No static analyzer found"
    ANALYZE_EXIT=0
fi

if [ $ANALYZE_EXIT -ne 0 ]; then
    echo "   ❌ Code analysis issues found"
    echo ""
    echo "$ANALYZE_OUTPUT" | grep -E "error|warning" | head -10
    echo ""
    echo "   💡 Fix issues before push"
    ERRORS=$((ERRORS + 1))
else
    echo "   ✅ No analysis issues"
fi

# 3. Tests
echo ""
echo "📋 3. Running tests..."
TEST_PASSED=false

if [ -d "test" ] && command -v flutter >/dev/null 2>&1; then
    if flutter test --no-pub 2>&1 | tee /tmp/test_output.txt; then
        echo "   ✅ All tests passed"
        TEST_PASSED=true
    else
        echo "   ❌ Some tests failed"
        ERRORS=$((ERRORS + 1))
    fi
elif [ -f "package.json" ] && command -v npm >/dev/null 2>&1; then
    if npm test 2>&1 | tee /tmp/test_output.txt; then
        echo "   ✅ All tests passed"
        TEST_PASSED=true
    else
        echo "   ❌ Some tests failed"
        ERRORS=$((ERRORS + 1))
    fi
elif [ -f "requirements.txt" ] && command -v pytest >/dev/null 2>&1; then
    if pytest -q 2>&1 | tee /tmp/test_output.txt; then
        echo "   ✅ All tests passed"
        TEST_PASSED=true
    else
        echo "   ❌ Some tests failed"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "   ⚠️  No tests found or test runner not available"
    echo "   💡 Recommended: Add tests (target: 70%+ coverage)"
fi

# 4. DORA Metrics Collection
echo ""
echo "📋 4. Collecting DORA metrics..."

# Calculate lead time (time since last commit)
LAST_COMMIT_TIME=$(git log -1 --format=%ct)
LEAD_TIME=$((PUSH_TIME - LAST_COMMIT_TIME))
LEAD_TIME_HOURS=$((LEAD_TIME / 3600))

# Record metrics
echo "$PUSH_TIME,$BRANCH,$LEAD_TIME_HOURS,$ERRORS,$TEST_PASSED" >> .kiro/metrics/dora-metrics.csv

echo "   📊 Lead time: ${LEAD_TIME_HOURS} hours"
echo "   📊 Errors: $ERRORS"
echo "   📊 Tests: $([ "$TEST_PASSED" = true ] && echo "PASSED" || echo "FAILED")"

# 5. SPACE Framework Metrics
echo ""
echo "📋 5. SPACE framework metrics..."

# Activity metrics
COMMITS_TODAY=$(git log --since="1 day ago" --oneline | wc -l)
FILES_CHANGED=$(git diff --name-only HEAD~1 2>/dev/null | wc -l)

echo "   📈 Commits today: $COMMITS_TODAY"
echo "   📈 Files changed: $FILES_CHANGED"

# Record SPACE metrics
echo "$PUSH_TIME,activity,$COMMITS_TODAY,$FILES_CHANGED" >> .kiro/metrics/space-metrics.csv

# 6. Quality Gates Assessment
echo ""
echo "📋 6. Quality gates assessment..."

# DORA targets check
if [ $LEAD_TIME_HOURS -le 24 ]; then
    echo "   ✅ Lead time target met (< 24 hours)"
else
    echo "   ⚠️  Lead time exceeds target (> 24 hours)"
fi

if [ $ERRORS -eq 0 ]; then
    echo "   ✅ Change failure rate target met (0 errors)"
else
    echo "   ⚠️  Quality issues detected"
fi

# Final Result
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $ERRORS -eq 0 ]; then
    echo "✅ Quality gate passed successfully"
    echo "✅ Code is ready for push"
    echo "📊 DORA metrics recorded"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    # Generate summary
    echo "📋 Push Summary:"
    echo "  • Lead Time: ${LEAD_TIME_HOURS}h"
    echo "  • Quality Issues: $ERRORS"
    echo "  • Tests: $([ "$TEST_PASSED" = true ] && echo "✅ PASSED" || echo "⚠️ SKIPPED")"
    echo "  • Branch: $BRANCH"
    echo ""
    
    exit 0
else
    echo "❌ Quality gate failed ($ERRORS issues)"
    echo "❌ Please fix issues before push"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "💡 Quick fixes:"
    echo "  • Format code with your formatter"
    echo "  • Run static analysis and fix issues"
    echo "  • Ensure all tests pass"
    echo ""
    
    # Record failed push
    echo "$PUSH_TIME,$BRANCH,failed,$ERRORS" >> .kiro/metrics/failed-pushes.csv
    
    exit 1
fi