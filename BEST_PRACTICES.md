# أفضل الممارسات لمستودع Kiro-Strategic-Blueprint

**المؤلف:** Kiro Strategic Blueprint Team
**التاريخ:** 25 نوفمبر 2025
**الموضوع:** دليل شامل لأفضل الممارسات في استخدام قالب Kiro-Strategic-Blueprint

---

## 1. مقدمة

هذا الدليل يجمع أفضل الممارسات المستخلصة من تحليل المستودعات المرجعية المتقدمة (مثل `spirit-of-kiro` و `aws-best-practices`) ومن فهم عميق لمنهجية Kiro IDE. الهدف هو توفير مرجع شامل يكمل التوجيهات الآلية المحددة في ملفات `.kiro/` ويساعد الفريق على تحقيق أقصى استفادة من هذا القالب الاستراتيجي.

## 2. مبادئ التطوير الأساسية (Core Development Principles)

### 2.1. التطوير الموجه بالمواصفات (Spec-Driven Development)

**المبدأ:** قبل كتابة أي سطر من الكود، يجب أن تكون هناك مواصفة واضحة ومهيكلة.

**الممارسة الأفضل:**
*   **ابدأ بـ EARS:** عند تلقي طلب ميزة جديدة، قم بصياغة المتطلبات باستخدام صيغة EARS (Easy Approach to Requirements Syntax) كما هو محدد في `.kiro/specs/requirements.md`. هذا يضمن أن المتطلب غير غامض وقابل للتنفيذ.
*   **مثال على متطلب EARS:**
    > **When** a user attempts to sign up, **the system shall** validate the email format **and** **if** the email is valid, **then** send a confirmation email.

*   **استخدم قالب Spec Writer Agent:** استخدم الـ Prompt المحدد في `.kiro/prompts/system_spec_writer.prompt.md` لتوليد مواصفات دقيقة وشاملة تتضمن جميع الجوانب (المتطلبات الوظيفية، غير الوظيفية، التأثير على DORA/SPACE).

### 2.2. التبني قبل البناء (Adopt Before Build)

**المبدأ:** البحث عن حلول جاهزة قبل البدء في كتابة كود جديد.

**الممارسة الأفضل:**
*   **استشر AWS Marketplace:** قبل البدء في بناء ميزة جديدة، تحقق من AWS Marketplace للخدمات المدارة (مثل Amazon Cognito للمصادقة، DynamoDB للبيانات).
*   **استخدم المكتبات المعتمدة:** استخدم المكتبات والأطر المحددة في `.kiro/steering/tech.md` (مثل Vue.js للواجهة الأمامية، Go للخدمات الخلفية).
*   **تجنب إعادة الاختراع:** إذا كانت هناك مكتبة مشهورة وموثوقة تحل المشكلة، استخدمها بدلاً من بناء حل مخصص.

### 2.3. القياس أولاً (Measure First)

**المبدأ:** يجب أن تكون المقاييس جزءًا لا يتجزأ من عملية التطوير.

**الممارسة الأفضل:**
*   **حدد مقاييس DORA و SPACE:** عند إنشاء ميزة جديدة، حدد كيف ستؤثر على مقاييس DORA (Lead Time for Changes، Deployment Frequency) و SPACE (Satisfaction، Activity، Communication، Efficiency).
*   **مثال:** إذا كنت تقوم بأتمتة عملية النشر، يجب أن تتوقع تقليل Lead Time for Changes من 5 أيام إلى 1 يوم.
*   **وثق المقاييس:** أضف قسمًا في مواصفات الميزة يوضح المقاييس المتوقعة والفعلية بعد التنفيذ.

## 3. الهيكلة المعمارية (Architectural Structure)

### 3.1. تنظيم المستوى الجذري (Root Level Organization)

**الممارسة الأفضل:**
*   **فصل الخدمات:** استخدم هيكل الخدمات المصغرة (Microservices) حيث يكون لكل خدمة (Client، Server، Image Generation) مجلدها الخاص مع `iac/` و `tests/` الخاصة بها.
*   **مثال من spirit-of-kiro:**
    ```
    ├── client/           # Vue.js frontend
    ├── server/           # Bun WebSocket server
    ├── item-images/      # AI image generation service
    ├── iac/              # Infrastructure as Code (Terraform/CloudFormation)
    └── scripts/          # Deployment and setup scripts
    ```

### 3.2. اتفاقيات التسمية (Naming Conventions)

**الممارسة الأفضل:**
*   **kebab-case للملفات والمجلدات:** استخدم `user-profile.ts` بدلاً من `UserProfile.ts` أو `user_profile.ts`.
*   **PascalCase للمكونات:** استخدم `UserProfileComponent` للمكونات.
*   **camelCase للمتغيرات والدوال:** استخدم `getUserData()` بدلاً من `get_user_data()`.
*   **Conventional Commits:** استخدم `feat:`, `fix:`, `docs:`, `refactor:` في رسائل الالتزام.

## 4. الأمان والجودة (Security and Quality)

### 4.1. فحص الأمان الوقائي (Preventive Security Scanning)

