<p align="center">
  <img src="assets/logo.svg" width="96" height="96" alt="Antigravity Plugins Suite Logo" />
</p>

<h1 align="center">Antigravity Plugins Suite</h1>

<p align="center">
  <strong>حزمة إضافات متكاملة لمنصة Google Antigravity</strong><br>
  6 إضافات إنتاجية رسمية &bull; 270+ أداة برمجية &bull; 61 مهارة معتمدة مجتمعياً &bull; معمارية عزل محكمة
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Antigravity%202.0%2B-blue?style=flat-square" alt="Antigravity 2.0+" />
  <img src="https://img.shields.io/badge/Plugins-6%20Active-emerald?style=flat-square" alt="6 Plugins" />
  <img src="https://img.shields.io/badge/Skills-61%20Verified-purple?style=flat-square" alt="61 Skills" />
  <img src="https://img.shields.io/badge/Community%20Installs-13M%2B-orange?style=flat-square" alt="13M+ Installs" />
  <img src="https://img.shields.io/badge/OS-Windows%20%7C%20Linux%20%7C%20macOS-lightgrey?style=flat-square" alt="Cross Platform" />
</p>

---

## 1. المعمارية العامة للحزمة (Architecture Overview)

صُممت هذه الحزمة لتوفير بيئة عمل متكاملة ذات كفاءة عالية ومحمية بالكامل لبيئة **Google Antigravity**، مع الالتزام الصارم بمبدأين أساسيين:
1. **عزل النطاق العام (Global Scope Hygiene):** جميع المهارات والتوثيقات والقواعد البرمجية محتواة بالكامل داخل مجلد الملحق الخاص بها، مع الحفاظ على نظافة مجلد المهارات العام (`~/.gemini/config/skills/`).
2. **عزل المفاتيح والمسارات (Zero Hardcoding):** لا تحتوي ملفات الإضافات على أي مفاتيح API أو مسارات ثابتة خاصة بجهاز محدد، حيث يتم حقن المفاتيح والمسارات ديناميكياً أثناء التثبيت.

### جدول الملحقات المضمنة

| الملحق | الإصدار | محرك التشغيل | عدد المهارات | عدد الأدوات | نموذج المصادقة | الغرض الأساسي |
|---|---|---|---|---|---|---|
| **Frontend Taste** | `v2.8.0` | Native Directive | 48 | — | بدون مفاتيح | هندسة الواجهات، الذوق البصري، ومنع AI Slop |
| **REA** | `v2.0.0` | Node.js / REA Core | 5 | 229 | بيئة محلية | الهندسة العكسية الشاملة وتفكيك التطبيقات |
| **Exa Search** | `v2.0.0` | NPX / Exa Server | 5 | 3 | API Key | البحث الدلالي الذكي واستخراج المحتوى |
| **Snyk Security** | `v2.0.0` | Node.js / Snyk CLI | 1 | 15 | Token | فحص الثغرات الأمنية والتبعيات والحاويات |
| **Serena** | `v2.0.0` | UVX / LSP Server | 1 | 25 | بيئة محلية | التنقل الدلالي في الكود وإعادة الهيكلة |
| **Context7** | `v2.0.0` | Node.js / Context7 | 1 | 2 | API Key / حر | جلب التوثيقات البرمجية المحدثة للمكتبات |

---

## 2. تفصيل الملحقات (Plugins Breakdown)

### 1. Frontend Taste & UI/UX Suite (`v2.8.0`)
الحزمة الأساسية لهندسة وتصميم واجهات المستخدم الاحترافية بمستوى منصات الويب الحديثة (Apple, Vercel, Linear). تضم **48 مهارة معتمدة** مجتمعياً بإجمالي يتجاوز 13 مليون تثبيت، وتغطي 8 محاور تقنية:

