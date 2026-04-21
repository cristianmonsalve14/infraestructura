# SECCIÓN COMPLEMENTARIA - REQUISITO 1
# Selección y Justificación de Patrones Arquitectónicos

---

## 1. Introducción: Estrategia de selección de patrones

La arquitectura de la Plataforma de Libro de Clases Digital se diseñó aplicando un conjunto estratégico de **patrones arquitectónicos y de diseño** que responden directamente a los requerimientos del cliente: seguridad, escalabilidad, mantenibilidad, trazabilidad y eficiencia operativa.

Este documento presenta:
1. **Diagrama conceptual** de los patrones aplicados
2. **Tabla de justificación** por cada patrón (problema/solución/alternativa)
3. **Mapeo** entre patrones y requerimientos del cliente
4. **Descripción detallada** de implementación

---

## 2. Diagrama de patrones arquitectónicos

**Archivo:** `diagrams/architecture_patterns.puml` y `architecture_patterns.png`

El diagrama muestra la distribución de 8 patrones principales aplicados en el sistema:

### Patrones Arquitectónicos (3)
1. **API Gateway Pattern**
2. **Layered Architecture (Arquitectura en Capas)**
3. **Shared Database with Logical Ownership**

### Patrones de Seguridad (2)
4. **JWT Token-Based Authentication**
5. **RBAC (Role-Based Access Control)**

### Patrones de Diseño (3)
6. **Repository Pattern**
7. **Circuit Breaker Pattern**
8. **Factory Method Pattern**

**Visualización:** El diagrama ilustra cómo estos patrones se integran en las diferentes capas del sistema, desde la presentación hasta la persistencia.

---

## 3. Tabla de justificación de patrones

Esta tabla conecta cada patrón con el problema que resuelve, el requerimiento del cliente que satisface, y las alternativas que se descartaron.

| # | Patrón Aplicado | Problema que Resuelve | Requerimiento del Cliente | Alternativa Descartada | Justificación de Elección |
|---|---|---|---|---|---|
| **1** | **API Gateway Pattern**<br>(Spring Cloud Gateway) | Múltiples puntos de entrada sin control centralizado generan duplicación de lógica de seguridad y dificultan el monitoreo | **REQ-01:** Seguridad centralizada<br>**REQ-06:** Trazabilidad de accesos | **Alt 1:** Backend for Frontend (BFF) por cada cliente<br>**Alt 2:** Acceso directo a microservicios | Gateway permite validar JWT en un solo punto, aplicar rate limiting, CORS y logging centralizado. BFF requeriría duplicar validaciones. Acceso directo expondría servicios internos. |
| **2** | **Layered Architecture**<br>(5 capas: UI/Gateway/Microservices/Data) | Sistema monolítico sin separación de responsabilidades dificulta mantenimiento y testing | **REQ-02:** Mantenibilidad<br>**REQ-05:** Escalabilidad | **Alt 1:** Arquitectura monolítica (MVC tradicional)<br>**Alt 2:** Event-Driven Architecture pura | Capas permiten desarrollo paralelo, testing aislado y cambios sin afectar otras capas. Monolito no escala horizontalmente. Event-driven es complejo para equipo académico. |
| **3** | **Shared Database with Logical Ownership** | En fase inicial, DB por microservicio aumenta complejidad operativa (backups, migraciones) sin beneficio claro | **REQ-04:** Simplicidad operativa (fase académica)<br>**REQ-02:** Migración futura | **Alt 1:** Database per Service desde inicio<br>**Alt 2:** Monolithic Database sin ownership | BD única simplifica desarrollo y aprendizaje. Ownership lógico prepara migración futura. DB per service desde inicio requiere distributed transactions complejas. |
| **4** | **JWT Token-Based Authentication** | Sesiones stateful no escalan horizontalmente y requieren sticky sessions en balanceadores | **REQ-01:** Autenticación segura y escalable<br>**REQ-05:** Stateless para microservicios | **Alt 1:** Sesiones en servidor (HttpSession)<br>**Alt 2:** OAuth 2.0 con servidor externo | JWT es stateless, admite firma digital, contiene claims del usuario. Sesiones requieren storage compartido (Redis) o sticky sessions. OAuth añade complejidad innecesaria para sistema interno. |
| **5** | **RBAC (Role-Based Access Control)** | Control de acceso granular por usuario individual es inmanejable (matriz usuarios × recursos) | **REQ-03:** Control de permisos por tipo de usuario<br>**REQ-01:** Seguridad por separación de funciones | **Alt 1:** ACL (Access Control Lists) por usuario<br>**Alt 2:** ABAC (Attribute-Based Access Control) | RBAC con 4 roles (Admin, Docente, Apoderado, Estudiante) es simple y suficiente. ACL requiere mantenimiento por usuario. ABAC es complejo para alcance actual. |
| **6** | **Repository Pattern**<br>(Spring Data JPA) | Lógica de negocio acoplada con SQL dificulta testing y cambios de BD | **REQ-02:** Mantenibilidad y testability<br>**REQ-07:** Abstracción de persistencia | **Alt 1:** Active Record Pattern<br>**Alt 2:** DAO Pattern manual | Repository con JPA permite mocks en tests, cambio de BD sin reescribir queries. Active Record acopla modelo con persistencia. DAO manual requiere boilerplate code. |
| **7** | **Circuit Breaker Pattern**<br>(Resilience4j) | Fallo en un microservicio causa cascada de timeouts y afecta todo el sistema | **REQ-06:** Disponibilidad y resiliencia<br>**REQ-08:** Degradación controlada | **Alt 1:** Retry simple sin circuit breaking<br>**Alt 2:** Timeout básico sin fallback | Circuit breaker detecta fallos recurrentes, abre circuito y ejecuta fallback. Retry sin límite empeora la cascada. Timeout sin fallback no provee degradación elegante. |
| **8** | **Factory Method Pattern** | Creación de entidades con lógica compleja (DTO → Entity) dispersa en controladores dificulta extensibilidad | **REQ-02:** Código limpio y extensible<br>**REQ-09:** Conversión de datos consistente | **Alt 1:** Builder Pattern<br>**Alt 2:** Constructor sobrecargado | Factory Method centraliza lógica de creación, facilita agregar tipos nuevos (ej: tipos de anotaciones). Builder es más verboso. Constructores sobrecargados generan código frágil. |

