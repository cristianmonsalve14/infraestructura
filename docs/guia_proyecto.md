# Informe de Arquitectura: Plataforma de Libro de Clases Digital

**Proyecto:** Colegio Bernardo O'Higgins – Plataforma de libro de clases digital  
**Asignatura:** DSY 1106 – Desarrollo Full Stack III  
**Fecha:** Marzo 2026  
**Alumnos:** Cristian Monsalve Budrovich – Héctor Olivares Troncoso

---

## 1. Antecedentes Personales

|  | Integrante 1 | Integrante 2 |
|---|---|---|
| **Rut** | 12.622.852-k | 17.945.411-4 |
| **Nombres** | Cristian | Héctor |
| **Apellidos** | Monsalve Budrovich | Olivares Troncoso |
| **Roles** | Full Stack - Backend | Full Stack - Frontend |

---

## 2. Descripción Proyecto

| Campo | Descripción |
|---|---|
| **Tema** | Plataforma de Libro de Clases Digital |
| **Descripción** | Sistema de gestión académica basado en microservicios que permite digitalizar y centralizar el libro de clases del Colegio Bernardo O'Higgins, facilitando el registro de asistencia, calificaciones y anotaciones. |
| **Problemática detectada** | El uso de libro de clases físico genera dificultades en la centralización de información académica, consultas históricas lentas, falta de comunicación eficiente entre actores educativos y riesgo de pérdida de información. |
| **Solución esperada** | Plataforma web moderna con arquitectura de microservicios que permita gestión académica completa, registro de asistencia digital, sistema de calificaciones y anotaciones estudiantiles. |
| **Objetivos generales** | Modernizar y digitalizar el proceso de gestión académica del Colegio Bernardo O'Higgins mediante una plataforma centralizada, segura y accesible que facilite el registro, consulta y análisis de información académica. |
| **Objetivos específicos** | 1. Implementar sistema de autenticación con roles (JWT)<br>2. Desarrollar módulos de gestión académica (cursos, asignaturas, matrículas)<br>3. Crear sistema de registro de asistencia y anotaciones<br>4. Implementar sistema de calificaciones y evaluaciones<br>5. Aplicar patrones de diseño (Repository, Factory Method, Circuit Breaker) |
| **Alcance del proyecto** | La aplicación permitirá gestionar años lectivos, cursos, asignaturas, matrículas, registro de asistencia por sesión, creación de evaluaciones y registro de notas, y anotaciones de conducta (positivas/negativas). Incluye roles para administrador, docente, apoderado y estudiante. |

---

## 3. Contexto del proyecto

### Antecedentes y motivación

El Colegio Bernardo O'Higgins actualmente utiliza un sistema tradicional de libro de clases físico para el registro de información académica. Este método presenta múltiples limitaciones en términos de accesibilidad, centralización, búsqueda de información histórica y comunicación eficiente entre los distintos actores del proceso educativo.

### Público objetivo

- **Administradores**: Gestión general del sistema, usuarios y configuraciones
- **Docentes**: Registro de asistencia, calificaciones y anotaciones; comunicación con apoderados
- **Apoderados**: Consulta de información académica de sus pupilos, recepción de comunicaciones
- **Estudiantes**: Consulta de calificaciones, asistencia y anotaciones propias

### Estado del arte

Existen plataformas como Napsis, Syscol y Lirmi en el mercado chileno, sin embargo, estas son soluciones propietarias de alto costo. El presente proyecto busca desarrollar una solución moderna usando tecnologías de código abierto y arquitectura de microservicios, permitiendo escalabilidad y mantenibilidad a largo plazo.

### Origen de la problemática

La necesidad surge de la dificultad para acceder a información histórica, la duplicación de esfuerzos al registrar datos manualmente, la falta de canales formales de comunicación digital entre docentes y apoderados, y la imposibilidad de generar reportes automatizados para análisis académico.

### Descripción del problema a resolver

