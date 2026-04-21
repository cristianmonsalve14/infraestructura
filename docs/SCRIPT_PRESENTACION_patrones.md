# Script de Presentación - Patrones de Diseño

**Duración estimada:** 3-4 minutos  
**Diapositiva:** `architecture_patterns_simple.png`

---

## 🎤 SCRIPT COMPLETO

### 1. INTRODUCCIÓN (15 segundos)

> "En la sección anterior vimos **CÓMO funciona** el sistema con sus 5 capas. Ahora vamos a ver los **patrones de diseño** que aplicamos en nuestros microservicios para hacerlos más mantenibles, extensibles y resilientes. Son 3 patrones estándar de la industria."

**[MOSTRAR DIAGRAMA]**

---

### 2. RECORRIDO POR LOS 3 PATRONES (2 minutos 30 segundos)

#### 📍 PATRÓN 1: REPOSITORY PATTERN (50 segundos)

> "El primer patrón es **Repository Pattern**, implementado con Spring Data JPA.
>
> **¿Qué problema resuelve?** Sin este patrón, tendríamos que escribir SQL manualmente en cada servicio. Por ejemplo, para obtener las calificaciones de un curso, escribiríamos 20 líneas de código JDBC: abrir conexión, crear statement, ejecutar query, mapear resultados, cerrar conexión. Y eso en cada servicio que necesite consultar datos.
>
> **Nuestra solución:** Interfaces que abstraen el acceso a datos. Por ejemplo, `CalificacionRepository` tiene un método `findByCursoId()` que Spring genera automáticamente. El código queda limpio y fácil de probar."

**[SEÑALAR el bloque amarillo de Repository en el diagrama]**

**Mostrar código si es posible:**
```java
// Solo definimos la interfaz
public interface CalificacionRepository extends JpaRepository<Calificacion, Long> {
    List<Calificacion> findByCursoId(Long cursoId);
}
// Spring genera la implementación automáticamente
```

---

#### 📍 PATRÓN 2: FACTORY METHOD PATTERN (50 segundos)

> "El segundo patrón es **Factory Method Pattern**.
>
> **¿Qué problema resuelve?** Tenemos objetos complejos que se crean de formas diferentes según el contexto. Por ejemplo, para las anotaciones de conducta, tenemos 3 tipos: positivas, negativas y graves. Cada una tiene reglas diferentes de puntos, notificaciones y acciones.
>
> **Sin Factory**, tendríamos esa lógica dispersa por todos los controladores con muchos `if-else`. Difícil de mantener.
>
> **Con Factory Method**, creamos una clase especializada por cada tipo de anotación. Si mañana necesitamos agregar 'ANOTACION_ESPECIAL', solo creamos una nueva factory sin tocar el código existente. Esto se llama extensibilidad sin romper nada."

**[SEÑALAR el bloque morado de Factory Method]**

---

#### 📍 PATRÓN 3: CIRCUIT BREAKER PATTERN (50 segundos)

> "El tercer patrón es **Circuit Breaker**, implementado con Resilience4j.
>
> **¿Qué problema resuelve?** En arquitecturas de microservicios, si un servicio se cae, puede crear una cascada de fallos. Imaginen que el servicio de autenticación está caído. Sin Circuit Breaker, todos los demás servicios seguirían intentando llamarlo, esperando 5 segundos por cada timeout, acumulando peticiones, hasta que todo el sistema colapsa.
>
> **Con Circuit Breaker**, funciona como un fusible eléctrico. Detecta cuando un servicio falla 3 veces consecutivas, 'abre el circuito' y deja de llamarlo por 30 segundos. En ese tiempo, ejecuta lógica de fallback: muestra un mensaje claro al usuario de 'servicio temporalmente no disponible'. Después de 30 segundos, hace una llamada de prueba. Si funciona, cierra el circuito y vuelve a la normalidad."

**[SEÑALAR el bloque rojo de Circuit Breaker y el diagrama de estados si lo tienes]**

