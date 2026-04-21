# Plataforma de Libro de Clases Digital


Plataforma de gestión académica desarrollada para el ramo Fullstack III. La arquitectura está basada en microservicios, cada uno como repositorio independiente, y un frontend desacoplado.

**Actualización abril 2026:**
Todos los microservicios y el frontend fueron regenerados usando Spring Initializr con la siguiente configuración:

- **Build tool:** Maven
- **Spring Boot:** 4.0.5
- **Group:** `cl.duoc.libroDigital`
- **Artifact:** (nombre de la carpeta)
- **Packaging:** jar
- **Java:** 21
- **Dependencias:**
    - spring-boot-starter-web
    - spring-boot-starter-data-jpa
    - spring-boot-starter-security

Esto asegura una base homogénea, moderna y alineada con buenas prácticas para microservicios Java.

---

## 📚 Contenido

- [Stack Tecnológico](#-stack-tecnológico)
- [Características](#-características)
- [Requisitos Previos](#-requisitos-previos)
- [Guía de Instalación](#-guía-de-instalación)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Autores](#-autores)

---

## 🛠️ Stack Tecnológico


### Backend
- **Lenguaje:** Java 21
- **Framework:** Spring Boot 4.0.5
- **Base de Datos:** PostgreSQL
- **Gestión de dependencias:** Maven
- **Seguridad:** Spring Security, JSON Web Tokens (JWT)
- **Arquitectura:** Microservicios (cada carpeta es un proyecto Maven independiente)

### Frontend
- **Framework**: React
- **Lenguaje**: TypeScript
- **Estilos**: Tailwind CSS
- **Build Tool**: Vite

### Herramientas
- **Control de Versiones**: Git & GitHub
- **Diagramas**: PlantUML

---


## ✨ Características

- [ ] **Gestión de Usuarios**: Registro, autenticación y gestión de roles (administrador, docente, apoderado, estudiante).
- [ ] **Gestión Académica**: Creación y manejo de años lectivos, cursos, asignaturas y matrículas.
- [ ] **Control de Asistencia**: Registro de asistencia por sesión de clase.
- [ ] **Sistema de Calificaciones**: Creación de evaluaciones y registro de notas.
- [ ] **Anotaciones**: Registro de anotaciones (positivas y negativas) a estudiantes.


---

## 📋 Requisitos Previos

Asegúrate de tener instalado el siguiente software antes de comenzar:

- [JDK 21](https://www.oracle.com/java/technologies/javase/jdk21-archive-downloads.html) (Java Development Kit)
- [Apache Maven](https://maven.apache.org/download.cgi)
- [PostgreSQL](https://www.postgresql.org/download/)
- [Node.js](https://nodejs.org/en/) (para el frontend)
- Un cliente Git como [Git for Windows](https://git-scm.com/download/win)

---

## 🚀 Guía de Instalación

Sigue estos pasos para configurar el proyecto en tu máquina local.

1.  **Clonar el repositorio:**
    ```bash
    git clone https://github.com/cristianmonsalve14/libro-de-clases-digital.git
    cd libro-de-clases-digital
    ```

2.  **Configurar la Base de Datos:**
    - Asegúrate de que PostgreSQL esté corriendo.
    - Crea una nueva base de datos (ej: `libro_clases_db`).
    - Ejecuta el script `ddl/initial_schema.sql` en tu base de datos para crear todas las tablas.

3.  **Configurar el Backend:**
    - Navega a cada microservicio (empezando por `services/auth-service`).
    - Configura el archivo `src/main/resources/application.properties` con los datos de tu base de datos (URL, usuario, contraseña).
    - *(Instrucciones futuras para compilar y empaquetar con Maven)*

4.  **Configurar el Frontend:**
    - Navega a la carpeta `frontend/`.
    - *(Instrucciones futuras para instalar dependencias con `npm install`)*

---

## 🏗️ Estructura del Proyecto

```
.
├── ddl/                # Scripts para la base de datos (Data Definition Language)
├── diagrams/           # Diagramas de arquitectura y modelo de datos
├── docs/               # Documentación general del proyecto
├── frontend/           # Contiene la aplicación de frontend (UI)

├── academicService/      # Microservicio académico (cursos, matrículas, evaluaciones)
├── apiGetaway/           # API Gateway (enrutamiento, JWT, políticas transversales)
├── attendanceService/    # Microservicio de asistencia y anotaciones
├── authService/          # Microservicio de autenticación y gestión de usuarios/roles/JWT
├── frontend/             # Frontend desacoplado (React, TypeScript, Tailwind CSS)

```

---

## ✍️ Autores

- **Cristian Monsalve** (Backend) - `cristianmonsalve14`
- **Hector Olivares** (Frontend) - `(usuario de github)`

---
**Nota:** Cada microservicio y el frontend cuentan con su propio `pom.xml`, estructura de carpetas estándar de Spring Boot y configuración inicial lista para desarrollo y despliegue independiente.
