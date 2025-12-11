# EARS Requirements Methodology

**Author:** [Your Development Team Name]  
**التاريخ:** 11 ديسمبر 2025  
**المصدر:** INCOSE EARS Guidelines  
**الحالة:** ✅ **منهجية متقدمة لكتابة المتطلبات**

---

## 🎯 نظرة عامة

EARS (Easy Approach to Requirements Syntax) هي منهجية منظمة لكتابة متطلبات واضحة ومحددة وقابلة للاختبار. تم تطويرها من قبل INCOSE لتحسين جودة المتطلبات وتقليل الغموض.

---

## 📋 الأنماط الستة لـ EARS

### 1. **Ubiquitous Requirements** - المتطلبات الشاملة

**الصيغة:** `THE <system> SHALL <response>`

**الاستخدام:** للمتطلبات التي تنطبق دائماً

**أمثلة:**

- THE system SHALL encrypt all data at rest using AES-256
- THE application SHALL validate user input before processing
- THE database SHALL maintain ACID properties for all transactions

### 2. **Event-Driven Requirements** - المتطلبات المحركة بالأحداث

**الصيغة:** `WHEN <trigger>, THE <system> SHALL <response>`

**الاستخدام:** للمتطلبات التي تحدث عند حدث معين

**أمثلة:**

- WHEN user clicks login button, THE system SHALL validate credentials
- WHEN payment fails, THE system SHALL notify the user and log the error
- WHEN file upload completes, THE system SHALL scan for malware

### 3. **State-Driven Requirements** - المتطلبات المحركة بالحالة

**الصيغة:** `WHILE <condition>, THE <system> SHALL <response>`

**الاستخدام:** للمتطلبات التي تنطبق أثناء حالة معينة

**أمثلة:**

- WHILE user is authenticated, THE system SHALL allow access to protected resources
- WHILE backup is running, THE system SHALL display progress indicator
- WHILE in maintenance mode, THE system SHALL reject new user registrations

### 4. **Unwanted Event Requirements** - متطلبات الأحداث غير المرغوبة

**الصيغة:** `IF <condition>, THEN THE <system> SHALL <response>`

**الاستخدام:** للاستجابة للأحداث غير المرغوب فيها

**أمثلة:**

- IF authentication fails three times, THEN THE system SHALL lock the account
- IF disk space falls below 10%, THEN THE system SHALL send alert notification
- IF network connection is lost, THEN THE system SHALL cache data locally

### 5. **Optional Feature Requirements** - متطلبات الميزات الاختيارية

**الصيغة:** `WHERE <option>, THE <system> SHALL <response>`

**الاستخدام:** للميزات الاختيارية أو القابلة للتكوين

**أمثلة:**

- WHERE dark mode is enabled, THE system SHALL use dark color scheme
- WHERE premium subscription is active, THE system SHALL allow unlimited downloads
- WHERE two-factor authentication is configured, THE system SHALL require second factor

### 6. **Complex Requirements** - المتطلبات المعقدة

**الصيغة:** `[WHERE] [WHILE] [WHEN/IF] THE <system> SHALL <response>`

**الترتيب:** WHERE → WHILE → WHEN/IF → THE → SHALL

**أمثلة:**

- WHERE notifications are enabled, WHILE user is online, WHEN new message arrives, THE system SHALL display popup notification
- WHERE backup is configured, IF system detects data corruption, THEN THE system SHALL restore from latest backup
- WHILE in development mode, WHEN error occurs, THE system SHALL display detailed error information

---

## 🔍 قواعد جودة INCOSE

### القواعد الإلزامية

1. **صوت نشط (Active Voice)**

   - ✅ الصحيح: "THE system SHALL validate the input"
   - ❌ الخطأ: "The input SHALL be validated"

2. **لا مصطلحات غامضة**

   - ❌ تجنب: "quickly", "adequate", "user-friendly"
   - ✅ استخدم: أرقام محددة وقيم قابلة للقياس

