# توجيه هيكل المشروع (Project Structure Steering)

هذا الملف يحدد المبادئ التوجيهية لهيكلة المشروع، بما في ذلك تنظيم الملفات، الاتفاقيات المعمارية، واتفاقيات التسمية. يجب على وكلاء الذكاء الاصطناعي الالتزام بهذه المبادئ عند إنشاء أو تعديل أي ملفات أو مجلدات.

## 1. تنظيم المستوى الجذري (Root Level Organization)

يجب أن يتبع هيكل المشروع نمط الخدمات المصغرة (Microservices) أو المكونات المنفصلة (Decoupled Components) لضمان قابلية التوسع والصيانة. **التوجيه للوكيل:** عند إنشاء مكونات جديدة، يجب فصل المنطق التجاري عن طبقة الوصول إلى البيانات.

| المجلد | الوصف | التوجيه المعماري |
| :--- | :--- | :--- |
| `client/` | تطبيق الواجهة الأمامية (Frontend Application) (مثلاً: Flutter، Vue.js). | يجب أن يتبع نمط MVVM أو Component-Based Architecture. |
| `server/` | تطبيق الواجهة الخلفية (Backend Application) (مثلاً: Go، Bun WebSocket Server). | يجب أن يتبع نمط Layered Architecture أو Clean Architecture. |
| `docs/` | وثائق المشروع العامة (باستثناء وثائق Kiro الخاصة). | يجب أن تكون الوثائق محدثة وتتبع معيار Markdown. |
| `scripts/` | نصوص الأتمتة (Automation Scripts) (مثل: النشر، الإعداد). | يجب أن تكون النصوص قابلة للتنفيذ وموثقة. |
| `iac/` | البنية التحتية ككود (Infrastructure as Code) (مثل: Terraform، CloudFormation). | يجب أن تكون منفصلة لكل خدمة (Client/Server). |
| `.kiro/` | ملفات توجيه Kiro (Steering, Specs, Hooks, Prompts). | **يجب عدم تعديل هذا المجلد إلا لغرض المعايرة الاستراتيجية.** (يجب على الوكيل قراءة هذا المجلد، وليس تعديله بشكل روتيني). |

## 2. المبادئ المعمارية الرئيسية (Key Architectural Principles)

### أ. الاتصال الموجه بالرسائل (Message-Driven Communication)

*   **المبدأ:** يجب أن يتم الاتصال بين الخدمات (Client/Server) عبر واجهات برمجة تطبيقات (APIs) واضحة أو بروتوكولات موجهة بالرسائل (مثل WebSocket).
*   **التوجيه:** يجب أن تتبع أسماء الرسائل والـ Endpoints اتفاقية **kebab-case** لضمان الاتساق.

### ب. البنية التحتية ككود (Infrastructure as Code - IaC)

*   **المبدأ:** يجب أن تكون البنية التحتية لكل خدمة (Client/Server) محددة بالكامل في مجلد `iac/` الخاص بها.
*   **التوجيه:** يجب أن يتم استخدام أدوات IaC المعتمدة (مثل Terraform أو CloudFormation) لضمان قابلية التكرار.

## 3. اتفاقيات التسمية (Naming Conventions)

| العنصر | الاتفاقية | مثال |
| :--- | :--- | :--- |
| **أسماء الملفات والمجلدات** | **kebab-case** (باستثناء أسماء المكونات والملفات التنفيذية). | `user-profile.ts`، `data-access-layer/` |
| **المكونات (Components)** | **PascalCase** | `UserProfileComponent` |
| **المتغيرات والدوال** | **camelCase** | `getUserData()`، `isLoggedIn` |
| **رسائل الالتزام (Commits)** | **Conventional Commits** | `feat: add user authentication`، `fix: resolve login bug` |
