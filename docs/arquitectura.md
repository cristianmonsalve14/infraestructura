# Arquitectura — Plataforma Libro de Clases Digital

Fecha: 2026-06-20

---

## Resumen

Sistema de gestión académica basado en **microservicios** con frontend desacoplado. Cada servicio backend tiene su propia base PostgreSQL y se expone al exterior a través del **API Gateway** (`apiGetaway`, puerto 8090).

Documentación relacionada:

- `docs/puertos.md` — mapa de puertos y rutas del gateway
- `docs/bases_de_datos.md` — inventario de bases y migraciones
- `docs/patrones.md` — patrones de diseño aplicados
- `docs/branching.md` — estrategia de ramas
- `docs/guia_proyecto.md` — contexto académico del ramo Fullstack III

---

## Componentes

| Componente | Carpeta | Puerto | Responsabilidad |
|---|---|---|---|
| API Gateway | `apiGetaway/` | 8090 | Enrutamiento centralizado hacia microservicios |
| Auth | `authService/` | 8091 | Usuarios, roles, JWT |
| Academic | `academicService/` | 8092 | Estudiantes, cursos, matrículas, evaluaciones, notas |
| Attendance | `attendanceService/` | 8093 | Sesiones, asistencia, anotaciones |
| UI React | `frontend-react/` | 8094 | Interfaz web (consume solo el gateway) |
| Spring scaffold | `frontend/` | — | Módulo reservado; la UI activa es `frontend-react` |

---

## Flujo de comunicación

```
frontend-react (:8094)
        │
        ▼  VITE_API_URL → http://localhost:8090
   apiGetaway (:8090)
        │
        ├── /auth/**        → authService (:8091)
        ├── /students/**    → academicService (:8092)
        ├── /courses/**     → academicService (:8092)
        ├── /teachers/**    → academicService (:8092)
        ├── /subjects/**    → academicService (:8092)
        ├── /enrollments/** → academicService (:8092)
        ├── /evaluations/** → academicService (:8092)
        ├── /grades/**      → academicService (:8092)
        ├── /guardians/**   → academicService (:8092)
        ├── /sessions/**    → attendanceService (:8093)
        ├── /attendances/** → attendanceService (:8093)
        └── /annotations/** → attendanceService (:8093)
```

El frontend **no** llama directamente a los microservicios en desarrollo; siempre usa el gateway.

---

## Stack tecnológico

| Capa | Tecnologías |
|---|---|
| Backend | Java 21, Spring Boot 4.1.0, Spring Security, JWT, JPA, Maven |
| Gateway | Spring Cloud Gateway 2025.1.2 |
| Frontend | React, TypeScript, Vite, Tailwind CSS |
| Base de datos | PostgreSQL (una BD por microservicio) |
| Comunicación | REST HTTP/JSON |

---

## Persistencia

Estrategia **database per service**:

| Base de datos | Servicio |
|---|---|
| `librodigital_auth` | authService |
| `librodigital_academic` | academicService |
| `librodigital_attendance` | attendanceService |

No hay foreign keys entre bases distintas; las relaciones cruzadas usan IDs lógicos o APIs REST.

Scripts: `ddl/` — ver `ddl/README.md`.

---

## Seguridad (JWT)

1. El usuario inicia sesión en `POST /auth/login`.
2. `authService` valida credenciales y emite `accessToken` (+ `refreshToken`).
3. El frontend guarda el token y lo envía en cada petición:

```
Authorization: Bearer {accessToken}
```

4. Cada microservicio valida el JWT en sus rutas protegidas.
5. El registro público (`POST /auth/register`) está **deshabilitado**; el administrador crea usuarios desde la app o vía `POST /admin/users`.

Usuarios demo: ver `docs/bases_de_datos.md`.

---

## Patrones de diseño

Implementados en el código:

- **Repository** — Spring Data JPA
- **DTO** — separación entidad / API
- **Service Layer** — lógica de negocio fuera de controllers
- **MVC** — entidades + REST + frontend React

Detalle y ejemplos: `docs/patrones.md`.

### Proyección (no implementado aún)

- Factory Method
- Circuit Breaker (Resilience4j)
- Microservicio de mensajería

---

## Diagramas

Ubicación: `diagrams/`

| Archivo | Contenido |
|---|---|
| `architecture_patterns_simple.puml` | Microservicios y patrones |
| `security_authentication.puml` | Flujo de login |
| `security_authorization.puml` | Autorización por roles |
| `auth_er_model.puml` | ER base `librodigital_auth` |
| `academic_er_model.puml` | ER base `librodigital_academic` |
| `attendance_er_model.puml` | ER base `librodigital_attendance` |

Los tres diagramas ER están en `infraestructura/diagrams/`.

---

## Orden de arranque

1. PostgreSQL
2. authService (8091)
3. academicService (8092)
4. attendanceService (8093)
5. apiGetaway (8090)
6. frontend-react (8094)

---

## Estado actual

- Microservicios auth, academic, attendance y gateway operativos
- Frontend React con paneles por rol (admin, docente, apoderado, estudiante)
- JWT en todos los servicios
- Pruebas unitarias con JUnit 5 + Mockito y reportes JaCoCo
- Colección Postman en `postman/`

---

## Autores

- Cristian Monsalve — backend / fullstack
- Héctor Olivares — frontend / fullstack