Se requiere una plataforma digital que reemplace el libro de clases físico, permitiendo registro centralizado de datos académicos, consultas históricas eficientes, generación automática de reportes, comunicación fluida entre actores educativos, y que garantice seguridad, trazabilidad y disponibilidad de la información.

---

## 4. Metodología

### Descripción Metodología

Se utilizará **metodología ágil SCRUM** adaptada al contexto académico, dividiendo el desarrollo en 3 Sprints correspondientes a los 3 parciales del semestre:

#### Sprint 1 (Parcial 1) - Diseño y Arquitectura

- Definición de microservicios y responsabilidades
- Diseño de arquitectura (API Gateway + servicios)
- Modelado de base de datos (DDL)
- Selección y documentación de patrones de diseño
- Creación de diagramas PlantUML
- **Entregable**: Documento de arquitectura completo

#### Sprint 2 (Parcial 2) - Desarrollo de Componentes

- Scaffolding de proyectos Maven para microservicios
- Implementación de API Gateway con validación JWT
- Desarrollo de al menos 2 microservicios con Spring Boot + JPA
- Implementación de frontend inicial con React + TypeScript
- Integración frontend-backend mediante API Gateway
- **Entregable**: Aplicación funcional con 2+ microservicios

#### Sprint 3 (Parcial 3) - Pruebas y Presentación

- Implementación de pruebas unitarias e integración (cobertura 60%+)
- Configuración de pipeline CI/CD (GitHub Actions)
- Documentación de APIs con OpenAPI/Swagger
- Refinamiento de funcionalidades
- **Entregable**: Sistema completo con pruebas y documentación

### Definición de roles y responsabilidades

- **Backend Developer (Cristian Monsalve)**: Desarrollo de microservicios, implementación de patrones, configuración de Spring Boot, integración con PostgreSQL, implementación de seguridad JWT
- **Frontend Developer (Héctor Olivares)**: Desarrollo de interfaz con React + TypeScript + Tailwind CSS, integración con API Gateway, diseño de experiencia de usuario
- **DBA/QA (Cristian Monsalve/Héctor Olivares)**: Diseño y optimización de base de datos, versionado de esquemas, pruebas unitarias e integración, QA testing, documentación

### Justificación

SCRUM permite iteraciones cortas con entregables concretos, facilitando la revisión docente en cada parcial. La arquitectura de microservicios permite trabajo paralelo entre integrantes sin bloqueos. El enfoque test-driven en el Sprint 3 asegura calidad del código.

---

## 5. Descripción técnica de la solución

### Especificaciones técnicas de la solución a desarrollar

#### Infraestructura a utilizar

- Local/Desarrollo: Localhost con puertos dedicados por microservicio
- Base de datos: PostgreSQL local
- Contenedores Docker para estandarizar entornos
- Control de versiones: GitHub (repositorio: cristianmonsalve14/libro-de-clases-digital)

#### Arquitectura de software

**Patrón:** Microservicios


**Componentes:**
- **API Gateway** (Spring Cloud Gateway): Punto de entrada único, validación JWT, enrutamiento
- **auth-service**: Autenticación y gestión de usuarios/roles
- **academic-service**: Gestión académica (cursos, asignaturas, matrículas, evaluaciones, notas)
- **attendance-service**: Registro de asistencia y anotaciones

**Comunicación:** REST HTTP/JSON síncrono entre servicios

**Patrones aplicados:** Repository (Spring Data JPA), Factory Method, Circuit Breaker (Resilience4j)

#### Lenguajes de programación

- **Backend**: Java 17
- **Frontend**: TypeScript (React)
- **Base de datos**: SQL (PostgreSQL)

#### Framework, dependencias y/o librerías a utilizar

**Backend:**
- Spring Boot 3.x
- Spring Data JPA
- Spring Security
- Spring Cloud Gateway
- Resilience4j (Circuit Breaker)
- JSON Web Tokens (JWT) - jjwt
- Flyway o Liquibase (migración de BD)
- Lombok
- Maven (gestión de dependencias)

**Frontend:**
- React 18+
- TypeScript
- Tailwind CSS
- Vite (build tool)
- React Router (navegación)
- Axios (HTTP client)

