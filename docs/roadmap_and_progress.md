# Roadmap y Guía de Progreso — Plataforma Libro de Clases Digital

Este documento sirve como guía operativa y checklist para el equipo. Se usará para chequear los pasos realizados y registrar evidencia mínima por entrega.

## Cómo usar este archivo
- Cada ítem contiene: descripción, responsable (placeholder) y criterios de aceptación.
- Marca un ítem como completado (✓) cuando se cumplan los criterios de aceptación y se suba el artefacto correspondiente al repositorio.
- No modificar el historial de cambios sin registrar el autor y fecha.

---

## Checklist principal (alto nivel)

### Sección 1 — Diseño de Arquitectura y Patrones (Parcial 1)
### Sección 1 — Diseño de Arquitectura y Patrones (Parcial 1)
 [x] Diagrama de microservicios (PlantUML) — criterios: muestra auth, academic, attendance, messaging y API Gateway; archivo: `diagrams/microservices.puml` (COMPLETADO).
### Sección 2 — Desarrollo de Componentes (Parcial 2)
### Sección 2 — Desarrollo de Componentes (Parcial 2)
- [x] Migración de todos los servicios a Java 21 y actualización de README (abril 2026).
- [x] Scaffoldar arquetipos Maven para servicios (auth, academic, attendance, api-getaway) — criterios: proyectos generados con `pom.xml`, `Application` main, y conexión a PostgreSQL por properties (COMPLETADO para todos los microservicios principales).
- [ ] Implementar BFF o API Gateway (config básica de routing y validación JWT).
- [ ] Implementar 2 microservicios con JPA (endpoints CRUD básicos + OpenAPI docs).
- [ ] Frontend inicial (React + TypeScript + Tailwind CSS) con llamadas a BFF.

### Sección 3 — Integración, Pruebas y Presentación Final
## Detalle de Artefactos y criterios de aceptación
- `docs/project_overview.md` — Resumen del proyecto (COMPLETADO).
- `docs/arquitectura.md` — Documento técnico largo con decisiones, alternativas descartadas y configuración (COMPLETADO).
- `diagrams/microservices.puml` — PlantUML del diagrama (Pendiente). Al aprobarse, exportar PNG y colocarlo en `diagrams/`.
- `ddl/initial_schema.sql` — SQL de definición inicial (PostgreSQL) (Pendiente).
- README de cada microservicio actualizado a Java 21 (COMPLETADO).
---

## Detalle de Artefactos y criterios de aceptación

- `docs/project_overview.md` — Resumen del proyecto (COMPLETADO).
## Pasos inmediatos recomendados (esta semana)
1. Generar y aprobar `diagrams/microservices.puml` (diagrama actualizado de microservicios).
2. Completar `docs/arquitectura.md` con patrones aplicados y justificación técnica.
3. Generar scaffold para `auth-service` y `academic-service` (arquetipos Maven) en `services/`.
4. Implementar endpoints CRUD básicos y conexión a PostgreSQL en cada microservicio.
5. Iniciar frontend en React y conectar con el backend.
6. Agregar pruebas unitarias y de integración.
7. Actualizar documentación y checklist de progreso.
- `docs/arquitectura.md` — Documento técnico largo con decisiones, alternativas descartadas y configuración (Pendiente).
- Ramas: usar `feature/<nombre>` para trabajo de funcionalidades, `docs/<nombre>` para documentación, y `release/<parcial>` cuando se sube la entrega parcial.
- Commits: mensajes claros en español: `feat(auth): añadir endpoint login`, `chore(docs): agregar diagrama de microservicios`.
- Pull Requests: incluir checklist de revisión y asignar al profesor o revisor del equipo.
- Stack actualizado: Java 21, Spring Boot 3, PostgreSQL, React, TypeScript, Tailwind CSS.
## Convenciones de trabajo
- Ramas: usar `feature/<nombre>` para trabajo de funcionalidades, `docs/<nombre>` para documentación, y `release/<parcial>` cuando se sube la entrega parcial.
- Commits: mensajes claros en español: `feat(auth): añadir endpoint login`, `chore(docs): agregar diagrama de microservicios`.
- Pull Requests: incluir checklist de revisión y asignar al profesor o revisor del equipo.

## Registro de progreso (ejemplo)
- 2026-03-17 — `docs/project_overview.md` creado — Autor: Equipo — Estado: COMPLETADO.
- 2026-03-18 — (pendiente) `diagrams/microservices.puml` — Responsable: _______ — Estado: en progreso.

---

## Pasos inmediatos recomendados (esta semana)
1. Revisar y aprobar `docs/project_overview.md` (tú).
2. Confirmar que queremos que genere `diagrams/microservices.puml` y `docs/arquitectura.md` ahora.
3. Generar scaffold para `auth-service` y `academic-service` (arquetipos Maven) en `services/` (previa confirmación).

---

_Mantén este documento actualizado; lo usaré como fuente de verdad para el avance y para generar commits y PRs cuando autorices._
