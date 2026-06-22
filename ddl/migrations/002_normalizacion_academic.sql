-- =====================================================
-- Migración 002 — Normalización esquema académico
-- Base de datos: librodigital_academic
-- Fecha: 2026-06-07
-- =====================================================
-- 1. Tablas catálogo (reemplazan VARCHAR categóricos)
-- 2. Claves foráneas entre tablas del mismo servicio
-- 3. Elimina columnas redundantes (3FN)
-- =====================================================

BEGIN;

-- -----------------------------------------------------
-- CATÁLOGOS
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS student_statuses (
    id    SMALLINT PRIMARY KEY,
    code  VARCHAR(30)  NOT NULL UNIQUE,
    label VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS teacher_statuses (
    id    SMALLINT PRIMARY KEY,
    code  VARCHAR(30)  NOT NULL UNIQUE,
    label VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS course_statuses (
    id    SMALLINT PRIMARY KEY,
    code  VARCHAR(30)  NOT NULL UNIQUE,
    label VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS enrollment_statuses (
    id    SMALLINT PRIMARY KEY,
    code  VARCHAR(30)  NOT NULL UNIQUE,
    label VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS evaluation_types (
    id    SMALLINT PRIMARY KEY,
    code  VARCHAR(30)  NOT NULL UNIQUE,
    label VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS evaluation_statuses (
    id    SMALLINT PRIMARY KEY,
    code  VARCHAR(30)  NOT NULL UNIQUE,
    label VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS grade_statuses (
    id    SMALLINT PRIMARY KEY,
    code  VARCHAR(30)  NOT NULL UNIQUE,
    label VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS relationship_types (
    id    SMALLINT PRIMARY KEY,
    code  VARCHAR(30)  NOT NULL UNIQUE,
    label VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS contract_types (
    id    SMALLINT PRIMARY KEY,
    code  VARCHAR(30)  NOT NULL UNIQUE,
    label VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS subject_types (
    id    SMALLINT PRIMARY KEY,
    code  VARCHAR(30)  NOT NULL UNIQUE,
    label VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS shifts (
    id    SMALLINT PRIMARY KEY,
    code  VARCHAR(30)  NOT NULL UNIQUE,
    label VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS education_levels (
    id    SMALLINT PRIMARY KEY,
    code  VARCHAR(30)  NOT NULL UNIQUE,
    label VARCHAR(100) NOT NULL,
    stage VARCHAR(20)  NOT NULL
);

CREATE TABLE IF NOT EXISTS academic_years (
    id         SMALLINT PRIMARY KEY,
    year       INTEGER     NOT NULL UNIQUE,
    code       VARCHAR(10) NOT NULL UNIQUE,
    start_date DATE        NOT NULL
);

INSERT INTO student_statuses (id, code, label) VALUES
    (1, 'ACTIVO', 'Activo'),
    (2, 'RETIRADO', 'Retirado'),
    (3, 'EGRESADO', 'Egresado')
ON CONFLICT (id) DO NOTHING;

INSERT INTO teacher_statuses (id, code, label) VALUES
    (1, 'ACTIVO', 'Activo'),
    (2, 'INACTIVO', 'Inactivo')
ON CONFLICT (id) DO NOTHING;

INSERT INTO course_statuses (id, code, label) VALUES
    (1, 'ACTIVO', 'Activo'),
    (2, 'CERRADO', 'Cerrado')
ON CONFLICT (id) DO NOTHING;

INSERT INTO enrollment_statuses (id, code, label) VALUES
    (1, 'ACTIVO', 'Activo'),
    (2, 'SUSPENDIDO', 'Suspendido'),
    (3, 'RETIRADO', 'Retirado')
ON CONFLICT (id) DO NOTHING;

INSERT INTO evaluation_types (id, code, label) VALUES
    (1, 'PRUEBA', 'Prueba'),
    (2, 'CONTROL', 'Control'),
    (3, 'TAREA', 'Tarea'),
    (4, 'EXAMEN', 'Examen')
ON CONFLICT (id) DO NOTHING;

INSERT INTO evaluation_statuses (id, code, label) VALUES
    (1, 'ACTIVO', 'Activo'),
    (2, 'CERRADO', 'Cerrado')
ON CONFLICT (id) DO NOTHING;

INSERT INTO grade_statuses (id, code, label) VALUES
    (1, 'DEFINITIVA', 'Definitiva'),
    (2, 'PRELIMINAR', 'Preliminar'),
    (3, 'EN_REVISION', 'En revisión'),
    (4, 'AUSENTE', 'Ausente')
ON CONFLICT (id) DO NOTHING;

INSERT INTO relationship_types (id, code, label) VALUES
    (1, 'MADRE', 'Madre'),
    (2, 'PADRE', 'Padre'),
    (3, 'TUTOR', 'Tutor legal'),
    (4, 'ABUELO', 'Abuelo'),
    (5, 'ABUELA', 'Abuela'),
    (6, 'TIO', 'Tío'),
    (7, 'TIA', 'Tía')
ON CONFLICT (id) DO NOTHING;

INSERT INTO contract_types (id, code, label) VALUES
    (1, 'PLANTA', 'Planta'),
    (2, 'HONORARIOS', 'Honorarios'),
    (3, 'REEMPLAZO', 'Reemplazo')
ON CONFLICT (id) DO NOTHING;

INSERT INTO subject_types (id, code, label) VALUES
    (1, 'OBLIGATORIA', 'Obligatoria'),
    (2, 'ELECTIVA', 'Electiva')
ON CONFLICT (id) DO NOTHING;

INSERT INTO shifts (id, code, label) VALUES
    (1, 'MANANA', 'Mañana'),
    (2, 'TARDE', 'Tarde'),
    (3, 'COMPLETA', 'Jornada completa')
ON CONFLICT (id) DO NOTHING;

INSERT INTO education_levels (id, code, label, stage) VALUES
    (1, '1B', '1° Básico', 'BASICA'),
    (2, '2B', '2° Básico', 'BASICA'),
    (3, '3B', '3° Básico', 'BASICA'),
    (4, '4B', '4° Básico', 'BASICA'),
    (5, '5B', '5° Básico', 'BASICA'),
    (6, '6B', '6° Básico', 'BASICA'),
    (7, '7B', '7° Básico', 'BASICA'),
    (8, '8B', '8° Básico', 'BASICA'),
    (9, '1M', '1° Medio', 'MEDIA'),
    (10, '2M', '2° Medio', 'MEDIA'),
    (11, '3M', '3° Medio', 'MEDIA'),
    (12, '4M', '4° Medio', 'MEDIA')
ON CONFLICT (id) DO NOTHING;

ALTER TABLE academic_years ADD COLUMN IF NOT EXISTS code VARCHAR(10);
UPDATE academic_years SET code = year::VARCHAR WHERE code IS NULL;

INSERT INTO academic_years (id, year, code, start_date) VALUES
    (1, 2025, '2025', DATE '2025-03-01'),
    (2, 2026, '2026', DATE '2026-03-01'),
    (3, 2027, '2027', DATE '2027-03-01')
ON CONFLICT (id) DO NOTHING;

-- -----------------------------------------------------
-- NUEVAS COLUMNAS FK (catálogos)
-- -----------------------------------------------------

ALTER TABLE students     ADD COLUMN IF NOT EXISTS student_status_id    SMALLINT;
ALTER TABLE teachers     ADD COLUMN IF NOT EXISTS teacher_status_id    SMALLINT;
ALTER TABLE teachers     ADD COLUMN IF NOT EXISTS contract_type_id    SMALLINT;
ALTER TABLE guardians    ADD COLUMN IF NOT EXISTS relationship_id      SMALLINT;
ALTER TABLE courses      ADD COLUMN IF NOT EXISTS course_status_id     SMALLINT;
ALTER TABLE courses      ADD COLUMN IF NOT EXISTS shift_id             SMALLINT;
ALTER TABLE courses      ADD COLUMN IF NOT EXISTS level_id             SMALLINT;
ALTER TABLE courses      ADD COLUMN IF NOT EXISTS academic_year_id      SMALLINT;
ALTER TABLE subjects     ADD COLUMN IF NOT EXISTS subject_type_id      SMALLINT;
ALTER TABLE enrollments  ADD COLUMN IF NOT EXISTS enrollment_status_id SMALLINT;
ALTER TABLE enrollments  ADD COLUMN IF NOT EXISTS academic_year_id     SMALLINT;
ALTER TABLE evaluations  ADD COLUMN IF NOT EXISTS evaluation_type_id   SMALLINT;
ALTER TABLE evaluations  ADD COLUMN IF NOT EXISTS evaluation_status_id  SMALLINT;
ALTER TABLE grades       ADD COLUMN IF NOT EXISTS grade_status_id      SMALLINT;

-- -----------------------------------------------------
-- MIGRAR DATOS VARCHAR → CATÁLOGO
-- -----------------------------------------------------

UPDATE students s SET student_status_id = ss.id
FROM student_statuses ss
WHERE s.student_status_id IS NULL
  AND UPPER(TRIM(s.student_status)) = ss.code;

UPDATE students SET student_status_id = 1 WHERE student_status_id IS NULL;

UPDATE teachers t SET teacher_status_id = ts.id
FROM teacher_statuses ts
WHERE t.teacher_status_id IS NULL
  AND UPPER(TRIM(t.teacher_status)) = ts.code;

UPDATE teachers SET teacher_status_id = 1 WHERE teacher_status_id IS NULL;

UPDATE teachers t SET contract_type_id = ct.id
FROM contract_types ct
WHERE t.contract_type_id IS NULL
  AND t.contract_type IS NOT NULL
  AND UPPER(TRIM(t.contract_type)) = ct.code;

UPDATE guardians g SET relationship_id = rt.id
FROM relationship_types rt
WHERE g.relationship_id IS NULL
  AND UPPER(TRIM(g.relationship)) = rt.code;

UPDATE guardians SET relationship_id = 1 WHERE relationship_id IS NULL;

UPDATE courses c SET course_status_id = cs.id
FROM course_statuses cs
WHERE c.course_status_id IS NULL
  AND UPPER(TRIM(c.course_status)) = cs.code;

UPDATE courses SET course_status_id = 1 WHERE course_status_id IS NULL;

UPDATE courses c SET shift_id = sh.id
FROM shifts sh
WHERE c.shift_id IS NULL
  AND c.shift IS NOT NULL
  AND UPPER(REPLACE(TRIM(c.shift), 'Ñ', 'N')) IN (sh.code, REPLACE(sh.code, 'MANANA', 'MAÑANA'));

UPDATE courses c SET shift_id = sh.id
FROM shifts sh
WHERE c.shift_id IS NULL
  AND c.shift IS NOT NULL
  AND UPPER(TRIM(c.shift)) = sh.code;

UPDATE courses c SET level_id = el.id
FROM education_levels el
WHERE c.level_id IS NULL
  AND c.grade IS NOT NULL
  AND (UPPER(TRIM(c.grade)) = el.label OR UPPER(TRIM(c.grade)) = el.code);

UPDATE courses c SET level_id = el.id
FROM education_levels el
WHERE c.level_id IS NULL
  AND c.level IS NOT NULL
  AND UPPER(TRIM(c.level)) = el.stage;

UPDATE courses SET level_id = 9 WHERE level_id IS NULL;

UPDATE courses c SET academic_year_id = ay.id
FROM academic_years ay
WHERE c.academic_year_id IS NULL
  AND c.academic_year IS NOT NULL
  AND ay.year = EXTRACT(YEAR FROM c.academic_year)::INTEGER;

UPDATE courses SET academic_year_id = 2 WHERE academic_year_id IS NULL;

UPDATE subjects s SET subject_type_id = st.id
FROM subject_types st
WHERE s.subject_type_id IS NULL
  AND s.subject_type IS NOT NULL
  AND UPPER(TRIM(s.subject_type)) = st.code;

UPDATE enrollments e SET enrollment_status_id = es.id
FROM enrollment_statuses es
WHERE e.enrollment_status_id IS NULL
  AND UPPER(TRIM(e.enrollment_status)) = es.code;

UPDATE enrollments SET enrollment_status_id = 1 WHERE enrollment_status_id IS NULL;

UPDATE enrollments e SET academic_year_id = ay.id
FROM academic_years ay
WHERE e.academic_year_id IS NULL
  AND e.academic_year IS NOT NULL
  AND ay.year = e.academic_year;

UPDATE enrollments SET academic_year_id = 2 WHERE academic_year_id IS NULL;

UPDATE evaluations ev SET evaluation_type_id = et.id
FROM evaluation_types et
WHERE ev.evaluation_type_id IS NULL
  AND UPPER(TRIM(ev.evaluation_type)) = et.code;

UPDATE evaluations SET evaluation_type_id = 1 WHERE evaluation_type_id IS NULL;

UPDATE evaluations ev SET evaluation_status_id = es.id
FROM evaluation_statuses es
WHERE ev.evaluation_status_id IS NULL
  AND UPPER(TRIM(ev.evaluation_status)) = es.code;

UPDATE evaluations SET evaluation_status_id = 1 WHERE evaluation_status_id IS NULL;

UPDATE grades g SET grade_status_id = gs.id
FROM grade_statuses gs
WHERE g.grade_status_id IS NULL
  AND UPPER(TRIM(g.grade_status)) = gs.code;

UPDATE grades SET grade_status_id = 1 WHERE grade_status_id IS NULL;

-- -----------------------------------------------------
-- LIMPIAR REFERENCIAS HUÉRFANAS (antes de FK)
-- -----------------------------------------------------

UPDATE students SET guardian_id = NULL
WHERE guardian_id IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM guardians g WHERE g.id = students.guardian_id);

UPDATE courses SET head_teacher_id = NULL
WHERE head_teacher_id IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM teachers t WHERE t.id = courses.head_teacher_id);

UPDATE subjects SET teacher_id = NULL
WHERE teacher_id IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM teachers t WHERE t.id = subjects.teacher_id);

UPDATE subjects SET course_id = NULL
WHERE course_id IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM courses c WHERE c.id = subjects.course_id);

DELETE FROM enrollments
WHERE student_id IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM students s WHERE s.id = enrollments.student_id);

DELETE FROM enrollments
WHERE course_id IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM courses c WHERE c.id = enrollments.course_id);

UPDATE evaluations SET subject_id = NULL
WHERE subject_id IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM subjects s WHERE s.id = evaluations.subject_id);

DELETE FROM grades
WHERE student_id IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM students s WHERE s.id = grades.student_id);

DELETE FROM grades
WHERE evaluation_id IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM evaluations e WHERE e.id = grades.evaluation_id);

UPDATE grades SET graded_by_teacher_id = NULL
WHERE graded_by_teacher_id IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM teachers t WHERE t.id = grades.graded_by_teacher_id);

-- -----------------------------------------------------
-- ELIMINAR COLUMNAS VARCHAR CATEGÓRICAS Y REDUNDANTES
-- -----------------------------------------------------

ALTER TABLE students     DROP COLUMN IF EXISTS student_status;
ALTER TABLE teachers     DROP COLUMN IF EXISTS teacher_status;
ALTER TABLE teachers     DROP COLUMN IF EXISTS contract_type;
ALTER TABLE guardians    DROP COLUMN IF EXISTS relationship;
ALTER TABLE courses      DROP COLUMN IF EXISTS course_status;
ALTER TABLE courses      DROP COLUMN IF EXISTS shift;
ALTER TABLE courses      DROP COLUMN IF EXISTS grade;
ALTER TABLE courses      DROP COLUMN IF EXISTS level;
ALTER TABLE courses      DROP COLUMN IF EXISTS academic_year;
ALTER TABLE subjects     DROP COLUMN IF EXISTS subject_type;
ALTER TABLE enrollments  DROP COLUMN IF EXISTS enrollment_status;
ALTER TABLE enrollments  DROP COLUMN IF EXISTS academic_year;
ALTER TABLE evaluations  DROP COLUMN IF EXISTS evaluation_type;
ALTER TABLE evaluations  DROP COLUMN IF EXISTS evaluation_status;
ALTER TABLE evaluations  DROP COLUMN IF EXISTS course_id;
ALTER TABLE grades       DROP COLUMN IF EXISTS grade_status;
ALTER TABLE grades       DROP COLUMN IF EXISTS subject_id;

-- -----------------------------------------------------
-- NOT NULL EN CATÁLOGOS OBLIGATORIOS
-- -----------------------------------------------------

ALTER TABLE students     ALTER COLUMN student_status_id    SET NOT NULL;
ALTER TABLE teachers     ALTER COLUMN teacher_status_id    SET NOT NULL;
ALTER TABLE guardians    ALTER COLUMN relationship_id      SET NOT NULL;
ALTER TABLE courses      ALTER COLUMN course_status_id     SET NOT NULL;
ALTER TABLE courses      ALTER COLUMN academic_year_id      SET NOT NULL;
ALTER TABLE enrollments  ALTER COLUMN enrollment_status_id SET NOT NULL;
ALTER TABLE enrollments  ALTER COLUMN academic_year_id     SET NOT NULL;
ALTER TABLE evaluations  ALTER COLUMN evaluation_type_id   SET NOT NULL;
ALTER TABLE evaluations  ALTER COLUMN evaluation_status_id SET NOT NULL;
ALTER TABLE grades       ALTER COLUMN grade_status_id      SET NOT NULL;

-- -----------------------------------------------------
-- CLAVES FORÁNEAS
-- -----------------------------------------------------

ALTER TABLE students DROP CONSTRAINT IF EXISTS fk_students_guardian;
ALTER TABLE students ADD CONSTRAINT fk_students_guardian
    FOREIGN KEY (guardian_id) REFERENCES guardians(id);

ALTER TABLE students DROP CONSTRAINT IF EXISTS fk_students_status;
ALTER TABLE students ADD CONSTRAINT fk_students_status
    FOREIGN KEY (student_status_id) REFERENCES student_statuses(id);

ALTER TABLE teachers DROP CONSTRAINT IF EXISTS fk_teachers_status;
ALTER TABLE teachers ADD CONSTRAINT fk_teachers_status
    FOREIGN KEY (teacher_status_id) REFERENCES teacher_statuses(id);

ALTER TABLE teachers DROP CONSTRAINT IF EXISTS fk_teachers_contract;
ALTER TABLE teachers ADD CONSTRAINT fk_teachers_contract
    FOREIGN KEY (contract_type_id) REFERENCES contract_types(id);

ALTER TABLE guardians DROP CONSTRAINT IF EXISTS fk_guardians_relationship;
ALTER TABLE guardians ADD CONSTRAINT fk_guardians_relationship
    FOREIGN KEY (relationship_id) REFERENCES relationship_types(id);

ALTER TABLE courses DROP CONSTRAINT IF EXISTS fk_courses_head_teacher;
ALTER TABLE courses ADD CONSTRAINT fk_courses_head_teacher
    FOREIGN KEY (head_teacher_id) REFERENCES teachers(id);

ALTER TABLE courses DROP CONSTRAINT IF EXISTS fk_courses_status;
ALTER TABLE courses ADD CONSTRAINT fk_courses_status
    FOREIGN KEY (course_status_id) REFERENCES course_statuses(id);

ALTER TABLE courses DROP CONSTRAINT IF EXISTS fk_courses_shift;
ALTER TABLE courses ADD CONSTRAINT fk_courses_shift
    FOREIGN KEY (shift_id) REFERENCES shifts(id);

ALTER TABLE courses DROP CONSTRAINT IF EXISTS fk_courses_level;
ALTER TABLE courses ADD CONSTRAINT fk_courses_level
    FOREIGN KEY (level_id) REFERENCES education_levels(id);

ALTER TABLE courses DROP CONSTRAINT IF EXISTS fk_courses_academic_year;
ALTER TABLE courses ADD CONSTRAINT fk_courses_academic_year
    FOREIGN KEY (academic_year_id) REFERENCES academic_years(id);

ALTER TABLE subjects DROP CONSTRAINT IF EXISTS fk_subjects_teacher;
ALTER TABLE subjects ADD CONSTRAINT fk_subjects_teacher
    FOREIGN KEY (teacher_id) REFERENCES teachers(id);

ALTER TABLE subjects DROP CONSTRAINT IF EXISTS fk_subjects_course;
ALTER TABLE subjects ADD CONSTRAINT fk_subjects_course
    FOREIGN KEY (course_id) REFERENCES courses(id);

ALTER TABLE subjects DROP CONSTRAINT IF EXISTS fk_subjects_type;
ALTER TABLE subjects ADD CONSTRAINT fk_subjects_type
    FOREIGN KEY (subject_type_id) REFERENCES subject_types(id);

ALTER TABLE enrollments DROP CONSTRAINT IF EXISTS fk_enrollments_student;
ALTER TABLE enrollments ADD CONSTRAINT fk_enrollments_student
    FOREIGN KEY (student_id) REFERENCES students(id);

ALTER TABLE enrollments DROP CONSTRAINT IF EXISTS fk_enrollments_course;
ALTER TABLE enrollments ADD CONSTRAINT fk_enrollments_course
    FOREIGN KEY (course_id) REFERENCES courses(id);

ALTER TABLE enrollments DROP CONSTRAINT IF EXISTS fk_enrollments_status;
ALTER TABLE enrollments ADD CONSTRAINT fk_enrollments_status
    FOREIGN KEY (enrollment_status_id) REFERENCES enrollment_statuses(id);

ALTER TABLE enrollments DROP CONSTRAINT IF EXISTS fk_enrollments_academic_year;
ALTER TABLE enrollments ADD CONSTRAINT fk_enrollments_academic_year
    FOREIGN KEY (academic_year_id) REFERENCES academic_years(id);

ALTER TABLE evaluations DROP CONSTRAINT IF EXISTS fk_evaluations_subject;
ALTER TABLE evaluations ADD CONSTRAINT fk_evaluations_subject
    FOREIGN KEY (subject_id) REFERENCES subjects(id);

ALTER TABLE evaluations DROP CONSTRAINT IF EXISTS fk_evaluations_type;
ALTER TABLE evaluations ADD CONSTRAINT fk_evaluations_type
    FOREIGN KEY (evaluation_type_id) REFERENCES evaluation_types(id);

ALTER TABLE evaluations DROP CONSTRAINT IF EXISTS fk_evaluations_status;
ALTER TABLE evaluations ADD CONSTRAINT fk_evaluations_status
    FOREIGN KEY (evaluation_status_id) REFERENCES evaluation_statuses(id);

ALTER TABLE grades DROP CONSTRAINT IF EXISTS fk_grades_student;
ALTER TABLE grades ADD CONSTRAINT fk_grades_student
    FOREIGN KEY (student_id) REFERENCES students(id);

ALTER TABLE grades DROP CONSTRAINT IF EXISTS fk_grades_evaluation;
ALTER TABLE grades ADD CONSTRAINT fk_grades_evaluation
    FOREIGN KEY (evaluation_id) REFERENCES evaluations(id);

ALTER TABLE grades DROP CONSTRAINT IF EXISTS fk_grades_status;
ALTER TABLE grades ADD CONSTRAINT fk_grades_status
    FOREIGN KEY (grade_status_id) REFERENCES grade_statuses(id);

ALTER TABLE grades DROP CONSTRAINT IF EXISTS fk_grades_teacher;
ALTER TABLE grades ADD CONSTRAINT fk_grades_teacher
    FOREIGN KEY (graded_by_teacher_id) REFERENCES teachers(id);

-- RUT único en students (integridad)
CREATE UNIQUE INDEX IF NOT EXISTS uk_students_rut ON students(rut);

COMMIT;
