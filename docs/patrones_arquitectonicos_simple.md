# Patrones de Diseño Aplicados - Versión Simplificada

**Asignatura:** DSY 1106 – Desarrollo Full Stack III  
**Proyecto:** Plataforma Libro de Clases Digital  
**Alumnos:** Cristian Monsalve / Héctor Olivares

---

## Diagrama Simplificado

**Archivo:** `diagrams/architecture_patterns_simple.png`

El diagrama muestra **los 3 patrones de diseño** aplicados en todos los microservicios del proyecto.

---

## Los 3 Patrones de Diseño

### 🟡 PATRÓN 1: REPOSITORY PATTERN
**Tecnología:** Spring Data JPA

**¿Qué problema resuelve?**  
Sin Repository, tendríamos que escribir SQL manualmente en cada servicio → código repetitivo y difícil de probar.

**Nuestra solución:**  
Interfaces que abstraen el acceso a la base de datos.

**Ejemplo concreto:**
```java
// SIN Repository (❌ MALO)
public List<Calificacion> obtenerPorCurso(Long cursoId) {
    String sql = "SELECT * FROM calificaciones WHERE curso_id = ?";
    // ... código JDBC manual ...
}

// CON Repository (✅ BUENO)
public interface CalificacionRepository extends JpaRepository<Calificacion, Long> {
    List<Calificacion> findByCursoId(Long cursoId);
}
```

**Beneficio para el colegio:**  
✅ Código más limpio y fácil de mantener  
✅ Fácil hacer tests sin base de datos real (usando mocks)  
✅ Si cambiamos de PostgreSQL a otra BD, solo cambiamos configuración

---

### 🟣 PATRÓN 2: FACTORY METHOD PATTERN
**Tecnología:** Clases Factory personalizadas

**¿Qué problema resuelve?**  
La creación de objetos complejos (convertir DTO → Entity) está dispersa por todo el código → difícil de extender.

**Nuestra solución:**  
Centralizar la lógica de creación en clases especializadas (Factories).

**Ejemplo concreto:**
```java
// SIN Factory (❌ MALO - código repetido en controladores)
@PostMapping("/anotaciones")
public Anotacion crear(@RequestBody AnotacionDTO dto) {
    Anotacion anotacion = new Anotacion();
    anotacion.setEstudiante(dto.getEstudiante());
    anotacion.setDescripcion(dto.getDescripcion());
    if ("POSITIVA".equals(dto.getTipo())) {
        anotacion.setPuntos(5);
        anotacion.setNotificarApoderado(false);
    } else if ("NEGATIVA".equals(dto.getTipo())) {
        anotacion.setPuntos(-3);
        anotacion.setNotificarApoderado(true);
    }
    // ... más lógica ...
    return repository.save(anotacion);
}

// CON Factory (✅ BUENO - lógica centralizada)
public interface AnotacionFactory {
    Anotacion crear(AnotacionDTO dto);
}

public class AnotacionPositivaFactory implements AnotacionFactory {
    public Anotacion crear(AnotacionDTO dto) {
        Anotacion a = new Anotacion();
        a.setEstudiante(dto.getEstudiante());
        a.setDescripcion(dto.getDescripcion());
        a.setTipo(POSITIVA);
        a.setPuntos(5);
        a.setNotificarApoderado(false);
        return a;
    }
}
```

**Beneficio para el colegio:**  
✅ Si necesitamos agregar "ANOTACION_ESPECIAL", solo creamos nueva factory  
✅ Lógica de creación está en un solo lugar (fácil de encontrar y modificar)  
✅ Código más extensible sin romper lo existente

---

### 🔴 PATRÓN 3: CIRCUIT BREAKER PATTERN
**Tecnología:** Resilience4j

**¿Qué problema resuelve?**  
Si un microservicio falla, puede causar una cascada de fallos en todo el sistema → el sistema completo se cae.

**Nuestra solución:**  
Detectar fallos recurrentes y "abrir el circuito" para evitar saturar el servicio caído. Ejecutar lógica de fallback.

**Estados del Circuit Breaker:**
```
   ┌─────────┐
   │ CLOSED  │ ← Normal: todas las llamadas pasan
   │(normal) │
   └────┬────┘
        │ 3 fallos consecutivos
        ▼
   ┌─────────┐
   │  OPEN   │ ← Circuito abierto: no llama al servicio, ejecuta fallback
   │ (falla) │
   └────┬────┘
        │ Espera 30 segundos
        ▼
   ┌──────────┐
   │HALF-OPEN │ ← Permite 1 llamada de prueba
   │ (prueba) │
   └─────┬────┘
         │
    ┌────┴───┐
    ▼        ▼
  CLOSED   OPEN
```

