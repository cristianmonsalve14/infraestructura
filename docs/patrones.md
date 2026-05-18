# Patrones de Diseño Aplicados

**Asignatura:** DSY 1106 – Desarrollo Full Stack III  
**Proyecto:** Plataforma Libro de Clases Digital  
**Alumnos:** Cristian Monsalve / Héctor Olivares  

---

## 📌 Introducción

En este proyecto se implementaron distintos patrones de diseño para garantizar una arquitectura organizada, mantenible y escalable.

El sistema se basa en microservicios desarrollados con Spring Boot, utilizando buenas prácticas estándar de la industria.

---

## 🧠 Patrones Utilizados

### 🟡 1. Repository Pattern

**Tecnología:** Spring Data JPA  

**¿Qué problema resuelve?**  
Evita escribir consultas SQL manuales y separa el acceso a datos de la lógica de negocio.

**Ejemplo:**

public interface StudentRepository extends JpaRepository<Student, Long> {
    List<Student> findByFirstName(String firstName);
}

**Beneficios:**

- Código más limpio  
- Menor probabilidad de errores  
- Integración automática con Spring  
- Facilita testing  

---

### 🔵 2. DTO Pattern

**¿Qué problema resuelve?**  
Permite separar las entidades de base de datos del modelo que se envía al frontend.

**Ejemplo:**

public class StudentDTO {
    private Long id;
    private String firstName;
    private String lastName;
}

**Beneficios:**

- Evita exponer directamente la base de datos  
- Mejora la seguridad  
- Permite adaptar la información enviada al cliente  

---

### 🟢 3. Service Layer Pattern

**¿Qué problema resuelve?**  
Evita que la lógica de negocio esté en los controladores.

**Ejemplo:**

@Service
public class StudentServiceImpl implements StudentService {

    public Student createStudent(Student student) {
        return studentRepository.save(student);
    }
}

**Beneficios:**

- Código más organizado  
- Separación de responsabilidades  
- Reutilización de lógica  

---

### 🟣 4. MVC (Model - View - Controller)

**¿Qué problema resuelve?**  
Organiza el sistema en capas bien definidas.

**Aplicación en el proyecto:**

- Model → Entities JPA  
- View → Frontend React  
- Controller → Endpoints REST  

**Beneficios:**

- Mejor organización del código  
- Facilita mantenimiento  
- Escalable  

---

## 📊 Tabla Resumen

| Patrón | Problema | Resultado |
|--------|---------|----------|
| Repository | Acceso a BD desordenado | Código limpio |
| DTO | Exposición de entidades | Seguridad |
| Service Layer | Lógica en controllers | Organización |
| MVC | Código mezclado | Arquitectura clara |

---

## ✅ Conclusión

Los patrones aplicados permiten que el sistema sea:

- Mantenible  
- Escalable  
- Seguro  
- Modular  

Se utilizaron patrones estándar ampliamente utilizados en la industria, asegurando estabilidad y facilidad de desarrollo.

---

## 📌 Observación

Se priorizó el uso de patrones simples y efectivos, en lugar de soluciones complejas, lo que facilita la comprensión, mantenimiento y evolución del sistema.