#### Base de datos

- PostgreSQL (versión 14+)
- Estrategia: Base de datos única con ownership lógico por servicio
- Identificadores: BIGINT auto-incremental
- Versionado: Flyway/Liquibase

#### Repositorio

- **GitHub**: https://github.com/cristianmonsalve14/libro-de-clases-digital
- **Estrategia de ramas**:
  - `main`: código estable
  - `feature/<desarrollo>`: desarrollo de funcionalidades

#### Otros

- OpenAPI/Swagger: Documentación de APIs
- JUnit 5 + Mockito: Testing backend
- Jest/Vitest: Testing frontend
- GitHub Actions: CI/CD
- PlantUML: Diagramas de arquitectura y ER

---

## 6. Plan de Trabajo

| Nro. | Nombre de Actividades/Tareas | Descripción Actividades/Tareas | Recursos | Duración de la actividad | Responsable | Observaciones |
|---|---|---|---|---|---|---|
| 1 | Diseño de arquitectura de microservicios | Definir servicios, responsabilidades y comunicación entre componentes | Lucidchart/PlantUML, docs | 1 semana | Equipo completo | Documento en arquitectura.md |
| 2 | Modelado de base de datos | Diseño ER, normalización, DDL PostgreSQL | PostgreSQL, PlantUML | 1 semana | DBA/QA | Script en initial_schema.sql |
| 3 | Documentación de patrones | Describir Repository, Factory, Circuit Breaker con ejemplos | IDE, markdown | 3 días | Backend Dev | Incluir en arquitectura.md |
| 4 | Creación de diagramas PlantUML | Generar diagramas de microservicios y ER | PlantUML, VSCode | 2 días | Equipo completo | Guardar .puml y exportar PNG/SVG |
| 5 | Scaffolding de microservicios | Generar proyectos Maven con Spring Initializr | Spring Initializr, Maven | 3 días | Backend Dev | 4 microservicios + Gateway |
| 6 | Implementación auth-service | Login, JWT, gestión usuarios/roles | Java, Spring Boot, JWT | 1 semana | Backend Dev | Endpoints: /auth/login, /auth/register |
| 7 | Implementación academic-service | CRUD cursos, asignaturas, evaluaciones, notas | Java, Spring Boot, JPA | 1.5 semanas | Backend Dev | APIs RESTful con validación |
| 8 | Configuración API Gateway | Routing, validación JWT, CORS | Spring Cloud Gateway | 3 días | Backend Dev | Configuration application.yml |
| 9 | Setup proyecto frontend | Crear proyecto React + TS + Tailwind | Vite, npm | 1 día | Frontend Dev | Estructura de carpetas definida |
| 10 | Implementación UI login | Pantalla login con validación | React, TypeScript | 2 días | Frontend Dev | Integración con auth-service |
| 11 | Implementación dashboard | Vistas por rol (admin, docente, apoderado) | React, Tailwind | 1 semana | Frontend Dev | Navegación con React Router |
| 12 | Integración frontend-backend | Conectar UI con APIs mediante Gateway | Axios, JWT | 3 días | Frontend Dev | Interceptors para JWT |
| 13 | Pruebas unitarias backend | Test JUnit para servicios y repositorios | JUnit 5, Mockito | 1 semana | DBA/QA | Cobertura mínima 60% |
| 14 | Pruebas unitarias frontend | Test Jest/Vitest para componentes | Jest/Vitest | 3 días | Frontend Dev + QA | Componentes críticos |
| 15 | Configuración CI/CD | Pipeline GitHub Actions con test | GitHub Actions | 2 días | Backend Dev | Build + test automático |
| 16 | Documentación OpenAPI | Swagger para cada microservicio | Springdoc OpenAPI | 2 días | Backend Dev | Accesible en /swagger-ui |
| 17 | Preparación presentación | Slides y demo | PowerPoint, sistema | 3 días | Equipo completo | Demo backup |

---

## 7. Evidencias