**Ejemplo concreto:**
```java
// CON Circuit Breaker
@Service
public class AcademicService {
    
    @CircuitBreaker(name = "authService", fallbackMethod = "validarPermisoFallback")
    public boolean validarPermiso(Long userId, String recurso) {
        // Llamada HTTP a Auth Service
        return authClient.verificarPermiso(userId, recurso);
    }
    
    // Método de fallback cuando el circuito está abierto
    public boolean validarPermisoFallback(Long userId, String recurso, Exception ex) {
        log.error("Auth Service no disponible", ex);
        throw new ServiceUnavailableException(
            "Sistema de autenticación temporalmente no disponible. Intente más tarde."
        );
    }
}
```

**Beneficio para el colegio:**  
✅ Si el servicio de autenticación se cae, los demás servicios no se saturan intentando llamarlo  
✅ El usuario recibe un mensaje claro: "temporalmente no disponible"  
✅ El sistema se auto-recupera cuando el servicio vuelve a estar disponible

---

## Tabla Resumen: ¿Por qué elegimos estos patrones?

| Patrón | Problema del Cliente | Alternativa Descartada | ¿Por qué la descartamos? |
|--------|---------------------|------------------------|--------------------------|
| **Repository Pattern** | SQL manual mezclado con lógica de negocio | Escribir SQL directo en servicios | Difícil de mantener, propenso a errores, imposible de testear sin BD |
| **Factory Method** | Lógica de creación dispersa en controladores | Constructores complejos o Builder | Constructores se vuelven enormes, difícil agregar nuevos tipos |
| **Circuit Breaker** | Fallos en cascada entre microservicios | Reintentos simples sin control | Los reintentos empeoran el problema, saturan más el servicio caído |

---

## ¿Cómo se usan juntos estos patrones?

### Ejemplo: Docente registra una anotación de conducta

```
1. Controlador recibe DTO con datos de la anotación
   ↓
2. FACTORY METHOD crea objeto Anotacion desde el DTO
   (AnotacionFactory.crear(dto) → Anotacion)
   ↓
3. Servicio valida permisos llamando a Auth Service
   (protegido por CIRCUIT BREAKER para evitar fallos)
   ↓
4. REPOSITORY guarda la anotación en PostgreSQL
   (repository.save(anotacion))
   ↓
5. Se retorna respuesta exitosa al frontend
```

**Si Auth Service falla:**
- Circuit Breaker detecta el fallo
- NO intenta llamar al servicio caído
- Ejecuta fallback: retorna mensaje de error claro
- Los demás servicios siguen funcionando normalmente

---

## Evaluación: ¿Cumple con los requerimientos?

| Requerimiento del Colegio | Patrón que lo Resuelve | ✓ |
|---------------------------|------------------------|---|
| **Código mantenible** | Repository Pattern | ✅ |
| **Sistema extensible (agregar funcionalidades)** | Factory Method Pattern | ✅ |
| **No caerse completamente ante fallos** | Circuit Breaker Pattern | ✅ |
| **Testing efectivo** | Repository (permite mocks) | ✅ |
| **Escalabilidad de servicios** | Circuit Breaker (evita saturación) | ✅ |

**Conclusión:** Los 3 patrones de diseño cubren requerimientos clave de mantenibilidad, extensibilidad y resiliencia.

---

## ¿Dónde se aplican estos patrones?

**Repository Pattern:**
- ✅ Auth Service: `UsuarioRepository`, `RefreshTokenRepository`
- ✅ Academic Service: `CalificacionRepository`, `CursoRepository`, `MatriculaRepository`
- ✅ Attendance Service: `AsistenciaRepository`, `AnotacionRepository`
- ✅ Messaging Service: `MensajeRepository`, `DestinatarioRepository`

**Factory Method Pattern:**
- ✅ Academic Service: `EstudianteFactory`, `EvaluacionFactory`
- ✅ Attendance Service: `AnotacionFactory` (crea anotaciones positivas/negativas/graves)
- ✅ Messaging Service: `NotificacionFactory` (crea notificaciones email/SMS)

**Circuit Breaker Pattern:**
- ✅ Academic Service → protege llamadas a Auth Service
- ✅ Attendance Service → protege llamadas a Auth Service
- ✅ Messaging Service → protege llamadas a Auth Service y Academic Service

---

## Conclusión

Estos **3 patrones de diseño** forman la base técnica de nuestros microservicios:
- ✅ **Mantenibles** (Repository separa lógica de datos)
- ✅ **Extensibles** (Factory permite agregar tipos sin romper código)
- ✅ **Resilientes** (Circuit Breaker evita cascadas de fallos)

**Implementación:** Todos los patrones están implementados con tecnologías estándar de la industria (Spring Data JPA, Resilience4j) que tienen amplia documentación y soporte de la comunidad.

**Recomendación:** Esta combinación de patrones es apropiada para sistemas de gestión académica como el del colegio. Son patrones probados, no experimentales.

---

**Documentos relacionados:**
- `diagrams/architecture_patterns_simple.png` — Diagrama visual de los 3 patrones
- `docs/arquitectura.md` — Documentación técnica completa
- `docs/informe_seguridad.md` — Detalles de seguridad JWT y RBAC

**Fecha:** Abril 2026
