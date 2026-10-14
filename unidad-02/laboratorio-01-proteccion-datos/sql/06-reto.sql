----------------------------------------------------------------------------
-- Actividad 6 RETO
---------------------------------------------------------------------------

--Utilizar rangos de edad mas amplios, generalizar la region utilizando solamente el primer digito 
--del codigo postal y conservar el umbral de cinco registros.
SELECT 
      CASE 
           WHEN edad BETWEEN 18 AND 45 THEN  '18-45'
           WHEN edad >= 46 THEN '46+'
           ELSE 'No clasificada'
      END AS rango_edad,
      LEFT( codigo_postal, 1) AS region_general,
      COUNT(*) AS total
FROM clientes
WHERE edaad >= 18
      AND codigo_postal IS NOT NULL
GROUP BY 1, 2
HAVING COUNT(*) >= 5;

