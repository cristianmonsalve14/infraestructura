# Justificación de Herramientas y Estrategias para Microservicios

**Proyecto:** Plataforma Libro de Clases Digital  
**Asignatura:** DSY 1106 – Desarrollo Full Stack III  
**Alumnos:** Cristian Monsalve / Héctor Olivares  
**Fecha:** Abril 2026

---

## 1. Introducción

Este documento justifica la selección de herramientas tecnológicas y estrategias de implementación para el sistema de microservicios. Cada decisión se evaluó considerando criterios de **eficiencia técnica**, **eficiencia operativa**, **escalabilidad**, **mantenibilidad** y **curva de aprendizaje** en contexto académico.

---

## 2. Stack Tecnológico Seleccionado

### Tabla Resumen

| Categoría | Herramienta Elegida | Alternativa Descartada | Justificación |
|-----------|---------------------|------------------------|---------------|
| **Backend Framework** | Spring Boot 3.x | Node.js / Django | Ecosistema maduro, integración nativa con herramientas Java, soporte empresarial |
| **Lenguaje Backend** | Java 17 | Python / JavaScript | Tipado estático, rendimiento superior, preparación profesional |
| **Frontend Framework** | React 18 | Angular / Vue.js | Curva aprendizaje gradual, comunidad grande, flexibilidad |
| **Lenguaje Frontend** | TypeScript | JavaScript puro | Detección temprana de errores, autocompletado, mantenibilidad |
| **Base de Datos** | PostgreSQL 14+ | MySQL / MongoDB | ACID completo, soporte JSON, funciones avanzadas, open source |
| **API Gateway** | Spring Cloud Gateway | Kong / NGINX | Integración nativa con Spring, configuración declarativa, filtros personalizados |
| **Autenticación** | JWT (jjwt) | OAuth 2.0 / Sessions | Stateless, simple para sistema interno, sin dependencias externas |
| **ORM** | Spring Data JPA | MyBatis / JDBC | Abstracción de queries, repositories automáticos, reducción de boilerplate |
| **Circuit Breaker** | Resilience4j | Hystrix / Sentinel | Activamente mantenido, lightweight, fácil configuración |
| **Build Tool** | Maven | Gradle | Convención sobre configuración, XML declarativo, ampliamente usado |
| **Migraciones BD** | Flyway | Liquibase | Simplicidad, SQL puro, versionado claro |
| **CSS Framework** | Tailwind CSS | Bootstrap / Material-UI | Utility-first, customizable, no componentes predefinidos pesados |
| **HTTP Client** | Axios | Fetch API | Interceptores, mejor manejo errores, cancelación requests |
| **Testing Backend** | JUnit 5 + Mockito | TestNG | Estándar de facto, anotaciones modernas, integración IDE |
| **Testing Frontend** | Jest + React Testing Library | Enzyme | Recomendado por React, testing comportamiento usuario |

---

## 3. Justificación Detallada por Categoría

### 3.1 Backend: Spring Boot 3.x + Java 17

**Decisión:** Framework principal Spring Boot con Java 17

**Alternativas evaluadas:**
- Node.js + Express
- Python + Django/FastAPI
- .NET Core

**Por qué Spring Boot:**

1. **Ecosistema completo:**
   - Spring Security (autenticación/autorización)
   - Spring Data JPA (persistencia)
   - Spring Cloud Gateway (API Gateway)
   - Todo integrado nativamente sin librerías de terceros

2. **Eficiencia técnica:**
   - Autoconfiguración reduce código boilerplate
   - Dependency Injection facilita testing
   - Starter dependencies simplifican setup

3. **Eficiencia operativa:**
   - JAR ejecutable standalone (no requiere servidor externo)
   - Métricas y health checks integrados (Actuator)
   - Hot reload en desarrollo (DevTools)

4. **Escalabilidad:**
   - Thread pooling configurable
   - Soporte reactive programming (WebFlux) para migración futura
   - Manejo eficiente de conexiones a BD

5. **Preparación profesional:**
   - Alta demanda laboral en Chile (78% ofertas backend requieren Spring)
   - Estándar en empresas medianas/grandes