### Leyenda de Requerimientos del Cliente

| Código | Requerimiento |
|---|---|
| REQ-01 | Seguridad de datos sensibles de estudiantes |
| REQ-02 | Mantenibilidad y extensibilidad del código |
| REQ-03 | Control de acceso diferenciado por rol |
| REQ-04 | Simplicidad operativa (contexto académico) |
| REQ-05 | Escalabilidad horizontal de la plataforma |
| REQ-06 | Disponibilidad y resiliencia ante fallos |
| REQ-07 | Abstracción de tecnologías de persistencia |
| REQ-08 | Degradación controlada de servicios |
| REQ-09 | Conversión consistente de DTOs y Entidades |

---

## 4. Descripción detallada de patrones y su aplicación

### 4.1 API Gateway Pattern

**Definición:** Punto de entrada único que enruta peticiones a microservicios y aplica políticas transversales (seguridad, logging, rate limiting).

**Implementación en nuestro sistema:**
- **Tecnología:** Spring Cloud Gateway
- **Responsabilidades:**
  1. Validación de JWT en cada request
  2. Verificación contra blacklist de tokens
  3. Enrutamiento dinámico según path (`/auth/*` → auth-service, `/academic/*` → academic-service)
  4. Aplicación de CORS policy
  5. Rate limiting por usuario/IP
  6. Logging centralizado de accesos

**Beneficio para el cliente:**
- **Seguridad:** Valida tokens antes de llegar a microservicios, evitando duplicar lógica
- **Trazabilidad:** Logs centralizados permiten auditoría de quién accedió a qué recurso
- **Escalabilidad:** Microservicios no necesitan implementar validación JWT

