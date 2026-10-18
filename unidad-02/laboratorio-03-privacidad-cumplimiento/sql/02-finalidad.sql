------------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////
-------------------------------------------------------------------------------
--- ACTIVIDAD 3 - SEPARACION POR FINALIDAD
--------------------------------------------------------------------------


------ANALITICA solicita informacion para obtener estadistica (datos son:ciudad, rango de edad, region del codigo postla)
------no solicita mas

-----CONSULTA QUE PROPORCIONA INFORMACION AGREGADA
SELECT
    ciudad,
    COUNT(*) AS cantidad_clientes
FROM clientes
GROUP BY ciudad
ORDER BY cantidad_clientes DESC;

-----CREAMOS RANGOS DE EDAD
SELECT
    CASE
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 29 THEN '18-29'
        WHEN edad BETWEEN 30 AND 44 THEN '30-44'
        WHEN edad BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60 o más'
    END AS rango_edad,
    COUNT(*) AS cantidad
FROM clientes
GROUP BY
    CASE
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 29 THEN '18-29'
        WHEN edad BETWEEN 30 AND 44 THEN '30-44'
        WHEN edad BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60 o más'
    END
ORDER BY rango_edad;


--- PREGUNTA
--- ¿Por qué esta información puede ser más apropiada para analítica que entregar directamente la tabla completa de clientes?

/*Esta informacion es mas apropiada para analitica porque permite obtener estadisticas sobre la distribución de los clientes por ciudad y rango de edad sin exponer datos personales, que permitan identificarlos directamente.
*/
