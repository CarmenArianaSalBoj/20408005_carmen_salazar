-- LAB-01, Actividad 2: colector de bitácora y vista dba.bitacora
-- Ejecutar como postgres en la base comercial

ALTER SYSTEM SET logging_collector = on;
SELECT name, setting, pending_restart FROM pg_settings WHERE name = 'logging_collector';

-- Reiniciar el servicio (docker restart dba-u3-pg) y volver a abrir la sesión

SELECT name, setting, source FROM pg_settings WHERE name = 'logging_collector';
SELECT pg_current_logfile();

CREATE SCHEMA dba;
REVOKE ALL ON SCHEMA dba FROM PUBLIC;

CREATE VIEW dba.bitacora AS
SELECT t.n AS num, t.linea
FROM regexp_split_to_table(pg_read_file(pg_current_logfile()), E'\n')
     WITH ORDINALITY AS t(linea, n)
WHERE t.linea <> '';

-- Consultas de ejemplo
SELECT num, linea FROM dba.bitacora ORDER BY num DESC LIMIT 10;
SELECT linea FROM dba.bitacora WHERE linea ILIKE '%update%';
SELECT linea FROM dba.bitacora WHERE linea ~ '(FATAL|ERROR)';