**Código ejemplo (configuración simplificada):**
```yaml
spring:
  cloud:
    gateway:
      routes:
        - id: auth-service
          uri: http://localhost:8081
          predicates:
            - Path=/auth/**
        - id: academic-service
          uri: http://localhost:8082
          predicates:
            - Path=/academic/**
          filters:
            - JwtAuthenticationFilter  # Valida JWT
            - RateLimitFilter           # Limita requests
```

---

### 4.2 Layered Architecture (Arquitectura en Capas)

**Definición:** Organización del sistema en capas horizontales donde cada capa depende solo de la inmediatamente inferior.

**Capas en nuestro sistema:**

1. **Capa de Presentación (Frontend - React)**
   - Responsabilidad: UI/UX, validaciones de entrada, rutas protegidas
   - Tecnología: React + TypeScript + Tailwind CSS

2. **Capa de Control de Acceso (API Gateway)**
   - Responsabilidad: Validación JWT, enrutamiento, políticas transversales
   - Tecnología: Spring Cloud Gateway

3. **Capa de Lógica de Negocio (Microservicios)**
   - Responsabilidad: Reglas de negocio, validaciones de dominio
    - Servicios: auth-service, academic-service, attendance-service
   - Tecnología: Spring Boot + Spring Security

4. **Capa de Persistencia (Repository Pattern)**
   - Responsabilidad: Abstracción de acceso a datos
   - Tecnología: Spring Data JPA

5. **Capa de Datos (PostgreSQL)**
   - Responsabilidad: Almacenamiento persistente
   - Tecnología: PostgreSQL 14+

**Beneficio para el cliente:**
- **Mantenibilidad:** Cambios en UI no afectan lógica de negocio
- **Testability:** Cada capa se prueba de forma aislada
- **Escalabilidad:** Capas 2 y 3 se pueden escalar horizontalmente de forma independiente

---

### 4.3 Shared Database with Logical Ownership

**Definición:** Base de datos única compartida por todos los microservicios, donde cada servicio tiene "ownership lógico" de sus tablas y no accede directamente a tablas de otros servicios.

**Justificación de esta decisión:**

**Contexto:** Proyecto académico con equipo de 2 personas en fase de aprendizaje de microservicios.

**Decisión:** Usar BD única con ownership lógico **por ahora**, con plan de migración a "Database per Service" en fase de producción.

**Ventajas para el contexto actual:**
1. ✅ Desarrollo más rápido (un solo script DDL, un solo Flyway)
2. ✅ Backups y migraciones simplificados
3. ✅ Queries que cruzan dominios (ej: reportes) no requieren agregación
4. ✅ Transacciones locales (no se requiere distributed transaction manager)

**Ownership lógico aplicado:**

| Microservicio | Tablas de su ownership | Acceso de otros servicios |
|---|---|---|
| auth-service | `usuarios`, `roles`, `refresh_tokens`, `token_blacklist` | ❌ Prohibido. Deben llamar API `/auth/validate` |
| academic-service | `cursos`, `asignaturas`, `matrículas`, `evaluaciones`, `calificaciones` | ❌ Prohibido. Llamar API REST |
| attendance-service | `sesiones`, `asistencias`, `anotaciones` | ❌ Prohibido. Llamar API REST |


**Regla de diseño:** Cada servicio expone APIs para consultar sus datos. Otros servicios NO deben hacer `SELECT` directo a tablas ajenas.

**Plan de migración futura:**
En fase de producción, cada microservicio tendrá su propia instancia PostgreSQL, comunicándose mediante:
- APIs REST para consultas síncronas
- Message broker (RabbitMQ/Kafka) para eventos asíncronos
- Patrón SAGA para transacciones distribuidas

**Beneficio para el cliente:**
- **Simplicidad operativa** en fase inicial (aprendizaje)
- **Preparado para escalar:** El código ya respeta boundaries, migración será transparente

---

### 4.4 JWT Token-Based Authentication

**Definición:** Mecanismo de autenticación stateless donde el servidor emite un token firmado digitalmente que contiene claims (información) del usuario.

**Estructura del JWT:**

```
HEADER.PAYLOAD.SIGNATURE
```