3. **لا بنود هروب**

   - ❌ تجنب: "where possible", "if feasible", "as appropriate"
   - ✅ استخدم: شروط محددة وواضحة

4. **لا عبارات سلبية**

   - ❌ تجنب: "SHALL not exceed", "SHALL not allow"
   - ✅ استخدم: "SHALL be less than", "SHALL prevent"

5. **فكرة واحدة لكل متطلب**
   - ❌ الخطأ: "THE system SHALL validate input AND log errors AND send notifications"
   - ✅ الصحيح: ثلاث متطلبات منفصلة

---

## 📝 أمثلة عملية متقدمة

### نظام إدارة المستخدمين

```markdown
## User Management System Requirements

### Authentication Requirements

1. **Ubiquitous**: THE system SHALL hash all passwords using bcrypt with minimum 12 rounds
2. **Event-Driven**: WHEN user submits login form, THE system SHALL validate credentials within 2 seconds
3. **Unwanted Event**: IF login fails 5 times within 15 minutes, THEN THE system SHALL lock account for 30 minutes
4. **State-Driven**: WHILE account is locked, THE system SHALL reject all login attempts for that user
5. **Optional**: WHERE two-factor authentication is enabled, THE system SHALL require TOTP code after password validation

### Session Management Requirements

6. **Event-Driven**: WHEN user logs in successfully, THE system SHALL create session token valid for 8 hours
7. **State-Driven**: WHILE session is active, THE system SHALL refresh token every 30 minutes of activity
8. **Unwanted Event**: IF session expires, THEN THE system SHALL redirect user to login page
9. **Complex**: WHERE remember me is selected, WHILE user remains active, WHEN session expires, THE system SHALL automatically renew session for up to 30 days
```

### نظام معالجة الدفع

```markdown
## Payment Processing System Requirements

### Transaction Processing

1. **Ubiquitous**: THE system SHALL encrypt all payment data using TLS 1.3 during transmission
2. **Event-Driven**: WHEN payment is submitted, THE system SHALL validate card details within 3 seconds
3. **Unwanted Event**: IF payment validation fails, THEN THE system SHALL return specific error code and log attempt
4. **State-Driven**: WHILE payment is processing, THE system SHALL display progress indicator to user
5. **Optional**: WHERE fraud detection is enabled, THE system SHALL score transaction risk before processing

### Compliance Requirements

6. **Ubiquitous**: THE system SHALL comply with PCI DSS Level 1 requirements
7. **Event-Driven**: WHEN storing card data, THE system SHALL tokenize using approved tokenization service
8. **Unwanted Event**: IF suspicious activity is detected, THEN THE system SHALL flag transaction for manual review
9. **Complex**: WHERE international payment is selected, WHILE compliance rules apply, WHEN currency conversion is needed, THE system SHALL use real-time exchange rates from approved provider
```

---

## 🛠️ أدوات التحقق والتطبيق

### 1. **EARS Validation Checklist**

```yaml
ears_validation_checklist:
  pattern_compliance:
    - uses_correct_ears_pattern: required
    - follows_word_order: required
    - includes_system_name: required
    - uses_shall_keyword: required

  incose_quality_rules:
    - active_voice: required
    - no_vague_terms: required
    - no_escape_clauses: required
    - no_negative_statements: required
    - single_thought: required
    - measurable_criteria: required

  content_quality:
    - clear_trigger_condition: required
    - specific_system_response: required
    - testable_requirement: required
    - unambiguous_language: required

validation_tools:
  - automated_pattern_checker
  - language_analyzer
  - requirement_tracer
  - test_case_generator
```

### 2. **Automated EARS Checker**

