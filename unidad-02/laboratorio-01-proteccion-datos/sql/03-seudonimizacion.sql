
-- Actividad 3: Seudonimizacion de clientes

-- 9.1 Crear los esquemas
CREATE SCHEMA IF NOT EXISTS pii;
CREATE SCHEMA IF NOT EXISTS analitica;

-- 9.2 Crear la tabla de correspondencia
CREATE TABLE IF NOT EXISTS pii.mapa_cliente (
    token UUID PRIMARY KEY,
    cliente_id BIGINT UNIQUE
        REFERENCES public.clientes(id)
);

-- 9.3 Habilitar la extension para generar UUID
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Generar tokens para clientes que aun no tienen uno
INSERT INTO pii.mapa_cliente (token, cliente_id)
SELECT
    gen_random_uuid(),
    c.id
FROM public.clientes AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM pii.mapa_cliente AS m
    WHERE m.cliente_id = c.id
);

-- Verificar la correspondencia
SELECT *
FROM pii.mapa_cliente;

-- Contar los tokens generados
SELECT COUNT(*) AS total_tokens
FROM pii.mapa_cliente;

-- 10. Crear el conjunto de datos para analitica

CREATE TABLE IF NOT EXISTS analitica.clientes AS
SELECT
    m.token AS cliente_token,
    c.edad,
    c.ciudad,
    c.codigo_postal,
    c.fecha_alta
FROM pii.mapa_cliente AS m
JOIN public.clientes AS c
    ON c.id = m.cliente_id;

-- Verificar los datos de analitica

SELECT *
FROM analitica.clientes;

-- Verificar las columnas de la tabla

SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'analitica'
  AND table_name = 'clientes'
ORDER BY ordinal_position;