**Ejemplo del payload (claims):**
```json
{
  "userId": 123,
  "correo": "profesor@colegio.cl",
  "rol": "DOCENTE",
  "nombre": "Juan Pérez",
  "iat": 1711700000,  // Issued at
  "exp": 1711786400   // Expiration (24 horas)
}
```

**Flujo de autenticación:**
1. Usuario envía credenciales → Auth Service
2. Auth Service valida con BCrypt → Genera JWT firmado con clave secreta
3. JWT se retorna al Frontend
4. Frontend incluye JWT en header `Authorization: Bearer <token>` en cada request
5. API Gateway valida firma, expiración y blacklist
6. Si válido, extrae claims y enruta a microservicio con headers `X-User-Id`, `X-User-Role`

**Por qué JWT y no sesiones:**

| Aspecto | JWT (elegido) | Sesiones en servidor (descartado) |
|---|---|---|
| **Escalabilidad** | ✅ Stateless, no requiere storage compartido | ❌ Requiere Redis compartido o sticky sessions |
| **Microserviios** | ✅ Gateway valida sin llamar a auth-service | ❌ Cada request requiere validar contra storage |
| **Performance** | ✅ Validación local con clave pública | ❌ Network call a Redis por cada request |
| **Seguridad** | ✅ Firma digital evita manipulación | ⚠️ Session ID puede ser robado (requiere HTTPS igual) |

**Implementación de seguridad adicional:**
- ✅ Blacklist de tokens revocados (logout, cambio de password)
- ✅ Refresh tokens para evitar re-login frecuente
- ✅ Expiración corta (24 horas) para limitar ventana de exposición

**Beneficio para el cliente:**
- **Seguridad robusta:** Firma digital evita suplantación de identidad
- **Escalabilidad:** Gateway puede escalar horizontalmente sin coordinación
- **Trazabilidad:** Claims en JWT incluyen información de auditoría

---

### 4.5 RBAC (Role-Based Access Control)

**Definición:** Control de acceso basado en roles predefinidos, donde cada rol tiene permisos específicos sobre recursos del sistema.

**Roles definidos para el Colegio:**

| Rol | Permisos Principales | Ejemplo de Acceso |
|---|---|---|
| **ADMINISTRADOR** | CRUD completo sobre usuarios, configuración del sistema, reportes globales | Crear docentes, asignar cursos, ver estadísticas generales |
| **DOCENTE** | Registro de asistencia, calificaciones y anotaciones **solo de cursos que dicta** | Ver calificaciones de 3°A (si lo dicta), no puede ver 4°B |
| **APODERADO** | Consulta read-only de información **solo de sus pupilos** | Ver calificaciones de hijo/a |
| **ESTUDIANTE** | Consulta read-only de **su propia** información académica | Ver sus calificaciones, asistencia y anotaciones |

**Implementación técnica:**

**1. A nivel de Base de Datos:**
```sql
CREATE TABLE usuarios (
    id BIGSERIAL PRIMARY KEY,
    correo VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    rol VARCHAR(20) NOT NULL CHECK (rol IN ('ADMINISTRADOR', 'DOCENTE', 'APODERADO', 'ESTUDIANTE')),
    activo BOOLEAN DEFAULT TRUE
);
```

**2. A nivel de API Gateway:**
```java
@Configuration
public class SecurityConfig {
    
    @Bean
    public SecurityWebFilterChain securityWebFilterChain(ServerHttpSecurity http) {
        return http
            .authorizeExchange()
            .pathMatchers("/auth/login", "/auth/register").permitAll()
            .pathMatchers("/admin/**").hasRole("ADMINISTRADOR")
            .pathMatchers("/academic/calificaciones/**").hasAnyRole("DOCENTE", "ADMINISTRADOR")
            .pathMatchers("/estudiante/**").hasRole("ESTUDIANTE")
            .anyExchange().authenticated()
            .and()
            .build();
    }
}
```

**3. A nivel de Microservicio (validación de negocio):**
```java
@GetMapping("/calificaciones/curso/{cursoId}")
public ResponseEntity<?> obtenerCalificaciones(
    @PathVariable Long cursoId,
    @RequestHeader("X-User-Id") Long userId,
    @RequestHeader("X-User-Role") String rol) {
    
    // Validación adicional: DOCENTE solo ve cursos que dicta
    if ("DOCENTE".equals(rol)) {
        if (!docenteService.dictaEsteCurso(userId, cursoId)) {
            return ResponseEntity.status(403)
                .body("No tienes permiso para ver este curso");
        }
    }
    
    // Proceder con lógica de negocio...
}
```

