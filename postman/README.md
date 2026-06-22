# Pruebas con Postman — Libro Digital

## Requisitos previos

Levantar los 4 servicios backend (en terminales separadas):

```bash
cd authService && mvn spring-boot:run        # :8091
cd academicService && mvn spring-boot:run    # :8092
cd attendanceService && mvn spring-boot:run  # :8093
cd apiGetaway && mvn spring-boot:run         # :8090
```

## Importar colección

1. Abre Postman → **Import**
2. Selecciona `Libro_Digital.postman_collection.json`
3. La variable `baseUrl` apunta a `http://localhost:8090`

## Flujo de prueba

### Paso 1 — Login

Request: **Auth → Login**

```json
{
  "username": "admin_colegio",
  "password": "test1234"
}
```

El script de tests guarda automáticamente `accessToken` en la variable `{{token}}`.

> `POST /auth/register` está **deshabilitado**. Usa los usuarios demo de `docs/bases_de_datos.md`.

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

## Usuarios demo

| Usuario | Contraseña | Rol |
|---|---|---|
| `admin_colegio` | `test1234` | ADMINISTRADOR |
| `prof_castillo` | `test1234` | DOCENTE |
| `apoderado_demo` | `test1234` | APODERADO |
| `estudiante_demo` | `test1234` | ESTUDIANTE |

## IDs de referencia (academic actual)

| Entidad | ID |
|---|---|
| Curso 1° Medio | 17 |
| Asignatura Matemáticas | 2 |
| Docente Manuel | 1 |
| Estudiante Juan | 2 |

> Los IDs pueden variar según tu BD. Ajusta los bodies de POST si es necesario.

## Endpoints incluidos

| Grupo | Rutas |
|---|---|
| Auth | `POST /auth/login` |
| Academic | `GET /students`, `/courses`, `/teachers` |
| Attendance | `GET/POST /sessions`, `/attendances`, `/annotations` |
