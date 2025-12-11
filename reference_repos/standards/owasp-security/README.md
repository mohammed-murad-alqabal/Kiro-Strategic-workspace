# OWASP Security Guidelines

**Author:** [Your Development Team Name]  
**التاريخ:** 11 ديسمبر 2025  
**المصدر:** OWASP Foundation  
**الحالة:** ✅ **دليل أمان شامل**

---

## 🎯 نظرة عامة

OWASP (Open Web Application Security Project) هي مؤسسة غير ربحية تهدف إلى تحسين أمان البرمجيات. توفر OWASP موارد مجانية ومفتوحة المصدر لمساعدة المطورين والمؤسسات على بناء تطبيقات آمنة.

---

## 🔟 OWASP Top 10 - 2021

### 1. **A01:2021 – Broken Access Control**

**الوصف:** فشل في تطبيق قيود الوصول بشكل صحيح

**أمثلة الثغرات:**

- الوصول لصفحات المشرف بدون صلاحيات
- تعديل معرف المستخدم في URL للوصول لحسابات أخرى
- رفع الصلاحيات بدون تخويل مناسب

**الحماية:**

```javascript
// مثال تطبيق التحكم في الوصول
class AccessController {
  constructor() {
    this.permissions = new Map();
    this.roles = new Map();
  }

  // تعريف الأدوار والصلاحيات
  defineRole(roleName, permissions) {
    this.roles.set(roleName, new Set(permissions));
  }

  // تخصيص دور للمستخدم
  assignRole(userId, roleName) {
    if (!this.roles.has(roleName)) {
      throw new Error(`Role ${roleName} does not exist`);
    }
    this.permissions.set(userId, roleName);
  }

  // فحص الصلاحية
  hasPermission(userId, resource, action) {
    const userRole = this.permissions.get(userId);
    if (!userRole) {
      return false;
    }

    const rolePermissions = this.roles.get(userRole);
    const requiredPermission = `${resource}:${action}`;

    return (
      rolePermissions.has(requiredPermission) ||
      rolePermissions.has(`${resource}:*`) ||
      rolePermissions.has("*:*")
    );
  }

  // Middleware للتحقق من الصلاحيات
  requirePermission(resource, action) {
    return (req, res, next) => {
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({ error: "Authentication required" });
      }

      if (!this.hasPermission(userId, resource, action)) {
        return res.status(403).json({ error: "Insufficient permissions" });
      }

      next();
    };
  }

  // تسجيل محاولات الوصول
  logAccessAttempt(userId, resource, action, granted) {
    const logEntry = {
      timestamp: new Date().toISOString(),
      userId,
      resource,
      action,
      granted,
      ip: req.ip,
      userAgent: req.get("User-Agent"),
    };

    console.log("Access Attempt:", logEntry);

    // إرسال تنبيه في حالة الرفض
    if (!granted) {
      this.sendSecurityAlert(logEntry);
    }
  }
}

// الاستخدام
const accessController = new AccessController();

// تعريف الأدوار
accessController.defineRole("admin", ["users:*", "system:*"]);
accessController.defineRole("user", ["profile:read", "profile:update"]);
accessController.defineRole("guest", ["content:read"]);

// حماية المسارات
app.get(
  "/admin/users",
  accessController.requirePermission("users", "read"),
  (req, res) => {
    // منطق الحصول على المستخدمين
  }
);

app.put(
  "/users/:id",
  accessController.requirePermission("users", "update"),
  (req, res) => {
    // التأكد من أن المستخدم يحدث بياناته فقط
    if (
      req.params.id !== req.user.id &&
      !accessController.hasPermission(req.user.id, "users", "*")
    ) {
      return res.status(403).json({ error: "Cannot modify other users" });
    }
    // منطق التحديث
  }
);
```

### 2. **A02:2021 – Cryptographic Failures**

**الوصف:** فشل في حماية البيانات الحساسة بالتشفير المناسب

**أمثلة الثغرات:**

- تخزين كلمات المرور بدون تشفير
- استخدام خوارزميات تشفير ضعيفة
- عدم تشفير البيانات أثناء النقل

**الحماية:**