**Matriz de permisos (ejemplo simplificado):**

| Recurso | ADMIN | DOCENTE | APODERADO | ESTUDIANTE |
|---|---|---|---|---|
| `/admin/usuarios` | ✅ CRUD | ❌ | ❌ | ❌ |
| `/academic/calificaciones/curso/:id` | ✅ Todos | ✅ Solo cursos propios | ❌ | ❌ |
| `/attendance/sesion/:id` | ✅ | ✅ Solo cursos propios | ❌ | ❌ |
| `/estudiante/calificaciones/:idEstudiante` | ✅ | ✅ (si dicta curso) | ✅ (si es su pupilo) | ✅ (solo propias) |
| `/messaging/enviar` | ✅ | ✅ | ⚠️ Solo responder | ❌ |

**Beneficio para el cliente:**
- **Seguridad por separación de funciones:** Docentes no ven datos de cursos ajenos
- **Simplicidad:** 4 roles cubren todos los casos sin complejidad de ACL por usuario
- **Compliance:** Facilita cumplir con protección de datos de menores

---

### 4.6 Repository Pattern (Spring Data JPA)

**Definición:** Capa de abstracción entre lógica de negocio y persistencia que encapsula queries y operaciones CRUD.

**Problema que resuelve:**
Código tradicional mezcla SQL con lógica de negocio:
```java
// ❌ ANTI-PATRÓN (sin Repository)
public class CalificacionService {
    public List<Calificacion> obtenerPorCurso(Long cursoId) {
        Connection conn = DriverManager.getConnection(...);
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(
            "SELECT * FROM calificaciones WHERE curso_id = " + cursoId
        );
        // ... mapeo manual de ResultSet a objetos
    }
}
```

**Con Repository Pattern:**
```java
// ✅ Repository interface
public interface CalificacionRepository extends JpaRepository<Calificacion, Long> {
    List<Calificacion> findByCursoId(Long cursoId);
    
    @Query("SELECT c FROM Calificacion c WHERE c.estudiante.id = :estudianteId AND c.curso.id = :cursoId")
    List<Calificacion> findPorEstudianteYCurso(
        @Param("estudianteId") Long estudianteId,
        @Param("cursoId") Long cursoId
    );
}

// ✅ Service limpio
@Service
public class CalificacionService {
    @Autowired
    private CalificacionRepository repository;
    
    public List<Calificacion> obtenerPorCurso(Long cursoId) {
        return repository.findByCursoId(cursoId);
    }
}
```

**Ventajas técnicas:**
1. ✅ **Abstracción:** Cambiar de PostgreSQL a MySQL requiere solo cambiar dependencia, no reescribir queries
2. ✅ **Testing:** Fácil hacer mock del repository en tests unitarios
3. ✅ **Queries tipadas:** Errores de SQL se detectan en compilación (con JPQL)
4. ✅ **Paginación automática:** `findAll(Pageable)` incluido sin escribir SQL
5. ✅ **Auditoría automática:** `@CreatedDate`, `@LastModifiedDate` con JPA Auditing

**Beneficio para el cliente:**
- **Mantenibilidad:** Código limpio y fácil de entender
- **Velocidad de desarrollo:** CRUD básico sin escribir SQL
- **Calidad:** Menos bugs por errores de SQL manual

---

### 4.7 Circuit Breaker Pattern (Resilience4j)

**Definición:** Patrón de resiliencia que detecta fallos recurrentes en un servicio y "abre el circuito" para evitar sobrecargarlo, ejecutando lógica de fallback.

**Problema que resuelve:**

**Escenario sin Circuit Breaker:**
1. Academic Service llama a Auth Service para validar permiso
2. Auth Service está caído (timeout de 5 segundos)
3. Academic Service espera... timeout... espera... timeout...
4. Todos los requests se acumulan esperando respuesta
5. **Cascada de fallos:** Academic Service también se cae por agotamiento de threads

