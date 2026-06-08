# Pruebas con Postman — Libro Digital

## Requisitos previos

Levantar los 4 servicios backend (en terminales separadas):

```bash
cd authService && mvn spring-boot:run        # :8091
cd academicService && mvn spring-boot:run    # :8092
cd attendanceService && mvn spring-boot:run   # :8093
cd apiGetaway && mvn spring-boot:run          # :8090
```

## Importar colección

1. Abre Postman → **Import**
2. Selecciona `Libro_Digital.postman_collection.json`
3. La variable `baseUrl` ya apunta a `http://localhost:8090`

## Flujo de prueba

### Paso 1 — Login

Request: **Auth → Login**

```json
{
  "username": "postman_test",
  "password": "test1234"
}
```

El script de tests guarda automáticamente `accessToken` en la variable `{{token}}`.

Si no tienes usuario, usa **Auth → Register** primero.

### Paso 2 — Probar attendance

Con el token guardado, ejecuta en orden:

1. **Attendance — Sessions → List Sessions** → `GET /sessions`
2. **Attendance — Records → List Attendances** → `GET /attendances`
3. **Attendance — Annotations → List Annotations** → `GET /annotations`

### Paso 3 — Crear datos

- **Create Session** → `POST /sessions`
- **Create Attendance** → `POST /attendances` (status: `PRESENTE`, `AUSENTE`, `ATRASADO`, `JUSTIFICADO`)
- **Create Annotation** → `POST /annotations` (type: `POSITIVA`, `NEGATIVA`)

## Header obligatorio (rutas protegidas)

```
Authorization: Bearer {{token}}
Content-Type: application/json
```

## IDs de referencia (academic actual)

| Entidad | ID |
|---|---|
| Curso 1° Medio | 17 |
| Asignatura Matemáticas | 2 |
| Docente Manuel | 1 |
| Estudiante Juan | 2 |

## Resultados verificados (2026-06-07)

| Endpoint | Método | Resultado |
|---|---|---|
| `/auth/register` | POST | ✅ 200 + token |
| `/auth/login` | POST | ✅ 200 + token |
| `/sessions` | GET | ✅ 200 (1 sesión) |
| `/attendances` | GET | ✅ 200 (1 asistencia) |
| `/annotations` | GET | ✅ 200 (1 anotación) |
| `/sessions` | POST | ✅ 201 — sesión id 2 |
| `/attendances` | POST | ✅ 201 — asistencia AUSENTE |
| `/students` | GET | ✅ 200 (vía gateway) |