* **معايير الذوق البصري ومكافحة AI Slop (8 مهارات):**  
  `design-taste-frontend`, `high-end-visual-design`, `frontend-design`, `apple-design`, `emil-design-eng`, `visual-design-foundations`, `theme-factory`, `unslop`.
* **الحركة والفيزياء التفاعلية (8 مهارات):**  
  `animate`, `review-animations`, `improve-animations` (255K+), `animation-vocabulary` (268K+), `animation-performance`, `choreograph`, `gsap-core`, `ask-sonner` (166K+).
* **هندسة المتجهات والشعارات والـ SVG (7 مهارات):**  
  `svg-precision-skill`, `svg-animations`, `svg-icon-generator`, `svg-logo-designer`, `logo-design`, `thesvg`, `brandkit`.
* **معمارية React 19 وتطبيقات Vercel (3 مهارات):**  
  `vercel-react-best-practices` (878K+), `vercel-react-view-transitions` (183K+), `composition-patterns` (442K+).
* **أداء الويب ومؤشرات Core Web Vitals (2 مهارات):**  
  `core-web-vitals` (34K+), `web-design-guidelines`.
* **إمكانية الوصول الشاملة والتنقل (2 مهارات):**  
  `accessibility` (68K+), `break-ui`.
* **أنظمة المكونات والإنتاج الهندسي (11 مهارة):**  
  `frontend-ui-engineering` (76K+), `shadcn`, `tailwind-design-system`, `pick-ui-library`, `ui-ux-pro-max`, `web-artifacts-builder`, `design-mobile-apps`, `prototype`, `canvas-design`, `brand-guidelines`.
* **حوكمة الأكواد والتحقق الصارم (7 مهارات):**  
  `anti-sycophancy`, `deslop`, `verification-before-completion`, `simplify`, `grill-me`, `executing-plans`, `improve-codebase-architecture`.

### 2. REA — Reverse Engineer Anything (`v2.0.0`)
منظومة الهندسة العكسية الاحترافية. تدعم تفكيك وتحليل ملفات الـ Native الثنائية (PE, ELF, Mach-O)، تطبيقات الويب و Electron، تطبيقات Android عبر ADB و APKTool، حزم الشبكات (PCAP)، ودعم Frida و Rizin و GDB.

### 3. Exa Search (`v2.0.0`)
محرك استرجاع المعلومات الدلالي عالي الدقة. يقوم بالبحث في صفحات الويب الحقيقية واستخراج النصوص المنظفة واسترجاع أحدث التطورات التقنية وتوليد قوائم الشركات وتتبع الأخبار.

### 4. Snyk Security (`v2.0.0`)
أداة الفحص الأمني الصارم للكود المصدري والحاويات (Docker) وملفات البنية التحتية ككود (IaC) وقوائم التبعيات البرمجية (SCA/SBOM)، مع فحص تسريب المفاتيح السرية (Secret Scan).

### 5. Serena Code Agent (`v2.0.0`)
وكيل الملاحة الدلالية الذكي للأكواد. يتكامل مباشرة مع خوادم بروتوكول اللغة (LSP) لتتبع استدعاءات الدوال، استعراض شجرة الرموز (AST)، وإعادة تسمية وتعديل الدوال بدقة جراحية على مستوى المشروع.

### 6. Context7 (`v2.0.0`)
أداة استدعاء التوثيقات الرسمية المحدثة للمكتبات والأطر البرمجية (React, Next.js, Supabase, Tailwind) لمنع الاعتماد على توثيقات قديمة أو واجهات ملغاة.

---

## 3. نظام عزل المفاتيح (`keys/keys.json`)

تعتمد الحزمة على ملف مركزي مستقل لإدارة مفاتيح الـ API دون المساس بملفات الإضافات:

```json
{
  "CONTEXT7_API_KEY": "",
  "EXA_API_KEY": "",
  "SNYK_TOKEN": ""
}
```

