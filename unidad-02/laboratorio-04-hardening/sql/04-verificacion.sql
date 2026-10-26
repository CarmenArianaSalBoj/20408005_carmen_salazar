-- LAB-04: Hardening de PostgreSQL 16
-- Archivo: 04-verificacion.sql
-- Objetivo: verificar parametros de seguridad, autenticacion,
-- conexiones, roles, extensiones y uso de TLS.
-- Estas consultas son de inspeccion; no modifican la configuracion.

-- 1. Verificar version de PostgreSQL.
SELECT version();

-- 2. Verificar parametros principales de seguridad.
SHOW port;
SHOW listen_addresses;
SHOW ssl;
SHOW ssl_min_protocol_version;
SHOW password_encryption;
SHOW max_connections;
SHOW superuser_reserved_connections;
SHOW statement_timeout;
SHOW idle_in_transaction_session_timeout;

-- 3. Verificar las reglas interpretadas de pg_hba.conf.
SELECT line_number,
       type,
       database,
       user_name,
       address,
       auth_method,
       error
FROM pg_hba_file_rules
ORDER BY line_number;

-- 4. Verificar roles y atributos administrativos.
SELECT rolname,
       rolsuper,
       rolcreaterole,
       rolcreatedb,
       rolcanlogin
FROM pg_roles
ORDER BY rolname;

-- 5. Verificar extensiones instaladas en la base actual.
SELECT extname,
       extversion
FROM pg_extension
ORDER BY extname;

-- 6. Verificar conexiones activas.
SELECT pid,
       usename,
       datname,
       client_addr,
       application_name,
       state
FROM pg_stat_activity
ORDER BY usename, pid;

-- 7. Verificar si la sesion actual usa TLS.
SELECT a.pid,
       a.usename,
       a.client_addr,
       s.ssl,
       s.version,
       s.cipher
FROM pg_stat_activity AS a
JOIN pg_stat_ssl AS s
  ON a.pid = s.pid
WHERE a.pid = pg_backend_pid();

-- 8. Consultar las rutas de configuracion y datos.
SHOW config_file;
SHOW hba_file;
SHOW data_directory;