```python
#!/usr/bin/env python3
# نظام التشفير الآمن

import hashlib
import secrets
import bcrypt
from cryptography.fernet import Fernet
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
import base64

class SecureCrypto:
    def __init__(self):
        self.salt_length = 32
        self.iterations = 100000

    def hash_password(self, password: str) -> str:
        """تشفير كلمة المرور باستخدام bcrypt"""
        # إنشاء salt عشوائي
        salt = bcrypt.gensalt(rounds=12)

        # تشفير كلمة المرور
        hashed = bcrypt.hashpw(password.encode('utf-8'), salt)

        return hashed.decode('utf-8')

    def verify_password(self, password: str, hashed: str) -> bool:
        """التحقق من كلمة المرور"""
        return bcrypt.checkpw(password.encode('utf-8'), hashed.encode('utf-8'))

    def generate_secure_token(self, length: int = 32) -> str:
        """إنشاء رمز آمن عشوائي"""
        return secrets.token_urlsafe(length)

    def encrypt_sensitive_data(self, data: str, password: str) -> dict:
        """تشفير البيانات الحساسة"""
        # إنشاء salt عشوائي
        salt = secrets.token_bytes(32)

        # اشتقاق مفتاح من كلمة المرور
        kdf = PBKDF2HMAC(
            algorithm=hashes.SHA256(),
            length=32,
            salt=salt,
            iterations=self.iterations,
        )
        key = base64.urlsafe_b64encode(kdf.derive(password.encode()))

        # تشفير البيانات
        fernet = Fernet(key)
        encrypted_data = fernet.encrypt(data.encode())

        return {
            'encrypted_data': base64.urlsafe_b64encode(encrypted_data).decode(),
            'salt': base64.urlsafe_b64encode(salt).decode(),
            'iterations': self.iterations
        }

    def decrypt_sensitive_data(self, encrypted_dict: dict, password: str) -> str:
        """فك تشفير البيانات الحساسة"""
        # استخراج المعاملات
        encrypted_data = base64.urlsafe_b64decode(encrypted_dict['encrypted_data'])
        salt = base64.urlsafe_b64decode(encrypted_dict['salt'])
        iterations = encrypted_dict['iterations']

        # اشتقاق المفتاح
        kdf = PBKDF2HMAC(
            algorithm=hashes.SHA256(),
            length=32,
            salt=salt,
            iterations=iterations,
        )
        key = base64.urlsafe_b64encode(kdf.derive(password.encode()))

        # فك التشفير
        fernet = Fernet(key)
        decrypted_data = fernet.decrypt(encrypted_data)

        return decrypted_data.decode()

    def secure_compare(self, a: str, b: str) -> bool:
        """مقارنة آمنة للسلاسل النصية لتجنب timing attacks"""
        return secrets.compare_digest(a.encode(), b.encode())

# مثال الاستخدام
crypto = SecureCrypto()

# تشفير كلمة المرور
password = "user_password_123"
hashed_password = crypto.hash_password(password)
print(f"Hashed Password: {hashed_password}")

# التحقق من كلمة المرور
is_valid = crypto.verify_password(password, hashed_password)
print(f"Password Valid: {is_valid}")

# تشفير البيانات الحساسة
sensitive_data = "Credit Card: 1234-5678-9012-3456"
master_password = "master_key_2023"
encrypted = crypto.encrypt_sensitive_data(sensitive_data, master_password)
print(f"Encrypted Data: {encrypted}")

# فك التشفير
decrypted = crypto.decrypt_sensitive_data(encrypted, master_password)
print(f"Decrypted Data: {decrypted}")
```

### 3. **A03:2021 – Injection**

**الوصف:** حقن كود ضار في التطبيق من خلال المدخلات غير المحققة

**أنواع الحقن:**

- SQL Injection
- NoSQL Injection
- Command Injection
- LDAP Injection

**الحماية:**

