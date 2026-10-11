-- Actividad 1: Clasificación de los datos

-- Consultar la estructura de la tabla clientes
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'clientes'
ORDER BY ordinal_position;

-- Consultar una muestra de los registros
SELECT
    id,
    nombre,
    correo,
    telefono,
    rfc,
    edad,
    ciudad,
    codigo_postal,
    fecha_alta
FROM public.clientes
LIMIT 10;

-- Contar los registros
SELECT COUNT(*) AS total_clientes
FROM public.clientes;
