# AWS Labs MCP Servers - Official Collection

**Author:** [Your Development Team Name]  
**التاريخ:** 11 ديسمبر 2025  
**المصدر:** AWS Labs - Official MCP Servers  
**الحالة:** ✅ **مجموعة رسمية معتمدة**

---

## 🎯 نظرة عامة

هذا المجلد يحتوي على مراجع رسمية لجميع MCP Servers المطورة من قبل AWS Labs، مع أمثلة عملية وأفضل الممارسات للتكامل.

---

## 🚀 AWS Labs MCP Servers

### 1. **aws-knowledge** - البحث في توثيق AWS

**الوصف:** Search and retrieve AWS documentation, best practices, and service information

**الأدوات المتاحة:**

- `search_aws_documentation` - البحث في التوثيق
- `get_service_info` - معلومات الخدمات
- `get_best_practices` - أفضل الممارسات

**التكوين:**

```json
{
  "aws-knowledge": {
    "command": "uvx",
    "args": ["awslabs.aws-knowledge-mcp-server@latest"],
    "env": {
      "FASTMCP_LOG_LEVEL": "ERROR"
    },
    "disabled": false,
    "autoApprove": ["search_aws_documentation", "get_service_info"]
  }
}
```

**أمثلة الاستخدام:**

```bash
# البحث في توثيق Lambda
search_aws_documentation --query "AWS Lambda best practices"

# الحصول على معلومات خدمة S3
get_service_info --service "s3"
```

---

### 2. **aws-iac** - Infrastructure as Code Validation

**الوصف:** Validate CloudFormation templates, troubleshoot deployments, and get IaC guidance

**الأدوات المتاحة:**

- `validate_cloudformation_template` - التحقق من القوالب
- `troubleshoot_cloudformation_deployment` - استكشاف أخطاء النشر
- `check_cloudformation_template_compliance` - فحص الامتثال
- `search_cdk_documentation` - البحث في توثيق CDK
- `search_cloudformation_documentation` - البحث في توثيق CloudFormation

**التكوين:**

```json
{
  "aws-iac": {
    "command": "uvx",
    "args": ["awslabs.aws-iac-mcp-server@latest"],
    "env": {
      "AWS_REGION": "${AWS_REGION}",
      "FASTMCP_LOG_LEVEL": "ERROR"
    },
    "disabled": false,
    "autoApprove": ["validate_template", "search_cdk_documentation"]
  }
}
```

**أمثلة الاستخدام:**

```bash
# التحقق من قالب CloudFormation
validate_cloudformation_template --template-content "$(cat template.yaml)"

# استكشاف أخطاء النشر
troubleshoot_cloudformation_deployment --stack-name "my-stack" --region "us-east-1"

# البحث في توثيق CDK
search_cdk_documentation --query "AWS Lambda Function construct"
```

---

### 3. **context7** - Dependency Compatibility Checking

**الوصف:** Check compatibility and get information about software dependencies and packages

**الأدوات المتاحة:**

- `check_compatibility` - فحص التوافق
- `get_package_info` - معلومات الحزم
- `analyze_dependencies` - تحليل التبعيات

**التكوين:**

```json
{
  "context7": {
    "command": "uvx",
    "args": ["context7@latest"],
    "env": {
      "FASTMCP_LOG_LEVEL": "ERROR"
    },
    "disabled": false,
    "autoApprove": ["check_compatibility", "get_package_info"]
  }
}
```

**أمثلة الاستخدام:**

```bash
# فحص توافق حزمة
check_compatibility --package "react@18.0.0" --with "typescript@5.0.0"

# الحصول على معلومات حزمة
get_package_info --package "express" --version "latest"
```

---

### 4. **aws-serverless** - Serverless Development Tools

**الوصف:** Tools for building and managing serverless applications on AWS

**الأدوات المتاحة:**

