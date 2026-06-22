# Diagramas — Libro Digital

Fecha: 2026-06-20

## Diagramas de arquitectura y flujos

| Archivo | Descripción |
|---|---|
| `architecture_patterns_simple.puml` | Microservicios, gateway, patrones |
| `security_authentication.puml` | Flujo de login JWT |
| `security_authorization.puml` | Autorización RBAC |

## Diagramas entidad-relación (por base de datos)

| Archivo | Base de datos | Servicio |
|---|---|---|
| `auth_er_model.puml` | `librodigital_auth` | authService |
| `academic_er_model.puml` | `librodigital_academic` | academicService |
| `attendance_er_model.puml` | `librodigital_attendance` | attendanceService |

Los `.png` son exportaciones para informes. Regenerar todos los diagramas ER:

```powershell
java -jar $env:USERPROFILE\.plantuml\plantuml.jar -tpng "infraestructura\diagrams\*_er_model.puml"
```

## Notas

- Cada microservicio tiene su propio ER (database per service).
- Las referencias `user_id`, `student_id`, `course_id` entre bases aparecen como **lógicas** (sin FK cross-database).
- Los scripts SQL normalizados están en `ddl/academic_schema.sql` y `ddl/attendance_schema.sql`.