```php
<?php
// حماية من SQL Injection

class SecureDatabase {
    private $pdo;

    public function __construct($dsn, $username, $password) {
        $options = [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false, // استخدام prepared statements حقيقية
        ];

        $this->pdo = new PDO($dsn, $username, $password, $options);
    }

    // استخدام Prepared Statements
    public function getUserById($userId) {
        // ✅ آمن - استخدام prepared statement
        $stmt = $this->pdo->prepare("SELECT * FROM users WHERE id = ?");
        $stmt->execute([$userId]);
        return $stmt->fetch();

        // ❌ غير آمن - عرضة لـ SQL injection
        // $query = "SELECT * FROM users WHERE id = " . $userId;
        // return $this->pdo->query($query)->fetch();
    }

    // التحقق من صحة المدخلات
    public function searchUsers($searchTerm) {
        // تنظيف وتحقق من المدخلات
        $searchTerm = $this->sanitizeInput($searchTerm);

        if (!$this->isValidSearchTerm($searchTerm)) {
            throw new InvalidArgumentException("Invalid search term");
        }

        $stmt = $this->pdo->prepare("SELECT * FROM users WHERE name LIKE ? OR email LIKE ?");
        $searchPattern = "%{$searchTerm}%";
        $stmt->execute([$searchPattern, $searchPattern]);
        return $stmt->fetchAll();
    }

    // تنظيف المدخلات
    private function sanitizeInput($input) {
        // إزالة المسافات الزائدة
        $input = trim($input);

        // إزالة الرموز الخطيرة
        $input = preg_replace('/[<>"\']/', '', $input);

        // تحديد الطول الأقصى
        if (strlen($input) > 100) {
            $input = substr($input, 0, 100);
        }

        return $input;
    }

    // التحقق من صحة مصطلح البحث
    private function isValidSearchTerm($term) {
        // يجب أن يحتوي على أحرف وأرقام فقط
        return preg_match('/^[a-zA-Z0-9\s\-_.@]+$/', $term);
    }

    // حماية من Command Injection
    public function processFile($filename) {
        // التحقق من اسم الملف
        if (!$this->isValidFilename($filename)) {
            throw new InvalidArgumentException("Invalid filename");
        }

        // استخدام escapeshellarg لحماية المعاملات
        $safeFilename = escapeshellarg($filename);

        // تحديد الأوامر المسموحة
        $allowedCommands = ['convert', 'identify', 'mogrify'];
        $command = 'identify';

        if (!in_array($command, $allowedCommands)) {
            throw new InvalidArgumentException("Command not allowed");
        }

        // تنفيذ الأمر بشكل آمن
        $output = [];
        $returnCode = 0;
        exec("{$command} {$safeFilename} 2>&1", $output, $returnCode);

        if ($returnCode !== 0) {
            throw new RuntimeException("Command execution failed");
        }

        return $output;
    }

    private function isValidFilename($filename) {
        // التحقق من وجود رموز خطيرة
        $dangerousChars = ['..', '/', '\\', '|', '&', ';', '`', '$', '(', ')'];

        foreach ($dangerousChars as $char) {
            if (strpos($filename, $char) !== false) {
                return false;
            }
        }

        // التحقق من امتداد الملف
        $allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'pdf'];
        $extension = strtolower(pathinfo($filename, PATHINFO_EXTENSION));

        return in_array($extension, $allowedExtensions);
    }
}

// مثال للاستخدام الآمن
try {
    $db = new SecureDatabase($dsn, $username, $password);

    // البحث الآمن
    $users = $db->searchUsers($_GET['search'] ?? '');

    // معالجة الملف الآمنة
    if (isset($_FILES['upload'])) {
        $result = $db->processFile($_FILES['upload']['name']);
    }

} catch (Exception $e) {
    // تسجيل الخطأ وإرجاع رسالة عامة
    error_log("Security error: " . $e->getMessage());
    http_response_code(400);
    echo json_encode(['error' => 'Invalid request']);
}
?>
```

### 4. **A04:2021 – Insecure Design**

**الوصف:** نقص في التصميم الأمني والتحكم في المخاطر

**أمثلة المشاكل:**

- عدم وجود نمذجة التهديدات
- عدم تطبيق مبدأ الدفاع في العمق
- عدم وجود حدود للمعدل (Rate Limiting)

**الحماية:**

```typescript
// تصميم آمن لنظام المصادقة
interface SecurityConfig {
  maxLoginAttempts: number;
  lockoutDuration: number;
  passwordPolicy: PasswordPolicy;
  sessionTimeout: number;
  requireMFA: boolean;
}

interface PasswordPolicy {
  minLength: number;
  requireUppercase: boolean;
  requireLowercase: boolean;
  requireNumbers: boolean;
  requireSpecialChars: boolean;
  preventReuse: number;
}

class SecureAuthenticationSystem {
  private config: SecurityConfig;
  private loginAttempts: Map<string, LoginAttempt[]> = new Map();
  private activeSessions: Map<string, Session> = new Map();

  constructor(config: SecurityConfig) {
    this.config = config;
    this.startCleanupTimer();
  }