| Nro. | Nombre de evidencia | Descripción | Link para acceder (repositorio) |
|---|---|---|---|
| 1 | Documento de Arquitectura | Descripción completa de microservicios, decisiones técnicas, justificación de patrones (Repository, Factory Method, Circuit Breaker), alternativas evaluadas | arquitectura.md |
| 2 | Diagrama de Microservicios | Diagrama de arquitectura mostrando API Gateway, 4 microservicios, PostgreSQL y flujos de comunicación | diagrams/microservices.svg |
| 3 | Modelo Entidad-Relación (ER) | Diagrama ER de base de datos con todas las tablas, relaciones y cardinalidades | diagrams/er_model.png |
| 4 | Script DDL Base de Datos | Script SQL para creación de todas las tablas en PostgreSQL con constraints, índices y valores por defecto | initial_schema.sql |
| 5 | Código fuente Backend | Implementación de 3 microservicios + API Gateway en Java Spring Boot con Maven | services/ (auth-service, academic-service, attendance-service, api-gateway) |
| 6 | Código fuente Frontend | Aplicación React con TypeScript y Tailwind CSS, integración con API Gateway | frontend/ |
| 7 | Documentación de APIs (OpenAPI) | Especificación Swagger de endpoints REST de cada microservicio | /swagger-ui de cada servicio |
| 8 | Reportes de Pruebas | Resultados de pruebas unitarias e integración, cobertura de código (JaCoCo para backend, coverage para frontend) | Reportes generados por Maven/npm |
| 9 | Configuración CI/CD | Pipeline de GitHub Actions para build, test y reporte de cobertura | .github/workflows |
| 10 | README Principal | Guía de instalación, stack tecnológico, estructura del proyecto, requisitos previos | README.md |

---

## 8. Otros

### Antecedentes adicionales

#### 1. Justificación de decisiones técnicas clave

- **Java 17 y Spring Boot 3**: Tecnología robusta, ampliamente documentada y con gran ecosistema de librerías. Compatible con los requerimientos del curso.
- **PostgreSQL**: Base de datos relacional open-source, robusta para datos estructurados académicos. Soporta transacciones ACID críticas para integridad de calificaciones y asistencia.
- **React + TypeScript**: React es el framework frontend más popular y demandado en la industria. TypeScript agrega tipado estático que reduce errores y mejora la mantenibilidad.
- **Tailwind CSS**: Framework CSS que acelera el desarrollo de UI responsive y mantiene consistencia de diseño sin escribir CSS custom extenso.
- **Arquitectura de Microservicios**: Permite escalabilidad independiente, deployment aislado, y trabajo paralelo del equipo sin conflictos de código.

#### 2. Consideraciones de seguridad

- Autenticación mediante JWT (JSON Web Tokens)
- Bcrypt para hash de contraseñas
- HTTPS en producción (TLS/SSL)
- Validación de entrada en todos los endpoints
- CORS configurado en API Gateway
- Principio de mínimos privilegios por rol

#### 3. Plan de contingencia

- Repositorio Git permite rollback ante errores críticos
- Comunicación diaria del equipo vía Discord/WhatsApp
- Reuniones semanales de sincronización (Scrum)
- Documentación actualizada permite que cualquier miembro pueda continuar trabajo de otro

#### 4. Cronograma de reuniones

- **Daily stand-up** (virtual): Lunes, Miércoles, Viernes - 10 minutos
- **Sprint Review con docente**: Cada clase
- **Sprint Planning**: Primera semana de cada fase
- **Retrospectiva**: Última semana de cada fase

#### 5. Criterios de éxito

- ✓ Sistema funcional con minimum 2 microservicios operativos
- ✓ Frontend integrado consumiendo APIs del Gateway
- ✓ Cobertura de pruebas ≥ 60%
- ✓ Documentación completa y actualizada
- ✓ Pipeline CI ejecutándose correctamente
- ✓ Presentación exitosa con demo en vivo

---

**Documento de referencia para el seguimiento y desarrollo del proyecto semestral**
