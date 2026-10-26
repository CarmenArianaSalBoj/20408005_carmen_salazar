////////////////////////////////////////////////////////////////////////////////
-- ACTIVIDAD 1- IDENTIFICAR LA SUPERFICIE DE ATAQUE ---
//////////////////////////////////////////////////////////////////////////

--OBJETIVO: Identificar los principales puntos de exposición del servidor PostgreSQL.

--- EJECUTAMOS 

SELECT version();

--- DESPUES
SHOW port;
SHOW listen_addresses;
SHOW ssl;
SHOW password_encryption;

-- INFORMACION SOBRE CONEXIONES
SELECT
    pid,
    usename,
    datname,
    client_addr,
    client_port,
    application_name
FROM pg_stat_activity;


-- ============================================================
--  ANALISIS DE LA SUPERFICIE DE ATAQUE
-- ============================================================
--
-- Elemento: Puerto PostgreSQL
-- Estado actual: 5432
-- ¿Es necesario?: Si, para permitir conexiones al servidor.
-- Riesgo: Exposicion a intentos de conexion no autorizados
-- si el puerto es accesible desde redes externas.
--
-- Elemento: Interfaces de escucha
-- Estado actual: localhost
-- ¿Es necesario?: Si, para conexiones locales.
-- Riesgo: La escucha local limita la exposicion remota.
--
-- Elemento: Conexiones remotas
-- Estado actual: No se observan direcciones IP remotas
-- en los resultados compartidos.
-- ¿Es necesario?: Solo si las aplicaciones requieren
-- conexiones desde otros equipos.
-- Riesgo: No se identificaron conexiones remotas en la
-- salida revisada; esto no demuestra por si solo que
-- sean imposibles.
--
-- Elemento: Usuarios administrativos
-- Estado actual: Se observa el usuario postgres
-- en las sesiones mostradas.
-- ¿Es necesario?: Si, para tareas administrativas.
-- Riesgo: El uso indebido de una cuenta privilegiada
-- puede comprometer toda la base de datos.
-- 
-- Elemento: SSL/TLS
-- Estado actual: on
-- ¿Es necesario?: Recomendable para conexiones de red.
-- Riesgo: SSL esta habilitado, pero se debe verificar
-- que las conexiones utilicen cifrado.
--
-- Elemento: Metodos de autenticacion
-- Estado actual: scram-sha-256
-- ¿Es necesario?: Si, para autenticar usuarios
-- mediante contrasena.
-- Riesgo: Es un metodo robusto de almacenamiento
-- de contrasenas, tambien deben revisarse las reglas
-- de autenticacion de pg_hba.conf.
--
-- ============================================================
-- 5. CONCLUSION
-- ============================================================
-- La inspeccion permite identificar la configuracion
-- de red, el soporte de cifrado y las conexiones activas
-- de PostgreSQL. Estos datos sirven como base para
-- determinar que medidas de hardening deben aplicarse
-- y reducir la superficie de ataque del servidor.
-- ============================================================  

