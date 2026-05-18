# Arquitectura y Patrones — Plataforma Libro de Clases Digital

Fecha: 2026-03-22 (actualizado)

---

## Resumen

Documento técnico que amplía la descripción del proyecto. Incluye la arquitectura del sistema, microservicios implementados, patrones de diseño y decisiones técnicas.

Este documento incluye tanto la implementación actual como la proyección completa del sistema para futuras evaluaciones.

---

## Microservicios (lista y responsabilidades)

### ✅ Implementados

- auth-service: autenticación y gestión de usuarios (emite JWT).
- academic-service: gestión académica (cursos, asignaturas, matrículas, evaluaciones).
- frontend-react: interfaz de usuario.

### 🚧 Planificados (fase final del proyecto)

- attendance-service: sesiones, registro de asistencias y anotaciones de conducta.
- API Gateway: punto de entrada centralizado (validación JWT, routing).

---

## 📌 Nota sobre implementación

La arquitectura descrita en este documento representa el diseño completo del sistema.

En la implementación actual del proyecto se desarrollaron:

- authService  
- academicService  
- frontend React  

Los siguientes componentes están considerados para la evaluación final:

- attendance-service  
- API Gateway completo  
- Circuit Breaker (Resilience4j)  

---

## Decisiones principales

- Lenguaje: Java 21
- Frontend: React + TypeScript
- Persistencia: PostgreSQL
- Comunicación: REST HTTP/JSON
- Identificadores: BIGINT auto incremental
- Seguridad: JWT

---

## Persistencia

- Base de datos relacional PostgreSQL  
- Uso de JPA para persistencia  
- Relaciones entre entidades académicas  

---

## Patrones de Diseño Aplicados

### ✅ Repository Pattern

- Uso de Spring Data JPA  
- Abstracción de acceso a datos  
- Mejora mantenibilidad  

---

### ✅ DTO Pattern

- Separación entre entidad y datos expuestos  
- Mayor control sobre la API  
- Seguridad de datos  

---

### ✅ Service Layer Pattern

- Lógica de negocio centralizada  
- Separación de responsabilidades  

---

### ✅ MVC

- Model → entidades  
- View → frontend React  
- Controller → API REST  

---

## ⚠️ Patrones considerados (no implementados)

### Factory Method

Diseñado para centralizar creación de objetos.

Estado: no implementado en esta fase.

---

### Circuit Breaker

Diseñado para evitar fallos entre servicios.

Estado: no implementado.

---

## Seguridad

Sistema basado en JWT.

Flujo:

1. Usuario inicia sesión  
2. authService genera token  
3. frontend guarda token  
4. se envía en cada request  

Formato:

Authorization: Bearer {token}

---

## Modelo de Datos (Resumen)

- Student  
- Teacher  
- Course  
- Subject  
- Enrollment  
- Evaluation  

---

## Estructura del sistema

Sistema Libro Digital

├── frontend-react  
├── academicService  
└── authService  

---

## Comunicación

- REST API  
- JSON  
- llamadas directas frontend → backend  

---

## Diagramas

Ubicación:

diagrams/

Incluye:

- arquitectura  
- modelo ER  

---

## Estado del Proyecto

✔ backend funcional  
✔ frontend funcional  
✔ CRUD completo  
✔ autenticación JWT  
✔ integración funcionando  

---

## Proyección

- implementar attendance-service  
- agregar API Gateway  
- agregar Circuit Breaker  
- escalar arquitectura  

---

## Conclusión

El sistema implementa una arquitectura modular basada en microservicios.

Permite:

- escalabilidad  
- mantenibilidad  
- organización del código  

Se encuentra listo para extenderse en futuras etapas del proyecto.

---

## 1. Antecedentes Personales

Integrantes:

- Cristian Monsalve  
- Héctor Olivares  

Roles:

- Backend / Fullstack  
- Frontend / Fullstack  

---

## 2. Descripción del Proyecto

Sistema de gestión académica basado en microservicios.

Permite:

- gestión de estudiantes  
- cursos  
- asignaturas  
- matrículas  
- evaluaciones  

---

## Problema

Uso de libros físicos → mala gestión de información

---

## Solución

Sistema web moderno con backend + frontend + JWT

---

## Objetivos

- implementar autenticación  
- desarrollar CRUD académico  
- aplicar patrones  
- construir sistema completo  

---

## 3. Contexto

Usuarios:

- administrador  
- docente  
- estudiante  

---

## 4. Metodología

SCRUM dividido en etapas:

- diseño  
- desarrollo  
- pruebas  

---

## 5. Tecnologías

Backend:
- Spring Boot  
- Java 21  
- JPA  

Frontend:
- React  
- TypeScript  
- Tailwind  

---

## Repositorio

GitHub:

- frontend  
- backend  
- microservicios  

---

## Conclusión Final

El proyecto cumple con los objetivos del curso y se encuentra preparado para futuras mejoras.

Incluye:

- frontend moderno  
- backend funcional  
- autenticación JWT  
- arquitectura modular  

``
## 🧠 Backend For Frontend (BFF)

El proyecto implementa un Backend For Frontend (BFF) como una capa intermedia entre el frontend y los microservicios.

Este componente se encarga de:

- Centralizar las solicitudes del frontend
- Gestionar la comunicación con los microservicios
- Facilitar la integración con la arquitectura backend
- Preparar y adaptar las respuestas para el frontend

### 📌 Estructura

El BFF se encuentra organizado en una carpeta independiente dentro del proyecto.

### 🔧 Relación con el sistema

El flujo de comunicación es:

Frontend React  
→ Backend For Frontend (BFF)  
→ Microservicios (authService, academicService)

### ✅ Beneficios

- Reduce el acoplamiento entre frontend y backend  
- Centraliza la lógica de integración  
- Facilita futuras mejoras (API Gateway, seguridad avanzada)  

---
