# 📌 Plan de Branching

Asignatura: DSY 1106 – Desarrollo Full Stack III  
Proyecto: Plataforma Libro de Clases Digital  
Alumnos: Cristian Monsalve / Héctor Olivares  

---

## 📌 Introducción

En el desarrollo del proyecto se utilizó una estrategia de branching simple orientada a la separación por componentes del sistema.

Cada parte del sistema (frontend, microservicios y documentación) fue desarrollada en una rama independiente, lo que permitió trabajar de forma organizada y evitar conflictos de código.

---

## 🌳 Estrategia de Branching

Se utilizaron dos tipos de ramas principales:

---

### 🔵 main

- Contiene la versión estable del sistema  
- Representa el estado final del proyecto  
- Solo se actualiza cuando el código está probado y funcional  

---

### 🟣 Ramas de desarrollo (develop-*)

Cada componente del sistema fue desarrollado en su propia rama:

- develop-apiGetaway  
- develop-authService  
- develop-academicService  
- develop-react  
- develop-infraestructura  

Estas ramas permiten trabajar de manera independiente en cada módulo del sistema.

---

## 🔄 Flujo de Trabajo

1. Se crea una rama de desarrollo para cada componente (`develop-*`)  
2. Se desarrolla la funcionalidad en dicha rama  
3. Se realizan pruebas del módulo de forma independiente  
4. Una vez validado, el código se integra en la rama `main`  
5. La rama `main` contiene la versión estable del sistema  

---

## 📊 Diagrama de ramas

main  
├── develop-apiGetaway  
├── develop-authService  
├── develop-academicService  
├── develop-react  
└── develop-infraestructura  

---

## ✅ Beneficios

- Organización por componentes del sistema  
- Desarrollo independiente por módulo  
- Reducción de conflictos de integración  
- Mantención de una rama estable (`main`)  
- Facilita el control y seguimiento del proyecto  

---

## 🧠 Conclusión

La estrategia de branching utilizada es simple y adecuada para el alcance del proyecto.

Permite desarrollar cada componente de forma modular y ordenada, asegurando estabilidad en la rama principal y facilitando la integración final del sistema.