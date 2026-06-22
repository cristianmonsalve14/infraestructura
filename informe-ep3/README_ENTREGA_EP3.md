# Evaluación Parcial N°3 — Encargo (30%)

**Asignatura:** DSY1106 — Desarrollo Fullstack III  
**Integración de arquitectura de microservicios**  
**Proyecto:** Plataforma Libro de Clases Digital  
**Equipo:** Cristian Monsalve / Héctor Olivares  
**Fecha de entrega:** 2026-06-20  

---

## Índice del encargo

| # | Documento | Formato solicitado | Archivo en esta carpeta |
|---|-----------|-------------------|-------------------------|
| 1 | Diagrama de arquitectura de microservicios | PNG / PDF | `diagramas/architecture_patterns_simple.png` |
| 2 | Descripción de persistencia de datos | PDF | `02_persistencia_datos.pdf` |
| 3 | Informe de pruebas unitarias con métricas | PDF | `03_informe_pruebas_unitarias.pdf` |
| 1b | Documento arquitectura (texto) | PDF | `01_arquitectura_microservicios.pdf` |
| 4 | Enlaces a repositorios GitHub | TXT / PDF | `04_repositorios_github.txt` |
| 5 | Especificación API REST (Postman) | JSON | `../postman/Libro_Digital.postman_collection.json` |
| 6 | Reportes de cobertura JaCoCo | HTML | `jacoco-reports/{servicio}/index.html` |
| 7 | Reporte cobertura frontend (Vitest) | HTML | `coverage-frontend/index.html` |

---

## Contenido del ZIP / RAR para Blackboard

Comprimir la siguiente estructura (excluir `node_modules`, `target`, `.git`):

```
LibroDigital_EP3/
├── informe-ep3/                    ← esta carpeta (documentación)
│   ├── README_ENTREGA_EP3.md
│   ├── 01_arquitectura_microservicios.md
│   ├── 02_persistencia_datos.md
│   ├── 03_informe_pruebas_unitarias.md
│   ├── 04_repositorios_github.txt
│   ├── diagramas/
│   └── jacoco-reports/
├── frontend-react/                 ← código fuente UI
├── authService/
├── academicService/
├── attendanceService/
├── apiGetaway/
└── infraestructura/                ← DDL, Postman, diagramas ER
```

> **Tip:** desde la raíz del workspace, excluir carpetas pesadas antes de comprimir:
> `node_modules/`, `*/target/`, `*/.git/`, `frontend/` (scaffold legacy sin UI activa).

---

## Cómo convertir los `.md` a PDF

Los PDF ya están generados en esta carpeta:

- `01_arquitectura_microservicios.pdf`
- `02_persistencia_datos.pdf`
- `03_informe_pruebas_unitarias.pdf`

Para **regenerarlos** después de editar los `.md`:

```powershell
cd infraestructura/informe-ep3/scripts
npm install
node export-pdf.mjs
```

Requisito: Chrome o Microsoft Edge instalado (el script usa el navegador en modo headless).

Alternativa manual: abrir cada `.md` en VS Code con extensión *Markdown PDF*, o copiar a Word/Google Docs → Exportar como PDF.

---

## Enlaces GitHub (resumen)

| Repositorio | URL |
|-------------|-----|
| Infraestructura (principal) | https://github.com/cristianmonsalve14/infraestructura |
| Frontend React | https://github.com/cristianmonsalve14/frontend-react |
| API Gateway | https://github.com/cristianmonsalve14/apiGetaway |
| Auth Service | https://github.com/cristianmonsalve14/authService |
| Academic Service | https://github.com/cristianmonsalve14/academicService |
| Attendance Service | https://github.com/cristianmonsalve14/attendanceService |

Detalle en `04_repositorios_github.txt`.

---

## Defensa oral (70%)

- Duración: **15 minutos** de exposición grupal.
- Preguntas **individuales** del docente sobre arquitectura, persistencia, pruebas y contribución de cada integrante.
- Material de apoyo: diagramas en `diagramas/`, documentación en `../docs/`, y este informe.

---

## Verificación previa a la entrega

- [ ] Los 4 backends compilan y pasan tests: `mvn test` en cada servicio.
- [ ] Reportes JaCoCo actualizados: `mvn test jacoco:report`.
- [ ] Postman: login + al menos un flujo academic y attendance vía gateway `:8090`.
- [ ] Frontend: `npm run test:coverage` en `frontend-react/` — 53 tests OK.
- [ ] Repositorios GitHub actualizados (`git push` en cada módulo).
- [ ] ZIP generado y subido a Blackboard con enlaces a repos.
