# 06 — Guía de defensa del examen (agilizar software, código, BD y pruebas)

**Proyecto:** Plataforma Libro de Clases Digital  
**Equipo:** Cristian Monsalve / Héctor Olivares  
**Objetivo:** Cumplir la recomendación docente de presentar con **software corriendo** y mostrar **código, BD y pruebas** sin perder tiempo.

---

## 1. Antes del día (checklist)

- [ ] PostgreSQL con `librodigital_auth`, `librodigital_academic`, `librodigital_attendance`
- [ ] `application-local.properties` en auth, academic, attendance y gateway (misma `jwt.secret`)
- [ ] Los 4 backends + frontend arrancan en el PC de defensa
- [ ] Probado el flujo innovación: lista → mensaje apoderado; evaluación → mensaje apoderado
- [ ] Navegador con pestañas listas: UI `:8094`, Opción B: DBeaver/pgAdmin, carpeta `informe-ep3`
- [ ] ZIP / PDF del informe actualizado (docs `01`–`06`)

### Arranque rápido (orden)

```text
1. authService      :8091
2. academicService  :8092
3. attendanceService:8093
4. apiGetaway       :8090
5. frontend-react   :8094   → http://localhost:8094
```

Ver también `README.md` en la raíz del workspace.

---

## 2. Guion sugerido (≈ 12–15 min)

| Min | Qué mostrar | Quién / nota |
|-----|-------------|--------------|
| 0–2 | Portada: arquitectura (diagrama) + “esto está corriendo ahora” | Abrir UI login |
| 2–5 | Roles: Dirección / Oficina / Docente / Apoderado | Cambiar usuario demo |
| 5–9 | **Innovación:** pasar lista → confirmar → apoderado ve aviso; crear evaluación → aviso | Núcleo del examen |
| 9–11 | Código: `AcademicApiClient.notifyGuardianAttendance` + `notifyGuardiansEvaluationCreated` | IDE ya abierto en esas clases |
| 11–13 | BD: tablas `conversations` / `messages` (academic) + `attendance_records` | pgAdmin |
| 13–15 | Pruebas: correr 1 `mvn test` (auth) o mostrar reporte JaCoCo; Vitest summary | Terminal lista |

Reservar 1–2 min para preguntas individuales.

---

## 3. Usuarios demo (password `test1234`)

| Usuario | Rol | Demo típica |
|---------|-----|-------------|
| `admin_colegio` | SUPER_ADMINISTRADOR | Dirección, estructura |
| `admin_oficina` | ADMINISTRATIVO | Oficina / coordinación |
| `prof_castillo` | DOCENTE | Lista + evaluaciones (innovación) |
| `apoderado_demo` | APODERADO | **Ver alertas** en Mensajes |
| `estudiante_demo` | ESTUDIANTE | Portal alumno |

---

## 4. Cómo mostrar código sin navegar 10 minutos

Tener **3 pestañas fijas en el IDE**:

1. `AcademicApiClient.java` (método `notifyGuardianAttendance`)
2. `MessageServiceImpl.java` (`notifyGuardianAttendance` / `notifyGuardiansEvaluationCreated`)
3. `EvaluationController.java` (hook en `createEvaluation`) + `ConfirmDialog.tsx`

Frase útil:  
*“Attendance no envía el mensaje; llama a academic, que es dueño de la mensajería. Si el notify falla, la lista igual se guarda.”*

---

## 5. Cómo mostrar BD

Consultas mínimas (academic):

```sql
-- Últimas conversaciones TG
SELECT id, conversation_type, student_id, teacher_id, guardian_id, updated_at
FROM conversations
ORDER BY updated_at DESC
LIMIT 10;

-- Últimos mensajes (avisos automáticos)
SELECT id, conversation_id, body, created_at
FROM messages
ORDER BY created_at DESC
LIMIT 10;
```

Asistencia (attendance):

```sql
SELECT id, session_id, student_id, status, updated_at
FROM attendance_records
ORDER BY updated_at DESC
LIMIT 10;
```

---

## 6. Cómo mostrar pruebas (rápido)

```powershell
# Ejemplo vivo (1–2 min)
cd authService
mvn -q test

# Frontend
cd frontend-react
npm test
```

Si no alcanza el tiempo: abrir `informe-ep3/jacoco-reports/authService/index.html` y decir cobertura EP3 + que las suites siguen green; el valor nuevo del examen es la **demo funcional de alertas**.

---

## 7. Plan B (si falla la red o un puerto)

1. Relanzar solo el servicio caído (puertos en `README.md`).
2. Si PostgreSQL cae: reiniciar servicio Windows / Docker según cómo lo tengan.
3. Video/screenshots previos del flujo innovación (último recurso).
4. Explicar con el diagrama de `05_mejoras_e_innovacion_examen.md`.

---

## 8. Mensaje de cierre (15 s)

*“En EP3 entregamos microservicios, persistencia por servicio y pruebas con métricas. Para el examen aplicamos el feedback: software listo para defensa y una innovación concreta —alertas inmediatas a apoderados al pasar lista y al publicar evaluaciones— integrada en la mensajería del colegio.”*