**Por qué Java 17:**
- LTS (Long Term Support hasta 2029)
- Records, Sealed Classes, Pattern Matching (código más conciso)
- Performance mejorado vs Java 11 (~15% más rápido)

**Trade-off aceptado:**
- ❌ Más verboso que Python/JavaScript
- ✅ Pero compensado con detección de errores en compilación

---

### 3.2 Frontend: React 18 + TypeScript

**Decisión:** React con TypeScript

**Alternativas evaluadas:**
- Angular
- Vue.js
- Svelte

**Por qué React:**

1. **Curva de aprendizaje:**
   - Menos opinionado que Angular (no impone estructura rígida)
   - Solo JavaScript + componentes (concepto simple)
   - Migración gradual (no requiere reescribir todo)

2. **Flexibilidad:**
   - Libertad para elegir router (React Router), state management (Context API)
   - No obliga a usar todo el ecosistema

3. **Comunidad y recursos:**
   - 220k+ estrellas GitHub (vs 93k Angular, 41k Vue)
   - Más tutoriales, librerías compatibles, Stack Overflow

4. **Eficiencia técnica:**
   - Virtual DOM optimiza renderizado
   - Hooks simplifican manejo de estado
   - Server Components (preparación para SSR futuro)

**Por qué TypeScript:**

1. **Prevención de errores:**
   ```typescript
   // TypeScript detecta error en compilación
   function obtenerCalificacion(estudianteId: number): Calificacion {
       return repository.findById(estudianteId); // Error si retorna tipo incorrecto
   }
   
   // JavaScript solo falla en ejecución
   function obtenerCalificacion(estudianteId) {
       return repository.findById(estudianteId); // Falla en runtime si estudianteId es string
   }
   ```

2. **Productividad:**
   - Autocompletado en IDE
   - Refactoring seguro
   - Documentación automática (tipos como contratos)

3. **Mantenibilidad:**
   - Código auto-documentado
   - Cambios en API backend detectados automáticamente

**Trade-off aceptado:**
- ❌ Setup inicial más complejo
- ✅ Pero compensa con menos bugs en producción

---

### 3.3 Base de Datos: PostgreSQL 14+

**Decisión:** PostgreSQL como BD relacional

**Alternativas evaluadas:**
- MySQL
- MongoDB (NoSQL)
- MariaDB

**Por qué PostgreSQL:**

1. **Robustez (ACID completo):**
   - Transacciones confiables (crítico para calificaciones/asistencia)
   - Integridad referencial estricta
   - Constraints personalizados (CHECK, UNIQUE multi-columna)

2. **Funcionalidades avanzadas:**
   - Soporte JSON/JSONB (flexibilidad sin sacrificar estructura)
   - Full-text search (búsqueda de estudiantes/docentes)
   - Extensiones (pg_trgm para búsquedas difusas)
   - CTEs recursivos para jerarquías

3. **Performance:**
   - Índices parciales, GiST, GIN
   - Vacuuming automático
   - Parallel queries (v14+)

4. **Open Source verdadero:**
   - Licencia permisiva (no dual license como MySQL)
   - No riesgo de cambios de licencia corporativos

5. **Ecosistema:**
   - PgAdmin 4 (GUI gratuita)
   - pg_stat_statements (profiling queries)
   - Heroku, Railway, Render ofrecen free tier

**Por qué NO MongoDB:**
- Sistema académico requiere relaciones fuertes (estudiante → curso → calificación)
- Consistencia de datos es crítica (no eventual consistency)
- Queries relacionales son la norma (JOINs frecuentes)

**Eficiencia operativa:**
- Backups con pg_dump (simple, versionable)
- Réplicas read-only para reportes (no afecta escrituras)

---

### 3.4 API Gateway: Spring Cloud Gateway

**Decisión:** Spring Cloud Gateway

**Alternativas evaluadas:**
- Kong
- NGINX + Lua
- AWS API Gateway
- Zuul (deprecated)

**Por qué Spring Cloud Gateway:**

