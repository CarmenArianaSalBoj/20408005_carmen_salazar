
-- =====================================================
-- Actividad 4: Anonimización de datos

-- 1. Crear el rol
CREATE ROLE analista NOLOGIN;
-- 2. Conceder acceso al conjunto de datos analítico:

GRANT USAGE
ON SCHEMA analitica
TO analista;

GRANT SELECT
ON analitica.clientes
TO analista;
-- 3. Verificar los permisos
SELECT *
FROM analitica.clientes;
-- 4. El acceso al mapa de correspondencia debe estar restringido:

SELECT *
FROM pii.mapa_cliente;
-- 5. También debe estar restringido el acceso directo a los datos originales:

SELECT *
FROM public.clientes;
