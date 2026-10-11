
-- =====================================================
-- Actividad 4: Anonimización de datos

-- 1. Crear el esquema para los datos anonimizados.
CREATE SCHEMA IF NOT EXISTS anonimizado;

-- 2. Crear una tabla con datos generales,
-- excluyendo nombre, correo, teléfono y RFC.
DROP TABLE IF EXISTS anonimizado.clientes;

CREATE TABLE anonimizado.clientes AS
SELECT
    edad,
    ciudad,
    codigo_postal,
    fecha_alta
FROM public.clientes;

-- 3. Verificar los datos resultantes.
SELECT *
FROM anonimizado.clientes;

-- 4. Comprobar el número de registros.
SELECT COUNT(*) AS total_registros
FROM anonimizado.clientes;

-- 5. Verificar las columnas de la tabla.
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'anonimizado'
  AND table_name = 'clientes'
ORDER BY ordinal_position;
