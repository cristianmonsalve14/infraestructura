-- Vincula profesores con cuentas de authService (username / user id lógico)
ALTER TABLE teachers ADD COLUMN IF NOT EXISTS auth_username VARCHAR(100) UNIQUE;
ALTER TABLE teachers ADD COLUMN IF NOT EXISTS user_id BIGINT UNIQUE;