- المفاتيح اختيارية بالكامل؛ تعمل إضافات REA و Serena و Frontend Taste محلياً بالكامل دون الحاجة لأي مفتاح خارجي.
- تُحقن المفاتيح تلقائياً في ملفات تهيئة الـ MCP (`mcp_config.json`) الخاصة بكل ملحق أثناء التثبيت، وتظل محفوظة في بيئة المستخدم المحلية فقط.

---

## 4. دليل التثبيت (Installation Guide)

### على نظام Windows (طريقتان)

#### الطريقة الأولى: التثبيت السريع بنقرة واحدة (موصى بها)
1. افتح مجلد الحزمة.
2. انقر نقراً مزدوجاً على الملف **`install.bat`**.

#### الطريقة الثانية: عبر PowerShell
افتح نافذة PowerShell داخل مجلد الحزمة ونفّذ:
```powershell
.\install.ps1
```

---

### على أنظمة Linux / macOS أو السيرفرات السحابية (VPS)

1. افتح التيرمنال داخل مجلد الحزمة.
2. امنح صلاحية التنفيذ للسكربت ثم ابدأ التثبيت:
```bash
chmod +x install.sh && ./install.sh
```

يقوم سكربت التثبيت تلقائياً بالآتي:
- التحقق من وجود الحزم الأساسية عبر `npm`.
- نسخ الإضافات بكافة مهاراتها المعزولة إلى مسار إعدادات المستخدم (`~/.gemini/config/plugins/`).
- بناء ملفات تهيئة MCP وتوزيع المسارات والمفاتيح وفق بنية نظام التشغيل.
- تهيئة ملف جلسات المصادقة `mcp_oauth_tokens.json` لضمان استقرار التشغيل.

---

## 5. فحص الحالة والتحقق (Health Verification)

بعد اكتمال التثبيت، أعد تشغيل أو تحديث واجهة **Antigravity** عبر اختصار `Ctrl + R`، ثم يمكنك التحقق عبر موجه الأوامر:

```powershell
# فحص عدد مهارات Frontend Taste المنشورة (يجب أن يكون 48)
(Get-ChildItem -Path "$HOME\.gemini\config\plugins\frontend-taste\skills" -Directory).Count

# فحص نظافة النطاق العام (يجب أن يظهر 0 مهارات حرة)
(Get-ChildItem -Path "$HOME\.gemini\config\skills" -ErrorAction SilentlyContinue).Count
```

---

## 6. هيكل مجلدات المشروع (Repository Structure)

```text
├── assets/
│   └── logo.svg                 # الشعار الرسمي للحزمة (Acrylic Optical Balance)
├── keys/
│   └── keys.json                # ملف المفاتيح المعزولة (فارغ افتراضياً)
├── logo-candidates/             # سجل الأصول والمتجهات الهندسية
├── plugins/
│   ├── context7/                # ملحق جلب التوثيقات المحدثة
│   ├── exa/                     # ملحق البحث الدلالي الذكي
│   ├── frontend-taste/          # ملحق هندسة الواجهات والذوق البصري (48 مهارة)
│   │   ├── assets/logo.svg
│   │   ├── plugin.json
│   │   ├── rules/AGENTS.md
│   │   └── skills/              # المهارات الـ 48 المعزولة بالكامل
│   ├── rea/                     # ملحق الهندسة العكسية (229 أداة)
│   ├── serena/                  # ملحق التنقل الدلالي للأكواد (LSP)
│   └── snyk/                    # ملحق الفحص والحماية الأمنية
├── install.bat                  # مشغل التثبيت السريع لنظام Windows
├── install.ps1                  # سكربت التثبيت البرمجي لـ PowerShell
├── install.sh                   # سكربت التثبيت الموحد لـ Linux و macOS
└── README.md                    # هذا التوثيق الرسمي
```

---

<p align="center">
  <sub>صُممت هذه الحزمة وفق أعلى معايير هندسة البرمجيات والنقاء الإمبيريقي لبيئة Google Antigravity.</sub>
</p>
