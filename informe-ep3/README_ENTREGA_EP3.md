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
| — | Guía de defensa (aparte) | App en vivo, código, BD, pruebas | `06_guia_defensa_examen.md` / `.pdf` |
| — | Fuentes parciales EP3 | Docs individuales (referencia) | `01`–`05` |
| — | Diagrama arquitectura | PNG | `diagramas/architecture_patterns_simple.png` |
| — | Postman | API REST | `../postman/Libro_Digital.postman_collection.json` |
| — | Cobertura JaCoCo / Vitest | HTML | `jacoco-reports/`, `coverage-frontend/` |

### Qué entregar al profesor (simplificado)

1. **`examen_transversal.pdf`** (informe completo en un solo archivo)
2. Enlaces GitHub (están dentro del transversal, Parte IV)
3. ZIP con código + `infraestructura` (opcional según pauta)
4. `06_guia_defensa_examen.pdf` **solo para el equipo** (no es el informe formal)

---

## Qué cambió para el examen (resumen)

1. Se **mantiene** el informe EP3 (docs 01–04) como base evaluada.
2. Se **agrega** el documento **05** con:
   - Mejoras realizadas tras la presentación N°3
   - **Innovación:** avisos inmediatos a apoderados al guardar asistencia y al crear evaluaciones
3. Se **agrega** el documento **06** para agilizar la defensa (software corriendo + código + BD + pruebas), según recomendación docente.
4. Se **actualizan** roles demo, mensajería, gateway y flujos en los docs 01–04.

Contraseña demo: `test1234` — usuarios: `admin_colegio`, `admin_oficina`, `prof_castillo`, `apoderado_demo`, `estudiante_demo`.

---

## Contenido del ZIP / RAR para Blackboard

```
LibroDigital_EXAMEN/
├── informe-ep3/                    ← esta carpeta (documentación EP3 + examen)
│   ├── README_ENTREGA_EP3.md
│   ├── 01_arquitectura_microservicios.md|.pdf
│   ├── 02_persistencia_datos.md|.pdf
│   ├── 03_informe_pruebas_unitarias.md|.pdf
│   ├── 04_repositorios_github.txt
│   ├── 05_mejoras_e_innovacion_examen.md|.pdf
│   ├── 06_guia_defensa_examen.md|.pdf
│   ├── diagramas/
│   ├── jacoco-reports/
│   └── coverage-frontend/
├── frontend-react/
├── authService/
├── academicService/
├── attendanceService/
├── apiGetaway/
└── infraestructura/                ← DDL, Postman, diagramas ER
```

Excluir: `node_modules/`, `*/target/`, `*/.git/`, `frontend/` (legacy).

---

## Cómo regenerar PDF

```powershell
cd infraestructura/informe-ep3/scripts
npm install
node export-pdf.mjs
```

Requisito: Chrome o Microsoft Edge.

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
- Guion: `06_guia_defensa_examen.md`
- Núcleo demo: **alertas a apoderados** (`05_mejoras_e_innovacion_examen.md`)
- Preguntas sobre arquitectura, persistencia, pruebas y contribución individual (como en EP3)

---

## Verificación previa

- [ ] Backends: `mvn test` en auth / academic / attendance / gateway
- [ ] Frontend: `npm test` en `frontend-react`
- [ ] Demo innovación: lista + evaluación → mensajes en `apoderado_demo`
- [ ] PDF regenerados (`01`–`03`, `05`, `06`)
- [ ] Repos GitHub al día
- [ ] ZIP subido / material listo para defensa
