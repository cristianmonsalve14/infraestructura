# 📚 Plataforma de Libro de Clases Digital

Plataforma de gestión académica desarrollada para el ramo **Fullstack III**, basada en una arquitectura de microservicios con frontend desacoplado.

---

## 🧠 Arquitectura

El sistema está compuesto por:

- ✅ **frontend-react** — UI React (puerto 8094)
- ✅ **apiGetaway** — API Gateway (puerto 8090)
- ✅ **authService** — autenticación y usuarios JWT (8091)
- ✅ **academicService** — gestión académica (8092)
- ✅ **attendanceService** — asistencia y anotaciones (8093)
- ✅ **frontend** — módulo Spring Boot reservado (scaffold; la UI activa es `frontend-react`)

Cada componente es independiente y se comunica mediante API REST.

---

## 🛠️ Stack Tecnológico

### 🔧 Backend
- Java 21
- Spring Boot 4.1.0
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
✅ Control de asistencia y anotaciones  
✅ API Gateway centralizado  
✅ Autenticación segura mediante JWT  

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

- apiGetaway → http://localhost:8090  
- authService → http://localhost:8091  
- academicService → http://localhost:8092  
- attendanceService → http://localhost:8093  

Ver detalle en `docs/puertos.md`.

---

### 🟢 Frontend (UI activa)

Ejecutar en la carpeta **frontend-react**:

npm install  
npm run dev  

Aplicación disponible en:

http://localhost:8094  

Variable de entorno (`.env`):

VITE_API_URL=http://localhost:8090

---

## 🗄️ Base de Datos

Arquitectura **database per service** (una BD por microservicio):

| Base de datos | Servicio |
|---|---|
| `librodigital_auth` | authService |
| `librodigital_academic` | academicService |
| `librodigital_attendance` | attendanceService |

Scripts en `ddl/` — ver `ddl/README.md` para instalación paso a paso.

Configurar credenciales en cada `application.properties`:

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/librodigital_auth
spring.datasource.username=postgres
spring.datasource.password=tu_password
```

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
├── frontend-react/     # UI React + Vite (puerto 8094)
├── frontend/           # Módulo Spring Boot (scaffold)
├── apiGetaway/
├── authService/
├── academicService/
├── attendanceService/
├── ddl/
└── docs/

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

- **puertos.md**  
Mapa oficial de puertos del ecosistema (bloque 8090–8099).

- **bases_de_datos.md**  
Estrategia database per service, inventario de tablas y guía de configuración.

- **repositorios.txt**  
Contiene los enlaces a los repositorios del proyecto (frontend y microservicios).

- **patrones.md**  
Documento que describe los patrones de diseño aplicados en el sistema, como Repository, DTO, Service Layer y MVC, incluyendo su justificación y beneficios.

- **arquitectura.md**  
Arquitectura de microservicios, flujos, stack y diagramas.

- **diagrams/README.md**  
Índice de diagramas PlantUML vigentes y archivados.

- **guia_proyecto.md**  
Informe académico: problema, objetivos, metodología SCRUM y contexto del ramo.

- **archive/**  
Material histórico (SQL monolítico, diagramas antiguos, snapshots). No usar en desarrollo actual.

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