1. **Integración nativa:**
   ```java
   // Configuración declarativa YAML (no código complejo)
   spring:
     cloud:
       gateway:
         routes:
           - id: academic-service
             uri: http://localhost:8082
             predicates:
               - Path=/academic/**
             filters:
               - name: JwtAuthenticationFilter
   ```

2. **Desarrollo unificado:**
   - Mismo lenguaje (Java) que microservicios
   - Mismo build tool (Maven)
   - Mismo IDE (IntelliJ/Eclipse)
   - Equipo no necesita aprender NGINX config o Lua

3. **Filtros personalizados:**
   - Validación JWT en Java puro
   - Logging estructurado
   - Métricas con Micrometer

4. **Reactive por defecto:**
   - Spring WebFlux (non-blocking I/O)
   - Maneja alta concurrencia con pocos threads

**Por qué NO Kong:**
- Requiere aprender Lua para plugins personalizados
- Base de datos adicional (PostgreSQL para Kong mismo)
- Over-engineering para scope actual

**Por qué NO NGINX:**
- Configuración menos declarativa
- Validación JWT requiere módulos third-party (lua-resty-jwt)
- Hot reload más complejo

---

### 3.5 Autenticación: JWT (jjwt library)

**Decisión:** JSON Web Tokens con biblioteca jjwt

**Alternativas evaluadas:**
- OAuth 2.0
- Sesiones en servidor (HttpSession)
- SAML

**Por qué JWT:**

1. **Stateless (crítico para microservicios):**
   - No requiere storage compartido de sesiones
   - Cada microservicio valida token independientemente
   - Escala horizontalmente sin sticky sessions

2. **Simplicidad para sistema interno:**
   - No necesitamos login con Google/Facebook
   - Colegio tiene su propia base de usuarios
   - OAuth añade complejidad innecesaria (authorization server, scopes, refresh flows)

3. **Performance:**
   - Validación local (verificar firma con clave pública)
   - Sin llamadas a base de datos por cada request
   - Redis opcional (solo para blacklist)

4. **Integración Spring Security:**
   ```java
   @Override
   protected void doFilterInternal(HttpServletRequest request, ...) {
       String token = extractToken(request);
       if (jwtUtil.validateToken(token)) {
           Authentication auth = jwtUtil.getAuthentication(token);
           SecurityContextHolder.getContext().setAuthentication(auth);
       }
   }
   ```

**Por qué NO OAuth 2.0:**
- Sistema cerrado (no third-party apps)
- Complejidad de authorization server (Keycloak, Okta) no justificada
- Scope management innecesario para 4 roles simples

**Por qué NO sesiones:**
- No escala con múltiples instancias
- Requiere Redis o sticky sessions
- Acoplamiento servicio-estado

**Estrategia de seguridad:**
- Token de corta duración (24h)
- Refresh tokens en BD (revocables)
- Blacklist para logout inmediato

---

### 3.6 Circuit Breaker: Resilience4j

**Decisión:** Resilience4j

**Alternativas evaluadas:**
- Netflix Hystrix
- Sentinel (Alibaba)

**Por qué Resilience4j:**

1. **Mantenimiento activo:**
   - Hystrix en modo maintenance desde 2018
   - Resilience4j es el sucesor recomendado

2. **Lightweight:**
   - Sin dependencias de RxJava (a diferencia de Hystrix)
   - Usa primitivas Java 8+ (CompletableFuture, Functional Interfaces)

3. **Modular:**
   ```java
   // Solo importas lo que necesitas
   resilience4j-circuitbreaker
   resilience4j-retry
   resilience4j-ratelimiter
   // vs Hystrix que trae todo empaquetado
   ```

4. **Configuración flexible:**
   ```yaml
   resilience4j:
     circuitbreaker:
       instances:
         authService:
           failureRateThreshold: 50
           waitDurationInOpenState: 30s
           slidingWindowSize: 10
   ```

5. **Integración Spring Boot:**
   - Anotación `@CircuitBreaker(name = "authService", fallbackMethod = "fallback")`
   - Métricas expuestas a Micrometer/Prometheus automáticamente

**Eficiencia operativa:**
- Dashboard de métricas en tiempo real
- Tuneable sin recompilar (application.yml)

---

### 3.7 Build Tool: Maven