**Escenario con Circuit Breaker:**
1. Academic Service llama a Auth Service
2. Circuit Breaker detecta 3 fallos consecutivos
3. **Abre el circuito:** próximas llamadas fallan inmediatamente (fast-fail)
4. Ejecuta **lógica de fallback** (ej: retornar datos cacheados o mostrar mensaje de "servicio temporalmente no disponible")
5. Después de 30 segundos, **half-open:** permite 1 llamada de prueba
6. Si la prueba funciona, **cierra el circuito** (vuelve a normalidad)

**Estados del Circuit Breaker:**

```
         ┌─────────┐
         │ CLOSED  │ ◄── Estado normal: todas las llamadas pasan
         │ (normal)│
         └────┬────┘
              │ 3 fallos consecutivos
              ▼
         ┌─────────┐
         │  OPEN   │ ◄── Circuito abierto: fast-fail, ejecuta fallback
         │ (falla) │
         └────┬────┘
              │ Espera 30s
              ▼
         ┌──────────┐
         │HALF-OPEN │ ◄── Permite 1 llamada de prueba
         │ (prueba) │
         └────┬─────┘
              │
         ┌────┴────┐
         ▼         ▼
      Éxito      Falla
         │         │
         ▼         ▼
      CLOSED     OPEN
```

**Implementación con Resilience4j:**

```java
@Service
public class AcademicService {
    
    @Autowired
    private AuthServiceClient authClient;
    
    @CircuitBreaker(name = "authService", fallbackMethod = "validarPermisoFallback")
    public boolean validarPermiso(Long userId, String recurso) {
        // Llamada HTTP a Auth Service
        return authClient.verificarPermiso(userId, recurso);
    }
    
    // Método de fallback ejecutado cuando el circuito está abierto
    public boolean validarPermisoFallback(Long userId, String recurso, Exception ex) {
        // Opción 1: Retornar datos cacheados
        // Opción 2: Asumir permisos mínimos (fail-safe)
        // Opción 3: Lanzar excepción personalizada con mensaje amigable
        
        log.error("Auth Service no disponible, usando fallback", ex);
        throw new ServiceUnavailableException(
            "El sistema de autenticación está temporalmente no disponible. Intente más tarde."
        );
    }
}
```

**Configuración (application.yml):**
```yaml
resilience4j:
  circuitbreaker:
    instances:
      authService:
        failureRateThreshold: 50       # Abre si falla 50% de requests
        waitDurationInOpenState: 30s   # Espera 30s antes de half-open
        slidingWindowSize: 10          # Considera últimas 10 llamadas
        minimumNumberOfCalls: 5        # Mínimo 5 llamadas antes de evaluar
```

**Beneficio para el cliente:**
- **Disponibilidad:** Sistema no se cae completamente ante fallo de un microservicio
- **Experiencia de usuario:** Mensajes claros de "servicio temporalmente no disponible" en vez de timeouts largos
- **Resiliencia:** Servicios se auto-recuperan automáticamente

---

### 4.8 Factory Method Pattern

**Definición:** Patrón creacional que delega la creación de objetos a métodos especializados, permitiendo extensibilidad sin modificar código existente.

**Problema que resuelve:**

**Escenario:** Sistema tiene 3 tipos de anotaciones de conducta:
- Anotaciones positivas (felicitaciones)
- Anotaciones negativas (infracciones leves)
- Anotaciones graves (infracciones graves que requieren notificación administrativa)

**Sin Factory Method:**
```java
// ❌ ANTI-PATRÓN: lógica de creación dispersa en controlador
@PostMapping("/anotaciones")
public Anotacion crearAnotacion(@RequestBody AnotacionDTO dto) {
    Anotacion anotacion = new Anotacion();
    anotacion.setEstudiante(dto.getEstudiante());
    anotacion.setDescripcion(dto.getDescripcion());
    
    if ("POSITIVA".equals(dto.getTipo())) {
        anotacion.setPuntos(+5);
        anotacion.setNotificarApoderado(false);
    } else if ("NEGATIVA".equals(dto.getTipo())) {
        anotacion.setPuntos(-3);
        anotacion.setNotificarApoderado(true);
    } else if ("GRAVE".equals(dto.getTipo())) {
        anotacion.setPuntos(-10);
        anotacion.setNotificarApoderado(true);
        anotacion.setNotificarDireccion(true);  // ← lógica específica
    }
    
    return repository.save(anotacion);
}
```