  // تسجيل دخول آمن مع Rate Limiting
  async login(
    username: string,
    password: string,
    ip: string
  ): Promise<LoginResult> {
    // فحص محاولات تسجيل الدخول
    if (this.isAccountLocked(username)) {
      await this.logSecurityEvent("LOGIN_BLOCKED_LOCKED_ACCOUNT", {
        username,
        ip,
      });
      throw new Error("Account is temporarily locked");
    }

    if (this.isIPBlocked(ip)) {
      await this.logSecurityEvent("LOGIN_BLOCKED_IP", { username, ip });
      throw new Error("Too many failed attempts from this IP");
    }

    // التحقق من بيانات الاعتماد
    const user = await this.validateCredentials(username, password);

    if (!user) {
      this.recordFailedAttempt(username, ip);
      await this.logSecurityEvent("LOGIN_FAILED", { username, ip });
      throw new Error("Invalid credentials");
    }

    // التحقق من MFA إذا كان مطلوباً
    if (this.config.requireMFA && !user.mfaVerified) {
      return {
        success: false,
        requiresMFA: true,
        mfaToken: await this.generateMFAToken(user.id),
      };
    }

    // إنشاء جلسة آمنة
    const session = await this.createSecureSession(user);

    // تنظيف محاولات تسجيل الدخول الفاشلة
    this.clearFailedAttempts(username);

    await this.logSecurityEvent("LOGIN_SUCCESS", {
      username,
      ip,
      sessionId: session.id,
    });

    return {
      success: true,
      sessionToken: session.token,
      expiresAt: session.expiresAt,
    };
  }

  // إنشاء جلسة آمنة
  private async createSecureSession(user: User): Promise<Session> {
    const session: Session = {
      id: this.generateSecureId(),
      userId: user.id,
      token: this.generateSecureToken(),
      createdAt: new Date(),
      expiresAt: new Date(Date.now() + this.config.sessionTimeout),
      lastActivity: new Date(),
      ipAddress: user.currentIP,
      userAgent: user.currentUserAgent,
    };

    // تخزين الجلسة
    this.activeSessions.set(session.token, session);

    // إزالة الجلسات القديمة للمستخدم
    await this.cleanupUserSessions(user.id);

    return session;
  }

