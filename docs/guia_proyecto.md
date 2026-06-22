# Guía del proyecto — Fullstack III

**Asignatura:** DSY 1106 – Desarrollo Full Stack III  
**Proyecto:** Plataforma Libro de Clases Digital  
**Alumnos:** Cristian Monsalve / Héctor Olivares  

Fecha: 2026-06-20

---

## 1. Descripción

Sistema web de gestión académica para reemplazar el libro de clases físico. Permite administrar estudiantes, docentes, cursos, matrículas, evaluaciones, notas, asistencia y anotaciones de conducta.

---

## 2. Problema y solución

**Problema:** el libro físico dificulta el acceso, la trazabilidad y la coordinación entre docentes, apoderados y administración.

**Solución:** plataforma web con arquitectura de microservicios, frontend React y autenticación JWT.

---

## 3. Objetivos

- Implementar autenticación segura con roles (administrador, docente, apoderado, estudiante)
- Desarrollar CRUD académico completo
- Registrar asistencia y anotaciones
- Aplicar patrones de diseño y buenas prácticas
- Documentar arquitectura, bases de datos y APIs

---

## 4. Usuarios del sistema

| Rol | Uso principal |
|---|---|
| Administrador | Gestión global del colegio |
| Docente | Cursos, evaluaciones, asistencia de su carga |
| Apoderado | Seguimiento del estudiante a su cargo |
| Estudiante | Consulta de notas y asistencia propia |

---

## 5. Metodología

Desarrollo iterativo con enfoque **SCRUM**, organizado por componentes:

- Diseño y documentación (`infraestructura/`)
- Microservicios backend (auth, academic, attendance, gateway)
- Frontend React (`frontend-react/`)

Estrategia de ramas: ver `branching.md`.

---

## 6. Repositorio

El proyecto se desarrolla como **monorepo local** con todos los servicios en una misma carpeta raíz. Referencia de repositorios remotos históricos: `repositorios.txt`.

---

## 7. Documentación técnica

| Documento | Tema |
|---|---|
| `arquitectura.md` | Componentes, flujos, stack |
| `bases_de_datos.md` | Bases, tablas, migraciones, usuarios demo |
| `puertos.md` | Puertos y rutas del gateway |
| `patrones.md` | Patrones de diseño |
| `branching.md` | Ramas Git |

---

## 8. Conclusión

El sistema cumple los objetivos del ramo: frontend moderno, backend modular, seguridad JWT y documentación técnica alineada con la implementación actual.