**Decisión:** Maven 3.x

**Alternativa evaluada:**
- Gradle

**Por qué Maven:**

1. **Convención sobre configuración:**
   - Estructura de directorios estándar (src/main/java, src/test/java)
   - No hay que decidir dónde va cada cosa

2. **XML declarativo:**
   ```xml
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-web</artifactId>
   </dependency>
   ```
   - Qué se hace es explícito
   - No "magia" de Gradle DSL

3. **Ecosistema Spring:**
   - Spring Initializr genera pom.xml por defecto
   - Todos los tutoriales oficiales usan Maven
   - Arquetipos disponibles

4. **Curva de aprendizaje:**
   - Equipo ya conoce XML
   - Gradle requiere aprender Groovy/Kotlin DSL

**Por qué NO Gradle:**
- Build cache y performance son irrelevantes en proyecto pequeño
- Flexibilidad de Gradle no necesaria (no tenemos builds complejos)

**Eficiencia operativa:**
- `mvn clean install` es universal
- CI/CD pipelines tienen soporte nativo

---

### 3.8 Migraciones de BD: Flyway

**Decisión:** Flyway

**Alternativa evaluada:**
- Liquibase

**Por qué Flyway:**

1. **Simplicidad:**
   ```
   src/main/resources/db/migration/
   ├── V1__initial_schema.sql
   ├── V2__add_anotaciones.sql
   ```
   - SQL puro (no XML como Liquibase)
   - Versionado numérico claro

2. **Sin abstracción:**
   - Escribes el SQL que se ejecutará
   - No se traduce a dialecto (sabes exactamente qué pasa)

3. **Rollback manual:**
   - No rollback automático (filosofía "forward-only")
   - Obliga a escribir migraciones V4_rollback_V3.sql explícitas
   - Más conscientes de cambios en producción

4. **Integración Spring Boot:**
   ```yaml
   spring:
     flyway:
       enabled: true
       locations: classpath:db/migration
   ```

**Por qué NO Liquibase:**
- XML verboso para cambios simples
- Abstracción de dialecto innecesaria (solo usamos PostgreSQL)
- Curva aprendizaje mayor

---

### 3.9 Estrategias de Implementación

#### 3.9.1 Comunicación entre Servicios

**Estrategia elegida:** REST HTTP/JSON síncrono

**Alternativas evaluadas:**
- gRPC
- Mensajería asíncrona (RabbitMQ/Kafka) [solo relevante si se agregan servicios de notificaciones o integración externa en el futuro]
- GraphQL

**Justificación:**

1. **Simplicidad:**
   - HTTP es universal (no requiere protobuf compilation de gRPC)
   - Debugging con Postman/curl
   - Logs legibles (JSON human-readable)

2. **Naturaleza del sistema:**
   - Operaciones mayormente transaccionales (crear nota, registrar asistencia)
   - Latencia <100ms es aceptable
   - No tenemos eventos de alto volumen que justifiquen async

3. **Tooling:**
   - OpenAPI/Swagger para documentación
   - Spring MockMvc para testing
   - Axios en frontend sin configuración especial

**Cuándo migrar a async:**
- Generación de reportes pesados
- Integraciones externas (Ministerio Educación)

#### 3.9.2 Estrategia de Base de Datos

**Estrategia elegida:** Shared Database con ownership lógico

**Ideal (descartado por ahora):** Database per Service

**Justificación:**

1. **Contexto académico:**
   - Equipo de 2 personas
   - 3 meses de desarrollo
   - Enfoque en aprendizaje, no en operations

2. **Simplificación operativa:**
   - Un solo backup
   - Un solo script DDL
   - Un solo Flyway migration path
   - Transacciones locales (no distributed)

3. **Ownership lógico:**
   ```
   auth-service        → tabla usuarios, roles
   academic-service   → tabla cursos, calificaciones
   attendance-service → tabla asistencias, anotaciones
   ```
   - Regla: cada servicio SOLO accede a sus tablas
   - Acceso cross-service mediante API REST
   - Preparado para split futuro

