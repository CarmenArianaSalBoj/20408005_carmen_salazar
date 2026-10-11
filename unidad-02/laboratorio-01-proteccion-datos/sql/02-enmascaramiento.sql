
-- Actividad 2: Enmascaramiento de datos

-- 1. Crear el rol de soporte
CREATE ROLE soporte NOLOGIN;

-- 2. Crear una vista con datos parcialmente ocultos
CREATE VIEW public.v_clientes_soporte AS
SELECT
    id,
    nombre,

    CONCAT(
        LEFT(correo, 2),
        '*****',
        SUBSTRING(correo FROM POSITION('@' IN correo))
    ) AS correo,

    CONCAT(
        '******',
        RIGHT(telefono, 4)
    ) AS telefono,

    CONCAT(
        '*********',
        RIGHT(rfc, 4)
    ) AS rfc

FROM public.clientes;

-- 3. Conceder acceso al esquema
GRANT USAGE
ON SCHEMA public
TO soporte;

-- 4. Permitir consultar únicamente la vista
GRANT SELECT
ON public.v_clientes_soporte
TO soporte;

-- 5. Revocar el acceso directo a la tabla original
REVOKE ALL
ON public.clientes
FROM soporte;

-- 6. Consultar la vista para comprobar el enmascaramiento
SELECT *
FROM public.v_clientes_soporte;