  // التحقق من صحة كلمة المرور
  validatePassword(password: string): ValidationResult {
    const policy = this.config.passwordPolicy;
    const errors: string[] = [];

    if (password.length < policy.minLength) {
      errors.push(`Password must be at least ${policy.minLength} characters`);
    }

    if (policy.requireUppercase && !/[A-Z]/.test(password)) {
      errors.push("Password must contain uppercase letters");
    }

    if (policy.requireLowercase && !/[a-z]/.test(password)) {
      errors.push("Password must contain lowercase letters");
    }

    if (policy.requireNumbers && !/\d/.test(password)) {
      errors.push("Password must contain numbers");
    }

    if (
      policy.requireSpecialChars &&
      !/[!@#$%^&*(),.?":{}|<>]/.test(password)
    ) {
      errors.push("Password must contain special characters");
    }

    // فحص كلمات المرور الشائعة
    if (this.isCommonPassword(password)) {
      errors.push("Password is too common");
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  // Rate Limiting للحماية من Brute Force
  private isAccountLocked(username: string): boolean {
    const attempts = this.loginAttempts.get(username) || [];
    const recentAttempts = attempts.filter(
      (attempt) => Date.now() - attempt.timestamp < this.config.lockoutDuration
    );

    return recentAttempts.length >= this.config.maxLoginAttempts;
  }

  private recordFailedAttempt(username: string, ip: string): void {
    const attempts = this.loginAttempts.get(username) || [];
    attempts.push({
      timestamp: Date.now(),
      ip,
      success: false,
    });

    // الاحتفاظ بآخر 100 محاولة فقط
    if (attempts.length > 100) {
      attempts.splice(0, attempts.length - 100);
    }

    this.loginAttempts.set(username, attempts);
  }

  // تنظيف دوري للبيانات
  private startCleanupTimer(): void {
    setInterval(() => {
      this.cleanupExpiredSessions();
      this.cleanupOldLoginAttempts();
    }, 60000); // كل دقيقة
  }
}
```

---

## 🛡️ OWASP Security Controls

### 1. **Input Validation**

```python
# نظام التحقق من صحة المدخلات
import re
from typing import Any, Dict, List, Optional
from html import escape
import bleach

class InputValidator:
    def __init__(self):
        self.patterns = {
            'email': r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
            'phone': r'^\+?1?-?\.?\s?\(?(\d{3})\)?[\s.-]?(\d{3})[\s.-]?(\d{4})$',
            'username': r'^[a-zA-Z0-9_]{3,20}$',
            'password': r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
            'url': r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$'
        }

        self.max_lengths = {
            'username': 20,
            'email': 254,
            'name': 100,
            'description': 1000,
            'comment': 500
        }

    def validate_input(self, value: Any, input_type: str, required: bool = True) -> Dict:
        """التحقق الشامل من المدخلات"""
        result = {
            'valid': True,
            'errors': [],
            'sanitized_value': None
        }

        # فحص القيم المطلوبة
        if required and (value is None or str(value).strip() == ''):
            result['valid'] = False
            result['errors'].append(f'{input_type} is required')
            return result

        if value is None:
            result['sanitized_value'] = None
            return result

        # تحويل إلى نص
        str_value = str(value).strip()

        # فحص الطول الأقصى
        if input_type in self.max_lengths:
            max_len = self.max_lengths[input_type]
            if len(str_value) > max_len:
                result['valid'] = False
                result['errors'].append(f'{input_type} must be {max_len} characters or less')

        # فحص النمط
        if input_type in self.patterns:
            if not re.match(self.patterns[input_type], str_value):
                result['valid'] = False
                result['errors'].append(f'Invalid {input_type} format')

        # تنظيف القيمة
        if input_type == 'html':
            # السماح ببعض HTML tags الآمنة فقط
            allowed_tags = ['p', 'br', 'strong', 'em', 'ul', 'ol', 'li']
            result['sanitized_value'] = bleach.clean(str_value, tags=allowed_tags, strip=True)
        else:
            # تنظيف عام
            result['sanitized_value'] = escape(str_value)

        return result

    def validate_file_upload(self, file_data: Dict) -> Dict:
        """التحقق من صحة رفع الملفات"""
        result = {'valid': True, 'errors': []}

        # فحص نوع الملف
        allowed_types = ['image/jpeg', 'image/png', 'image/gif', 'application/pdf']
        if file_data.get('content_type') not in allowed_types:
            result['valid'] = False
            result['errors'].append('File type not allowed')

        # فحص حجم الملف (5MB max)
        max_size = 5 * 1024 * 1024
        if file_data.get('size', 0) > max_size:
            result['valid'] = False
            result['errors'].append('File size too large')

        # فحص اسم الملف
        filename = file_data.get('filename', '')
        if not re.match(r'^[a-zA-Z0-9._-]+$', filename):
            result['valid'] = False
            result['errors'].append('Invalid filename')

        return result

# مثال الاستخدام
validator = InputValidator()

# التحقق من البريد الإلكتروني
email_result = validator.validate_input('user@example.com', 'email')
print(f"Email validation: {email_result}")

# التحقق من كلمة المرور
password_result = validator.validate_input('SecurePass123!', 'password')
print(f"Password validation: {password_result}")
```

---

## 📊 OWASP Testing Guide

### Security Testing Checklist

```yaml
# قائمة فحص الأمان
owasp_testing_checklist:
  authentication_testing:
    - test_default_credentials
    - test_weak_password_policy
    - test_account_lockout_mechanism
    - test_password_reset_functionality
    - test_multi_factor_authentication

  authorization_testing:
    - test_path_traversal
    - test_privilege_escalation
    - test_insecure_direct_object_references
    - test_missing_authorization
    - test_bypass_authorization_schema

  session_management_testing:
    - test_session_token_strength
    - test_session_fixation
    - test_session_timeout
    - test_logout_functionality
    - test_concurrent_sessions

  input_validation_testing:
    - test_sql_injection
    - test_xss_vulnerabilities
    - test_command_injection
    - test_file_upload_vulnerabilities
    - test_buffer_overflow

  error_handling_testing:
    - test_error_code_analysis
    - test_stack_trace_analysis
    - test_information_leakage
    - test_custom_error_pages

  cryptography_testing:
    - test_weak_ssl_tls_ciphers
    - test_certificate_validation
    - test_sensitive_data_encryption
    - test_random_number_generation

automated_testing_tools:
  static_analysis:
    - sonarqube
    - checkmarx
    - veracode
    - semgrep

  dynamic_analysis:
    - owasp_zap
    - burp_suite
    - nikto
    - sqlmap

  dependency_scanning:
    - owasp_dependency_check
    - snyk
    - whitesource
    - npm_audit
```

---

## 🎯 الخلاصة

OWASP يوفر مجموعة شاملة من الموارد والأدوات لبناء تطبيقات آمنة. من خلال اتباع إرشادات OWASP Top 10 وتطبيق أفضل الممارسات الأمنية، يمكن للمطورين تقليل المخاطر الأمنية بشكل كبير.

**الفوائد الرئيسية:**
✅ حماية شاملة ضد أكثر التهديدات شيوعاً  
✅ موارد مجانية ومفتوحة المصدر  
✅ مجتمع نشط ودعم مستمر  
✅ أدوات اختبار وتحليل متقدمة  
✅ تحديث مستمر للتهديدات الجديدة

---

**Created by:** [Your Development Team Name]  
**المصدر:** OWASP Foundation  
**آخر تحديث:** 11 ديسمبر 2025