```python
#!/usr/bin/env python3
# EARS Requirements Validator

import re
from typing import List, Dict, Tuple

class EARSValidator:
    def __init__(self):
        self.patterns = {
            'ubiquitous': r'^THE\s+\w+\s+SHALL\s+.+$',
            'event_driven': r'^WHEN\s+.+,\s+THE\s+\w+\s+SHALL\s+.+$',
            'state_driven': r'^WHILE\s+.+,\s+THE\s+\w+\s+SHALL\s+.+$',
            'unwanted_event': r'^IF\s+.+,\s+THEN\s+THE\s+\w+\s+SHALL\s+.+$',
            'optional': r'^WHERE\s+.+,\s+THE\s+\w+\s+SHALL\s+.+$',
            'complex': r'^(WHERE\s+.+,\s+)?(WHILE\s+.+,\s+)?(WHEN|IF)\s+.+,\s+(THEN\s+)?THE\s+\w+\s+SHALL\s+.+$'
        }

        self.forbidden_terms = [
            'quickly', 'slowly', 'adequate', 'appropriate', 'user-friendly',
            'where possible', 'if feasible', 'as needed', 'etc.', 'and so on'
        ]

    def validate_requirement(self, requirement: str) -> Dict:
        """Validate a single EARS requirement"""
        result = {
            'requirement': requirement,
            'valid': True,
            'pattern_match': None,
            'issues': []
        }

        # Check pattern compliance
        pattern_found = False
        for pattern_name, pattern_regex in self.patterns.items():
            if re.match(pattern_regex, requirement, re.IGNORECASE):
                result['pattern_match'] = pattern_name
                pattern_found = True
                break

        if not pattern_found:
            result['valid'] = False
            result['issues'].append("Does not match any EARS pattern")

        # Check for forbidden terms
        for term in self.forbidden_terms:
            if term.lower() in requirement.lower():
                result['valid'] = False
                result['issues'].append(f"Contains forbidden vague term: '{term}'")

        # Check for passive voice
        passive_indicators = ['is', 'are', 'was', 'were', 'been', 'being']
        words = requirement.lower().split()
        for i, word in enumerate(words):
            if word in passive_indicators and i < len(words) - 1:
                if words[i + 1].endswith('ed') or words[i + 1] in ['done', 'made', 'given']:
                    result['issues'].append("May contain passive voice construction")
                    break

        # Check for SHALL keyword
        if 'SHALL' not in requirement:
            result['valid'] = False
            result['issues'].append("Missing required 'SHALL' keyword")

        return result

    def validate_requirements_set(self, requirements: List[str]) -> Dict:
        """Validate a set of requirements"""
        results = []
        summary = {
            'total_requirements': len(requirements),
            'valid_requirements': 0,
            'invalid_requirements': 0,
            'pattern_distribution': {},
            'common_issues': {}
        }

        for req in requirements:
            result = self.validate_requirement(req)
            results.append(result)

            if result['valid']:
                summary['valid_requirements'] += 1
            else:
                summary['invalid_requirements'] += 1

            # Track pattern distribution
            if result['pattern_match']:
                pattern = result['pattern_match']
                summary['pattern_distribution'][pattern] = summary['pattern_distribution'].get(pattern, 0) + 1

            # Track common issues
            for issue in result['issues']:
                summary['common_issues'][issue] = summary['common_issues'].get(issue, 0) + 1

        return {
            'results': results,
            'summary': summary
        }

# Example usage
if __name__ == "__main__":
    validator = EARSValidator()

    test_requirements = [
        "THE system SHALL encrypt all data at rest using AES-256",
        "WHEN user clicks login, THE system SHALL validate credentials",
        "The data should be processed quickly",  # Invalid - passive voice, vague term
        "IF login fails 3 times, THEN THE system SHALL lock account",
        "WHERE premium is enabled, WHILE user is active, WHEN notification arrives, THE system SHALL display popup"
    ]

    validation_results = validator.validate_requirements_set(test_requirements)

    print("EARS Validation Results:")
    print(f"Valid: {validation_results['summary']['valid_requirements']}")
    print(f"Invalid: {validation_results['summary']['invalid_requirements']}")
    print(f"Pattern Distribution: {validation_results['summary']['pattern_distribution']}")
```

---

## 📊 مقاييس جودة المتطلبات

### KPIs للمتطلبات