**Plan de migración (cuando escalar):**
- Cada servicio tiene su propia PostgreSQL
- APIs ya están definidas (migración transparente)
- Introducir event sourcing para sincronización solo si en el futuro se agregan servicios que requieran comunicación asíncrona (por ejemplo, notificaciones o integración externa; actualmente no implementado).

#### 3.9.3 Logging y Monitoreo

**Estrategia elegida:** Logging centralizado estructurado

**Herramientas:**
- Logback (backend)
- JSON structured logging
- Correlation IDs (trazabilidad request cross-service)

**Ejemplo:**
```json
{
  "timestamp": "2026-04-06T10:30:00Z",
  "level": "INFO",
  "service": "academic-service",
  "correlationId": "abc-123",
  "userId": 456,
  "message": "Calificación creada",
  "data": {"cursoId": 10, "nota": 6.5}
}
```

**Futura integración:**
- ELK Stack (Elasticsearch + Logstash + Kibana)
- Splunk / Datadog

#### 3.9.4 Testing Strategy

**Estrategia multicapa:**

1. **Unit Tests (JUnit 5 + Mockito):**
   - Lógica de negocio aislada
   - Repositories mockeados
   - Cobertura objetivo: 80%

2. **Integration Tests (SpringBootTest):**
   - Testcontainers con PostgreSQL real
   - Testing de transacciones
   - Validación de constraints

3. **API Tests (MockMvc):**
   - Endpoints REST
   - Validación JSON responses
   - Status codes

4. **E2E Tests (mínimo):**
   - Happy paths críticos
   - Selenium/Playwright para flujos UI

---

## 4. Eficiencia Técnica vs Eficiencia Operativa

### Comparativa

| Aspecto | Eficiencia Técnica | Eficiencia Operativa |
|---------|-------------------|----------------------|
| **Spring Boot** | ✅ Alta productividad (autoconfig) | ✅ JAR standalone, fácil deploy |
| **PostgreSQL** | ✅ Performance ACID + JSON | ✅ Backups simples, réplicas |
| **JWT** | ✅ Stateless, bajo overhead | ✅ No requiere Redis (opcional) |
| **Maven** | ⚠️ Builds lentos vs Gradle | ✅ CI/CD simple, universalmente soportado |
| **Flyway** | ✅ SQL directo, sin abstracción | ✅ Versionado explícito, auditable |
| **React** | ✅ Virtual DOM, optimizado | ✅ Build estático, CDN-friendly |
| **TypeScript** | ✅ Previene errores compilación | ⚠️ Build step adicional |

**Resumen:** 
- Priorizamos **eficiencia operativa** en decisiones donde performance no es crítico
- Ejemplo: Maven sobre Gradle (simplicidad > velocidad build)
- Priorizamos **eficiencia técnica** donde afecta UX
- Ejemplo: React (rendering optimizado) > frameworks pesados

---

## 5. Conclusión

Las herramientas seleccionadas forman un stack coherente que:

✅ **Es maduro y probado** (Spring Boot, PostgreSQL, React son industria estándar)

✅ **Escala con el proyecto** (shared DB → DB per service, REST → async messaging)

✅ **Facilita aprendizaje** (TypeScript detecta errores, Spring autoconfig reduce boilerplate)

✅ **Es mantenible** (convenciones claras, comunidad grande, documentación abundante)

✅ **Tiene demanda laboral** (Spring + React cubren 60%+ ofertas dev en Chile)

✅ **Es sostenible** (open source, sin vendor lock-in, alternativas disponibles)

**Trade-offs conscientes:**
- Shared database sacrifica pureza arquitectónica por simplicidad operativa
- Maven sacrifica velocidad de build por convención y universalidad
- REST sacrifica performance extrema por simplicidad y debugging

Cada decisión prioriza **entregar valor al colegio** sobre perfección arquitectónica abstracta.

---

**Documentos relacionados:**
- `docs/arquitectura.md` — Decisiones técnicas detalladas
- `docs/patrones_arquitectonicos_simple.md` — Patrones de diseño aplicados
- `docs/informe_seguridad.md` — Estrategia de seguridad JWT/RBAC

**Fecha:** Abril 2026  
**Autores:** Cristian Monsalve / Héctor Olivares
