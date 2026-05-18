# Proyecto Fullstack III - Libro Digital (registro de usuario)

- Propósito: Plataforma educativa de gestión académica basada en microservicios.
- Stack backend: Java 21, Spring Boot 4.0.5, PostgreSQL, Maven, JWT, Spring Security.
- Stack frontend: React, TypeScript, Tailwind CSS, Vite.
- Arquitectura: Microservicios (carpetas/repo independientes para cada servicio y frontend).
- Estructura de carpetas/repositorios:
  - academicService: Microservicio académico (cursos, matrículas, evaluaciones). Rama principal: develop-academicService
  - apiGetaway: API Gateway (enrutamiento, JWT, políticas transversales). Rama principal: develop-apiGetaway
  - attendanceService: Microservicio de asistencia y anotaciones. Rama principal: develop-attendanceService
  - authService: Microservicio de autenticación y gestión de usuarios/roles/JWT. Rama principal: develop-authService
  - infraestructura: Documentación, diagramas, scripts SQL. Rama principal: main
  - frontend: Frontend desacoplado (React, TypeScript, Tailwind CSS). Rama principal: develop-frontend
- Características principales:
  - Gestión de usuarios y roles
  - Gestión académica (años, cursos, asignaturas, matrículas)
  - Control de asistencia
  - Sistema de calificaciones
  - Registro de anotaciones
- Requisitos previos: JDK 21, Maven, PostgreSQL, Node.js, Git
- Autores: Cristian Monsalve (backend), Hector Olivares (frontend)

## Estado y mejoras (abril 2026)

- Todos los microservicios y el frontend fueron regenerados con Spring Initializr (Maven, Spring Boot 4.0.5, Java 21, dependencias base).
- Cada repositorio cuenta con su propio README.md profesional, con descripción, stack, instrucciones y autores.
- Se crearon ramas develop para cada microservicio y frontend, siguiendo buenas prácticas de Git Flow.
- El README principal de infraestructura está actualizado y centraliza la documentación general.
- Todos los cambios y documentación están sincronizados en GitHub.

Este registro se mantiene actualizado para soporte y automatización del proyecto.


## Avances (abril 2026)

- Todos los microservicios principales cuentan con estructura Maven independiente:
  - auth-service: pom.xml, clase principal, carpetas src configuradas
  - academic-service: pom.xml, clase principal, carpetas src configuradas
  - attendance-service: pom.xml, clase principal, carpetas src configuradas
  - api-getaway: pom.xml, clase principal, carpetas src configuradas
- Esto permite desarrollo, pruebas y despliegue desacoplado para cada servicio.
- El roadmap y la documentación han sido actualizados para reflejar este avance.