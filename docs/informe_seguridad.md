# Informe de Arquitectura de Seguridad - Plataforma Libro de Clases Digital

**Proyecto:** Colegio Bernardo O'Higgins  
**Asignatura:** DSY 1106 – Desarrollo Full Stack III  
**Fecha:** Marzo 2026  
**Tema:** Documentación de Seguridad - JWT, Roles y Protección de Microservicios

---

## 📋 ÍNDICE

1. [Introducción - Estrategia de Seguridad](#introducción)
2. [Diagrama 1: Flujo de Autenticación y Autorización JWT](#diagrama-1-flujo-de-autenticación-y-autorización-jwt)
3. [Diagrama 2: Modelo de Datos de Seguridad](#diagrama-2-modelo-de-datos-de-seguridad)
4. [Diagrama 3: Arquitectura de Componentes de Seguridad](#diagrama-3-arquitectura-de-componentes-de-seguridad)
5. [Consideraciones para AWS](#consideraciones-para-aws)
6. [Preguntas Frecuentes del Docente](#preguntas-frecuentes-del-docente)

---

## INTRODUCCIÓN

### ¿Por qué necesitamos seguridad en nuestra plataforma?

Nuestro sistema maneja información sensible de estudiantes (calificaciones, asistencia, datos personales). Necesitamos:

1. **Autenticación**: Verificar que el usuario es quien dice ser
2. **Autorización**: Controlar qué puede hacer cada usuario según su rol
3. **Protección de datos**: Encriptar contraseñas, usar comunicación segura
4. **Trazabilidad**: Saber quién hizo qué y cuándo

### Tecnologías de Seguridad Elegidas

| Tecnología | Propósito | Justificación |
|------------|-----------|---------------|
| **JWT (JSON Web Tokens)** | Autenticación stateless | Escalable, no requiere sesiones en servidor, ideal para microservicios |
| **BCrypt** | Hash de contraseñas | Algoritmo probado, resistente a ataques de fuerza bruta, auto-salting |
| **Spring Security** | Framework de seguridad | Estándar de la industria Java, integración nativa con Spring Boot |
| **HTTPS/TLS** | Transporte seguro | Encriptación en tránsito, previene man-in-the-middle |
| **RBAC** (Role-Based Access Control) | Control de acceso | Simple, mantenible, suficiente para nuestros 4 roles |

---

## DIAGRAMA 1: FLUJO DE AUTENTICACIÓN Y AUTORIZACIÓN JWT

**Archivo:** `diagrams/security_flow.png` y `diagrams/security_flow.puml`

### ¿Qué muestra este diagrama?

Un diagrama de secuencia que documenta **TODO el flujo de seguridad** desde que un usuario ingresa sus credenciales hasta que recibe datos protegidos. Muestra la interacción entre 5 componentes principales:

1. **Usuario** (actor)
2. **Frontend** (React)
3. **API Gateway** (Spring Cloud Gateway)
4. **Auth Service** (microservicio de autenticación)
5. **Academic Service** (ejemplo de microservicio protegido)
6. **PostgreSQL** (base de datos)

### El diagrama se divide en 3 FASES

---

### 📍 FASE 1: AUTENTICACIÓN (LOGIN)

**Objetivo:** Verificar identidad del usuario y emitir un token JWT.

#### Paso a paso:

**1. Usuario ingresa credenciales**
- Alumno: Cristian Monsalve
- Acción: Ingresa su correo (`cristian.monsalve@colegio.cl`) y password en la pantalla de login
- Frontend: Formulario React con validación básica

**2. Frontend envía POST a Gateway**
```http
POST /auth/login
Content-Type: application/json

{
  "correo": "cristian.monsalve@colegio.cl",
  "password": "miPassword123"
}
```

**3. API Gateway enruta a Auth Service**
- El Gateway NO valida JWT aquí (es login, no hay token aún)
- Simplemente redirige la petición al microservicio `auth-service`

**4. Auth Service consulta base de datos**
```sql
SELECT id, correo, password_hash, rol, nombre, apellido
FROM usuarios
WHERE correo = 'cristian.monsalve@colegio.cl'
  AND activo = true;
```

**5. Base de datos retorna datos del usuario**
```json
{
  "id": 123,
  "correo": "cristian.monsalve@colegio.cl",
  "password_hash": "$2a$10$N9qo8uLOickgx2ZM...",
  "rol": "DOCENTE",
  "nombre": "Cristian",
  "apellido": "Monsalve"
}
```

**6. Auth Service valida password con BCrypt**
```java
boolean passwordValido = BCrypt.checkpw(
    passwordIngresado,     // "miPassword123"
    passwordHashBD         // "$2a$10$N9qo8uLOickgx2ZM..."
);
```

**BCrypt explica:**
- NO guarda passwords en texto plano
- Genera un hash único usando "salt" (sal aleatoria)
- Imposible revertir el hash al password original
- 10 rounds = suficientemente seguro vs. ataques de fuerza bruta

**7. Si password es válido, genera JWT Token**

El JWT se compone de 3 partes separadas por puntos (`.`):

```
HEADER.PAYLOAD.SIGNATURE
```

**HEADER** (metadata):
```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

**PAYLOAD** (claims - datos del usuario):
```json
{
  "userId": 123,
  "correo": "cristian.monsalve@colegio.cl",
  "rol": "DOCENTE",
  "nombre": "Cristian Monsalve",
  "iat": 1711700000,    // Issued at (timestamp)
  "exp": 1711786400     // Expiration (24 horas después)
}
```

**SIGNATURE** (firma digital):
```
HMACSHA256(
  base64UrlEncode(header) + "." + base64UrlEncode(payload),
  SECRET_KEY
)
```

**Token JWT completo (ejemplo):**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEyMywiY29ycmVvIjoiY3Jpc3RpYW4ubW9uc2FsdmVAY29sZWdpby5jbCIsInJvbCI6IkRPQ0VOVEUiLCJub21icmUiOiJDcmlzdGlhbiBNb25zYWx2ZSIsImlhdCI6MTcxMTcwMDAwMCwiZXhwIjoxNzExNzg2NDAwfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

**8-9. Auth Service retorna token al Gateway, Gateway al Frontend**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "usuario": {
    "id": 123,
    "nombre": "Cristian Monsalve",
    "rol": "DOCENTE"
  }
}
```

**10. Frontend guarda token**
```javascript
localStorage.setItem('jwt_token', response.token);
localStorage.setItem('user', JSON.stringify(response.usuario));
```

**11. Frontend redirige a Dashboard según rol**
- ADMIN → `/admin/dashboard`
- DOCENTE → `/docente/dashboard`
- APODERADO → `/apoderado/dashboard`
- ESTUDIANTE → `/estudiante/dashboard`

#### ❌ FLUJO ALTERNATIVO: Credenciales inválidas

Si el password es incorrecto o el usuario no existe:

```
Auth Service → Gateway: 401 Unauthorized
Gateway → Frontend: 401 Unauthorized
Frontend → Usuario: "Credenciales inválidas"
```

**NO se revela** si el correo existe o si el password es incorrecto (seguridad).

---

### 📍 FASE 2: ACCESO A RECURSOS PROTEGIDOS (AUTORIZACIÓN)

**Objetivo:** Verificar que el token es válido y que el usuario tiene permisos para acceder al recurso.

#### Ejemplo práctico: Docente quiere ver calificaciones del curso 3°A

**12. Usuario solicita ver calificaciones**
- Acción: Docente hace click en "Ver calificaciones de 3°A"

**13. Frontend envía GET con JWT en header**
```http
GET /academic/calificaciones/curso/123
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**14. API Gateway VALIDA el JWT (CRÍTICO)**

El Gateway realiza 3 validaciones:

**Validación 1: Verifica la firma digital**
```java
Claims claims = Jwts.parser()
    .setSigningKey(SECRET_KEY)
    .parseClaimsJws(token)
    .getBody();
```

Si alguien modificó el payload (ej: cambió rol de ESTUDIANTE a ADMIN), la firma no coincidirá y se rechaza el token.

**Validación 2: Verifica que no expiró**
```java
if (claims.getExpiration().before(new Date())) {
    throw new ExpiredJwtException("Token expirado");
}
```

**Validación 3: Consulta blacklist (tokens revocados)**
```sql
SELECT COUNT(*) FROM token_blacklist
WHERE token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

Si el usuario hizo logout o cambió su password, el token estará en blacklist.

**15. Gateway verifica permisos (RBAC)**

```java
String rol = claims.get("rol", String.class);
String endpoint = "/academic/calificaciones/curso/123";

// Matriz de permisos
boolean autorizado = authorizationService.canAccess(rol, endpoint);
```

**Matriz de permisos (ejemplo):**

| ROL | Puede acceder a `/academic/calificaciones/curso/:id` |
|-----|------------------------------------------------------|
| ADMIN | ✅ SÍ (todos los cursos) |
| DOCENTE | ✅ SÍ (solo cursos que dicta) |
| APODERADO | ❌ NO |
| ESTUDIANTE | ❌ NO |

**16. Si autorizado, Gateway enruta a Academic Service**

El Gateway agrega headers personalizados para que el microservicio sepa quién está llamando:

```http
GET /calificaciones/curso/123
X-User-Id: 123
X-User-Role: DOCENTE
X-User-Email: cristian.monsalve@colegio.cl
```

**17-18. Academic Service consulta BD**

El servicio hace validación adicional de negocio:

```java
@GetMapping("/calificaciones/curso/{cursoId}")
public ResponseEntity<?> obtenerCalificaciones(
    @PathVariable Long cursoId,
    @RequestHeader("X-User-Id") Long userId,
    @RequestHeader("X-User-Role") String rol) {
    
    // Validación adicional: docente solo ve sus propios cursos
    if (rol.equals("DOCENTE")) {
        if (!docenteService.dictaCurso(userId, cursoId)) {
            return ResponseEntity.status(403).body("No dictas este curso");
        }
    }
    
    // Si pasa validación, obtener datos
    List<Calificacion> calificaciones = service.obtenerPorCurso(cursoId);
    return ResponseEntity.ok(calificaciones);
}
```

```sql
SELECT c.id, c.nota, e.nombre AS estudiante, ev.titulo AS evaluacion
FROM calificaciones c
JOIN estudiantes e ON c.estudiante_id = e.id
JOIN evaluaciones ev ON c.evaluacion_id = ev.id
WHERE ev.asignatura_curso_id IN (
    SELECT id FROM asignatura_curso WHERE curso_id = 123
);
```

**19-21. Respuesta exitosa**

```json
{
  "calificaciones": [
    {
      "estudiante": "Juan Pérez",
      "evaluacion": "Prueba Matemáticas 1",
      "nota": 6.5
    },
    {
      "estudiante": "María González",
      "evaluacion": "Prueba Matemáticas 1",
      "nota": 5.8
    }
  ]
}
```

Frontend recibe los datos y los muestra en una tabla.

#### ❌ FLUJOS ALTERNATIVOS

**Token inválido/expirado:**
```
Gateway → Frontend: 401 Unauthorized "Token inválido o expirado"
Frontend → Usuario: Redirige a login
```

**Rol no autorizado:**
```
Gateway → Frontend: 403 Forbidden "No tienes permisos"
Frontend → Usuario: Mensaje de error amigable
```

---

### 📍 FASE 3: REFRESH TOKEN (OPCIONAL)

**Objetivo:** Renovar JWT sin pedir credenciales nuevamente (mejor UX).

**¿Por qué?**
- JWT expira en 24 horas (seguridad)
- Sería molesto que el usuario tenga que hacer login cada 24h
- Refresh token dura 7 días

**Flujo:**

**1. Frontend detecta que token está cerca de expirar**
```javascript
function isTokenExpiringSoon(token) {
    const payload = JSON.parse(atob(token.split('.')[1]));
    const exp = payload.exp * 1000; // convertir a ms
    const now = Date.now();
    const timeLeft = exp - now;
    
    // Si quedan menos de 30 minutos
    return timeLeft < 30 * 60 * 1000;
}
```

**2. Frontend solicita renovación**
```http
POST /auth/refresh
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**3. Auth Service valida token actual y genera uno nuevo**
```java
// Validar token actual
Claims claims = jwtUtil.validateToken(currentToken);

// Generar nuevo token (24h más)
String newToken = jwtUtil.generateToken(
    claims.get("userId"),
    claims.get("correo"),
    claims.get("rol")
);

return new TokenResponse(newToken);
```

**4. Frontend actualiza token en storage**
```javascript
localStorage.setItem('jwt_token', newToken);
```

El usuario **no se da cuenta** que el token se renovó (experiencia fluida).

---

### 🔑 CONCEPTOS CLAVE A DOMINAR

#### ¿Qué es JWT?

**JSON Web Token** = Estándar abierto (RFC 7519) para transmitir información de forma segura entre partes.

**Ventajas:**
- ✅ **Stateless**: No requiere sesiones en servidor (escalable)
- ✅ **Portable**: Funciona cross-domain, cross-platform
- ✅ **Auto-contenido**: Toda la info está en el token
- ✅ **Compacto**: Pequeño, se envía en headers HTTP

**Desventajas:**
- ❌ No se puede revocar fácilmente (solución: blacklist)
- ❌ Si se roba el token, el atacante tiene acceso (solución: HTTPS + expiración corta)

#### ¿Qué es BCrypt?

Algoritmo de hash de contraseñas basado en **Blowfish cipher**.

**Características:**
- **Salt automático**: Cada hash es único aunque el password sea igual
- **Adaptive**: Configurable con "rounds" (trabajo computacional)
- **Lento a propósito**: Dificulta ataques de fuerza bruta

**Ejemplo:**
```
Password: "hola123"
BCrypt hash: $2a$10$N9qo8uLOickgx2ZMWxzQHOeGpxxAWblSKs5F3sTVLAqFoLOXfUcKq

$2a$ = versión BCrypt
$10$ = 10 rounds (2^10 = 1024 iteraciones)
N9qo8uLOickgx2ZMWxzQHO = salt (22 caracteres)
eGpxxAWblSKs5F3sTVLAqFoLOXfUcKq = hash
```

#### ¿Qué es RBAC?

**Role-Based Access Control** = Control de acceso basado en roles.

**Principio:** Los permisos se asignan a roles, los usuarios tienen roles.

```
Usuario → Rol → Permisos

Cristian Monsalve → DOCENTE → [ver_calificaciones, registrar_asistencia, crear_anotaciones]
```

**Alternativa:** ABAC (Attribute-Based) - más complejo, mayor granularidad.

Para nuestro proyecto, RBAC es suficiente (solo 4 roles).

---

### 🎯 RESUMEN FASE 1, 2 y 3

| Fase | Qué hace | Tecnología clave | Salida |
|------|----------|------------------|--------|
| **1. Login** | Valida credenciales y genera token | BCrypt + JWT | Token JWT válido 24h |
| **2. Acceso** | Valida token y verifica permisos | JWT validation + RBAC | Datos solicitados |
| **3. Refresh** | Renueva token sin re-login | JWT + Refresh tokens | Nuevo token JWT |

---

## DIAGRAMA 2: MODELO DE DATOS DE SEGURIDAD

**Archivo:** `diagrams/security_data_model.png` y `diagrams/security_data_model.puml`

### ¿Qué muestra este diagrama?

Un **diagrama Entidad-Relación (ER)** que documenta las 3 tablas principales de seguridad y sus relaciones:

1. **usuarios** - Tabla principal con credenciales y roles
2. **refresh_tokens** - Tokens de larga duración para renovar JWT
3. **token_blacklist** - Lista de tokens revocados antes de expiración

### 📊 TABLA 1: usuarios

**Propósito:** Almacenar información de todos los usuarios del sistema.

**Estructura completa:**

```sql
CREATE TABLE usuarios (
  id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  correo VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  nombre VARCHAR(100),
  apellido VARCHAR(100),
  telefono VARCHAR(50),
  rol VARCHAR(30) NOT NULL,
  activo BOOLEAN DEFAULT true,
  creado_en TIMESTAMPTZ DEFAULT now(),
  actualizado_en TIMESTAMPTZ DEFAULT now()
);
```

**Campos explicados:**

| Campo | Tipo | Descripción | Ejemplo |
|-------|------|-------------|---------|
| `id` | BIGINT | Identificador único auto-incremental | 123 |
| `correo` | VARCHAR(255) | Email único del usuario (usado para login) | cristian.monsalve@colegio.cl |
| `password_hash` | VARCHAR(255) | Hash BCrypt del password (NUNCA texto plano) | $2a$10$N9qo8uLOickgx2ZMWxzQHO... |
| `nombre` | VARCHAR(100) | Nombre del usuario | Cristian |
| `apellido` | VARCHAR(100) | Apellido | Monsalve |
| `telefono` | VARCHAR(50) | Teléfono de contacto (opcional) | +56912345678 |
| `rol` | VARCHAR(30) | Rol del usuario (ADMIN, DOCENTE, APODERADO, ESTUDIANTE) | DOCENTE |
| `activo` | BOOLEAN | Si el usuario puede acceder (soft delete) | true |
| `creado_en` | TIMESTAMPTZ | Cuándo se creó la cuenta | 2026-03-01 10:30:00 |
| `actualizado_en` | TIMESTAMPTZ | Última modificación | 2026-03-15 14:20:00 |

**Notas importantes:**

✅ **Password NUNCA en texto plano**
```sql
-- ❌ MAL
password VARCHAR(255) -- "miPassword123"

-- ✅ BIEN
password_hash VARCHAR(255) -- "$2a$10$N9qo8uLOickgx2ZMWxzQHO..."
```

✅ **Correo UNIQUE** - No puede haber usuarios duplicados

✅ **Rol definido por VARCHAR** - Simple, suficiente para 4 roles. Alternativa: tabla separada `roles` si necesitáramos más flexibilidad.

✅ **Campo `activo`** - Permite desactivar usuarios sin eliminarlos (soft delete). Si activo=false, no puede hacer login.

**Roles permitidos:**

```java
public enum Rol {
    ADMIN,      // Administrador del sistema
    DOCENTE,    // Profesor/Instructor
    APODERADO,  // Padre/Tutor legal
    ESTUDIANTE  // Alumno
}
```

**Ejemplo de registro:**

```sql
INSERT INTO usuarios (correo, password_hash, nombre, apellido, rol)
VALUES (
  'cristian.monsalve@colegio.cl',
  '$2a$10$N9qo8uLOickgx2ZMWxzQHOeGpxxAWblSKs5F3sTVLAqFoLOXfUcKq', -- hash de "MiPassword123"
  'Cristian',
  'Monsalve',
  'DOCENTE'
);
```

---

### 🔄 TABLA 2: refresh_tokens

**Propósito:** Permitir renovación de JWT sin solicitar credenciales nuevamente.

**Estructura:**

```sql
CREATE TABLE refresh_tokens (
  id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  usuario_id BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
  token VARCHAR(500) UNIQUE NOT NULL,
  fecha_expiracion TIMESTAMPTZ NOT NULL,
  creado_en TIMESTAMPTZ DEFAULT now(),
  revocado BOOLEAN DEFAULT false
);

CREATE INDEX idx_refresh_tokens_usuario ON refresh_tokens(usuario_id);
```

**Campos explicados:**

| Campo | Tipo | Descripción | Ejemplo |
|-------|------|-------------|---------|
| `id` | BIGINT | ID del refresh token | 456 |
| `usuario_id` | BIGINT FK | A qué usuario pertenece | 123 → Cristian Monsalve |
| `token` | VARCHAR(500) | El refresh token (string largo aleatorio) | `rt_7f3b9c8a2d1e5f6...` |
| `fecha_expiracion` | TIMESTAMPTZ | Cuándo expira (7 días típicamente) | 2026-03-29 10:00:00 |
| `creado_en` | TIMESTAMPTZ | Cuándo se creó | 2026-03-22 10:00:00 |
| `revocado` | BOOLEAN | Si se invalidó (logout) | false |

**¿Cómo funciona?**

**Escenario 1: Login exitoso**
```java
// 1. Generar JWT (expira en 24h)
String jwt = generateJWT(user);

// 2. Generar refresh token (expira en 7 días)
String refreshToken = generateSecureRandomToken(); // UUID aleatorio
Date expiration = Date.from(Instant.now().plus(7, ChronoUnit.DAYS));

// 3. Guardar en BD
INSERT INTO refresh_tokens (usuario_id, token, fecha_expiracion)
VALUES (123, 'rt_7f3b9c8a2d1e5f6...', '2026-03-29 10:00:00');

// 4. Retornar ambos al frontend
return {
  jwt: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  refreshToken: "rt_7f3b9c8a2d1e5f6..."
};
```

**Escenario 2: JWT expiró, renovar con refresh token**
```java
// Frontend detecta que JWT expiró
POST /auth/refresh
Body: {
  refreshToken: "rt_7f3b9c8a2d1e5f6..."
}

// Backend valida
SELECT * FROM refresh_tokens
WHERE token = 'rt_7f3b9c8a2d1e5f6...'
  AND revocado = false
  AND fecha_expiracion > now();

// Si válido, generar nuevo JWT
String newJWT = generateJWT(user);

// Retornar
return { jwt: newJWT };
```

**Escenario 3: Logout (revocar refresh token)**
```java
// Usuario hace logout
UPDATE refresh_tokens
SET revocado = true
WHERE usuario_id = 123 AND revocado = false;
```

**Ventaja:** El usuario NO tiene que hacer login cada 24 horas. Solo cada 7 días (o al cerrar sesión).

**Seguridad:** 
- Refresh token se guarda en BD (podemos revocarlo)
- JWT NO se guarda en BD (stateless, no podemos revocarlo fácilmente → usamos blacklist)

---

### 🚫 TABLA 3: token_blacklist

**Propósito:** Invalidar JWTs antes de su expiración natural.

**Estructura:**

```sql
CREATE TABLE token_blacklist (
  id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  token VARCHAR(500) UNIQUE NOT NULL,
  usuario_id BIGINT REFERENCES usuarios(id),
  razon VARCHAR(100),
  blacklisted_en TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_token_blacklist_token ON token_blacklist(token);
```

**Campos explicados:**

| Campo | Tipo | Descripción | Ejemplo |
|-------|------|-------------|---------|
| `id` | BIGINT | ID del registro | 789 |
| `token` | VARCHAR(500) | JWT completo que se invalida | eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9... |
| `usuario_id` | BIGINT FK | Qué usuario tenía este token | 123 |
| `razon` | VARCHAR(100) | Por qué se invalidó | LOGOUT, PASSWORD_CHANGED, COMPROMISED |
| `blacklisted_en` | TIMESTAMPTZ | Cuándo se agregó | 2026-03-22 15:30:00 |

**¿Cuándo se usa?**

**Caso 1: LOGOUT**
```java
// Usuario hace logout
POST /auth/logout
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

// Backend agrega token a blacklist
INSERT INTO token_blacklist (token, usuario_id, razon)
VALUES (
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  123,
  'LOGOUT'
);

// Respuesta
return { message: "Logout exitoso" };
```

Ahora ese JWT queda inválido aunque no haya expirado.

**Caso 2: PASSWORD_CHANGED**
```java
// Usuario cambió su contraseña
// Invalidar TODOS sus tokens activos

// 1. Obtener todos los tokens activos del usuario (difícil, no los guardamos)
// Solución: Agregar claim "iat" (issued at) y validar contra tabla usuarios.actualizado_en

// Alternativa simple: Agregar campo last_password_change en usuarios
UPDATE usuarios SET last_password_change = now() WHERE id = 123;

// Al validar JWT:
if (jwt.iat < user.last_password_change) {
    throw new InvalidTokenException("Password fue cambiado");
}
```

**Caso 3: COMPROMISED (seguridad comprometida)**
```java
// Administrador detecta actividad sospechosa
// Manualmente invalida token de usuario

INSERT INTO token_blacklist (token, usuario_id, razon)
VALUES (
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  123,
  'COMPROMISED - Actividad sospechosa detectada'
);
```

**Validación en API Gateway:**

```java
public boolean isTokenValid(String token) {
    // 1. Validar firma y expiración
    Claims claims = jwtUtil.validateToken(token);
    
    // 2. Consultar blacklist
    boolean isBlacklisted = blacklistRepository.existsByToken(token);
    
    if (isBlacklisted) {
        throw new InvalidTokenException("Token revocado");
    }
    
    return true;
}
```

**Consulta SQL en cada request:**
```sql
SELECT COUNT(*) FROM token_blacklist
WHERE token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';

-- Si COUNT > 0 → token en blacklist → rechazar
```

**Optimización:** Usar caché (Redis) para evitar consultar BD en cada request.

**Limpieza periódica:**
```sql
-- Job nocturno: eliminar tokens ya expirados de blacklist
DELETE FROM token_blacklist
WHERE blacklisted_en < (now() - INTERVAL '7 days');
```

---

### 🔗 RELACIONES ENTRE TABLAS

**1. usuarios → refresh_tokens (1:N)**
- Un usuario puede tener **múltiples refresh tokens** activos (ej: login desde PC y móvil)
- Foreign key: `refresh_tokens.usuario_id → usuarios.id`
- On delete: CASCADE (si elimino usuario, elimino sus refresh tokens)

**2. usuarios → token_blacklist (1:N)**
- Un usuario puede tener **múltiples tokens en blacklist** (histórico)
- Foreign key: `token_blacklist.usuario_id → usuarios.id`
- On delete: SET NULL (podemos mantener histórico aunque el usuario se elimine)

---

### 🎯 RESUMEN MODELO DE DATOS

| Tabla | Registros típicos | Propósito | Tiempo de retención |
|-------|-------------------|-----------|---------------------|
| **usuarios** | ~500-1000 (colegio mediano) | Credenciales y perfiles | Permanente (soft delete) |
| **refresh_tokens** | ~100-200 (usuarios activos × dispositivos) | Renovación sin re-login | 7 días automático |
| **token_blacklist** | ~50-100 (logouts y cambios de password) | Invalidación de JWT | 7 días, limpieza periódica |

---

## DIAGRAMA 3: ARQUITECTURA DE COMPONENTES DE SEGURIDAD

**Archivo:** `diagrams/security_architecture.png` y `diagrams/security_architecture.puml`

### ¿Qué muestra este diagrama?

Un **diagrama de componentes y capas** que muestra cómo se organiza la seguridad en nuestra arquitectura de microservicios. Documenta:

1. Flujo de autenticación (flecha naranja/roja)
2. Flujo de autorización (flechas azules)
3. Componentes de seguridad en cada capa
4. Responsabilidades de cada componente

### 🏗️ ARQUITECTURA POR CAPAS

La arquitectura se divide en 4 capas claramente separadas:

---

### 🌐 CAPA 1: INTERNET (Externa)

**Componente:** Usuario Final

**Descripción:** Actores humanos que acceden al sistema desde navegador web o app móvil.

**Tipos de usuarios:**
- Administradores (gestión del sistema)
- Docentes (registro académico)
- Apoderados (consulta de información)
- Estudiantes (consulta de notas)

**Acceso:** HTTPS público (puerto 443), expuesto a Internet.

---

### 💻 CAPA 2: PRESENTACIÓN (Frontend)

**Componente principal:** Frontend (React + TypeScript)

**Sub-componentes de seguridad:**

#### 1. Login Page
- **Responsabilidad:** Capturar credenciales (correo + password)
- **Validaciones:**
  - Formato de email válido
  - Password mínimo 8 caracteres
  - Prevención XSS (sanitizar inputs)

**Código ejemplo:**
```typescript
const handleLogin = async (e: FormEvent) => {
  e.preventDefault();
  
  // Validación básica
  if (!isValidEmail(correo)) {
    setError("Email inválido");
    return;
  }
  
  try {
    const response = await authService.login({ correo, password });
    
    // Guardar token
    localStorage.setItem('jwt_token', response.token);
    
    // Redirigir según rol
    if (response.usuario.rol === 'DOCENTE') {
      navigate('/docente/dashboard');
    }
  } catch (error) {
    setError("Credenciales inválidas");
  }
};
```

#### 2. Dashboard
- **Responsabilidad:** Mostrar interfaz según rol
- **Seguridad:** Rutas protegidas con guards

**Código ejemplo:**
```typescript
// ProtectedRoute.tsx
const ProtectedRoute = ({ children, allowedRoles }) => {
  const token = localStorage.getItem('jwt_token');
  const user = JSON.parse(localStorage.getItem('user'));
  
  if (!token) {
    return <Navigate to="/login" />;
  }
  
  if (!allowedRoles.includes(user.rol)) {
    return <Navigate to="/unauthorized" />;
  }
  
  return children;
};

// Uso
<Route path="/docente/dashboard" element={
  <ProtectedRoute allowedRoles={['DOCENTE', 'ADMIN']}>
    <DocenteDashboard />
  </ProtectedRoute>
} />
```

#### 3. Auth Interceptor (Axios)
- **Responsabilidad:** Agregar JWT automáticamente a TODAS las peticiones HTTP
- **Manejo de errores:** Detectar 401 y redirigir a login

**Código ejemplo:**
```typescript
// axios-interceptor.ts
import axios from 'axios';

// Request interceptor: agregar JWT a headers
axios.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('jwt_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Response interceptor: manejar errores de auth
axios.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Token inválido o expirado
      localStorage.removeItem('jwt_token');
      localStorage.removeItem('user');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);
```

**Flujo de request:**
```
Frontend → Axios interceptor agrega JWT → API Gateway
```

---

### 🛡️ CAPA 3: API GATEWAY (Control de Seguridad)

**Componente principal:** API Gateway (Spring Cloud Gateway)

**Responsabilidad crítica:** **ÚNICO PUNTO DE VALIDACIÓN DE SEGURIDAD**

Todos los requests pasan por aquí ANTES de llegar a microservicios.

**Sub-componentes:**

#### 1. JWT Validator
- **Acción:** Valida firma, expiración y claims de JWT
- **Resultado:** Extrae `userId`, `rol`, `correo` del token

**Código ejemplo:**
```java
@Component
public class JWTValidator {
    
    @Value("${jwt.secret}")
    private String secretKey;
    
    public Claims validateToken(String token) throws InvalidTokenException {
        try {
            return Jwts.parser()
                .setSigningKey(secretKey)
                .parseClaimsJws(token)
                .getBody();
        } catch (ExpiredJwtException e) {
            throw new InvalidTokenException("Token expirado");
        } catch (SignatureException e) {
            throw new InvalidTokenException("Firma inválida");
        }
    }
}
```

#### 2. Route Filter
- **Acción:** Decide a qué microservicio enrutar según path
- **Modificación:** Agrega headers `X-User-Id`, `X-User-Role` para microservicios

**Configuración:**
```yaml
spring:
  cloud:
    gateway:
      routes:
        - id: academic-service
          uri: lb://academic-service
          predicates:
            - Path=/academic/**
          filters:
            - StripPrefix=1
            - name: JWTAuthenticationFilter  # Custom filter
```

**Custom Filter:**
```java
@Component
public class JWTAuthenticationFilter implements GatewayFilter {
    
    @Autowired
    private JWTValidator jwtValidator;
    
    @Autowired
    private TokenBlacklistService blacklistService;
    
    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        String token = extractTokenFromHeader(exchange.getRequest());
        
        if (token == null) {
            exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
            return exchange.getResponse().setComplete();
        }
        
        try {
            // Validar JWT
            Claims claims = jwtValidator.validateToken(token);
            
            // Consultar blacklist
            if (blacklistService.isBlacklisted(token)) {
                exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
                return exchange.getResponse().setComplete();
            }
            
            // Agregar claims como headers
            ServerHttpRequest modifiedRequest = exchange.getRequest().mutate()
                .header("X-User-Id", claims.get("userId").toString())
                .header("X-User-Role", claims.get("rol").toString())
                .header("X-User-Email", claims.get("correo").toString())
                .build();
            
            // Continuar con request modificado
            return chain.filter(exchange.mutate().request(modifiedRequest).build());
            
        } catch (InvalidTokenException e) {
            exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
            return exchange.getResponse().setComplete();
        }
    }
}
```

#### 3. CORS Config
- **Acción:** Configurar políticas Cross-Origin Resource Sharing
- **Permite:** Frontend (localhost:3000 en dev, dominio en prod) puede llamar API

**Configuración:**
```yaml
spring:
  cloud:
    gateway:
      globalcors:
        cors-configurations:
          '[/**]':
            allowed-origins: 
              - "https://colegio-frontend.com"
              - "http://localhost:3000"  # Dev
            allowed-methods:
              - GET
              - POST
              - PUT
              - DELETE
              - OPTIONS
            allowed-headers: "*"
            allow-credentials: true
            max-age: 3600
```

#### 4. Rate Limiter
- **Acción:** Limitar requests por usuario/IP para prevenir ataques
- **Estrategia:** Token bucket algorithm

**Configuración:**
```yaml
spring:
  cloud:
    gateway:
      routes:
        - id: academic-service
          filters:
            - name: RequestRateLimiter
              args:
                redis-rate-limiter.replenishRate: 10  # 10 requests/segundo
                redis-rate-limiter.burstCapacity: 20  # máximo burst
                key-resolver: "#{@userKeyResolver}"    # por userId
```

**Resultado si se excede:** `429 Too Many Requests`

---

**Responsabilidades del API Gateway (Notas del diagrama):**

✅ Validar JWT en cada petición  
✅ Verificar expiración de token  
✅ Aplicar CORS policies  
✅ Rate limiting por usuario  
✅ Logging de accesos  

**Ventaja de centralizar:** Un solo lugar para cambiar lógica de seguridad, no replicar en cada microservicio.

---

### ⚙️ CAPA 4: MICROSERVICIOS

Cada microservicio tiene componentes de seguridad similares:

#### Auth Service (Especial - no requiere JWT)

**Sub-componentes:**

**1. JWT Generator**
```java
@Component
public class JWTGenerator {
    
    @Value("${jwt.secret}")
    private String secretKey;
    
    @Value("${jwt.expiration}")
    private long expiration; // 24 horas en ms
    
    public String generateToken(Long userId, String correo, String rol) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + expiration);
        
        return Jwts.builder()
            .claim("userId", userId)
            .claim("correo", correo)
            .claim("rol", rol)
            .setIssuedAt(now)
            .setExpiration(expiryDate)
            .signWith(SignatureAlgorithm.HS256, secretKey)
            .compact();
    }
}
```

**2. Password Encoder (BCrypt)**
```java
@Configuration
public class SecurityConfig {
    
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(10); // 10 rounds
    }
}

// Uso en servicio
@Service
public class AuthService {
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    public void crearUsuario(String correo, String passwordPlano) {
        String passwordHash = passwordEncoder.encode(passwordPlano);
        
        Usuario usuario = new Usuario();
        usuario.setCorreo(correo);
        usuario.setPasswordHash(passwordHash);
        
        usuarioRepository.save(usuario);
    }
    
    public boolean validarPassword(String passwordPlano, String passwordHash) {
        return passwordEncoder.matches(passwordPlano, passwordHash);
    }
}
```

**3. User Service**
- CRUD de usuarios
- Gestión de roles
- Activar/desactivar cuentas

#### Academic Service, Attendance Service, Messaging Service

**Sub-componentes comunes:**

**1. Role Validator**
```java
@Component
public class RoleValidator {
    
    public boolean canAccessEndpoint(String rol, String endpoint) {
        // Matriz de permisos
        Map<String, List<String>> permissions = Map.of(
            "ADMIN", List.of("/**"),  // acceso total
            "DOCENTE", List.of("/calificaciones/**", "/asistencia/**", "/anotaciones/**"),
            "APODERADO", List.of("/calificaciones/estudiante/**"),
            "ESTUDIANTE", List.of("/calificaciones/estudiante/**", "/asistencia/estudiante/**")
        );
        
        List<String> allowedPaths = permissions.get(rol);
        return allowedPaths.stream().anyMatch(endpoint::startsWith);
    }
}
```

**2. Business Logic**
- Lógica de negocio específica del dominio
- Validaciones adicionales (ej: docente solo ve sus cursos)
- Interacción con BD

**Ejemplo:**
```java
@RestController
@RequestMapping("/api/calificaciones")
public class CalificacionController {
    
    @Autowired
    private RoleValidator roleValidator;
    
    @Autowired
    private CalificacionService service;
    
    @GetMapping("/estudiante/{estudianteId}")
    public ResponseEntity<?> obtenerCalificaciones(
            @PathVariable Long estudianteId,
            @RequestHeader("X-User-Id") Long userId,
            @RequestHeader("X-User-Role") String rol) {
        
        // Validación de permisos
        if (!roleValidator.canAccessEndpoint(rol, "/calificaciones/estudiante")) {
            return ResponseEntity.status(403).build();
        }
        
        // Validación de negocio
        if (rol.equals("ESTUDIANTE") && !estudianteId.equals(userId)) {
            return ResponseEntity.status(403)
                .body("Solo puedes ver tus propias calificaciones");
        }
        
        if (rol.equals("APODERADO")) {
            if (!apoderadoService.esApoderadoDe(userId, estudianteId)) {
                return ResponseEntity.status(403)
                    .body("No eres apoderado de este estudiante");
            }
        }
        
        // Si pasa validaciones, obtener datos
        List<CalificacionDTO> calificaciones = service.obtenerPorEstudiante(estudianteId);
        return ResponseEntity.ok(calificaciones);
    }
}
```

---

### 💾 CAPA 5: DATOS

**Componente:** PostgreSQL

**Tablas de seguridad:**
- `usuarios` - Credenciales y roles
- `roles` - (opcional) Catálogo de roles
- `permisos` - (opcional) Catálogo de permisos
- `refresh_tokens` - Tokens de larga duración
- `token_blacklist` - Tokens revocados

**Notas del diagrama:**

**Modelo de Seguridad:**
- Usuarios con rol único (ADMIN, DOCENTE, APODERADO, ESTUDIANTE)
- Password hasheado con BCrypt
- Opcional: tabla de refresh_tokens
- Opcional: tabla de token_blacklist

---

### 🔄 FLUJOS COMPLETOS EN EL DIAGRAMA

**Flujo de Autenticación (flechas naranjas/rojas):**

```
1. Usuario accede a Frontend
2. Frontend envía credenciales a Gateway (HTTP/HTTPS)
3. Gateway enruta a Auth Service (/auth/login)
4. Auth Service valida contra PostgreSQL
5. PostgreSQL retorna usuario + rol
6. Auth Service genera JWT Token
7. Gateway retorna token a Frontend
```

**Flujo de Autorización (flechas azules):**

```
8. Frontend envía request + JWT a Gateway
9. Gateway valida token con JWT Validator
10. Gateway extrae claims (userId, rol)
11. Gateway enruta a Academic Service (u otro)
12. Microservicio verifica rol con Role Validator
13. Si autorizado, Business Logic ejecuta
14. Business Logic consulta PostgreSQL
15. Respuesta sube por las capas hasta Frontend
```

---

### 🎯 RESUMEN ARQUITECTURA DE SEGURIDAD

**Principios aplicados:**

✅ **Defense in Depth** (Defensa en profundidad)
- Validación en Gateway (primera línea)
- Validación en microservicio (segunda línea)
- Validación de negocio (tercera línea)

✅ **Separation of Concerns** (Separación de responsabilidades)
- Auth Service: solo autenticación
- Gateway: solo validación de tokens
- Microservicios: solo autorización de negocio

✅ **Least Privilege** (Mínimo privilegio)
- Cada rol tiene acceso mínimo necesario
- Validaciones granulares (no solo por rol, también por ownership)

✅ **Single Point of Entry** (Punto único de entrada)
- TODO pasa por API Gateway
- No hay acceso directo a microservicios

---

## CONSIDERACIONES PARA AWS

### Opción 1: AWS API Gateway + Lambda + Cognito

**Arquitectura:**

```
Internet → AWS API Gateway → Lambda Authorizer (JWT) → Lambda Functions
                              ↓
                         AWS Cognito (gestión de usuarios)
                              ↓
                         RDS PostgreSQL
```

**Componentes AWS:**

**1. AWS API Gateway**
- Reemplaza nuestro Spring Cloud Gateway
- Manejo nativo de JWT con authorizers
- Rate limiting integrado
- Certificados SSL automáticos

**Configuración de Authorizer:**
```json
{
  "type": "TOKEN",
  "authorizerUri": "arn:aws:lambda:us-east-1:123456789:function:jwt-authorizer",
  "authorizerResultTtlInSeconds": 300,
  "identitySource": "method.request.header.Authorization"
}
```

**Lambda Authorizer (pseudocódigo):**
```python
def lambda_handler(event, context):
    token = event['authorizationToken'].replace('Bearer ', '')
    
    # Validar JWT
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
    except:
        raise Exception('Unauthorized')
    
    # Generar IAM policy
    return {
        'principalId': payload['userId'],
        'policyDocument': {
            'Statement': [{
                'Action': 'execute-api:Invoke',
                'Effect': 'Allow',
                'Resource': event['methodArn']
            }]
        },
        'context': {
            'userId': payload['userId'],
            'rol': payload['rol']
        }
    }
```

**2. AWS Cognito**
- Alternativa a auth-service custom
- Gestión de usuarios integrada
- Provee JWT automáticamente
- Soporta MFA, password policies

**Ventajas:**
- ✅ No tenemos que implementar autenticación
- ✅ Escalable automáticamente
- ✅ Integración con  social login (Google, Facebook)

**Desventajas:**
- ❌ Vendor lock-in (AWS)
- ❌ Menos control sobre lógica custom

**3. AWS Lambda**
- Microservicios como funciones serverless
- Auto-scaling
- Pay-per-use

**4. RDS PostgreSQL**
- Base de datos gestionada
- Backups automáticos
- Encriptación at-rest

**5. AWS Secrets Manager**
- Almacenar JWT secret key
- Rotación automática de secretos

**Configuración:**
```java
@Configuration
public class AWSSecretsConfig {
    
    @Bean
    public String jwtSecret() {
        AWSSecretsManager client = AWSSecretsManagerClientBuilder.defaultClient();
        GetSecretValueRequest request = new GetSecretValueRequest()
            .withSecretId("prod/jwt-secret");
        GetSecretValueResult result = client.getSecretValue(request);
        return result.getSecretString();
    }
}
```

---

### Opción 2: ECS/Fargate + Application Load Balancer

**Arquitectura:**

```
Internet → ALB (HTTPS) → ECS/Fargate Tasks
                         ├─ auth-service (container)
                         ├─ academic-service (container)
                         ├─ attendance-service (container)
                         └─ messaging-service (container)
```

**Componentes AWS:**

**1. Application Load Balancer (ALB)**
- HTTPS termination con ACM
- Routing basado en path
- Health checks

**Configuración de routing:**
```yaml
- Path: /auth/*
  Target: auth-service-target-group
  
- Path: /academic/*
  Target: academic-service-target-group
```

**2. ECS (Elastic Container Service) con Fargate**
- Contenedores sin gestionar servidores
- Auto-scaling por CPU/memoria
- Integración con ECR (container registry)

**Task Definition (ejemplo):**
```json
{
  "family": "auth-service",
  "networkMode": "awsvpc",
  "containerDefinitions": [{
    "name": "auth-service",
    "image": "123456789.dkr.ecr.us-east-1.amazonaws.com/auth-service:latest",
    "cpu": 256,
    "memory": 512,
    "portMappings": [{
      "containerPort": 8080,
      "protocol": "tcp"
    }],
    "environment": [{
      "name": "JWT_SECRET",
      "value": "{{resolve:secretsmanager:jwt-secret}}"
    }],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/auth-service"
      }
    }
  }]
}
```

**3. ACM (Certificate Manager)**
- Certificados SSL/TLS gratuitos
- Renovación automática

**4. Security Groups**
- Firewall virtual para contenedores
- Reglas inbound/outbound

**Ejemplo:**
```
ALB Security Group:
- Inbound: 443 (HTTPS) desde 0.0.0.0/0
- Outbound: 8080 a ECS security group

ECS Security Group:
- Inbound: 8080 desde ALB security group
- Outbound: 5432 a RDS security group

RDS Security Group:
- Inbound: 5432 desde ECS security group
```

**5. IAM Roles**
- Permisos entre servicios AWS
- Task execution role (ECS puede pull images de ECR)
- Task role (contenedor puede acceder a Secrets Manager)

**6. RDS PostgreSQL**
- Multi-AZ para alta disponibilidad
- Automated backups
- Encryption at-rest

---

### Comparación de Opciones

| Aspecto | Opción 1: API Gateway + Lambda | Opción 2: ECS/Fargate + ALB |
|---------|-------------------------------|----------------------------|
| **Costo** | Pay-per-request (muy bajo si tráfico bajo) | Pay-per-hour (contenedores siempre corriendo) |
| **Escalabilidad** | Automática infinita | Configurar auto-scaling |
| **Complejidad** | Baja (menos componentes) | Media (más configuración) |
| **Control** | Menos (abstracciones AWS) | Más (contenedores estándar) |
| **Vendor lock** | Alto (Lambda, API Gateway) | Bajo (contenedores portables) |
| **Cold starts** | Sí (Lambda) | No (contenedores siempre activos) |
| **Ideal para** | POC, startups, tráfico esporádico | Producción, tráfico constante |

**Recomendación para nuestro proyecto (académico):**
- **Desarrollo local:** Docker Compose
- **Demo/POC:** Lambda + API Gateway (gratis con free tier)
- **Producción hipotética:** ECS/Fargate (más control, portable)

---

## PREGUNTAS FRECUENTES DEL DOCENTE

### 1. ¿Por qué usaron JWT y no sesiones tradicionales?

**Respuesta:**

JWT es **stateless** (sin estado en servidor), lo que significa que el servidor no necesita guardar sesiones en memoria o BD. Esto tiene ventajas claveen microservicios:

✅ **Escalabilidad horizontal**: Podemos agregar más instancias del API Gateway sin preocuparnos por sesiones compartidas.

✅ **No requiere almacenamiento de sesiones**: En sesiones tradicionales necesitaríamos Redis o sticky sessions en load balancer.

✅ **Cross-domain**: JWT funciona entre dominios diferentes (útil si frontend y backend en dominios distintos).

✅ **Estándar de la industria**: JWT es ampliamente adoptado, compatible con OAuth2, OpenID Connect.

**Desventaja:**
❌ No se puede revocar fácilmente → Lo resolvimos con blacklist

**Comparación:**

| Aspecto | Sesiones tradicionales | JWT |
|---------|----------------------|------|
| Estado en servidor | Sí (Redis/memcache) | No |
| Revocacióninmediata | Sí (delete session) | No (requiere blacklist) |
| Escalabilidad | Media (sticky sessions) | Alta (stateless) |
| Tamaño | Cookie pequeña (sessionId) | Token grande (~200 bytes) |

---

### 2. ¿Cómo protegen las contraseñas?

**Respuesta:**

Usamos **BCrypt** con 10 rounds. BCrypt es un algoritmo de hash diseñado específicamente para passwords que tiene 3 características clave:

1. **Salt automático**: Cada hash es único aunque el password sea igual
2. **Adaptativo (rounds)**: Podemos incrementar la dificultad computacional
3. **Lento a propósito**: Dificulta ataques de fuerza bruta

**Ejemplo práctico:**

```
Password original: "MiPassword123"

BCrypt hash generado:
$2a$10$N9qo8uLOickgx2ZMWxzQHOeGpxxAWblSKs5F3sTVLAqFoLOXfUcKq

Desglose:
$2a$     → Versión BCrypt
$10$     → 10 rounds (2^10 = 1024 iteraciones)
N9qo8... → Salt (22 caracteres aleatorios)
eGpxx... → Hash resultante

Si el usuario cambia password a "MiPassword123" de nuevo:
$2a$10$X7fT9pLMqgRx3YZNWxzQAbeKpyyCWclRKt6G4tUVMAqGoMPYgVdLq
                ↑ Salt diferente → Hash diferente
```

**Tiempo de hash:**
- 10 rounds ≈ 100ms por password
- Parece lento pero es intencional
- Un atacante necesitaría 100ms × 1 billion combinaciones ≈ 3 años para 1 password

**Almacenamiento:**
```sql
CREATE TABLE usuarios (
  password_hash VARCHAR(60) NOT NULL  -- BCrypt siempre 60 caracteres
);
```

**NUNCA guardamos el password original.**

---

### 3. ¿Qué pasa si alguien roba el JWT?

**Respuesta:**

Si un atacante obtiene el JWT, puede usarlo hasta que expire (24 horas en nuestro caso). Esto es un **riesgo inherente** de JWT. Nuestras mitigaciones:

**Prevención:**
1. ✅ **HTTPS obligatorio** - JWT viaja encriptado en tránsito
2. ✅ **Expiración corta** - 24 horas (balance entre seguridad y UX)
3. ✅ **No guardar en cookies sin flags** - usamos localStorage con precauciones
4. ✅ **Validar origen** - CORS configurado estrictamente

**Detección:**
5. ✅ **Logging de accesos** - Si vemos 2 IPs diferentes con mismo token, alerta
6. ✅ **Anomaly detection** - Actividad inusual (ej: 1000 requests/segundo)

**Reacción:**
7. ✅ **Blacklist inmediata** - Agregar token a `token_blacklist`
8. ✅ **Forzar cambio de password** - Invalida todos los tokens del usuario
9. ✅ **Notificar al usuario** - Email/SMS de actividad sospechosa

**Ejemplo de código de detección:**

```java
@Component
public class AnomalyDetector {
    
    public void detectarAnomalias(String token, String ipAddress) {
        Claims claims = jwtUtil.parseToken(token);
        Long userId = claims.get("userId", Long.class);
        
        // Obtener última IP conocida
        String lastKnownIP = userSessionService.getLastIP(userId);
        
        // Si IP diferente en corto tiempo, alertar
        if (!ipAddress.equals(lastKnownIP)) {
            alertService.enviarAlerta(
                "Acceso desde IP diferente",
                userId,
                "IP anterior: " + lastKnownIP + ", IP actual: " + ipAddress
            );
        }
        
        // Actualizar última IP
        userSessionService.updateLastIP(userId, ipAddress);
    }
}
```

**Comparación con sesiones:**
- Sesiones: Se puede invalidar inmediatamente en servidor
- JWT: Requiere blacklist (consulta extra)

**Por qué aceptamos este trade-off:**
- Ganamos escalabilidad (stateless)
- Mitigamos con expiración corta y blacklist

---

### 4. ¿Por qué 4 roles y no más granularidad?

**Respuesta:**

Optamos por **RBAC simple** (4 roles) en vez de ABAC (Attribute-Based Access Control) por:

1. **Simplicidad**: Proyecto académico, no necesitamos permisos ultra-granulares
2. **Mantenibilidad**: Menos roles = menos complejidad
3. **Performance**: Validación rápida (solo verificar 1 campo)
4. **Suficiente para el dominio**: Los 4 roles cubren todos los actores del colegio

**Roles y permisos:**

```
ADMIN
├─ Gestionar usuarios (CRUD)
├─ Gestionar cursos (CRUD)
├─ Gestionar asignaturas (CRUD)
├─ Ver todas las calificaciones
├─ Ver toda la asistencia
└─ Configuración del sistema

DOCENTE
├─ Ver cursos que dicta
├─ Registrar asistencia (solo sus cursos)
├─ Registrar calificaciones (solo sus cursos)
├─ Crear anotaciones (solo sus estudiantes)
└─ Enviar mensajes a apoderados

APODERADO
├─ Ver calificaciones de sus pupilos
├─ Ver asistencia de sus pupilos
├─ Ver anotaciones de sus pupilos
└─ Enviar mensajes a docentes

ESTUDIANTE
├─ Ver sus propias calificaciones
├─ Ver su propia asistencia
└─ Ver sus propias anotaciones
```

**Si necesitáramos más granularidad en el futuro:**

Podríamos migrar a modelo de permisos:

```sql
CREATE TABLE roles (
  id BIGINT PRIMARY KEY,
  nombre VARCHAR(50) UNIQUE
);

CREATE TABLE permisos (
  id BIGINT PRIMARY KEY,
  recurso VARCHAR(100),  -- 'calificaciones', 'asistencia'
  accion VARCHAR(50)     -- 'leer', 'escribir', 'eliminar'
);

CREATE TABLE roles_permisos (
  rol_id BIGINT REFERENCES roles(id),
  permiso_id BIGINT REFERENCES permisos(id),
  PRIMARY KEY (rol_id, permiso_id)
);
```

Pero para nuestro alcance actual, 4 roles en 1 campo son suficientes.

---

### 5. ¿Cómo manejan el logout si JWT es stateless?

**Respuesta:**

JWT por diseño es **stateless**, no hay forma de "invalidarlo" en servidor porque no hay sesión guardada. Nuestra solución: **token blacklist**.

**Flujo de logout:**

```
1. Usuario hace click en "Cerrar sesión"
2. Frontend envía: POST /auth/logout con JWT
3. Backend agrega JWT completo a tabla token_blacklist
4. Frontend elimina token de localStorage
5. Frontend redirige a login
```

**Código backend:**

```java
@PostMapping("/logout")
public ResponseEntity<?> logout(
        @RequestHeader("Authorization") String authHeader) {
    
    String token = authHeader.replace("Bearer ", "");
    Claims claims = jwtUtil.parseToken(token);
    Long userId = claims.get("userId", Long.class);
    
    // Agregar a blacklist
    TokenBlacklist blacklist = new TokenBlacklist();
    blacklist.setToken(token);
    blacklist.setUsuarioId(userId);
    blacklist.setRazon("LOGOUT");
    blacklist.setBlacklistedEn(LocalDateTime.now());
    
    blacklistRepository.save(blacklist);
    
    // También revocar refresh token
    refreshTokenRepository.revokeAllByUserId(userId);
    
    return ResponseEntity.ok().body("Logout exitoso");
}
```

**Validación en Gateway:**

```java
public boolean isTokenValid(String token) {
    // 1. Validar firma y expiración con jwtUtil
    Claims claims = jwtUtil.validateToken(token);
    
    // 2. Consultar blacklist
    boolean isBlacklisted = blacklistRepository.existsByToken(token);
    
    if (isBlacklisted) {
        throw new InvalidTokenException("Token revocado (logout)");
    }
    
    return true;
}
```

**Optimización con caché (Redis):**

Consultar BD en cada request es costoso. Podemos cachear:

```java
@Cacheable("token_blacklist")
public boolean isTokenBlacklisted(String token) {
    return blacklistRepository.existsByToken(token);
}
```

**Limpieza periódica:**

Tokens en blacklist solo necesitan estar hasta su expiración natural:

```sql
-- Job diario (ej: 3 AM)
DELETE FROM token_blacklist
WHERE blacklisted_en < (now() - INTERVAL '7 days');
```

**Trade-off:**
- ✅ Logout efectivo (token se invalida inmediatamente)
- ❌ Consulta extra en cada request (mitigado con caché)

**Alternativa sin blacklist:**
- Expiración ultra-corta (ej: 5 minutos) + refresh tokens
- Logout solo elimina refresh token
- Desventaja: Usuario sigue autenticado hasta 5 minutos después de logout

Preferimos blacklist para logout inmediato.

---

### 6. ¿Qué medidas tomaron contra ataques comunes?

**Respuesta:**

Implementamos protecciones contra los ataques más comunes:

**1. SQL Injection**
- ✅ Usamos JPA/Hibernate con prepared statements
- ✅ NUNCA concatenamos strings para queries

```java
// ❌ VULNERABLE
String query = "SELECT * FROM usuarios WHERE correo = '" + correo + "'";

// ✅ SEGURO
@Query("SELECT u FROM Usuario u WHERE u.correo = :correo")
Optional<Usuario> findByCorreo(@Param("correo") String correo);
```

**2. XSS (Cross-Site Scripting)**
- ✅ React auto-escapa output por defecto
- ✅ Sanitizamos inputs en backend

```java
import org.jsoup.Jsoup;
import org.jsoup.safety.Safelist;

public String sanitizeInput(String input) {
    return Jsoup.clean(input, Safelist.basic());
}
```

**3. CSRF (Cross-Site Request Forgery)**
- ✅ JWT en header (no en cookie) → CSRF no aplica
- ✅ CORS estricto (solo dominios permitidos)

**4. Brute Force (login)**
- ✅ Rate limiting en login endpoint (5 intentos/minuto)
- ✅ Account lockout después de 5 intentos fallidos

```java
@Component
public class LoginAttemptService {
    
    private final Map<String, Integer> attemptsCache = new ConcurrentHashMap<>();
    
    public void loginFailed(String correo) {
        int attempts = attemptsCache.getOrDefault(correo, 0) + 1;
        attemptsCache.put(correo, attempts);
        
        if (attempts >= 5) {
            // Bloquear cuenta temporalmente
            usuarioService.lockAccount(correo, Duration.ofMinutes(15));
        }
    }
    
    public void loginSucceeded(String correo) {
        attemptsCache.remove(correo);
    }
}
```

**5. DDoS (Distributed Denial of Service)**
- ✅ Rate limiting por IP (API Gateway)
- ✅ En AWS: WAF + API Gateway throttling

**6. Man-in-the-Middle**
- ✅ HTTPS obligatorio en producción
- ✅ HSTS headers

```java
@Configuration
public class SecurityHeaders {
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) {
        http.headers()
            .httpStrictTransportSecurity()
                .maxAgeInSeconds(31536000)  // 1 año
                .includeSubDomains(true);
        return http.build();
    }
}
```

**7. Session Fixation**
- ✅ No aplica (usamos JWT, no sesiones)

**8. Clickjacking**
- ✅ X-Frame-Options header

```java
http.headers().frameOptions().deny();
```

---

### 7. ¿Está lista la seguridad para producción?

**Respuesta honesta:**

**Para ambiente académico/demo: SÍ ✅**

Tenemos:
- ✅ Autenticación robusta (BCrypt + JWT)
- ✅ Autorización por roles
- ✅ HTTPS
- ✅ Validación de inputs
- ✅ Logging básico

**Para producción real: FALTA trabajo adicional ⚠️**

Necesitaríamos:
- ❌ Auditoría completa (penetration testing)
- ❌ MFA (Multi-Factor Authentication)
- ❌ Password policies estrictas (complejidad, historial)
- ❌ Encrypted data at rest (columnas sensibles encriptadas en BD)
- ❌ Security incident response plan
- ❌ SIEM (Security Information and Event Management)
- ❌ Regular security updates y patching
- ❌ Compliance con regulaciones (ej: Ley de Protección de Datos en Chile)

**Roadmap de seguridad:**

**Fase 1 (Actual - MVP académico):**
- JWT + BCrypt + RBAC ✅

**Fase 2 (Pre-producción):**
- MFA
- Password policies
- Encrypted backups

**Fase 3 (Producción):**
- Penetration testing
- SOC 2 compliance
- Bug bounty program

Para el contexto de este proyecto (académico, entrega DSY1106), la seguridad implementada es **apropiada y demuestra comprensión** de principios de seguridad modernos.

---

## 🎯 CONCLUSIONES

### Resumen de Seguridad Implementada

1. **Autenticación**: JWT con BCrypt ✅
2. **Autorización**: RBAC con 4 roles ✅
3. **Protección de datos**: HTTPS, hash de passwords ✅
4. **Gestión de sesiones**: Refresh tokens + blacklist ✅
5. **Arquitectura**: Gateway centralizado, microservicios independientes ✅
6. **Documentación**: 3 diagramas PlantUML + especificaciones ✅

### Tecnologías y Estándares Usados

- **JWT** (RFC 7519) - Tokens de autenticación
- **BCrypt** - Hash de contraseñas
- **Spring Security** - Framework de seguridad Java
- **RBAC** - Control de acceso basado en roles
- **HTTPS/TLS** - Transporte seguro
- **PostgreSQL** - Almacenamiento seguro

### Preparación para el Docente

Con esta documentación puedes explicar:

✅ Cómo funciona la autenticación completa (login → token → acceso)  
✅ Por qué elegimos JWT vs sesiones  
✅ Cómo protegemos las contraseñas (BCrypt)  
✅ Cómo manejamos logout (blacklist)  
✅ Qué roles existen y qué pueden hacer  
✅ Cómo se vería en AWS  
✅ Qué ataques comunes mitigamos  

**Consejo final para la presentación:**

1. Empieza mostrando el **diagrama de arquitectura** (visión general)
2. Luego el **diagrama de flujo** (paso a paso del login)
3. Finalmente el **modelo de datos** (cómo se almacena)
4. Termina con **consideraciones AWS** (escalabilidad)

**Domina estos 3 conceptos clave:**
- JWT (qué es, por qué lo usamos, cómo funciona)
- BCrypt (por qué nunca passwords en texto plano)
- RBAC (4 roles, matriz de permisos)

---

**Fecha de creación:** Marzo 29, 2026  
**Autores:** Cristian Monsalve, Héctor Olivares  
**Proyecto:** Plataforma Libro de Clases Digital  

---

_Este documento es material de estudio y referencia para la defensa del proyecto ante el docente._