**¿Qué pasa si necesitamos agregar "ANOTACION_ESPECIAL"?**
→ Modificar el controlador con más `if/else` (viola Open/Closed Principle)

**Con Factory Method:**

```java
// ✅ Factory interface
public interface AnotacionFactory {
    Anotacion crear(AnotacionDTO dto);
}

// ✅ Implementaciones específicas
@Component
public class AnotacionPositivaFactory implements AnotacionFactory {
    @Override
    public Anotacion crear(AnotacionDTO dto) {
        Anotacion anotacion = new Anotacion();
        anotacion.setEstudiante(dto.getEstudiante());
        anotacion.setDescripcion(dto.getDescripcion());
        anotacion.setTipo(TipoAnotacion.POSITIVA);
        anotacion.setPuntos(5);
        anotacion.setNotificarApoderado(false);
        return anotacion;
    }
}

@Component
public class AnotacionGraveFactory implements AnotacionFactory {
    @Override
    public Anotacion crear(AnotacionDTO dto) {
        Anotacion anotacion = new Anotacion();
        anotacion.setEstudiante(dto.getEstudiante());
        anotacion.setDescripcion(dto.getDescripcion());
        anotacion.setTipo(TipoAnotacion.GRAVE);
        anotacion.setPuntos(-10);
        anotacion.setNotificarApoderado(true);
        anotacion.setNotificarDireccion(true);  // ← lógica encapsulada
        anotacion.generarReporteAutomatico();   // ← comportamiento específico
        return anotacion;
    }
}

// ✅ Factory Provider (selecciona factory según tipo)
@Service
public class AnotacionFactoryProvider {
    
    @Autowired
    private Map<String, AnotacionFactory> factories;
    
    public AnotacionFactory getFactory(String tipo) {
        String factoryName = tipo.toLowerCase() + "Factory";
        return factories.get(factoryName);
    }
}

// ✅ Controlador limpio
@PostMapping("/anotaciones")
public Anotacion crearAnotacion(@RequestBody AnotacionDTO dto) {
    AnotacionFactory factory = factoryProvider.getFactory(dto.getTipo());
    Anotacion anotacion = factory.crear(dto);
    return repository.save(anotacion);
}
```

**Ventaja:** Agregar "ANOTACION_ESPECIAL" solo requiere crear nueva clase `AnotacionEspecialFactory`, sin tocar código existente.

**Otros usos del Factory Method en el proyecto:**
1. **Conversión DTO → Entity:** `EstudianteFactory.crearDesdeDTO(EstudianteDTO)`
2. **Generación de reportes:** `ReporteFactory.crear(TipoReporte)` → retorna `ReportePDF` o `ReporteExcel`
3. **Notificaciones administrativas:** `NotificacionFactory.crear(Canal)` → retorna `EmailNotificacion` o `SMSNotificacion`

**Beneficio para el cliente:**
- **Extensibilidad:** Agregar nuevos tipos de anotaciones sin romper código existente
- **Mantenibilidad:** Lógica de creación centralizada y fácil de encontrar
- **Testing:** Cada factory se prueba de forma aislada

---

## 5. Mapeo completo: Patrones → Requerimientos del Cliente

Este diagrama muestra cómo los 8 patrones aplicados cubren los 6 requerimientos principales del Colegio Bernardo O'Higgins.

