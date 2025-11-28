# الأمان المتقدم (Advanced Security)

## نظرة عامة
هذا المستند يوفر إرشادات شاملة ومتقدمة للأمان تتجاوز المعايير الأساسية المحددة في `.kiro/steering/security.md`.

---

## 🛡️ الأمان متعدد الطبقات (Defense in Depth)

### الطبقة 1: أمان الشبكة (Network Security)
- **Zero Trust Architecture**: عدم الثقة بأي شيء افتراضياً
- **Network Segmentation**: تقسيم الشبكة إلى مناطق أمنية
- **Firewall Rules**: قواعد جدار حماية صارمة
- **DDoS Protection**: حماية من هجمات الحرمان من الخدمة
- **VPN/Private Links**: اتصالات آمنة ومشفرة

**التطبيق:**
```terraform
# مثال Terraform لـ Security Group
resource "aws_security_group" "app" {
  name        = "app-security-group"
  description = "Security group for application"
  
  # السماح فقط بـ HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # منع كل شيء آخر
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

### الطبقة 2: أمان التطبيق (Application Security)
- **Input Validation**: التحقق الصارم من جميع المدخلات
- **Output Encoding**: ترميز المخرجات لمنع XSS
- **SQL Injection Prevention**: استخدام Prepared Statements
- **CSRF Protection**: حماية من هجمات CSRF
- **Rate Limiting**: تحديد معدل الطلبات

**التطبيق:**
```typescript
// مثال TypeScript للتحقق من المدخلات
import { z } from 'zod';

const userSchema = z.object({
  email: z.string().email(),
  password: z.string().min(12).regex(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])/),
  name: z.string().min(2).max(100),
});

function validateUser(data: unknown) {
  try {
    return userSchema.parse(data);
  } catch (error) {
    throw new ValidationError('Invalid user data');
  }
}
```

### الطبقة 3: أمان البيانات (Data Security)
- **Encryption at Rest**: تشفير البيانات المخزنة
- **Encryption in Transit**: تشفير البيانات أثناء النقل
- **Data Masking**: إخفاء البيانات الحساسة
- **Data Classification**: تصنيف البيانات حسب الحساسية
- **Backup Encryption**: تشفير النسخ الاحتياطية

**التطبيق:**
```python
# مثال Python للتشفير
from cryptography.fernet import Fernet
import os

class DataEncryption:
    def __init__(self):
        # استخدام مفتاح من متغيرات البيئة
        key = os.environ.get('ENCRYPTION_KEY')
        if not key:
            raise ValueError('ENCRYPTION_KEY not set')
        self.cipher = Fernet(key.encode())
    
    def encrypt(self, data: str) -> bytes:
        """تشفير البيانات"""
        return self.cipher.encrypt(data.encode())
    
    def decrypt(self, encrypted_data: bytes) -> str:
        """فك تشفير البيانات"""
        return self.cipher.decrypt(encrypted_data).decode()
```

### الطبقة 4: أمان الهوية (Identity Security)
- **Multi-Factor Authentication**: مصادقة متعددة العوامل
- **Strong Password Policy**: سياسة كلمات مرور قوية
- **Session Management**: إدارة الجلسات بشكل آمن
- **OAuth 2.0 / OpenID Connect**: معايير المصادقة الحديثة
- **Least Privilege**: أقل الصلاحيات المطلوبة

**التطبيق:**
```go
// مثال Go للمصادقة
package auth

import (
    "time"
    "github.com/golang-jwt/jwt/v5"
)

type Claims struct {
    UserID string `json:"user_id"`
    Role   string `json:"role"`
    jwt.RegisteredClaims
}