- `create_lambda_function` - إنشاء دوال Lambda
- `manage_api_gateway` - إدارة API Gateway
- `configure_dynamodb` - تكوين DynamoDB
- `setup_event_bridge` - إعداد EventBridge

**التكوين:**

```json
{
  "aws-serverless": {
    "command": "uvx",
    "args": ["awslabs.aws-serverless-mcp@latest"],
    "env": {
      "AWS_REGION": "${AWS_REGION}",
      "AWS_ACCESS_KEY_ID": "${AWS_ACCESS_KEY_ID}",
      "AWS_SECRET_ACCESS_KEY": "${AWS_SECRET_ACCESS_KEY}"
    },
    "disabled": false,
    "autoApprove": ["list_functions", "get_function_info"]
  }
}
```

---

### 5. **dynamodb-mcp-server** - DynamoDB Operations

**الوصف:** Comprehensive DynamoDB operations and management tools

**الأدوات المتاحة:**

- `create_table` - إنشاء جداول
- `query_items` - استعلام العناصر
- `put_item` - إضافة عناصر
- `scan_table` - مسح الجدول
- `manage_indexes` - إدارة الفهارس

**التكوين:**

```json
{
  "dynamodb": {
    "command": "uvx",
    "args": ["awslabs.dynamodb-mcp-server@latest"],
    "env": {
      "AWS_REGION": "${AWS_REGION}",
      "AWS_ACCESS_KEY_ID": "${AWS_ACCESS_KEY_ID}",
      "AWS_SECRET_ACCESS_KEY": "${AWS_SECRET_ACCESS_KEY}"
    },
    "disabled": false,
    "autoApprove": ["list_tables", "describe_table"]
  }
}
```

---

## 📋 أمثلة التكامل المتقدم

### 1. سير عمل تطوير Serverless كامل

```bash
#!/bin/bash
# سكريبت تطوير تطبيق serverless متكامل

# 1. البحث عن أفضل الممارسات
search_aws_documentation --query "Lambda best practices 2025"

# 2. التحقق من توافق التبعيات
check_compatibility --package "aws-sdk@3.0.0" --with "node@18.0.0"

# 3. إنشاء قالب CloudFormation
cat > template.yaml << EOF
AWSTemplateFormatVersion: '2010-09-09'
Transform: AWS::Serverless-2016-10-31
Resources:
  MyFunction:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: src/
      Handler: index.handler
      Runtime: nodejs18.x
EOF

# 4. التحقق من القالب
validate_cloudformation_template --template-content "$(cat template.yaml)"

# 5. إنشاء جدول DynamoDB
create_table --table-name "MyTable" --key-schema "id:S"

# 6. نشر التطبيق
aws cloudformation deploy --template-file template.yaml --stack-name my-app
```

### 2. مراقبة ومتابعة التطبيق

```bash
#!/bin/bash
# سكريبت مراقبة التطبيق

# فحص حالة النشر
troubleshoot_cloudformation_deployment --stack-name "my-app" --region "us-east-1"

# فحص جداول DynamoDB
list_tables

# الحصول على معلومات الدوال
get_function_info --function-name "MyFunction"

# فحص السجلات
aws logs tail /aws/lambda/MyFunction --follow
```

---

## 🔧 أفضل الممارسات

### 1. الأمان والمصادقة

```bash
# استخدام IAM roles بدلاً من access keys
export AWS_ROLE_ARN="arn:aws:iam::123456789012:role/MyRole"
aws sts assume-role --role-arn $AWS_ROLE_ARN --role-session-name "mcp-session"

# تشفير المتغيرات الحساسة
export AWS_ACCESS_KEY_ID=$(echo $ENCRYPTED_KEY | base64 -d)
```

### 2. إدارة التكوين

```json
{
  "profiles": {
    "development": {
      "aws-region": "us-west-2",
      "log-level": "DEBUG"
    },
    "production": {
      "aws-region": "us-east-1",
      "log-level": "ERROR"
    }
  }
}
```