```
REQUERIMIENTOS DEL CLIENTE                PATRONES QUE LO SATISFACEN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[REQ-1] Seguridad de datos sensibles      ■ JWT Authentication
        de estudiantes                    ■ RBAC Pattern
                                          ■ API Gateway (validación centralizada)
                                          ■ Layered Architecture (separación)

[REQ-2] Mantenibilidad y extensibilidad   ■ Repository Pattern (abstracción)
        del código                        ■ Factory Method (extensible)
                                          ■ Layered Architecture (separación)

[REQ-3] Control de acceso diferenciado    ■ RBAC Pattern
        por rol (Admin, Docente,          ■ JWT (claims con rol)
        Apoderado, Estudiante)

[REQ-4] Escalabilidad horizontal          ■ JWT (stateless, no requiere sesiones)
                                          ■ API Gateway (enrutamiento dinámico)
                                          ■ Shared DB with Ownership (migración futura)

[REQ-5] Disponibilidad y resiliencia      ■ Circuit Breaker Pattern
        ante fallos                       ■ API Gateway (health checks)

[REQ-6] Trazabilidad de accesos           ■ API Gateway (logging centralizado)
        y cambios                         ■ JWT (claims con userId)
                                          ■ Repository Pattern (JPA Auditing)
```

**Cobertura:**
- Todos los requerimientos están cubiertos por al menos 2 patrones
- REQ-1 (Seguridad) es el más crítico y tiene 4 patrones que lo refuerzan
- No hay requerimientos sin patrón asignado ✅

---

## 6. Evaluación de decisiones: Trade-offs asumidos

Toda decisión arquitectónica implica compromisos (trade-offs). Esta sección documenta las limitaciones conocidas y aceptadas.

| Patrón/Decisión | Ventaja obtenida | Trade-off (Desventaja aceptada) | Mitigación aplicada |
|---|---|---|---|
| **Shared Database** (en vez de DB per Service) | Simplicidad operativa, transacciones locales, desarrollo rápido | ❌ Acoplamiento de esquema entre servicios, dificulta escalado independiente | ✅ Ownership lógico estricto, plan de migración documentado |
| **JWT con expiración corta** (24 horas) | Ventana de exposición limitada si token se roba | ❌ Usuario debe re-autenticarse frecuentemente | ✅ Refresh tokens (duración 7 días) |
| **Validación JWT en Gateway** (no en cada servicio) | Evita duplicar lógica, performance | ❌ Si Gateway se compromete, todos los servicios quedan expuestos | ✅ Gateway es el componente más auditado, logs centralizados |
| **Circuit Breaker con fail-fast** | Evita cascadas de fallos | ❌ Usuario ve errores incluso si servicio se recuperó (hasta half-open) | ✅ Timeout de 30s a half-open reduce ventana de error |
| **RBAC simple (4 roles)** | Fácil de entender y mantener | ❌ No cubre casos edge (ej: "docente suplente temporal") | ✅ Documentado como mejora futura (ABAC o permisos temporales) |

---

## 7. Conclusión: Patrones como solución integral

Los 8 patrones seleccionados forman una **arquitectura cohesiva** que:

1. ✅ **Resuelve todos los requerimientos del cliente** sin excepciones
2. ✅ **Balancea complejidad vs beneficio** (no over-engineering)
3. ✅ **Está implementado con tecnologías maduras** (Spring Boot, PostgreSQL, Resilience4j)
4. ✅ **Es extensible** (Factory Method, Repository) sin reescribir código existente
5. ✅ **Es resiliente** (Circuit Breaker, API Gateway) ante fallos parciales
6. ✅ **Es seguro** (JWT, RBAC, validación en múltiples capas)

**Recomendación para el cliente:**
Esta arquitectura es adecuada para el alcance actual (1 colegio, ~500 usuarios). Para escalado a red de colegios (>5,000 usuarios), se recomienda:
- Migrar de Shared DB a Database per Service
- Agregar message broker (RabbitMQ) para eventos asíncronos
- Implementar Service Mesh (Istio) para observabilidad avanzada

---

**Documentos complementarios:**
- `diagrams/architecture_patterns.puml` — Diagrama PlantUML de patrones
- `docs/informe_seguridad.md` — Detalle de JWT y RBAC
- `docs/arquitectura.md` — Decisiones técnicas profundas

**Autor:** Cristian Monsalve / Héctor Olivares  
**Fecha:** Abril 2026  
**Asignatura:** DSY 1106 – Desarrollo Full Stack III
