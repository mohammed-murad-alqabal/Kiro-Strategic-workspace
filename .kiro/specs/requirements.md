# متطلبات المشروع (Project Requirements)

هذا الملف يحدد المتطلبات الوظيفية وغير الوظيفية للمشروع، ويجب أن يتم صياغتها بدقة عالية باستخدام صيغة EARS (Easy Approach to Requirements Syntax) لضمان قابلية التنفيذ من قبل وكلاء الذكاء الاصطناعي.

## 1. المتطلبات الوظيفية (Functional Requirements)

### 1.1. توليد المواصفات (Spec Generation)
**المتطلب (EARS Format):**
> **If** the user requests a new feature specification, **then** the Kiro Agent **shall** generate a draft `specs/` document (requirements, design, tasks) based on the approved `templates/spec_template.md`.

### 1.2. فرض المكدس التقني
**المتطلب (EARS Format):**
> **Whenever** the Kiro Agent generates or modifies code, **the system shall** ensure strict adherence to the technology stack defined in `.kiro/steering/tech.md`.

### 1.3. فحص الأمان الوقائي
**المتطلب (EARS Format):**
> **When** a developer attempts a `git commit`, **the system shall** execute the `hooks/on-commit/10_security_scan.sh` script **and** **if** sensitive data is detected, **then** the commit **shall** be aborted.

### 1.4. الاتصال بمصادر المعرفة
**المتطلب (EARS Format):**
> **While** the Kiro Agent is processing a task, **the system shall** prioritize context from the configured MCP servers in `.kiro/settings/mcp.json` **to** ensure the use of the latest organizational knowledge.

## 2. المتطلبات غير الوظيفية (Non-Functional Requirements)

### 2.1. الأداء (Performance)
*   **الاستجابة:** يجب أن يكون زمن استجابة واجهة برمجة التطبيقات (API) أقل من 100 مللي ثانية لـ 95% من الطلبات (P95 < 100ms).

### 2.2. الأمان (Security)
*   **التشفير:** يجب تشفير جميع الاتصالات بين العميل والخادم باستخدام TLS 1.3.
*   **المصادقة:** يجب استخدام المصادقة الثنائية (2FA) لجميع حسابات المسؤولين.

### 2.3. قابلية الصيانة (Maintainability)
*   **التوثيق:** يجب أن تكون جميع الدوال والوحدات النمطية موثقة بالكامل باستخدام معيار JSDoc/GoDoc.
*   **التغطية بالاختبارات:** يجب أن لا تقل تغطية الكود بالاختبارات (Test Coverage) عن 85%.

## 3. مقاييس النجاح (Success Metrics)

سيتم قياس نجاح القالب بناءً على مقاييس DORA و SPACE، والتي سيساعد القالب في تحقيقها:

### أ. مقاييس DORA (لأداء التسليم)
*   **Lead Time for Changes:** يجب أن يساهم القالب في تقليل الوقت المستغرق من الـ Commit إلى النشر (Deployment) إلى أقل من 24 ساعة (Lead Time for Changes < 24h).
*   **Deployment Frequency:** يجب أن يسهل القالب زيادة تكرار عمليات النشر الآمنة (Deployment Frequency) إلى مرة واحدة على الأقل يوميًا.

### ب. مقاييس SPACE (لإنتاجية المطور)
*   **Satisfaction and Well-being:** يجب أن يساهم القالب في تقليل الإحباط الناتج عن الأخطاء المتكررة (مثل أخطاء الأمان) بنسبة 20% خلال الربع الأول من خلال الأتمتة الوقائية.
*   **Activity:** يجب أن يزيد القالب من جودة مخرجات المطور (مثل جودة التوثيق والمواصفات) من خلال فرض القوالب الموحدة، مما يؤدي إلى انخفاض معدل المراجعات (Review Cycles) بنسبة 15%.
