--------------------------------------------------------------------------
/////////////////////////////////////////////////////////////////////////////
----------------------------------------------------------------------------------
---   ACTIVIDAD 4 - CONTROL DE ACCESO RELACIONADO CON LA FINALIDAD
---   
--------------------------------------------------------------------------

--CREA UN ROL
CREATE ROLE analista NOLOGIN;

--OTRORGAR UNICAMENTE ACCESO A LA INFORMACIÓN PREPARADA PARA ANALITICA.
--POR EJEMPLO, CREA UNA VISTA

CREATE VIEW v_analitica_clientes AS
SELECT
    ciudad,
    CASE
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 29 THEN '18-29'
        WHEN edad BETWEEN 30 AND 44 THEN '30-44'
        WHEN edad BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60 o más'
    END AS rango_edad
FROM clientes;

--OTORGAR PERSMISOS
GRANT USAGE ON SCHEMA public TO analista;

GRANT SELECT
ON v_analitica_clientes
TO analista;

--NO OTORgar accesos a la tabla clientes
//GRANT SELECT ON clientes TO analista;

--COMPROBAR PRIVILEGIOS
SELECT
    grantee,
    table_name,
    privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'analista';

/*
1. ¿Qué información puede consultar el rol?
Puede consultar la vista v_analitica_clientes, que contiene la ciudad y el rango de edad de los clientes.

2. ¿Puede consultar directamente clientes?
No. El rol analista no tiene permisos de lectura sobre la tabla original, porque únicamente se le otorgó acceso a la vista.

3. ¿Puede obtener nombre, correo y RFC?
No. Esos campos no están incluidos en la vista y el rol no tiene acceso directo a la tabla clientes.

4. ¿Qué principio de privacidad estás aplicando?
El principio de minimización de datos, porque solo se proporciona la información necesaria para realizar análisis estadísticos.

5. ¿Qué principio de seguridad estás aplicando?
El principio de mínimo privilegio, porque el rol recibe únicamente los permisos necesarios para cumplir su función.
*/