func GenerateToken(userID, role string) (string, error) {
    claims := Claims{
        UserID: userID,
        Role:   role,
        RegisteredClaims: jwt.RegisteredClaims{
            ExpiresAt: jwt.NewNumericDate(time.Now().Add(15 * time.Minute)),
            IssuedAt:  jwt.NewNumericDate(time.Now()),
            NotBefore: jwt.NewNumericDate(time.Now()),
        },
    }
    
    token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
    return token.SignedString([]byte(getSecretKey()))
}
```

### الطبقة 5: أمان البنية التحتية (Infrastructure Security)
- **Container Security**: أمان الحاويات
- **Kubernetes Security**: أمان Kubernetes
- **Secrets Management**: إدارة الأسرار
- **Patch Management**: إدارة التحديثات الأمنية
- **Security Monitoring**: مراقبة الأمان

---

## 🔐 OWASP Top 10 (2021) - الحماية الشاملة

### 1. Broken Access Control
**المشكلة**: فشل في فرض القيود على المستخدمين المصادق عليهم.

**الحماية:**
```typescript
// مثال Middleware للتحقق من الصلاحيات
function requireRole(allowedRoles: string[]) {
  return (req: Request, res: Response, next: NextFunction) => {
    const userRole = req.user?.role;
    
    if (!userRole || !allowedRoles.includes(userRole)) {
      return res.status(403).json({ error: 'Forbidden' });
    }
    
    next();
  };
}

// الاستخدام
app.delete('/api/users/:id', requireRole(['admin']), deleteUser);
```

### 2. Cryptographic Failures
**المشكلة**: فشل في حماية البيانات الحساسة.

**الحماية:**
- استخدام TLS 1.3 للاتصالات
- تشفير البيانات الحساسة في قاعدة البيانات
- استخدام خوارزميات تشفير قوية (AES-256)
- عدم تخزين كلمات المرور بشكل نصي

```typescript
import bcrypt from 'bcrypt';

async function hashPassword(password: string): Promise<string> {
  const saltRounds = 12;
  return await bcrypt.hash(password, saltRounds);
}

async function verifyPassword(password: string, hash: string): Promise<boolean> {
  return await bcrypt.compare(password, hash);
}
```

### 3. Injection
**المشكلة**: إدخال بيانات غير موثوقة في الأوامر أو الاستعلامات.

**الحماية:**
```typescript
// ✅ صحيح - استخدام Prepared Statements
async function getUserByEmail(email: string) {
  return await db.query(
    'SELECT * FROM users WHERE email = $1',
    [email]
  );
}

// ❌ خطأ - عرضة لـ SQL Injection
async function getUserByEmailUnsafe(email: string) {
  return await db.query(
    `SELECT * FROM users WHERE email = '${email}'`
  );
}
```

### 4. Insecure Design
**المشكلة**: تصميم غير آمن من الأساس.

**الحماية:**
- تطبيق Threat Modeling
- استخدام Secure Design Patterns
- مراجعة التصميم من منظور أمني
- تطبيق Principle of Least Privilege

### 5. Security Misconfiguration
**المشكلة**: تكوينات أمنية خاطئة أو افتراضية.

**الحماية:**
```yaml
# مثال Docker Compose آمن
version: '3.8'
services:
  app:
    image: myapp:latest
    # عدم تشغيل كـ root
    user: "1000:1000"
    # قراءة فقط للنظام
    read_only: true
    # إزالة القدرات غير الضرورية
    cap_drop:
      - ALL
    # إضافة القدرات المطلوبة فقط
    cap_add:
      - NET_BIND_SERVICE
    # تحديد الموارد
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
```

### 6. Vulnerable and Outdated Components
**المشكلة**: استخدام مكونات قديمة أو بها ثغرات.

**الحماية:**
```bash
# فحص التبعيات بانتظام
npm audit
pip-audit
govulncheck ./...

# تحديث التبعيات
npm update
pip install --upgrade -r requirements.txt
go get -u ./...
```

### 7. Identification and Authentication Failures
**المشكلة**: فشل في التحقق من هوية المستخدم بشكل صحيح.

**الحماية:**
```typescript
// تطبيق Rate Limiting للحماية من Brute Force
import rateLimit from 'express-rate-limit';

const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 دقيقة
  max: 5, // 5 محاولات فقط
  message: 'Too many login attempts, please try again later',
  standardHeaders: true,
  legacyHeaders: false,
});

app.post('/api/login', loginLimiter, login);
```

### 8. Software and Data Integrity Failures
**المشكلة**: فشل في التحقق من سلامة البرمجيات والبيانات.

**الحماية:**
```yaml
# مثال GitHub Actions مع التحقق من السلامة
name: CI
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      # التحقق من توقيع الـ commits
      - name: Verify commit signature
        run: git verify-commit HEAD
      
      # فحص الأمان
      - name: Security scan
        run: |
          npm audit
          npm run test:security
