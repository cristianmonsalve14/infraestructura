# Proyecto Fullstack III - Libro Digital (registro de usuario)

- Propósito: Plataforma educativa de gestión académica basada en microservicios.
- Stack backend: Java 21, Spring Boot 3, PostgreSQL, Maven, JWT, Spring Security.
- Stack frontend: React, TypeScript, Tailwind CSS, Vite.
- Arquitectura: Microservicios (carpetas/repo independientes para cada servicio y frontend).
- Estructura de carpetas:
  - academic-service: Microservicio académico (cursos, matrículas, evaluaciones).
  - api-getaway: API Gateway (enrutamiento, JWT, políticas transversales).
  - attendance-service: Microservicio de asistencia y anotaciones.
  - auth-service: Microservicio de autenticación y gestión de usuarios/roles/JWT.
  - infraestructura: Documentación, diagramas, scripts SQL.
  - frontend: Frontend desacoplado (React, TypeScript, Tailwind CSS).
- Características principales:
  - Gestión de usuarios y roles
  - Gestión académica (años, cursos, asignaturas, matrículas)
  - Control de asistencia
  - Sistema de calificaciones
  - Registro de anotaciones
- Requisitos previos: JDK 21, Maven, PostgreSQL, Node.js, Git
- Autores: Cristian Monsalve (backend), Hector Olivares (frontend)

Este registro se mantiene actualizado para soporte y automatización del proyecto.


## Avances (abril 2026)

- Todos los microservicios principales cuentan con estructura Maven independiente:
  - auth-service: pom.xml, clase principal, carpetas src configuradas
  - academic-service: pom.xml, clase principal, carpetas src configuradas
  - attendance-service: pom.xml, clase principal, carpetas src configuradas
  - api-getaway: pom.xml, clase principal, carpetas src configuradas
- Esto permite desarrollo, pruebas y despliegue desacoplado para cada servicio.
- El roadmap y la documentación han sido actualizados para reflejar este avance.