-- LAB-01, Actividad 16: exportar y conservar la bitácora
-- Consulta ejecutada como postgres en la base comercial.
-- Lee el archivo de bitácora vigente y sustituye la contraseña del rol
-- La contraseña real se omite aquí con un marcador por la regla de no subir contraseñas.

SELECT replace(
         pg_read_file(pg_current_logfile()),
         '<CONTRASEÑA_DEL_ROL_TEMPORAL>',
         '<REDACTED>'
       );

-- Comandos de terminal usados (desde la carpeta LAB-01/):
--
--   docker exec dba-u3-pg psql -U postgres -d comercial -At -c "<la consulta de arriba, con la contraseña real>" > evidencias/bitacora-lab01.log
--   grep -c "<contraseña real>" evidencias/bitacora-lab01.log     -- debe devolver 0
--   sha256sum evidencias/bitacora-lab01.log > evidencias/bitacora-lab01.sha256
--   sha256sum -c evidencias/bitacora-lab01.sha256                 -- debe responder OK
