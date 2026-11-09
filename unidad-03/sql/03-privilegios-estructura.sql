-- LAB-01, Actividad 6: cambios de privilegios y de estructura
-- Ejecutar como postgres en la base comercial, con log_statement = 'ddl'

REVOKE UPDATE ON clientes FROM soporte_ana;
GRANT UPDATE ON clientes TO app_ventas;
ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20);

-- Rol desechable para demostrar que la bitácora filtra secretos
-- (la contraseña real se omite aquí por la regla de no subir contraseñas)
CREATE ROLE rol_temporal LOGIN PASSWORD '<REDACTED>';
DROP ROLE rol_temporal;

SELECT linea FROM dba.bitacora WHERE linea LIKE '%statement:%' ORDER BY num;
