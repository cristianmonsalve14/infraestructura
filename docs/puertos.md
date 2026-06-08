# Puertos — Libro Digital

Bloque reservado **8090–8099** para evitar conflictos con otros proyectos (8080, 8081, 5173, etc.).

## Asignación

| Componente | Puerto | URL local |
|---|---|---|
| **apiGetaway** | 8090 | http://localhost:8090 |
| **authService** | 8091 | http://localhost:8091 |
| **academicService** | 8092 | http://localhost:8092 |
| **attendanceService** | 8093 | http://localhost:8093 |
| **frontend-react** | 8094 | http://localhost:8094 |
| **PostgreSQL** | 5432 | localhost:5432 |

## Reservados para futuro

| Puerto | Uso sugerido |
|---|---|
| 8095 | Nuevo microservicio |
| 8096 | Nuevo microservicio |
| 8097–8099 | Margen / otros entornos |

## Flujo de comunicación

```
frontend-react (:8094)
        │
        ▼
   apiGetaway (:8090)  ← única URL que usa el frontend (VITE_API_URL)
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

## Bases de datos (PostgreSQL :5432)

| Microservicio | Base de datos | Estado |
|---|---|---|
| authService | `librodigital_auth` | ✅ configurada |
| academicService | `librodigital_academic` | ✅ configurada |
| attendanceService | `librodigital_attendance` | ✅ configurada |

Scripts: `infraestructura/ddl/` — ver `ddl/README.md` y `docs/bases_de_datos.md`.

## Orden de arranque recomendado

1. PostgreSQL
2. authService (8091)
3. academicService (8092)
4. attendanceService (8093) — cuando esté implementado
5. apiGetaway (8090)
6. frontend-react (8094)