```

### 9. Security Logging and Monitoring Failures
**المشكلة**: عدم كفاية التسجيل والمراقبة.

**الحماية:**
```typescript
import winston from 'winston';

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' }),
  ],
});

// تسجيل الأحداث الأمنية
function logSecurityEvent(event: string, details: any) {
  logger.warn('Security Event', {
    event,
    details,
    timestamp: new Date().toISOString(),
    ip: details.ip,
    user: details.user,
  });
}

// مثال الاستخدام
logSecurityEvent('failed_login', {
  ip: req.ip,
  user: req.body.email,
  attempts: 3,
});
```

### 10. Server-Side Request Forgery (SSRF)
**المشكلة**: السماح للمهاجم بإجبار الخادم على إرسال طلبات غير مصرح بها.

**الحماية:**
```typescript
import { URL } from 'url';

const ALLOWED_HOSTS = ['api.example.com', 'cdn.example.com'];

function validateUrl(urlString: string): boolean {
  try {
    const url = new URL(urlString);
    
    // التحقق من البروتوكول
    if (!['http:', 'https:'].includes(url.protocol)) {
      return false;
    }
    
    // التحقق من المضيف
    if (!ALLOWED_HOSTS.includes(url.hostname)) {
      return false;
    }
    
    // منع الوصول إلى IPs الداخلية
    if (url.hostname.match(/^(10|172\.(1[6-9]|2[0-9]|3[01])|192\.168)\./)) {
      return false;
    }
    
    return true;
  } catch {
    return false;
  }
}
```

---

## 🔍 فحص الأمان التلقائي

### 1. Static Application Security Testing (SAST)
```bash
# SonarQube
sonar-scanner

# Semgrep
semgrep --config=auto .

# Bandit (Python)
bandit -r .

# gosec (Go)
gosec ./...
```

### 2. Dynamic Application Security Testing (DAST)
```bash
# OWASP ZAP
zap-cli quick-scan http://localhost:3000

# Burp Suite
# استخدام واجهة المستخدم
```

### 3. Software Composition Analysis (SCA)
```bash
# Snyk
snyk test

# Dependabot
# تكوين في GitHub

# npm audit
npm audit --audit-level=high
```

### 4. Container Security Scanning
```bash
# Trivy
trivy image myapp:latest

# Clair
clairctl analyze myapp:latest

# Anchore
anchore-cli image scan myapp:latest
```

---

## 📋 قائمة التحقق الأمنية

### قبل النشر
- [ ] جميع الاختبارات الأمنية تنجح
- [ ] لا توجد ثغرات عالية الخطورة
- [ ] جميع الأسرار في Secrets Manager
- [ ] TLS 1.3 مفعّل
- [ ] HTTPS فقط
- [ ] CORS مكوّن بشكل صحيح
- [ ] Rate Limiting مفعّل
- [ ] Logging & Monitoring مفعّل
- [ ] Backup مشفّر
- [ ] Disaster Recovery Plan جاهز

### بعد النشر
- [ ] مراقبة السجلات الأمنية
- [ ] فحص الثغرات الدوري
- [ ] تحديث التبعيات
- [ ] مراجعة الصلاحيات
- [ ] اختبار Disaster Recovery
- [ ] تدريب الفريق

---

## 🚨 الاستجابة للحوادث

### 1. الكشف (Detection)
- مراقبة مستمرة للسجلات
- تنبيهات تلقائية للأنشطة المشبوهة
- تحليل الأنماط غير الطبيعية

### 2. الاحتواء (Containment)
- عزل الأنظمة المتأثرة
- منع انتشار الهجوم
- حفظ الأدلة

### 3. الاستئصال (Eradication)
- إزالة البرمجيات الخبيثة
- إصلاح الثغرات
- تحديث الأنظمة

### 4. الاستعادة (Recovery)
- استعادة الأنظمة من النسخ الاحتياطية
- التحقق من سلامة البيانات
- العودة للعمل الطبيعي

### 5. الدروس المستفادة (Lessons Learned)
- توثيق الحادثة
- تحليل الأسباب الجذرية
- تحسين الإجراءات

---

**ملاحظة**: الأمان عملية مستمرة وليست حدثاً لمرة واحدة. يجب المراجعة والتحديث المستمر.
