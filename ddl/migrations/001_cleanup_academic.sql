-- =====================================================
-- Migración 001 — Limpieza esquema académico
-- Base de datos: librodigital_academic
-- Fecha: 2026-06-07
-- =====================================================
-- Elimina columnas legadas del diseño monolítico y campos
-- redundantes. Ejecutar conectado a librodigital_academic.
-- =====================================================

-- students: datos médicos y campo name obsoleto
ALTER TABLE students DROP COLUMN IF EXISTS blood_type;
ALTER TABLE students DROP COLUMN IF EXISTS allergies;
ALTER TABLE students DROP COLUMN IF EXISTS medical_conditions;
ALTER TABLE students DROP COLUMN IF EXISTS emergency_medication;
ALTER TABLE students DROP COLUMN IF EXISTS name;

-- courses: teacher_id y year reemplazados por head_teacher_id y academic_year
ALTER TABLE courses DROP COLUMN IF EXISTS teacher_id;
ALTER TABLE courses DROP COLUMN IF EXISTS year;

-- teachers: user_id no usado en entidad JPA actual
ALTER TABLE teachers DROP COLUMN IF EXISTS user_id;

-- evaluations: grade pertenece a la tabla grades (notas por alumno)
ALTER TABLE evaluations DROP CONSTRAINT IF EXISTS evaluations_grade_check;
ALTER TABLE evaluations DROP COLUMN IF EXISTS grade;

-- grades: campos calculables (se derivan de score y max_score)
ALTER TABLE grades DROP COLUMN IF EXISTS letter_grade;
ALTER TABLE grades DROP COLUMN IF EXISTS percentage;