**الممارسة الأفضل:**
*   **استخدم خطاف on-commit:** قبل كل التزام، يتم تشغيل `.kiro/hooks/on-commit/10_security_scan.sh` للبحث عن مفاتيح سرية.
*   **أدوات موصى بها:** استخدم أدوات مثل `gitleaks` أو `truffleHog` للفحص الفعلي.
*   **إدارة الأسرار:** استخدم AWS Secrets Manager أو HashiCorp Vault لإدارة المفاتيح السرية، لا تخزنها في الكود.

### 4.2. فرض جودة الكود (Code Quality Enforcement)

**الممارسة الأفضل:**
*   **استخدم خطاف on-push:** قبل كل دفع (Push)، يتم التحقق من تغطية الاختبارات باستخدام `.kiro/hooks/on-push/20_quality_gate.sh`.
*   **الحد الأدنى للتغطية:** يجب أن تكون تغطية الاختبارات (Test Coverage) لا تقل عن 85%.
*   **Linting و Formatting:** استخدم ESLint و Prettier (لـ JavaScript/TypeScript) أو `gofmt` و `golint` (لـ Go) تلقائيًا قبل كل التزام.

### 4.3. التطوير الموجه بالاختبارات (Test-Driven Development)

**الممارسة الأفضل:**
*   **اكتب الاختبارات أولاً:** قبل كتابة الكود الفعلي، اكتب الاختبارات التي تحدد السلوك المتوقع.
*   **أنواع الاختبارات:**
    *   **Unit Tests:** اختبر كل دالة أو وحدة منطقية بشكل منفصل.
    *   **Integration Tests:** اختبر التفاعل بين المكونات المختلفة.
    *   **End-to-End Tests:** اختبر سير العمل الكامل من البداية إلى النهاية.

## 5. الأتمتة والتكامل (Automation and Integration)

### 5.1. أتمتة GitOps (GitOps Automation)

**الممارسة الأفضل:**
*   **استخدم خطاف manual:** استخدم `.kiro/hooks/manual/30_deploy_gitops.sh` لتشغيل عملية نشر GitOps عند الطلب.
*   **مبدأ GitOps:** كل شيء يجب أن يكون موصوفًا في Git. عند تحديث ملفات Kubernetes Manifests، يتم تشغيل عملية المزامنة تلقائيًا.

### 5.2. تكوين MCP (Model Context Protocol)

**الممارسة الأفضل:**
*   **استخدم مصادر المعرفة:** استخدم ملف `.kiro/settings/mcp.json` لربط الوكيل بمصادر المعرفة الاستراتيجية (مثل "The Definitive Engineering Charter").
*   **تحديث المصادر:** عند إضافة وثيقة استراتيجية جديدة، أضفها إلى قائمة `knowledge_sources` مع تحديد أولوية مناسبة.

## 6. التوثيق والتواصل (Documentation and Communication)

### 6.1. التوثيق الشامل (Comprehensive Documentation)

**الممارسة الأفضل:**
*   **وثق كل ميزة:** لكل ميزة جديدة، أضف توثيقًا شاملاً يشرح الغرض والاستخدام والأمثلة.
*   **استخدم Markdown:** استخدم Markdown لكتابة الوثائق، مما يسهل قراءتها وصيانتها.
*   **حدث README.md:** حافظ على ملف README.md محدثًا بأحدث المعلومات عن المشروع.

### 6.2. التزام Conventional Commits

**الممارسة الأفضل:**
*   **استخدم صيغة موحدة:** استخدم `feat:`, `fix:`, `docs:`, `refactor:`, `test:` في بداية رسائل الالتزام.
*   **مثال:**
    ```
    feat: Add user authentication with OAuth2
    fix: Resolve login timeout issue
    docs: Update API documentation
    ```

## 7. الخطوات التالية (Next Steps)

عند البدء في مشروع جديد باستخدام هذا القالب، اتبع الخطوات التالية:

1.  **استنسخ المستودع:** `git clone https://github.com/mohammed-murad-alqabal/Kiro-Strategic-Blueprint.git`
2.  **افتح في Kiro IDE:** قم بفتح المستودع في Kiro IDE، وستتم تفعيل جميع ملفات `.kiro/` تلقائيًا.
3.  **اقرأ التوجيهات:** اقرأ ملفات `.kiro/steering/` لفهم المبادئ التوجيهية للمشروع.
4.  **ابدأ بالمواصفات:** استخدم `.kiro/prompts/system_spec_writer.prompt.md` لإنشاء مواصفات لأول ميزة.
5.  **نفذ الميزة:** استخدم `.kiro/prompts/system_code_generator.prompt.md` لتنفيذ الميزة بناءً على المواصفات.

---

## المراجع

[1] kirodotdev/spirit-of-kiro: The official example project demonstrating Kiro best practices. https://github.com/kirodotdev/spirit-of-kiro
[2] Kiro.dev: Agentic AI development from prototype to production. https://kiro.dev/
[3] awsdataarchitect/kiro-best-practices: Best practices and boilerplate for Kiro implementation on AWS. https://github.com/awsdataarchitect/kiro-best-practices