### 3. مراقبة الأداء

```bash
# مراقبة استخدام MCP servers
tail -f ~/.kiro/logs/mcp-servers.log | grep "aws-"

# فحص زمن الاستجابة
time search_aws_documentation --query "S3 performance"
```

---

## 📊 مقاييس الاستخدام

### معدلات النجاح المستهدفة

| الخدمة         | معدل النجاح | زمن الاستجابة | الاستخدام اليومي |
| -------------- | ----------- | ------------- | ---------------- |
| aws-knowledge  | 95%+        | < 2s          | 50+ استعلام      |
| aws-iac        | 90%+        | < 5s          | 20+ تحقق         |
| context7       | 98%+        | < 1s          | 100+ فحص         |
| aws-serverless | 92%+        | < 3s          | 30+ عملية        |

### مراقبة الأداء

```bash
# سكريبت مراقبة يومي
#!/bin/bash
echo "=== AWS Labs MCP Servers Health Check ==="
echo "Date: $(date)"

# فحص aws-knowledge
echo "Testing aws-knowledge..."
time search_aws_documentation --query "test" > /dev/null 2>&1
echo "Status: $?"

# فحص aws-iac
echo "Testing aws-iac..."
time validate_cloudformation_template --template-content "AWSTemplateFormatVersion: '2010-09-09'" > /dev/null 2>&1
echo "Status: $?"

# فحص context7
echo "Testing context7..."
time check_compatibility --package "test@1.0.0" --with "test@2.0.0" > /dev/null 2>&1
echo "Status: $?"
```

---

## 🚨 استكشاف الأخطاء

### مشاكل شائعة وحلولها

#### 1. خطأ في المصادقة AWS

```bash
# التحقق من الإعدادات
aws sts get-caller-identity

# إعادة تكوين المفاتيح
aws configure set aws_access_key_id YOUR_KEY
aws configure set aws_secret_access_key YOUR_SECRET
aws configure set region us-east-1
```

#### 2. مشاكل الشبكة

```bash
# فحص الاتصال
curl -I https://aws.amazon.com

# فحص DNS
nslookup aws.amazon.com

# فحص البروكسي
echo $HTTP_PROXY $HTTPS_PROXY
```

#### 3. مشاكل الأذونات

```bash
# فحص الأذونات
aws iam get-user
aws iam list-attached-user-policies --user-name YOUR_USER

# فحص الأدوار
aws sts get-caller-identity
```

---

## 📚 مراجع إضافية

### التوثيق الرسمي

- [AWS Labs GitHub](https://github.com/awslabs)
- [MCP Protocol Documentation](https://modelcontextprotocol.io/)
- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/)

### أمثلة وقوالب

- [AWS Samples](https://github.com/aws-samples)
- [Serverless Examples](https://github.com/serverless/examples)
- [CloudFormation Templates](https://github.com/awslabs/aws-cloudformation-templates)

### أدوات التطوير

- [AWS CDK](https://aws.amazon.com/cdk/)
- [AWS SAM](https://aws.amazon.com/serverless/sam/)
- [Serverless Framework](https://www.serverless.com/)

---

## 🎉 الخلاصة

AWS Labs MCP Servers تقدم مجموعة شاملة من الأدوات لتطوير وإدارة التطبيقات على AWS. من خلال التكامل مع Kiro IDE، يمكن للمطورين الاستفادة من قوة AWS مع سهولة الاستخدام.

**الفوائد الرئيسية:**
✅ تكامل مباشر مع خدمات AWS  
✅ أدوات التحقق والتشخيص المتقدمة  
✅ دعم Infrastructure as Code  
✅ مراقبة وإدارة شاملة

---

**Created by:** [Your Development Team Name]  
**المصدر:** AWS Labs Official MCP Servers  
**آخر تحديث:** 11 ديسمبر 2025
