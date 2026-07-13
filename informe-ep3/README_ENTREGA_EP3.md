# Evaluación Parcial N°3 + Examen — Encargo documental

**Asignatura:** DSY1106 — Desarrollo Fullstack III  
**Integración de arquitectura de microservicios**  
**Proyecto:** Plataforma Libro de Clases Digital  
**Equipo:** Cristian Monsalve / Héctor Olivares  

| Entrega | Fecha |
|---------|--------|
| Informe EP3 (base) | 2026-06-20 |
| Actualización Examen (mejoras + innovación) | 2026-07-13 |

---

## Índice del encargo

| # | Documento | Contenido | Archivo |
|---|-----------|-----------|---------|
| **★** | **Informe único del examen** | Arquitectura + BD + pruebas + repos + innovación | **`examen_transversal.md` / `.pdf`** |
| — | Fuentes parciales EP3 | Docs individuales (referencia) | `01`–`05` |
| — | Diagrama arquitectura | PNG | `diagramas/architecture_patterns_simple.png` |
| — | Postman | API REST | `../postman/Libro_Digital.postman_collection.json` |
| — | Cobertura JaCoCo / Vitest | HTML | `jacoco-reports/`, `coverage-frontend/` |

### Qué entregar al profesor

1. **`examen_transversal.pdf`** (informe completo en un solo archivo)
2. Enlaces GitHub (están dentro del transversal, Parte IV)
3. ZIP con código + `infraestructura` (opcional según pauta)

---

## Qué cambió para el examen (resumen)

1. Se **mantiene** el informe EP3 (docs 01–04) como base evaluada.
2. Se **agrega** el documento **05** / integrado en `examen_transversal` con:
   - Mejoras realizadas tras la presentación N°3
   - **Innovación:** avisos inmediatos a apoderados al guardar asistencia y al crear evaluaciones
3. Se **actualizan** roles demo, mensajería, gateway y flujos en los docs 01–04.

Contraseña demo: `test1234` — usuarios: `admin_colegio`, `admin_oficina`, `prof_castillo`, `apoderado_demo`, `estudiante_demo`.

---

## Contenido del ZIP / RAR para Blackboard

```
LibroDigital_EXAMEN/
├── informe-ep3/
│   ├── README_ENTREGA_EP3.md
│   ├── examen_transversal.md|.pdf   ← entrega principal
│   ├── 01…05… (fuentes parciales / respaldo)
│   ├── diagramas/
│   ├── jacoco-reports/
│   └── coverage-frontend/
├── frontend-react/
├── authService/
├── academicService/
├── attendanceService/
├── apiGetaway/
└── infraestructura/
```

Excluir: `node_modules/`, `*/target/`, `*/.git/`, `frontend/` (legacy).

---

## Cómo regenerar PDF

```powershell
cd infraestructura/informe-ep3/scripts
npm install
node export-pdf.mjs
```

Requisito: Chrome o Microsoft Edge. Genera `examen_transversal.pdf`.

---

## Enlaces GitHub (resumen)

| Repositorio | URL |
|-------------|-----|
| Infraestructura | https://github.com/cristianmonsalve14/infraestructura |
| Frontend React | https://github.com/cristianmonsalve14/frontend-react |
| API Gateway | https://github.com/cristianmonsalve14/apiGetaway |
| Auth Service | https://github.com/cristianmonsalve14/authService |
| Academic Service | https://github.com/cristianmonsalve14/academicService |
| Attendance Service | https://github.com/cristianmonsalve14/attendanceService |

Detalle en `04_repositorios_github.txt`.

---

## Defensa oral

- Traer **PC propio con el stack levantado** (recomendación docente).
- Núcleo demo: **alertas a apoderados** (Parte V de `examen_transversal` / doc `05`).
- Preguntas sobre arquitectura, persistencia, pruebas y contribución individual.

---

## Verificación previa

- [ ] Backends: `mvn test` en auth / academic / attendance / gateway
- [ ] Frontend: `npm test` en `frontend-react`
- [ ] Demo innovación: lista + evaluación → mensajes en `apoderado_demo`
- [ ] PDF `examen_transversal.pdf` al día
- [ ] Repos GitHub al día
- [ ] ZIP subido / material listo
