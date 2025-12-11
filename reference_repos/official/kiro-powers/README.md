# Kiro Powers - Official Collection

**Author:** [Your Development Team Name]  
**التاريخ:** 11 ديسمبر 2025  
**المصدر:** kiro.dev - Official Powers Ecosystem  
**الحالة:** ✅ **مجموعة رسمية معتمدة**

---

## 🎯 نظرة عامة

هذا المجلد يحتوي على مراجع رسمية لجميع Kiro Powers المتاحة من النظام البيئي الرسمي، مع التركيز على الاستخدام العملي والتكامل المتقدم.

---

## 🚀 Kiro Powers الرسمية

### 1. **strands** - بناء وكلاء الذكاء الاصطناعي

**الوصف:** Build AI agents with Strands Agent SDK using multiple LLM providers

**الكلمات المفتاحية:** agents, ai, llm, bedrock, anthropic, openai, gemini, strands, tools

**MCP Servers:** strands-agents

**الاستخدام:**

```bash
# تفعيل Power
kiro powers activate strands

# استخدام الأدوات
kiro powers use strands strands-agents create_agent --args '{"name":"my-agent","model":"claude-3"}'
```

**الميزات الرئيسية:**

- دعم متعدد المزودين (Bedrock, Anthropic, OpenAI, Gemini, Llama)
- SDK متكامل لبناء الوكلاء
- أدوات متقدمة للتطوير
- تكامل مع Kiro IDE

---

### 2. **dynatrace** - مراقبة الأداء والتحليلات

**الوصف:** Query logs, metrics, traces, problems, and Kubernetes events using DQL

**الكلمات المفتاحية:** dynatrace, observability, monitoring, dql, logs, metrics, kubernetes, davis, grail

**MCP Servers:** dynatrace

**الاستخدام:**

```bash
# تفعيل Power
kiro powers activate dynatrace

# استعلام السجلات
kiro powers use dynatrace dynatrace query_logs --args '{"query":"fetch logs | limit 100"}'
```

**الميزات الرئيسية:**

- استعلامات DQL متقدمة
- مراقبة Kubernetes
- تحليل الأداء
- تتبع المشاكل

---

### 3. **aurora-dsql** - قاعدة بيانات PostgreSQL موزعة

**الوصف:** PostgreSQL compatible serverless distributed SQL database with Aurora DSQL

**الكلمات المفتاحية:** aurora, dsql, postgresql, serverless, database, sql, aws, distributed

**MCP Servers:** aurora-dsql, aws-core

**الاستخدام:**

```bash
# تفعيل Power
kiro powers activate aurora-dsql

# إدارة المخططات
kiro powers use aurora-dsql aurora-dsql manage_schema --args '{"operation":"create","schema":"users"}'
```

**الميزات الرئيسية:**

- PostgreSQL متوافق
- Serverless وموزع
- إدارة المخططات
- هجرات البيانات

---

### 4. **saas-builder** - بناء تطبيقات SaaS

**الوصف:** Build production ready multi-tenant SaaS applications with serverless architecture

**الكلمات المفتاحية:** saas, multi-tenant, serverless, aws, lambda, dynamodb, stripe, billing, react, typescript

**MCP Servers:** fetch, stripe, aws-knowledge-mcp-server, awslabs.dynamodb-mcp-server, awslabs.aws-serverless-mcp, playwright

**الاستخدام:**

```bash
# تفعيل Power
kiro powers activate saas-builder

# إنشاء تطبيق SaaS
kiro powers use saas-builder aws-serverless create_saas_app --args '{"name":"my-saas","billing":"stripe"}'
```

**الميزات الرئيسية:**

- Multi-tenant architecture
- تكامل Stripe للفوترة
- Serverless AWS
- أمان متقدم

---

### 5. **terraform** - إدارة البنية التحتية

**الوصف:** Build and manage Infrastructure as Code with Terraform and HCP Terraform

**الكلمات المفتاحية:** terraform, hashicorp, infrastructure, iac, hcp, providers, modules, registry

**MCP Servers:** terraform

**الاستخدام:**

```bash
# تفعيل Power
kiro powers activate terraform

# إدارة البنية التحتية
kiro powers use terraform terraform plan_infrastructure --args '{"config":"main.tf"}'
```

**الميزات الرئيسية:**

- Infrastructure as Code
- HCP Terraform integration
- Provider registry access
- Module management

---

## 📋 دليل التكامل

### 1. تكوين MCP للـ Powers