---

### 3. EJEMPLO CONCRETO (40 segundos)

> "Veamos cómo trabajan juntos estos 3 patrones. Cuando un docente registra una anotación de conducta:
>
> 1. **Factory Method** crea el objeto correcto según el tipo (positiva/negativa/grave)
> 2. El servicio valida permisos llamando a Auth Service, protegido por **Circuit Breaker**
> 3. **Repository** guarda la anotación en PostgreSQL con un simple `.save()`
>
> Si Auth Service falla, Circuit Breaker previene la cascada de fallos. Si necesitamos agregar nuevos tipos de anotaciones, Factory Method facilita la extensión. Y Repository mantiene el código limpio sin SQL manual."

**[SEÑALAR las conexiones en el diagrama mientras explicas]**

---

### 4. JUSTIFICACIÓN DE ALTERNATIVAS (30 segundos)

> "¿Por qué estos patrones y no otros?
>
> - **Repository** vs SQL directo → Repository es testeable, SQL manual no
> - **Factory Method** vs Constructores complejos → Factory centraliza lógica, constructores se vuelven inmanejables
> - **Circuit Breaker** vs Reintentos simples → Reintentos empeoran cascadas, Circuit Breaker las previene
>
> Cada patrón es estándar de la industria, ampliamente probado en sistemas de producción."

---

### 5. CONEXIÓN CON REQUERIMIENTOS (20 segundos)

> "Estos 3 patrones cumplen requerimientos del colegio:
>
> ✅ **Código mantenible** → Repository separa lógica de datos  
> ✅ **Sistema extensible** → Factory permite agregar funcionalidades sin romper código  
> ✅ **Disponibilidad** → Circuit Breaker evita que fallos tumben todo el sistema  
> ✅ **Testing efectivo** → Repository permite tests sin base de datos real"

---

### 6. CIERRE (10 segundos)

> "En resumen, estos 3 patrones de diseño no son invenciones nuestras. Son patrones probados de la industria que aplicamos a nuestro contexto del colegio. Hacen el código más mantenible, extensible y resiliente."

**[SEÑALAR todo el diagrama con gesto amplio]**

---

## 🎯 TIPS PARA LA PRESENTACIÓN

### ✅ HAZ ESTO:

1. **Usa tu mano para señalar:** Cuando digas "API Gateway", señala el bloque azul en el diagrama
2. **Usa analogías:** "Como un guardia en la entrada" (API Gateway), "Como un fusible" (Circuit Breaker)
3. **Menciona al colegio:** Relaciona cada patrón con un requerimiento real del colegio
4. **Habla con confianza:** Estos patrones son estándares de la industria, no los inventaste tú
5. **Pausas estratégicas:** Después de explicar cada patrón, pausa 2 segundos

### ❌ NO HAGAS ESTO:

1. **No leas el diagrama textualmente:** El diagrama es apoyo visual, tú eres quien explica
2. **No uses demasiado tecnicismo:** Evita palabras como "stateless", "facade pattern", etc.
3. **No te apures:** 3-4 minutos está bien, no intentes explicarlo en 1 minuto
4. **No digas "no sé":** Si te preguntan algo que no sabes, di "eso está en la documentación técnica detallada"
5. **No te disculpes por el diseño:** Di "este diagrama muestra...", no "perdón que el diagrama esté simple..."

---

## 💬 RESPUESTAS A PREGUNTAS FRECUENTES

### Pregunta 1: "¿Por qué no usaron OAuth 2.0 en vez de JWT?"

**Respuesta:**
> "OAuth 2.0 es excelente para sistemas que necesitan integración con proveedores externos como Google o Facebook. En nuestro caso, el colegio tiene su propio sistema de autenticación interno, por lo que JWT es más simple y directo. OAuth añadiría complejidad innecesaria para un sistema cerrado."

---

### Pregunta 2: "¿Qué pasa si el API Gateway se cae?"

