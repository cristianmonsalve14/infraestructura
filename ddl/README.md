# Scripts de base de datos — Libro Digital

Arquitectura **database per service**: cada microservicio tiene su propia base PostgreSQL.

## Bases de datos

| Base de datos | Microservicio | Puerto |
|---|---|---|
| `librodigital_auth` | authService | 8091 |
| `librodigital_academic` | academicService | 8092 |
| `librodigital_attendance` | attendanceService | 8093 |

## Instalación desde cero (recomendado)

### 1. Crear las bases

```sql
-- 00_create_databases.sql
CREATE DATABASE librodigital_auth;
CREATE DATABASE librodigital_academic;
CREATE DATABASE librodigital_attendance;
```

### 2. Ejecutar esquema normalizado por servicio

| Base | Script | Estado |
|---|---|---|
| `librodigital_auth` | `auth_schema.sql` | Esquema final |
| `librodigital_academic` | `academic_schema.sql` | Esquema final (3FN + catálogos) |
| `librodigital_attendance` | `attendance_schema.sql` | Esquema final (3FN + catálogos) |

Los scripts `*_schema.sql` ya incluyen tablas catálogo, claves foráneas y datos demo.

### 3. Alternativa con JPA (desarrollo)

```properties
spring.jpa.hibernate.ddl-auto=update
```

Hibernate crea/actualiza tablas desde las entidades JPA. Los scripts SQL documentan el modelo y sirven para instalaciones controladas.

## Migraciones (solo BD existentes antiguas)

Si tu base fue creada con una versión **anterior** de los schemas (VARCHAR categóricos), aplica en orden:

### librodigital_academic

```bash
psql -U postgres -d librodigital_academic -f migrations/001_cleanup_academic.sql
psql -U postgres -d librodigital_academic -f migrations/002_normalizacion_academic.sql
psql -U postgres -d librodigital_academic -f migrations/003_shifts_completa.sql
psql -U postgres -d librodigital_academic -f migrations/004_teachers_auth_link.sql
```

### librodigital_attendance

```bash
psql -U postgres -d librodigital_attendance -f migrations/002_normalizacion_attendance.sql
```

> Instalación nueva: **no** necesitas migraciones si ejecutas los `*_schema.sql` actuales.

## Orden de arranque

1. PostgreSQL
2. authService (8091)
3. academicService (8092)
4. attendanceService (8093)
5. apiGetaway (8090)
6. frontend-react (8094)

## Usuarios demo

Creados al iniciar `authService` (`DemoUserInitializerConfig`):

| Usuario | Contraseña | Rol |
|---|---|---|
| `admin_colegio` | `test1234` | ADMINISTRADOR |
| `prof_castillo` | `test1234` | DOCENTE |
| `apoderado_demo` | `test1234` | APODERADO |
| `estudiante_demo` | `test1234` | ESTUDIANTE |

Registro público (`POST /auth/register`) deshabilitado. Nuevos usuarios vía panel admin o `POST /admin/users`.

## Diagramas ER

| Base | Archivo |
|---|---|
| Auth | `infraestructura/diagrams/auth_er_model.puml` |
| Academic | `infraestructura/diagrams/academic_er_model.puml` |
| Attendance | `infraestructura/diagrams/attendance_er_model.puml` |

## Referencias cruzadas (sin FK entre bases)

- `students.user_id`, `guardians.user_id`, `teachers.user_id` → `users.id` (authService)
- `class_sessions.course_id`, `subject_id`, `teacher_id` → academicService
- `attendance_records.student_id`, `annotations.student_id` → academicService

## Script legado

`archive/ddl/initial_schema.sql` — BD monolítica antigua. **No usar.**
