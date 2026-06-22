-- =====================================================
-- LIBRO DIGITAL — Creación de bases de datos
-- =====================================================
-- Ejecutar conectado a PostgreSQL como superusuario (postgres).
-- En pgAdmin: Query Tool sobre la base "postgres".
-- =====================================================

CREATE DATABASE librodigital_auth;
CREATE DATABASE librodigital_academic;
CREATE DATABASE librodigital_attendance;

-- Si ya existen, PostgreSQL mostrará error — puedes ignorarlo
-- o usar:
-- SELECT 'CREATE DATABASE librodigital_auth' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'librodigital_auth')\gexec
