-- Reemplaza VESPERTINO por Jornada completa (uso habitual en colegios chilenos)
\c librodigital_academic

UPDATE shifts
SET code = 'COMPLETA', label = 'Jornada completa'
WHERE code = 'VESPERTINO';