```yaml
requirements_quality_metrics:
  completeness:
    - all_functional_requirements_covered: "> 95%"
    - all_non_functional_requirements_covered: "> 90%"
    - traceability_to_business_needs: "100%"

  clarity:
    - ears_pattern_compliance: "100%"
    - incose_quality_rules_compliance: "100%"
    - ambiguity_score: "< 5%"

  testability:
    - requirements_with_test_cases: "> 95%"
    - automated_test_coverage: "> 80%"
    - acceptance_criteria_defined: "100%"

  maintainability:
    - requirements_change_rate: "< 10% per sprint"
    - requirements_defect_rate: "< 2%"
    - requirements_review_coverage: "100%"

measurement_tools:
  - automated_ears_validator
  - requirements_traceability_matrix
  - test_coverage_analyzer
  - change_impact_tracker
```

---

## 🎯 أفضل الممارسات

### 1. **عملية كتابة المتطلبات**

```markdown
## Requirements Writing Process

### Phase 1: Requirements Elicitation

1. Stakeholder interviews and workshops
2. Business process analysis
3. User story mapping
4. Prototype feedback sessions

### Phase 2: Requirements Analysis

1. Categorize requirements by type
2. Identify dependencies and conflicts
3. Prioritize using MoSCoW method
4. Create requirements traceability matrix

### Phase 3: Requirements Specification

1. Apply EARS patterns consistently
2. Validate against INCOSE quality rules
3. Peer review all requirements
4. Create acceptance criteria for each requirement

### Phase 4: Requirements Validation

1. Stakeholder review and approval
2. Automated EARS validation
3. Test case generation
4. Requirements baseline establishment
```

### 2. **Common Pitfalls and Solutions**

| Pitfall                 | Example                                                                 | Solution                                                    |
| ----------------------- | ----------------------------------------------------------------------- | ----------------------------------------------------------- |
| **Vague Language**      | "The system should be fast"                                             | "THE system SHALL respond to user queries within 2 seconds" |
| **Multiple Thoughts**   | "THE system SHALL validate input and log errors and send notifications" | Split into 3 separate requirements                          |
| **Passive Voice**       | "Data shall be encrypted"                                               | "THE system SHALL encrypt all data"                         |
| **Escape Clauses**      | "WHERE possible, THE system SHALL..."                                   | Define specific conditions instead of "where possible"      |
| **Negative Statements** | "SHALL not exceed 5 seconds"                                            | "SHALL complete within 5 seconds"                           |

---

## 📚 مراجع ومصادر

### المعايير والأدلة

| المصدر            | الوصف                           | الرابط                                        |
| ----------------- | ------------------------------- | --------------------------------------------- |
| **INCOSE EARS**   | الدليل الرسمي لـ EARS           | [INCOSE.org](https://www.incose.org/)         |
| **IEEE 830**      | معيار مواصفات متطلبات البرمجيات | [IEEE Standards](https://standards.ieee.org/) |
| **ISO/IEC 25010** | معيار جودة البرمجيات            | [ISO Standards](https://www.iso.org/)         |

### أدوات وتقنيات

- **DOORS** - IBM Rational DOORS for requirements management
- **Jama Connect** - Requirements and test management
- **Azure DevOps** - Work item tracking and requirements
- **Confluence** - Documentation and requirements collaboration

---

## 🎉 الخلاصة

منهجية EARS تقدم نهجاً منظماً وعلمياً لكتابة متطلبات عالية الجودة. من خلال اتباع الأنماط الستة وقواعد INCOSE، يمكن للفرق تقليل الغموض وتحسين جودة المنتج النهائي.

**الفوائد الرئيسية:**
✅ وضوح وتحديد أكبر في المتطلبات  
✅ تقليل الغموض والتفسيرات المتعددة  
✅ سهولة في كتابة حالات الاختبار  
✅ تحسين التواصل بين الفرق  
✅ جودة أعلى للمنتج النهائي

---

**Created by:** [Your Development Team Name]  
**المصدر:** INCOSE EARS Guidelines  
**آخر تحديث:** 11 ديسمبر 2025