```json
{
  "mcpServers": {
    "strands-agents": {
      "command": "uvx",
      "args": ["strands-agents@latest"],
      "disabled": false,
      "autoApprove": ["list_agents", "get_agent_status"]
    },
    "dynatrace": {
      "command": "uvx",
      "args": ["dynatrace-mcp@latest"],
      "env": {
        "DYNATRACE_API_TOKEN": "${DYNATRACE_API_TOKEN}",
        "DYNATRACE_ENVIRONMENT_URL": "${DYNATRACE_ENVIRONMENT_URL}"
      },
      "disabled": false,
      "autoApprove": ["query_logs", "get_metrics"]
    },
    "aurora-dsql": {
      "command": "uvx",
      "args": ["aurora-dsql-mcp@latest"],
      "env": {
        "AWS_REGION": "${AWS_REGION}",
        "AWS_ACCESS_KEY_ID": "${AWS_ACCESS_KEY_ID}",
        "AWS_SECRET_ACCESS_KEY": "${AWS_SECRET_ACCESS_KEY}"
      },
      "disabled": false,
      "autoApprove": ["list_tables", "describe_table"]
    }
  }
}
```

### 2. أمثلة عملية للاستخدام

#### بناء وكيل ذكي مع Strands

```bash
# إنشاء وكيل جديد
kiro powers use strands strands-agents create_agent \
  --args '{
    "name": "code-reviewer",
    "model": "claude-3-sonnet",
    "tools": ["code_analysis", "git_operations"],
    "instructions": "Review code for quality and security"
  }'

# تشغيل الوكيل
kiro powers use strands strands-agents run_agent \
  --args '{
    "agent_id": "code-reviewer",
    "input": "Review the latest commit"
  }'
```

#### مراقبة التطبيق مع Dynatrace

```bash
# استعلام السجلات
kiro powers use dynatrace dynatrace query_logs \
  --args '{
    "query": "fetch logs | filter contains(content, \"ERROR\") | limit 50"
  }'

# الحصول على مقاييس الأداء
kiro powers use dynatrace dynatrace get_metrics \
  --args '{
    "metric": "builtin:service.response.time",
    "timeframe": "now-1h"
  }'
```

#### إدارة قاعدة البيانات مع Aurora DSQL

```bash
# إنشاء جدول
kiro powers use aurora-dsql aurora-dsql execute_query \
  --args '{
    "query": "CREATE TABLE users (id SERIAL PRIMARY KEY, name VARCHAR(100), email VARCHAR(100) UNIQUE)"
  }'

# استعلام البيانات
kiro powers use aurora-dsql aurora-dsql execute_query \
  --args '{
    "query": "SELECT * FROM users WHERE created_at > NOW() - INTERVAL \"1 day\""
  }'
```

---

## 🔧 أفضل الممارسات

### 1. إدارة الأمان

- استخدم متغيرات البيئة للمفاتيح الحساسة
- فعّل auto-approve فقط للعمليات الآمنة
- راجع أذونات الأدوات بانتظام

### 2. الأداء والكفاءة

- فعّل Powers حسب الحاجة فقط
- استخدم caching للاستعلامات المتكررة
- راقب استهلاك الموارد

### 3. التطوير والاختبار

- اختبر Powers في بيئة التطوير أولاً
- استخدم logging مفصل للتشخيص
- وثّق استخدام Powers في المشروع

---

## 📚 مراجع إضافية

### التوثيق الرسمي

- [Kiro Powers Documentation](https://kiro.dev/powers)
- [MCP Protocol Specification](https://modelcontextprotocol.io/)
- [Strands Agent SDK](https://github.com/strands-ai/agent-sdk)

### أمثلة المجتمع

- [Kiro Powers Examples](https://github.com/kiro-dev/powers-examples)
- [Community Powers](https://github.com/kiro-dev/community-powers)
- [Best Practices Guide](https://kiro.dev/powers/best-practices)

---

## 🎉 الخلاصة

Kiro Powers تقدم نظاماً بيئياً متكاملاً لتطوير التطبيقات الذكية والمتقدمة. من خلال التكامل مع MCP servers والأدوات المتخصصة، يمكن للمطورين بناء حلول قوية ومرنة بسهولة.

**الفوائد الرئيسية:**
✅ تكامل سلس مع Kiro IDE  
✅ دعم متعدد المزودين والتقنيات  
✅ أدوات متقدمة للتطوير والمراقبة  
✅ مجتمع نشط ودعم رسمي

---

**Created by:** [Your Development Team Name]  
**المصدر:** kiro.dev Official Powers Ecosystem  
**آخر تحديث:** 11 ديسمبر 2025