**Respuesta:**
> "Si el Gateway se cae, efectivamente todo el sistema queda inaccesible, por eso en producción se implementaría con alta disponibilidad: múltiples instancias detrás de un load balancer. Si una instancia falla, las otras siguen funcionando. Para esta fase académica tenemos una instancia, pero la arquitectura permite escalar horizontalmente."

---

### Pregunta 3: "¿Por qué base de datos compartida si es microservicios?"

**Respuesta:**
> "Excelente pregunta. En un escenario ideal, cada microservicio tendría su propia base de datos. Lo hicimos así en esta fase por simplicidad operativa: es un contexto académico con 2 personas. Sin embargo, aplicamos 'ownership lógico': cada servicio solo accede a sus propias tablas. Cuando el sistema crezca, la migración a bases de datos separadas será transparente porque ya respetamos esos límites en el código."

---

### Pregunta 4: "¿Estos patrones son estándares o los inventaron ustedes?"

**Respuesta:**
> "Todos estos patrones son estándares de la industria ampliamente probados. API Gateway es un patrón documentado por empresas como Netflix y Amazon. JWT es un estándar RFC 7519. Resilience4j implementa el patrón Circuit Breaker popularizado por Michael Nygard en su libro 'Release It!'. Nosotros los aplicamos a nuestro contexto específico del colegio."

---

### Pregunta 5: "¿Cuál es el patrón más importante?"

**Respuesta:**
> "Todos son importantes porque resuelven problemas diferentes, pero si tuviera que elegir uno, diría **API Gateway**. Es el guardián que centraliza toda la seguridad. Sin él, tendríamos que duplicar validaciones en cada microservicio, aumentando el riesgo de inconsistencias. Es la primera línea de defensa."

---

## 📝 CHECKLIST ANTES DE PRESENTAR

- [ ] Practicaste el script al menos 2 veces en voz alta
- [ ] Memorizaste la analogía del "guardia" (Gateway) y el "fusible" (Circuit Breaker)
- [ ] Sabes señalar cada bloque del diagrama con confianza
- [ ] Cronometraste tu explicación (debe ser 3-4 minutos)
- [ ] Preparaste respuestas a las 5 preguntas frecuentes
- [ ] Tienes el diagrama en buena resolución visible para todos
- [ ] Conoces la transición desde la sección anterior (arquitectura por capas)

---

## ⏱️ VERSIÓN RÁPIDA (1 minuto)

Si te quedas sin tiempo, usa esta versión compacta:

> "Aplicamos 4 patrones arquitectónicos: **API Gateway** para centralizar seguridad, **Microservicios** para independencia y escalabilidad, **JWT y RBAC** para autenticación sin sesiones y control por roles, y **Repository con Circuit Breaker** para código limpio y protección ante fallos. Cada patrón resuelve un problema específico del colegio y en conjunto forman una arquitectura segura, escalable y mantenible."

---

## 🎬 TRANSICIÓN DESDE SECCIÓN ANTERIOR

**Al terminar la explicación de las 5 capas, di:**

> "Bien, hasta aquí vimos **CÓMO funciona** el sistema con sus 5 capas. Pero esta estructura no surgió por casualidad. Detrás de cada decisión hay patrones arquitectónicos que justifican **POR QUÉ** lo diseñamos así. Veamos cuáles aplicamos... [CAMBIAR DIAPOSITIVA]"

---

## 🎬 TRANSICIÓN HACIA SIGUIENTE SECCIÓN

**Al terminar la explicación de patrones, di:**

> "Perfecto, con estos patrones arquitectónicos quedó claro el diseño del sistema. Ahora veamos cómo estos patrones se materializan en... [SIGUIENTE TEMA: herramientas, conclusiones, etc.]"

---

**Consejo final:** Practica frente a alguien (compañero, familiar) y pídele que te haga preguntas difíciles. La confianza viene de la preparación.

**¡Éxito en tu presentación! 🚀**
