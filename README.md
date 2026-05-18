# 📚 Plataforma de Libro de Clases Digital

Plataforma de gestión académica desarrollada para el ramo **Fullstack III**, basada en una arquitectura de microservicios con frontend desacoplado.

---

## 🧠 Arquitectura

El sistema está compuesto por:

- ✅ Frontend React (UI)
- ✅ Microservicio académico (gestión de datos)
- ✅ Microservicio de autenticación (JWT)

Cada componente es independiente y se comunica mediante API REST.

---

## 🛠️ Stack Tecnológico

### 🔧 Backend
- Java 21
- Spring Boot 4.0.5
- Spring Security + JWT
- PostgreSQL
- Maven

### 🎨 Frontend
- React
- TypeScript
- Tailwind CSS
- Vite

### 🔧 Herramientas
- Git / GitHub
- Postman
- pgAdmin

---

## ✨ Funcionalidades

✅ Gestión de estudiantes  
✅ Gestión de profesores  
✅ Gestión de asignaturas  
✅ Matrículas de estudiantes en cursos  
✅ Evaluaciones académicas  
✅ Registro de notas (escala chilena 1.0 - 7.0)  
✅ Autenticación segura mediante JWT  
✅ Protección de rutas backend  

---

## 📋 Requisitos

- Java JDK 21
- Maven
- PostgreSQL
- Node.js

---

## 🚀 Ejecución del Proyecto

### 🟣 Backend

Para cada microservicio ejecutar:

mvn spring-boot:run

Puertos:

- authService → http://localhost:8081  
- academicService → http://localhost:8082  

---

### 🟢 Frontend

Ejecutar:

npm install  
npm run dev  

Aplicación disponible en:

http://localhost:5173  

---

## 🗄️ Base de Datos

1. Crear base de datos en PostgreSQL (ej: libro_clases_db)  
2. Ejecutar scripts SQL del proyecto  
3. Configurar credenciales en:

src/main/resources/application.properties

Ejemplo:

spring.datasource.url=jdbc:postgresql://localhost:5432/libro_clases_db  
spring.datasource.username=postgres  
spring.datasource.password=tu_password  

---

## 🔐 Seguridad

El sistema utiliza:

✅ JSON Web Tokens (JWT)  
✅ Spring Security  
✅ Autenticación stateless  

Funcionamiento:

- Login en /auth/login  
- Se obtiene token JWT  
- El token se envía así:

Authorization: Bearer {token}

- Todas las rutas están protegidas excepto /auth/**  

---

## 🏗️ Estructura del Proyecto

.
├── frontend-react/  
├── academicService/  
│   ├── controller  
│   ├── service  
│   ├── repository  
│   └── model  
├── authService/  
├── ddl/  

---

## ✅ Estado del Proyecto

✔ Frontend completo  
✔ Backend completo  
✔ CRUD funcional en todos los módulos  
✔ Seguridad JWT implementada  
✔ Sistema de evaluaciones con notas chilenas  

---

## 👨‍💻 Autores

- Cristian Monsalve  
- Hector Olivares  

---

## 📌 Observaciones

El sistema sigue buenas prácticas de arquitectura:

- Controller → APIs REST  
- Service → lógica de negocio  
- Repository → base de datos  
- DTO → comunicación con frontend  

Incluye autenticación segura con JWT y separación por microservicios.

---

## 📚 Documentación del Proyecto

La documentación completa del sistema se encuentra en la carpeta `docs/` del repositorio.

### 📄 Contenido de la carpeta docs/

- **repositorios.txt**  
Contiene los enlaces a los repositorios del proyecto (frontend y microservicios).

- **patrones.md**  
Documento que describe los patrones de diseño aplicados en el sistema, como Repository, DTO, Service Layer y MVC, incluyendo su justificación y beneficios.

- **arquitectura.md**  
Documento técnico que incluye:
Arquitectura de microservicios  
Modelo de datos  
Diagramas (PlantUML)  
Definición de base de datos (DDL)  
Estrategia de seguridad con JWT  
Descripción de componentes del sistema  

- **guia_proyecto.md**  
Informe general del proyecto con:
Descripción del problema  
Objetivos  
Metodología SCRUM  
Plan de trabajo  
Justificación técnica  

---

## 📌 Organización del Repositorio

Se centralizó toda la documentación en la carpeta `docs/` para mantener una estructura ordenada y clara.

Esto permite separar:

- Código fuente  
- Configuración  
- Documentación técnica  

---

## ✅ Estado de la Documentación

✔ Documentación completa  
✔ Arquitectura definida  
✔ Patrones implementados  
✔ Repositorios documentados  
✔ Proyecto alineado con buenas prácticas  

---
