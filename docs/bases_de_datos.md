# Bases de datos — Libro Digital

Fecha: 2026-06-07

## Estrategia

Cada microservicio posee su propia base PostgreSQL (**Database per Service**). No hay foreign keys entre bases distintas; las relaciones se resuelven por **ID lógico** o vía API REST.

## Inventario

| Base de datos | Servicio | Estado |
|---|---|---|
| `librodigital_auth` | authService | ✅ Existente |
| `librodigital_academic` | academicService | ✅ Existente |
| `librodigital_attendance` | attendanceService | ✅ Creada |

## Tablas por servicio

### librodigital_auth

- `users` — credenciales y perfil de acceso
- `role` — roles del sistema
- `user_roles` — relación N:M usuario ↔ rol

### librodigital_academic

**Catálogos** (reemplazan VARCHAR categóricos):
- `student_statuses`, `teacher_statuses`, `course_statuses`, `enrollment_statuses`
- `evaluation_types`, `evaluation_statuses`, `grade_statuses`
- `relationship_types`, `contract_types`, `subject_types`, `shifts`
- `education_levels`, `academic_years`

**Entidades principales** (con claves foráneas):
- `guardians`, `teachers`, `students`
- `courses`, `subjects`, `enrollments`
- `evaluations`, `grades`

### librodigital_attendance

- `class_sessions` — sesiones de clase
- `attendance_records` — asistencia por estudiante/sesión
- `annotations` — anotaciones de conducta

## Scripts SQL

Ubicación: `infraestructura/ddl/`

| Archivo | Uso |
|---|---|
| `00_create_databases.sql` | Crear las 3 bases |
| `auth_schema.sql` | Esquema auth (final) |
| `academic_schema.sql` | Esquema académico normalizado 3FN + catálogos + demo |
| `attendance_schema.sql` | Esquema asistencia normalizado 3FN + catálogos + demo |
> Instalación nueva: ejecutar solo los `*_schema.sql`. Las migraciones en `migrations/` son para actualizar BDs antiguas.

| `migrations/001_cleanup_academic.sql` | Limpieza columnas legadas (BD existente) |
| `migrations/002_normalizacion_academic.sql` | Catálogos, FK y 3FN en `librodigital_academic` |
| `migrations/002_normalizacion_attendance.sql` | Catálogos y FK en `librodigital_attendance` |
| `migrations/003_shifts_completa.sql` | Renombra jornada VESPERTINO → COMPLETA |
| `migrations/004_teachers_auth_link.sql` | Vínculo `teachers.auth_username` / `user_id` con authService |

> `initial_schema.sql` (monolito) está archivado en `../archive/ddl/`.

## Datos de prueba actuales (attendance)

Referencias al academicService en tu entorno:

| Entidad | ID | Descripción |
|---|---|---|
| Curso | 17 | 1° Medio |
| Asignatura | 2 | Matemáticas |
| Docente | 1 | Manuel |
| Estudiante | 2 | Juan |

## Configuración en microservicios

```properties
# authService
spring.datasource.url=jdbc:postgresql://localhost:5432/librodigital_auth

# academicService
spring.datasource.url=jdbc:postgresql://localhost:5432/librodigital_academic

# attendanceService
spring.datasource.url=jdbc:postgresql://localhost:5432/librodigital_attendance
```

`spring.jpa.hibernate.ddl-auto=update` mantiene el esquema sincronizado con las entidades JPA en desarrollo.

## Campos eliminados (migración 001)

Columnas removidas del esquema académico por ser legado o redundantes:

| Tabla | Columnas eliminadas | Motivo |
|---|---|---|
| `students` | `blood_type`, `allergies`, `medical_conditions`, `emergency_medication`, `name` | Datos médicos fuera de alcance |
| `courses` | `teacher_id`, `year` | Reemplazados por `head_teacher_id`, `academic_year` |
| `evaluations` | `grade` | Las notas van en tabla `grades` |
| `grades` | `letter_grade`, `percentage` | Calculables desde `score` |

Para aplicar en una BD existente:

```bash
psql -U postgres -d librodigital_academic -f infraestructura/ddl/migrations/001_cleanup_academic.sql
psql -U postgres -d librodigital_academic -f infraestructura/ddl/migrations/002_normalizacion_academic.sql
psql -U postgres -d librodigital_attendance -f infraestructura/ddl/migrations/002_normalizacion_attendance.sql
```

## Normalización (migración 002)

Cambios aplicados para cumplir 3FN e integridad referencial:

| Cambio | Detalle |
|---|---|
| Tablas catálogo | Estados, tipos y categorías ya no son `VARCHAR` libre |
| Claves foráneas | Relaciones validadas dentro de cada base de datos |
| Columnas eliminadas | `grades.subject_id`, `evaluations.course_id`, `courses.grade` (redundantes) |
| Año académico unificado | `academic_years` referenciado por `courses` y `enrollments` |
| Nivel educativo | `education_levels` reemplaza `courses.grade` y `courses.level` |

Los `VARCHAR` que permanecen son datos reales de texto libre: nombres, RUT, email, dirección, descripciones y comentarios.

## Vínculo docente ↔ auth (migración 004)

Se agregan `teachers.auth_username` y `teachers.user_id` para enlazar profesores con cuentas de `authService`. `TeacherAuthLinkConfig` en academicService asigna `auth_username = 'prof_castillo'` al inicio.

## Usuarios demo (RBAC)

Creados automáticamente al iniciar `authService` (`DemoUserInitializerConfig`):

| Usuario | Contraseña | Rol | Uso |
|---|---|---|---|
| `admin_colegio` | `test1234` | ADMINISTRADOR | Director / secretaría — CRUD completo |
| `prof_castillo` | `test1234` | DOCENTE | Profesor — solo su carga académica |
| `apoderado_demo` | `test1234` | APODERADO | Panel apoderado |
| `estudiante_demo` | `test1234` | ESTUDIANTE | Panel estudiante |
| `postman_test` | `test1234` | ADMINISTRADOR | Pruebas API (si existe en BD) |

Vínculo docente ↔ auth: al iniciar `academicService`, `TeacherAuthLinkConfig` asigna `auth_username = 'prof_castillo'` al profesor con email `prof.castillo@duoc.cl` (o al primero disponible).

```http
POST http://localhost:8090/auth/login
Content-Type: application/json

{
  "username": "admin_colegio",
  "password": "test1234"
}
```

Perfil autenticado:

```http
GET http://localhost:8090/auth/me
Authorization: Bearer {accessToken}
```

El registro público (`POST /auth/register`) está deshabilitado; solicitar acceso al administrador.
