// lib/core/constants/agents_prompt.dart
// Prompt standar AI untuk proyek SPACE EDUOS
// Versi: v2026.08.10 — MASTER STANDARD
//
// SPACE EDUOS
// Integrated Education Operating System
//
// File ini menjadi aturan utama AI dan developer dalam
// membuat, mengedit, menganalisis, dan melakukan refactor kode.

const String kAgentsPrompt = r'''
AGENTS.md — Panduan AI & Standar Koding SPACE EDUOS
Version: v2026.08.10 MASTER STANDARD

======================================================================
STATUS DOKUMEN
======================================================================

Dokumen ini adalah ATURAN UTAMA (STRICT RULES) untuk seluruh
pengembangan aplikasi SPACE EDUOS.

WAJIB dipatuhi oleh:

- GPT
- Gemini
- Claude
- AI coding agent lainnya
- Developer
- Kontributor proyek

Setiap perubahan kode HARUS mengikuti arsitektur, business rule,
security rule, UI rule, naming convention, dan database convention
yang ditetapkan dalam dokumen ini.

Kegagalan mengikuti aturan ini dianggap sebagai KEGAGALAN TUGAS.

======================================================================
1. IDENTITAS PROYEK
   ======================================================================

Nama Produk       : SPACE EDUOS
Nama Singkat      : SPACE
Kategori          : Education Operating System
Konsep            : Integrated Education Operating System

SPACE EDUOS BUKAN sekadar aplikasi LMS.

SPACE EDUOS adalah platform pendidikan terintegrasi yang menyatukan:

- Academic Management
- Student Management
- Teacher & Staff Management
- Class Management
- Curriculum Management
- LMS
- Learning Content
- Assignment
- Quiz & Question Bank
- Assessment
- Attendance
- Student Progress
- Report / Rapor
- Certificate
- Finance
- Tuition / SPP
- Payroll
- Communication
- Chat
- Forum
- Notification
- Dashboard
- AI Assistant
- Organization Management
- Multi-Tenant Management

----------------------------------------------------------------------
TECH STACK
----------------------------------------------------------------------

Frontend        : Flutter
Language        : Dart
State Management: Riverpod
Code Generation : riverpod_annotation + build_runner
Backend         : Supabase
Database        : PostgreSQL
Storage         : Supabase Storage
Realtime        : Supabase Realtime
Authentication  : Supabase Auth
Architecture    : Feature-First / Modular Architecture

Target Platform:

- Android
- iOS
- Web
- PWA bila diperlukan

======================================================================
2. PRINSIP PRODUK SPACE EDUOS
   ======================================================================

SPACE EDUOS harus dibangun sebagai platform pendidikan yang:

1. Modular
2. Multi-tenant
3. Secure by default
4. Scalable
5. Maintainable
6. Consistent
7. Predictable
8. Offline-aware
9. Role-based
10. Organization-aware

Jangan membangun fitur sebagai aplikasi terpisah.

Semua fitur harus menjadi bagian dari satu ekosistem SPACE EDUOS.

======================================================================
3. PRINSIP ARSITEKTUR UTAMA
   ======================================================================

Gunakan:

FEATURE-FIRST + MODULAR ARCHITECTURE

Struktur utama:

lib/
├── core/
├── shared/
├── features/
└── app/

----------------------------------------------------------------------
3.1 lib/core/
----------------------------------------------------------------------

Berisi pondasi global aplikasi.

Contoh:

core/
├── constants/
├── errors/
├── extensions/
├── network/
├── routing/
├── security/
├── services/
├── theme/
├── utils/
└── providers/

Contoh:

core/services/base_service.dart
core/providers/app_context_provider.dart
core/theme/app_theme.dart
core/theme/app_colors.dart
core/routing/app_router.dart

DILARANG memasukkan business logic feature-specific ke dalam core.

----------------------------------------------------------------------
3.2 lib/features/
----------------------------------------------------------------------

Setiap domain bisnis harus memiliki feature sendiri.

Contoh:

features/
├── auth/
├── dashboard/
├── organization/
├── academic/
├── students/
├── teachers/
├── classes/
├── curriculum/
├── lms/
├── attendance/
├── assessment/
├── reports/
├── finance/
├── payroll/
├── communication/
├── notifications/
└── ai/

Setiap feature dapat memiliki:

models/
services/
providers/
screens/
widgets/

Contoh:

features/students/
├── models/
├── services/
├── providers/
├── screens/
└── widgets/

----------------------------------------------------------------------
3.3 lib/shared/
----------------------------------------------------------------------

Berisi komponen yang benar-benar digunakan oleh banyak feature.

Contoh:

shared/
├── models/
├── widgets/
├── components/
├── enums/
└── helpers/

Jangan memasukkan sesuatu ke shared hanya karena terlihat reusable.

Rule:

Jika belum digunakan oleh minimal beberapa feature,
tetap simpan di feature asal.

======================================================================
4. PEMBAGIAN TANGGUNG JAWAB LAYER
   ======================================================================

======================================================================
4.1 MODEL
======================================================================

Model hanya bertanggung jawab terhadap representasi data.

BOLEH:

- field
- fromJson
- toJson
- copyWith
- equality
- parsing
- nested model

DILARANG:

- BuildContext
- query Supabase
- navigation
- SnackBar
- Dialog
- business flow UI
- dependency terhadap widget

======================================================================
4.2 SERVICE
======================================================================

Service bertanggung jawab terhadap:

- komunikasi dengan Supabase
- CRUD
- query database
- transaksi bisnis yang bersifat data-level
- validasi business rule yang berkaitan langsung dengan data

BOLEH:

- Supabase query
- insert
- update
- delete
- select
- RPC
- filtering
- pagination
- mapping data

DILARANG:

- BuildContext
- Navigator
- GoRouter
- SnackBar
- Dialog
- TextEditingController
- Widget
- UI state

Semua database service WAJIB:

extends BaseService

======================================================================
4.3 PROVIDER
======================================================================

Provider bertanggung jawab terhadap:

- state
- loading
- error
- data
- dependency antar service
- reactive state
- app context

Gunakan Riverpod.

Preferensi:

@riverpod

Gunakan code generation.

Provider TIDAK boleh mengandung UI.

======================================================================
4.4 SCREEN
======================================================================

Screen bertanggung jawab terhadap:

- layout
- composition
- navigation
- user interaction
- presentation state

Screen DILARANG melakukan query Supabase langsung.

======================================================================
4.5 WIDGET
======================================================================

Widget digunakan untuk:

- komponen visual
- reusable UI
- input
- card
- table
- dialog presentation
- section
- form component

Widget DILARANG mengambil alih business logic utama.

======================================================================
5. MULTI-TENANT ARCHITECTURE
   ======================================================================

SPACE EDUOS adalah aplikasi MULTI-TENANT.

Data tenant TIDAK boleh tercampur.

Semua query yang berhubungan dengan tenant HARUS memperhatikan
organization context.

Konsep organisasi dapat berkembang menjadi:

Platform
└── Organization / Lembaga
├── Unit / Cabang
├── Academic Structure
├── Users
├── Students
├── Teachers
├── Classes
├── Curriculum
├── LMS
├── Finance
└── Reports

Jangan mengasumsikan bahwa semua lembaga hanya mempunyai satu unit.

======================================================================
6. APP CONTEXT
   ======================================================================

Context global harus menjadi sumber kebenaran untuk:

- organization aktif
- unit/cabang aktif
- academic year aktif
- semester aktif
- user aktif
- role aktif

Gunakan:

appContextProvider

UI TIDAK boleh mengirim tenant/organization ID secara manual
jika context tersebut sudah tersedia melalui provider.

BENAR:

ref.watch(appContextProvider)

SALAH:

service.getStudents(organizationId: hardcodedId)

======================================================================
7. BASE SERVICE — SECURITY FIRST
   ======================================================================

Semua service database WAJIB menggunakan BaseService.

Tujuannya:

- mencegah data leak
- konsistensi query
- safe parsing
- tenant isolation
- standard error handling
- standard data cleaning

BaseService minimal menyediakan konsep:

- applyTenantFilter()
- applyOrganizationFilter()
- cleanData()
- toSafeId()
- toSafeDate()
- handleDatabaseError()
- requireActiveOrganization()

JANGAN membuat query database langsung dari UI.

JANGAN bypass BaseService tanpa alasan arsitektural yang jelas.

======================================================================
8. ROW LEVEL SECURITY
   ======================================================================

Security database TIDAK boleh hanya mengandalkan Flutter.

Supabase PostgreSQL RLS adalah lapisan keamanan utama.

Setiap tabel tenant-aware harus memiliki policy RLS
yang memastikan user hanya dapat mengakses data yang memang
menjadi haknya.

PRINSIP:

Flutter filter
+
Service filter
+
Supabase RLS

Ketiga lapisan harus konsisten.

JANGAN menganggap:

.eq('organization_id', currentOrganizationId)

sebagai pengganti RLS.

======================================================================
9. ROLE & ACCESS CONTROL
   ======================================================================

SPACE EDUOS menggunakan Role-Based Access Control.

Role harus berasal dari sistem identity/authorization,
bukan dibuat ulang secara acak pada masing-masing feature.

Contoh role:

- super_admin
- organization_admin
- academic_admin
- teacher
- staff
- student
- parent
- finance
- hr

Role tambahan boleh dibuat jika kebutuhan bisnis mengharuskan.

JANGAN membuat model user terpisah untuk setiap role.

Gunakan satu identity/profile system.

Contoh:

Profile
├── id
├── user_id
├── organization_id
├── role
└── profile data

Jika diperlukan, role-specific data boleh berada pada tabel
khusus, tetapi identity utama tetap konsisten.

======================================================================
10. MODEL ARCHITECTURE
    ======================================================================

Gunakan dua kategori:

SHARED MODEL
FEATURE MODEL

----------------------------------------------------------------------
10.1 Shared Models
----------------------------------------------------------------------

Untuk entitas lintas feature.

Contoh:

ProfileModel
OrganizationModel
UnitModel
RoleModel

Lokasi:

lib/shared/models/

----------------------------------------------------------------------
10.2 Feature Models
----------------------------------------------------------------------

Untuk domain tertentu.

Contoh:

StudentModel
TeacherModel
ClassModel
CurriculumModel
AssignmentModel
QuizModel
AssessmentModel
AttendanceModel
InvoiceModel
PayrollModel

Lokasi:

lib/features/[feature]/models/

======================================================================
11. NESTED MODEL RULE
    ======================================================================

Nested model yang secara kuat merupakan bagian dari domain yang sama
boleh ditempatkan dalam file model yang sama.

Contoh:

curriculum_model.dart

dapat berisi:

- Curriculum
- CurriculumLevel
- CurriculumModule
- CurriculumLesson

Tujuan:

- namespace lebih bersih
- dependency lebih sederhana
- maintenance lebih mudah

Namun jika model sudah digunakan lintas feature,
pindahkan menjadi shared model.

======================================================================
12. STANDARD MODEL
    ======================================================================

Setiap model WAJIB mempunyai:

1. fromJson()
2. toJson()
3. copyWith()

Parsing harus aman.

BENAR:

id: json['id']?.toString()

BENAR:

amount: (json['amount'] as num?)?.toDouble()

BENAR:

DateTime.tryParse(json['birth_date']?.toString() ?? '')

Database menggunakan:

snake_case

Dart menggunakan:

camelCase

Contoh:

nama_lengkap
↓
namaLengkap

======================================================================
13. COMPATIBILITY BRIDGE
    ======================================================================

Jika terjadi perubahan nama field database,
gunakan compatibility bridge jika diperlukan.

Contoh:

String get nama => namaLengkap;

Jangan melakukan rename massal hanya demi kosmetik.

Breaking change harus disengaja.

======================================================================
14. DATABASE NAMING CONVENTION
    ======================================================================

PostgreSQL:

- table       → snake_case
- column      → snake_case
- foreign key → [entity]_id
- timestamp   → created_at / updated_at
- boolean     → is_xxx / has_xxx bila sesuai

Contoh:

students
teachers
classes
academic_years
semesters
enrollments
attendance_records

DART:

StudentModel
TeacherModel
ClassModel

studentId
teacherId
classId

======================================================================
15. BUSINESS DOMAIN SPACE EDUOS
    ======================================================================

SPACE EDUOS minimal memiliki domain berikut:

----------------------------------------------------------------------
15.1 ORGANIZATION
----------------------------------------------------------------------

Mengatur:

- organization
- unit/cabang
- user membership
- role
- permissions
- organization settings

----------------------------------------------------------------------
15.2 ACADEMIC
----------------------------------------------------------------------

Mengatur:

- academic year
- semester
- program
- department
- grade/level
- class
- student enrollment
- teacher assignment
- curriculum

----------------------------------------------------------------------
15.3 STUDENT
----------------------------------------------------------------------

Mengatur:

- biodata
- guardian
- enrollment
- class membership
- academic history
- status siswa

----------------------------------------------------------------------
15.4 TEACHER / STAFF
----------------------------------------------------------------------

Mengatur:

- profile
- employment
- assignment
- teaching load
- attendance
- payroll relationship

----------------------------------------------------------------------
15.5 CURRICULUM
----------------------------------------------------------------------

Mengatur:

- curriculum
- subject
- competency
- module
- lesson
- learning objective

======================================================================
16. LMS DOMAIN
    ======================================================================

LMS bukan feature yang berdiri sendiri tanpa academic context.

Relasi konseptual:

Academic
↓
Class
↓
Subject
↓
Course
↓
Learning Content
├── Material
├── Assignment
├── Quiz
├── Discussion
└── Activity

Assignment dapat memiliki:

- title
- description
- deadline
- attachment
- submission
- score
- feedback
- status

Quiz dapat memiliki:

- question bank
- questions
- options
- correct answer
- attempt
- score
- result

======================================================================
17. ASSESSMENT
    ======================================================================

Assessment harus dapat mendukung berbagai bentuk penilaian.

Contoh:

- score
- grade
- rubric
- competency
- attendance
- assignment
- quiz
- project
- practical assessment

Jangan hardcode satu metode penilaian untuk seluruh lembaga.

Assessment harus configurable berdasarkan academic context.

======================================================================
18. ATTENDANCE
    ======================================================================

Attendance harus mendukung:

- manual attendance
- QR attendance
- optional GPS validation
- check-in
- check-out
- attendance status
- attendance correction
- attendance report

Status dapat berupa:

- present
- absent
- late
- excused
- sick
- leave

Jangan menggunakan string bebas jika enum/domain value sudah ditentukan.

======================================================================
19. REPORT / RAPOR
    ======================================================================

Rapor adalah hasil agregasi beberapa domain.

Contoh:

Academic
+
Assessment
+
LMS
+
Attendance
+
Other configured metrics
↓
Report / Rapor

Jangan menyimpan nilai yang seharusnya dapat dihitung ulang
sebagai satu-satunya source of truth.

Jika diperlukan snapshot rapor,
jelaskan bahwa snapshot tersebut adalah hasil finalisasi.

======================================================================
20. FINANCE
    ======================================================================

Finance harus dipisahkan secara modular dari academic.

Dapat mencakup:

- billing
- tuition
- invoice
- payment
- expense
- income
- financial report

Contoh:

Student
↓
Billing
↓
Invoice
↓
Payment
↓
Payment Status

Jangan menyimpan status pembayaran tanpa relasi transaksi
yang dapat diaudit.

======================================================================
21. PAYROLL
    ======================================================================

Payroll harus mendukung:

- employee
- salary component
- attendance relation
- deduction
- allowance
- payroll period
- payroll calculation
- payroll finalization

Payroll calculation harus berada di service/domain logic,
BUKAN di widget.

======================================================================
22. COMMUNICATION
    ======================================================================

Communication dapat mencakup:

- notification
- direct message
- group chat
- class discussion
- forum
- announcement

Realtime menggunakan Supabase Realtime jika sesuai.

UI tidak boleh mengakses channel realtime secara liar.

Realtime subscription harus memiliki lifecycle yang jelas.

======================================================================
23. FILE & STORAGE
    ======================================================================

File upload menggunakan Supabase Storage.

WAJIB:

- validasi ukuran
- validasi MIME/type
- path terstruktur
- tenant isolation
- access policy

Contoh struktur konseptual:

organization/
unit/
feature/
entity/
file

Jangan menggunakan path global yang menyebabkan file tenant
berpotensi tercampur.

======================================================================
24. OFFLINE-FIRST / OFFLINE-AWARE
    ======================================================================

SPACE EDUOS harus dapat dikembangkan untuk kondisi koneksi
yang tidak selalu stabil.

Feature yang membutuhkan offline support harus mempunyai strategi:

- local cache
- pending action
- sync
- conflict handling

Jangan menganggap semua fitur harus offline.

Tentukan offline requirement berdasarkan domain.

======================================================================
25. AI INTEGRATION
    ======================================================================

AI adalah fitur pendukung SPACE EDUOS,
bukan sumber kebenaran utama database.

AI dapat membantu:

- student insight
- teacher assistant
- lesson generation
- content generation
- question generation
- report summary
- academic analytics
- administrative assistant

AI DILARANG:

- mengubah data penting tanpa authorization
- mengambil data lintas tenant
- melewati RLS
- dianggap sebagai source of truth
- melakukan destructive action tanpa explicit authorization

Semua AI action harus melalui service/application layer.

======================================================================
26. STATE MANAGEMENT
    ======================================================================

Gunakan Riverpod.

Prioritas:

- @riverpod
- code generation
- immutable state
- AsyncValue
- dependency injection melalui provider

Jangan membuat global singleton state secara sembarangan.

Jangan menggunakan Provider lama jika feature sudah menggunakan
Riverpod.

======================================================================
27. PROVIDER NAMING
    ======================================================================

Gunakan nama singular untuk entity.

BENAR:

studentProvider
teacherProvider
classProvider

SALAH:

studentsProvider
teachersProvider
classesProvider

Untuk collection, gunakan nama yang tetap jelas berdasarkan
fungsi provider.

Contoh:

studentsProvider
boleh digunakan jika memang provider tersebut secara eksplisit
merepresentasikan collection.

Namun class/type tetap singular.

======================================================================
28. NAVIGATION
    ======================================================================

Gunakan centralized routing.

Contoh:

context.go()
context.push()
context.goNamed()
context.pushNamed()

Route HARUS didefinisikan di:

app_router.dart / app_routes.dart

JANGAN membuat route string acak di berbagai widget.

======================================================================
29. ASYNC SAFETY
    ======================================================================

Setelah await dan sebelum menggunakan BuildContext:

WAJIB memeriksa:

if (!context.mounted) return;

Jangan menggunakan BuildContext setelah asynchronous operation
tanpa memastikan context masih mounted.

======================================================================
30. DESIGN SYSTEM — SINGLE SOURCE OF TRUTH
    ======================================================================

INI ADALAH ATURAN WARNA UTAMA SPACE EDUOS.

DILARANG setiap feature menentukan warna sendiri.

DILARANG:

Colors.blue
Colors.green
Colors.red
Color(0xFF...)
di dalam feature UI,

kecuali warna tersebut merupakan bagian resmi dari Design System.

Semua warna harus berasal dari:

AppColors
AppTheme
Theme.of(context).colorScheme

======================================================================
31. SPACE EDUOS COLOR SYSTEM
    ======================================================================

Gunakan satu identitas visual utama.

PRIMARY:

SPACE Blue
#2563EB

PRIMARY DARK:

#1D4ED8

PRIMARY LIGHT:

#DBEAFE

SECONDARY:

Space Indigo
#4F46E5

SECONDARY LIGHT:

#E0E7FF

SUCCESS:

#16A34A

WARNING:

#D97706

ERROR:

#DC2626

INFO:

#0284C7

NEUTRAL / SLATE:

#0F172A
#334155
#64748B
#94A3B8
#E2E8F0
#F1F5F9
#F8FAFC

WHITE:

#FFFFFF

BLACK:

#000000

======================================================================
32. COLOR SEMANTIC RULE
    ======================================================================

Warna tidak ditentukan berdasarkan feature.

SALAH:

Academic = Blue
Finance = Green
Student = Orange
Teacher = Purple

Jangan membuat setiap modul mempunyai warna sendiri.

BENAR:

Primary
Secondary
Success
Warning
Error
Info
Surface
Background
Border
Text

Feature menggunakan semantic color.

Contoh:

AppColors.primary
AppColors.success
AppColors.warning
AppColors.error

Bukan:

AppColors.studentBlue
AppColors.financeGreen
AppColors.teacherPurple

Tujuan:

Seluruh SPACE EDUOS harus terlihat sebagai SATU PRODUK.

======================================================================
33. MATERIAL THEME
    ======================================================================

Gunakan Material 3.

Theme menjadi sumber utama:

- colorScheme
- typography
- component theme
- input theme
- button theme
- card theme
- dialog theme
- navigation theme

Prefer:

Theme.of(context).colorScheme.primary

daripada hardcoded color.

======================================================================
34. DARK MODE
    ======================================================================

SPACE EDUOS harus dirancang agar siap dark mode.

Jangan mengasumsikan:

Colors.white
atau
Colors.black

sebagai background permanen.

Gunakan semantic theme:

colorScheme.surface
colorScheme.onSurface
colorScheme.background
atau token theme yang sesuai dengan versi Flutter yang digunakan.

======================================================================
35. OPACITY / DEPRECATED API
    ======================================================================

DILARANG menggunakan API deprecated jika sudah tersedia
pengganti resmi.

Contoh:

DILARANG:

color.withOpacity(0.5)

GUNAKAN:

color.withValues(alpha: 0.5)

======================================================================
36. UI CONSISTENCY
    ======================================================================

Semua feature harus mengikuti:

- spacing system
- typography system
- border radius system
- elevation system
- color system
- button style
- input style
- card style
- dialog style

Jangan membuat desain baru hanya untuk satu screen
tanpa alasan desain yang kuat.

======================================================================
37. RESPONSIVE DESIGN
    ======================================================================

SPACE EDUOS berjalan pada:

- mobile
- tablet
- desktop
- web

UI tidak boleh bergantung pada satu ukuran layar.

Gunakan:

- LayoutBuilder
- MediaQuery
- adaptive widgets
- responsive breakpoints

Jangan hardcode ukuran yang menyebabkan UI rusak
pada device berbeda.

======================================================================
38. TABLE / DATA-DENSE UI
    ======================================================================

Untuk dashboard dan administrative screen,
gunakan pola yang sesuai untuk data padat.

Contoh:

- DataTable
- PaginatedDataTable
- responsive table
- list/card pada mobile

Desktop dan mobile tidak harus menggunakan layout identik.

======================================================================
39. FORM STANDARD
    ======================================================================

Form harus:

- memiliki validation
- memiliki loading state
- memiliki error state
- mencegah double submit
- memberikan feedback
- menjaga nilai input jika terjadi error

Jangan melakukan submit berkali-kali akibat double tap.

======================================================================
40. ERROR HANDLING
    ======================================================================

Error harus ditangani secara eksplisit.

Kategori:

- validation error
- authentication error
- authorization error
- network error
- database error
- storage error
- unexpected error

Jangan menampilkan raw database error kepada user jika
mengandung informasi internal.

Gunakan user-friendly message.

Detail teknis masuk ke logging/debug layer.

======================================================================
41. ERROR PRIORITY
    ======================================================================

Jika memperbaiki warning/error:

Prioritas:

1. compile error
2. uri_does_not_exist
3. type error
4. generated code error
5. unused import
6. analyzer warning
7. lint
8. style improvement

Jangan melakukan refactor besar hanya untuk memperbaiki
warning kecil tanpa diminta.

======================================================================
42. SAFE DATABASE RELATION PARSING
    ======================================================================

Relasi Supabase harus selalu null-safe.

Contoh:

json['teacher'] != null
    ? ProfileModel.fromJson(json['teacher'])
    : null

Jangan mengasumsikan nested relation selalu tersedia.

======================================================================
43. PAGINATION
    ======================================================================

List besar HARUS mempertimbangkan pagination.

DILARANG mengambil seluruh tabel tanpa alasan.

Gunakan:

- range
- cursor pagination
- pagination strategy

sesuai kebutuhan feature.

======================================================================
44. PERFORMANCE
    ======================================================================

Hindari:

- query berulang
- rebuild widget berlebihan
- loading data yang tidak diperlukan
- nested query tanpa kontrol
- fetching data besar tanpa pagination

Gunakan caching jika memang bermanfaat.

======================================================================
45. AUDITABILITY
    ======================================================================

Operasi penting harus dapat diaudit.

Contoh:

- perubahan nilai
- finalisasi rapor
- pembayaran
- payroll
- perubahan role
- perubahan organization setting
- delete data penting

Jangan melakukan perubahan kritis tanpa mempertimbangkan
audit trail.

======================================================================
46. DATA DELETION
    ======================================================================

Jangan langsung menghapus data penting jika business domain
membutuhkan histori.

Pertimbangkan:

- soft delete
- archive
- status inactive
- audit trail

Hard delete hanya jika memang diperbolehkan oleh business rule.

======================================================================
47. BUSINESS LOGIC
    ======================================================================

Business logic TIDAK boleh berada di:

- widget
- screen
- build method

Business logic harus berada di:

- service
- domain/application layer jika diperlukan
- provider untuk orchestration state

Contoh:

MENGHITUNG NILAI RAPOR

SALAH:

Widget menghitung seluruh nilai.

BENAR:

Assessment/Rapor service/domain logic menghitung nilai,
provider menyediakan hasil ke UI.

======================================================================
48. SOURCE OF TRUTH
    ======================================================================

Setiap domain harus mempunyai source of truth yang jelas.

Contoh:

Student enrollment
→ academic enrollment

Payment
→ payment transaction

Assessment
→ assessment record

Attendance
→ attendance record

Report final
→ finalized snapshot jika diperlukan

Jangan menyimpan data duplikat tanpa alasan.

======================================================================
49. TRANSACTIONAL OPERATION
    ======================================================================

Operasi yang mengubah beberapa tabel sekaligus dan harus atomic
sebaiknya menggunakan PostgreSQL function/RPC atau transaction
strategy yang tepat.

Contoh:

Finalisasi pembayaran
Finalisasi payroll
Finalisasi rapor

Jangan melakukan serangkaian update kritis dari Flutter
tanpa mempertimbangkan atomicity.

======================================================================
50. FILE STRUCTURE STANDARD
    ======================================================================

Struktur feature standar:

features/
└── feature_name/
├── models/
├── services/
├── providers/
├── screens/
└── widgets/

Jika feature semakin kompleks,
boleh menggunakan sub-domain:

features/
└── academic/
├── models/
├── services/
├── providers/
├── screens/
└── widgets/

Jangan membuat struktur folder terlalu dalam tanpa kebutuhan.

======================================================================
51. FEATURE CREATION PROTOCOL
    ======================================================================

Saat membuat feature baru:

STEP 1
Tentukan business requirement.

STEP 2
Tentukan entity dan database relation.

STEP 3
Tentukan model.

STEP 4
Tentukan service.

STEP 5
Tentukan provider.

STEP 6
Tentukan UI.

STEP 7
Tambahkan validation.

STEP 8
Tambahkan authorization.

STEP 9
Tambahkan RLS jika diperlukan.

STEP 10
Testing.

Jangan langsung membuat UI sebelum memahami data model
dan business logic.

======================================================================
52. SAFE CODE UPDATE PROTOCOL
    ======================================================================

Saat AI diminta mengubah kode:

WAJIB:

1. Pahami file yang diberikan.
2. Identifikasi perubahan yang diminta.
3. Jangan mengubah bagian yang tidak diminta.
4. Jangan rename tanpa permintaan.
5. Jangan refactor tanpa permintaan.
6. Jangan menghapus kode tanpa alasan.
7. Jangan mengganti architecture tanpa persetujuan.
8. Jangan mengubah database contract secara diam-diam.
9. Pertahankan compatibility jika memungkinkan.

Jika user meminta FULL FILE:

WAJIB memberikan seluruh file.

DILARANG:

// ... kode lainnya

DILARANG:

// existing code

DILARANG memotong bagian kode.

======================================================================
53. CODE GENERATION
    ======================================================================

Jika project menggunakan generated code:

Jangan mengedit file generated secara manual
kecuali memang diminta secara eksplisit.

Source code harus diperbaiki terlebih dahulu,
kemudian generated code diperbarui melalui build_runner.

======================================================================
54. DEPENDENCY RULE
    ======================================================================

Jangan menambahkan package baru hanya karena
tersedia solusi yang lebih mudah.

Sebelum menambah dependency:

1. Cek apakah Flutter/Dart sudah menyediakan.
2. Cek apakah project sudah memiliki package yang sama.
3. Pertimbangkan maintenance.
4. Pertimbangkan bundle size.
5. Pertimbangkan web compatibility.
6. Pertimbangkan long-term support.

======================================================================
55. DATABASE CHANGE RULE
    ======================================================================

Perubahan database harus diperlakukan sebagai perubahan kontrak.

Jangan:

- rename column sembarangan
- delete column sembarangan
- ubah type tanpa migration
- menghapus foreign key
- mengubah RLS secara diam-diam

Gunakan migration yang jelas.

Setiap migration harus dapat ditelusuri.

======================================================================
56. SUPABASE RULE
    ======================================================================

Supabase digunakan sebagai:

- Authentication
- PostgreSQL database
- Storage
- Realtime
- RPC
- Row Level Security

Jangan membuat layer backend kedua tanpa alasan.

Jika business complexity meningkat,
backend/service layer tambahan boleh dipertimbangkan,
tetapi harus melalui keputusan arsitektural.

======================================================================
57. AUTHENTICATION
    ======================================================================

Authentication:

Supabase Auth

Authentication ≠ Authorization.

Auth menentukan:

"Siapa user?"

Authorization menentukan:

"Apa yang boleh dilakukan user?"

Keduanya harus dipisahkan secara konseptual.

======================================================================
58. AUTHORIZATION FLOW
    ======================================================================

Konsep:

User
↓
Authentication
↓
Profile / Membership
↓
Organization
↓
Role
↓
Permission
↓
Feature
↓
Action

UI hanya membantu menyembunyikan fitur.

Security sebenarnya tetap berada pada backend/database.

======================================================================
59. TESTING
    ======================================================================

Feature penting harus memiliki testing yang sesuai.

Minimal pertimbangkan:

- model parsing test
- service test
- business logic test
- provider test
- widget test
- integration test

Business logic kritis harus dapat diuji tanpa UI.

======================================================================
60. NO ASSUMPTION RULE
    ======================================================================

AI DILARANG membuat asumsi bisnis tanpa dasar.

Jika requirement tidak jelas:

- jangan mengarang business rule
- jangan membuat database relation berdasarkan tebakan
- jangan mengubah terminology
- jangan mengubah workflow

Gunakan SDD SPACE EDUOS sebagai sumber utama.

Jika SDD tidak menentukan dan keputusan tersebut
berdampak besar terhadap architecture/database/business logic,
AI harus meminta klarifikasi.

======================================================================
61. TERMINOLOGY RULE
    ======================================================================

Gunakan terminology resmi SPACE EDUOS.

Produk:

SPACE EDUOS

Jangan kembali menggunakan:

Tahfidz Core

sebagai nama aplikasi.

Tahfidz adalah salah satu DOMAIN / use case,
bukan identitas utama platform.

Jika ada feature tahfidz:

features/
└── tahfidz/

tetap menjadi bagian dari SPACE EDUOS.

======================================================================
62. EDUCATION DOMAIN GENERALIZATION
    ======================================================================

SPACE EDUOS tidak boleh dikunci hanya untuk:

- tahfidz
- pesantren
- sekolah tertentu
- satu kurikulum
- satu metode pembelajaran

Architecture harus cukup fleksibel untuk:

- sekolah
- madrasah
- pesantren
- lembaga tahfidz
- lembaga kursus
- training center
- pendidikan non-formal

Namun fleksibel TIDAK berarti membuat sistem abstrak
secara berlebihan.

Implementasikan kebutuhan nyata terlebih dahulu.

======================================================================
63. TAHFIDZ AS A DOMAIN
    ======================================================================

Jika fitur tahfidz dipertahankan,
tempatkan sebagai domain khusus:

Tahfidz

yang dapat terintegrasi dengan:

- Student
- Class
- Teacher
- Curriculum
- Assessment
- Attendance
- Report

Contoh:

Student
↓
Class
↓
Tahfidz Program
↓
Hafalan / Mutabaah
↓
Assessment
↓
Report

Business logic tahfidz tidak boleh mengotori
Academic Core secara global.

======================================================================
64. DASHBOARD
    ======================================================================

Dashboard adalah layer agregasi.

Dashboard TIDAK menjadi source of truth.

Dashboard mengambil data dari domain:

- Academic
- Student
- Attendance
- Assessment
- Finance
- LMS
- HR

Jangan menyimpan ulang semua data hanya untuk dashboard
jika dapat dihitung melalui query/view/materialized view
yang sesuai.

======================================================================
65. NOTIFICATION
    ======================================================================

Notification harus mendukung konsep:

- recipient
- type
- title
- message
- reference
- read/unread
- created_at

Notification tidak boleh menjadi satu-satunya tempat
menyimpan data transaksi sebenarnya.

Contoh:

Notification pembayaran
≠
Payment transaction

======================================================================
66. OBSERVABILITY
    ======================================================================

Error penting harus dapat ditelusuri.

Minimal:

- debug log
- error context
- feature context
- user context bila aman
- organization context bila aman

Jangan memasukkan password, token, secret,
atau data sensitif ke log.

======================================================================
67. SECRET MANAGEMENT
    ======================================================================

DILARANG hardcode:

- password
- service role key
- private API key
- secret token
- credential

Flutter client hanya boleh menggunakan credential
yang memang aman untuk client.

Supabase service_role key TIDAK BOLEH masuk aplikasi Flutter.

======================================================================
68. ENVIRONMENT
    ======================================================================

Pisahkan environment bila diperlukan:

development
staging
production

Jangan mencampur database production dengan development.

======================================================================
69. PRODUCTION SAFETY
    ======================================================================

Sebelum perubahan production:

- migration reviewed
- RLS reviewed
- authorization reviewed
- destructive operation reviewed
- backup strategy dipertimbangkan
- regression test dilakukan

======================================================================
70. DESIGN PHILOSOPHY
    ======================================================================

SPACE EDUOS harus terasa:

- modern
- clean
- professional
- educational
- trustworthy
- calm
- consistent

Bukan:

- terlalu ramai
- terlalu banyak warna
- setiap modul berbeda tema
- terlalu banyak gradient
- terlalu banyak decoration

Gunakan whitespace dan hierarchy.

======================================================================
71. UI COLOR GOLDEN RULE
    ======================================================================

Jika developer tidak tahu warna apa yang digunakan:

JANGAN MEMBUAT WARNA BARU.

Gunakan:

Theme.of(context).colorScheme

atau:

AppColors

Jika warna baru benar-benar diperlukan,
tambahkan terlebih dahulu ke Design System.

Jangan hardcode di feature.

======================================================================
72. ICON RULE
    ======================================================================

Gunakan icon yang konsisten.

Jangan menggunakan emoji sebagai icon UI utama.

Emoji boleh digunakan hanya jika merupakan bagian
dari konten/user-generated content.

======================================================================
73. EMPTY STATE
    ======================================================================

Setiap list/data screen harus mempertimbangkan:

- loading
- empty
- error
- success
- permission denied

Jangan hanya membuat happy path.

======================================================================
74. LOADING STATE
    ======================================================================

Loading harus jelas.

Untuk operasi kecil:

- progress indicator

Untuk data screen:

- skeleton/loading state jika sesuai

Jangan menampilkan blank screen tanpa informasi.

======================================================================
75. USER FEEDBACK
    ======================================================================

Setelah operasi penting:

Create
Update
Delete
Submit
Approve
Reject
Finalize

user harus mendapatkan feedback yang jelas.

======================================================================
76. CONFIRMATION RULE
    ======================================================================

Operasi destructive harus memiliki confirmation.

Contoh:

- delete
- finalize
- reject
- cancel transaction
- remove member

Jangan menggunakan confirmation untuk setiap tindakan kecil
karena akan mengganggu UX.

======================================================================
77. ACCESSIBILITY
    ======================================================================

UI harus mempertimbangkan:

- readable text
- contrast
- touch target
- semantic labels
- keyboard navigation pada web/desktop bila relevan

======================================================================
78. PERFORMANCE GOLDEN RULE
    ======================================================================

Jangan melakukan optimasi prematur.

Namun jangan membuat:

- N+1 query
- infinite unbounded query
- rebuild seluruh aplikasi
- massive list tanpa pagination
- image/file loading tanpa batas

======================================================================
79. DOCUMENTATION RULE
    ======================================================================

Business logic penting harus memiliki komentar atau dokumentasi
yang menjelaskan:

- WHY

bukan sekadar:

- WHAT

Contoh buruk:

// get students

Contoh baik:

// Hanya mengambil siswa aktif pada enrollment semester berjalan
// agar histori semester sebelumnya tidak ikut tercampur.

======================================================================
80. AI CODING AGENT WORKFLOW
    ======================================================================

Sebelum mengubah kode:

STEP 1
Baca AGENTS.md.

STEP 2
Baca SDD SPACE EDUOS yang relevan.

STEP 3
Baca file yang diminta.

STEP 4
Identifikasi dependency.

STEP 5
Identifikasi database contract.

STEP 6
Identifikasi security implication.

STEP 7
Implementasi perubahan minimum.

STEP 8
Periksa compile/analyzer issue.

STEP 9
Periksa consistency.

STEP 10
Laporkan perubahan.

======================================================================
81. AI OUTPUT RULE
    ======================================================================

Jika diminta membuat kode:

Berikan kode yang siap digunakan.

Jika diminta FULL FILE:

Berikan seluruh file.

Jika diminta patch:

Berikan bagian yang berubah dengan jelas.

Jika perubahan memiliki dampak terhadap:

- database
- RLS
- API
- routing
- model
- provider
- business logic

jelaskan dampaknya.

======================================================================
82. REFACTOR RULE
    ======================================================================

Refactor besar harus dipisahkan dari feature implementation.

Jangan melakukan:

feature implementation
+
architecture migration
+
mass rename
+
database migration

dalam satu perubahan kecil tanpa alasan.

Tujuannya:

- mudah review
- mudah rollback
- mudah debugging

======================================================================
83. BREAKING CHANGE RULE
    ======================================================================

Breaking change harus eksplisit.

Contoh:

- rename database column
- rename model
- change provider API
- change route
- change business rule
- change authentication flow

AI harus memberi tahu jika perubahan berpotensi breaking.

======================================================================
84. SOURCE OF TRUTH HIERARCHY
    ======================================================================

Jika terdapat konflik informasi:

PRIORITAS:

1. Database schema / migration aktual
2. SDD SPACE EDUOS terbaru
3. Business rules yang telah disepakati
4. AGENTS.md
5. Existing implementation
6. AI assumption

AI TIDAK BOLEH menganggap existing code selalu benar
jika bertentangan dengan SDD atau database contract.

======================================================================
85. FINAL QUALITY CHECK
    ======================================================================

Sebelum menyatakan tugas selesai, periksa:

[ ] Architecture sesuai
[ ] Feature placement sesuai
[ ] Model aman
[ ] Service tidak mengandung UI
[ ] Provider menggunakan Riverpod
[ ] UI tidak query Supabase langsung
[ ] Tenant isolation aman
[ ] RLS tidak dilupakan
[ ] Authorization diperiksa
[ ] Loading state tersedia
[ ] Empty state tersedia
[ ] Error state tersedia
[ ] Async safety aman
[ ] Warna menggunakan Design System
[ ] Tidak ada hardcoded feature color
[ ] Tidak ada deprecated API
[ ] Naming konsisten
[ ] Tidak ada unnecessary dependency
[ ] Tidak ada breaking change tersembunyi
[ ] Tidak ada secret
[ ] Tidak ada data leak

======================================================================
86. ABSOLUTE RULES
    ======================================================================

AI DILARANG:

1. Mengabaikan multi-tenancy.
2. Membypass RLS.
3. Menaruh Supabase query di UI.
4. Menaruh business logic kompleks di widget.
5. Membuat warna feature-specific secara sembarangan.
6. Hardcode tenant/organization ID.
7. Hardcode credential/secret.
8. Mengubah database contract tanpa migration.
9. Melakukan refactor besar tanpa diminta.
10. Mengarang business rule.
11. Menganggap Tahfidz Core sebagai nama produk.
12. Membuat feature yang tidak mengikuti architecture.
13. Menghapus data penting tanpa business rule.
14. Membuat role baru tanpa alasan.
15. Membuat duplicate source of truth.

======================================================================
87. IDENTITAS FINAL
    ======================================================================

Nama aplikasi:

SPACE EDUOS

Posisi produk:

Integrated Education Operating System

Konsep utama:

                    SPACE EDUOS
                         │
        ┌────────────────┼────────────────┐
        │                │                │
     ACADEMIC           LMS            ADMIN
        │                │                │
┌────┼────┐      ┌────┼────┐      ┌────┼────┐
│    │    │      │    │    │      │    │    │
Student Class Curriculum Content Quiz Finance HR
│    │                     │        │    │
│    │                 Assignment   │ Payroll
│    │                     │        │
└────┴──────────────┬──────┴────────┘
│
ASSESSMENT
│
RAPOR
│
DASHBOARD
│
AI

Semua domain tersebut harus menjadi bagian dari
SATU platform SPACE EDUOS.

======================================================================
88. PESAN FINAL UNTUK AI
    ======================================================================

Jika Anda membaca file ini:

Anda sedang mengembangkan SPACE EDUOS.

Jangan berpikir seperti sedang membuat aplikasi kecil.

Berpikir sebagai:

EDUCATION OPERATING SYSTEM.

Namun:

JANGAN over-engineering.

Bangun berdasarkan kebutuhan nyata,
ikuti SDD,
ikuti database,
ikuti business rule,
ikuti security,
dan pertahankan konsistensi.

PRIORITAS UTAMA:

1. SECURITY
2. DATA INTEGRITY
3. BUSINESS LOGIC
4. ARCHITECTURE
5. CONSISTENCY
6. MAINTAINABILITY
7. PERFORMANCE
8. UX

Jika ragu:

JANGAN MENGARANG.

Periksa SDD.

Jika tetap tidak ditentukan dan keputusan tersebut berdampak
besar terhadap database, architecture, security, atau business logic:

TANYAKAN TERLEBIH DAHULU.

======================================================================
END OF AGENTS.md
======================================================================
''';