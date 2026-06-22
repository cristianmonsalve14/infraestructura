-- =====================================================
-- Migración 002 — Normalización esquema asistencia
-- Base de datos: librodigital_attendance
-- Fecha: 2026-06-07
-- =====================================================

BEGIN;

CREATE TABLE IF NOT EXISTS session_statuses (
    id    SMALLINT PRIMARY KEY,
    code  VARCHAR(30)  NOT NULL UNIQUE,
    label VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS attendance_statuses (
    id    SMALLINT PRIMARY KEY,
    code  VARCHAR(30)  NOT NULL UNIQUE,
    label VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS annotation_types (
    id    SMALLINT PRIMARY KEY,
    code  VARCHAR(30)  NOT NULL UNIQUE,
    label VARCHAR(100) NOT NULL
);

INSERT INTO session_statuses (id, code, label) VALUES
    (1, 'ABIERTA', 'Abierta'),
    (2, 'CERRADA', 'Cerrada')
ON CONFLICT (id) DO NOTHING;

INSERT INTO attendance_statuses (id, code, label) VALUES
    (1, 'PRESENTE', 'Presente'),
    (2, 'AUSENTE', 'Ausente'),
    (3, 'ATRASADO', 'Atrasado'),
    (4, 'JUSTIFICADO', 'Justificado')
ON CONFLICT (id) DO NOTHING;

INSERT INTO annotation_types (id, code, label) VALUES
    (1, 'POSITIVA', 'Positiva'),
    (2, 'NEGATIVA', 'Negativa')
ON CONFLICT (id) DO NOTHING;

ALTER TABLE class_sessions      ADD COLUMN IF NOT EXISTS session_status_id    SMALLINT;
ALTER TABLE attendance_records  ADD COLUMN IF NOT EXISTS attendance_status_id SMALLINT;
ALTER TABLE annotations         ADD COLUMN IF NOT EXISTS annotation_type_id  SMALLINT;

UPDATE class_sessions cs SET session_status_id = ss.id
FROM session_statuses ss
WHERE cs.session_status_id IS NULL
  AND UPPER(TRIM(cs.session_status)) = ss.code;

UPDATE class_sessions SET session_status_id = 1 WHERE session_status_id IS NULL;

UPDATE attendance_records ar SET attendance_status_id = ast.id
FROM attendance_statuses ast
WHERE ar.attendance_status_id IS NULL
  AND UPPER(TRIM(ar.status)) = ast.code;

UPDATE attendance_records SET attendance_status_id = 1 WHERE attendance_status_id IS NULL;

UPDATE annotations a SET annotation_type_id = at.id
FROM annotation_types at
WHERE a.annotation_type_id IS NULL
  AND UPPER(TRIM(a.type)) = at.code;

UPDATE annotations SET annotation_type_id = 1 WHERE annotation_type_id IS NULL;

DELETE FROM attendance_records
WHERE session_id NOT IN (SELECT id FROM class_sessions);

ALTER TABLE class_sessions     DROP COLUMN IF EXISTS session_status;
ALTER TABLE attendance_records DROP COLUMN IF EXISTS status;
ALTER TABLE annotations        DROP COLUMN IF EXISTS type;

ALTER TABLE class_sessions     ALTER COLUMN session_status_id SET NOT NULL;
ALTER TABLE attendance_records ALTER COLUMN attendance_status_id SET NOT NULL;
ALTER TABLE annotations        ALTER COLUMN annotation_type_id SET NOT NULL;

ALTER TABLE class_sessions DROP CONSTRAINT IF EXISTS fk_sessions_status;
ALTER TABLE class_sessions ADD CONSTRAINT fk_sessions_status
    FOREIGN KEY (session_status_id) REFERENCES session_statuses(id);

ALTER TABLE attendance_records DROP CONSTRAINT IF EXISTS fk_attendance_session;
ALTER TABLE attendance_records ADD CONSTRAINT fk_attendance_session
    FOREIGN KEY (session_id) REFERENCES class_sessions(id);

ALTER TABLE attendance_records DROP CONSTRAINT IF EXISTS fk_attendance_status;
ALTER TABLE attendance_records ADD CONSTRAINT fk_attendance_status
    FOREIGN KEY (attendance_status_id) REFERENCES attendance_statuses(id);

ALTER TABLE annotations DROP CONSTRAINT IF EXISTS fk_annotations_type;
ALTER TABLE annotations ADD CONSTRAINT fk_annotations_type
    FOREIGN KEY (annotation_type_id) REFERENCES annotation_types(id);

COMMIT;
