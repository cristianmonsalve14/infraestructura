# Proyecto: Plataforma de Libro de Clases Digital — Colegio Bernardo O’Higgins

Fecha: 2026-03-17

## Resumen ejecutivo

Este repositorio contiene el trabajo del Caso Semestral para la asignatura DSY1106 — Desarrollo Fullstack III. El objetivo es diseñar e implementar una plataforma digital que funcione como libro de clases electrónico para el Colegio Bernardo O’Higgins, permitiendo registrar, consultar y analizar información académica de forma centralizada y segura.

## Objetivos del proyecto
- Reemplazar/modernizar el libro de clases físico.
- Centralizar información académica (cursos, estudiantes, evaluaciones, asistencia, anotaciones).
- Facilitar la comunicación entre docentes, estudiantes y apoderados.
- Permitir consultas históricas y generación de reportes.

## Alcance (Sección 1 — diseño)
Esta fase (Parcial 1) entrega el diseño de arquitectura de microservicios, incluyendo:
- Definición de microservicios clave
- Diseño de API Gateway
- Selección y justificación de patrones arquitectónicos (Repository, Factory Method, Circuit Breaker)
- Diagrama de microservicios (PlantUML)
- Asignación lógica de datos a los servicios

## Módulos / Microservicios acordados
Se definió la siguiente descomposición mínima (independientes):

1. auth-service (servicio de autenticación/usuarios)
   - Login (JWT), gestión de roles, validación de token.

2. academic-service (gestión académica)
   - Asignaturas, cursos, matrículas, evaluaciones, notas.

3. attendance-service (asistencia y anotaciones)
   - Sesiones, registro de asistencia, anotaciones de conducta.

4. messaging-service (portal de comunicaciones)
   - Mensajería entre usuarios, destinatarios y metadatos de adjuntos.

Transversal: API Gateway (entrada única hacia el frontend); observabilidad (logs/metrics) y políticas de seguridad.

## Decisiones técnicas principales
- Lenguaje / Framework backend: Java + Spring Boot (Spring Data JPA para repositories).
- Comunicación entre servicios: RESTful HTTP/JSON (síncrona), con Circuit Breaker para llamadas críticas.
- Circuit Breaker recomendado: Resilience4j.
- Base de datos: PostgreSQL (una única base de datos compartida, por decisión del equipo en esta fase).
- Versionado de esquemas: Flyway o Liquibase (recomendado).
- Seguridad: JWT emitido por `auth-service`; API Gateway valida tokens y enruta.

## Patrones aplicados y por qué
- Repository Pattern: desacopla persistencia y facilita pruebas; implementado con Spring Data JPA.
- Factory Method: encapsula creación de objetos de dominio y facilita extensibilidad (p. ej. distintos tipos de notificaciones o anotaciones).
- Circuit Breaker (Resilience4j): protege servicios consumidores ante fallos en proveedores y evita cascadas de error.

## Esquema lógico de datos (resumen)
- La base de datos centralizada en PostgreSQL contendrá tablas para:
  - users, roles
  - academic: academic_years, class_groups, subjects, enrollments, assessments, grades
  - attendance: sessions, attendance_records, annotations
  - messaging: messages, message_recipients, attachments (metadatos)

Nota: aunque la DB es única, aplicaremos contratos API y políticas operacionales que desalienten el acceso directo entre servicios (las consultas a datos de otro dominio deben ser mediante su API).

## Entregables (por sección)
- Sección 1 (Parcial 1): Documento de arquitectura (este archivo + `docs/arquitectura.md`), diagrama de microservicios (PlantUML), justificación de patrones.
- Sección 2 (Parcial 2): Implementación parcial — BFF, al menos 2 microservicios con JPA y APIs, frontend inicial empaquetado, versiones en Git.
- Sección 3 (Parcial 3): Pruebas unitarias y de integración, cobertura mínima solicitada, pipeline CI y documentación final.

## Supuestos y limitaciones
- Se parte de una única base de datos PostgreSQL por decisión del equipo (revisión futura recomendada).
- Comunicación síncrona entre servicios (REST/JSON). En fases posteriores se podrá introducir mensajería asíncrona.
- No se realizarán cambios de infraestructura (Kubernetes, CI) sin aprobación explícita del equipo/instructor.

## Próximos pasos sugeridos (a corto plazo)
1. Finalizar y aprobar el documento de arquitectura (Parcial 1).
2. Generar diagramas PlantUML y exportar PNG.
3. Definir contrato OpenAPI mínimo para cada microservicio.
4. Preparar scaffold de los servicios (arquetipos Maven) para Parcial 2.

---
_Autor: Equipo "Cristian Monsalve" — entregable Sección 1_
