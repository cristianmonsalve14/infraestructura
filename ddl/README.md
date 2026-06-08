# Scripts de base de datos — Libro Digital

Arquitectura **database per service**: cada microservicio tiene su propia base PostgreSQL.

## Bases de datos

| Base de datos | Microservicio | Puerto |
|---|---|---|
| `librodigital_auth` | authService | 8091 |
| `librodigital_academic` | academicService | 8092 |
| `librodigital_attendance` | attendanceService | 8093 |

## Instalación desde cero

### 1. Crear las bases (una sola vez)

Conéctate a PostgreSQL como `postgres` y ejecuta:

```sql
-- Archivo: 00_create_databases.sql
CREATE DATABASE librodigital_auth;
CREATE DATABASE librodigital_academic;
CREATE DATABASE librodigital_attendance;
```

### 2. Ejecutar esquema por servicio

En pgAdmin o psql, conéctate a **cada base** y ejecuta su script:

| Base | Script |
|---|---|
| librodigital_auth | `auth_schema.sql` |
| librodigital_academic | `academic_schema.sql` |
| librodigital_attendance | `attendance_schema.sql` |

### 3. Alternativa con JPA (desarrollo)

Si prefieres que Hibernate cree las tablas automáticamente:

```properties
spring.jpa.hibernate.ddl-auto=update
```

Los microservicios crearán/actualizarán tablas al iniciar. Los scripts SQL sirven como documentación y para entornos controlados.

## Orden de ejecución de microservicios

1. PostgreSQL
2. authService
3. academicService
4. attendanceService
5. apiGetaway
6. frontend-react

## Usuario de prueba

Los roles se crean al iniciar `authService`. Registra un admin:

```http
POST http://localhost:8090/auth/register
Content-Type: application/json

{
  "username": "admin",
  "email": "admin@librodigital.cl",
  "password": "admin123!"
}
```

## Script legado

`initial_schema.sql` corresponde al diseño monolítico anterior (una sola BD `libro_clases`). **No usar** en la arquitectura actual de microservicios.

## Referencias cruzadas entre servicios

- `students.user_id` → `users.id` en auth (solo ID, sin FK)
- `class_sessions.course_id` → `courses.id` en academic (solo ID, sin FK)
- `attendance_records.student_id` → `students.id` en academic (solo ID, sin FK)
