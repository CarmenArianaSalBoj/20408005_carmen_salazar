----------------------------------------------------------------------------------
-- Actividad 7
----------------------------------------------------------------------------------------
 //IDENTIFICAR REGISTROS QUE HIPOTETICAMENTE SUPERAN EL PERIODO DE CONSERVACION ESTABLECIDO DE 5 AÑOS
SELECT *
FROM clientes
WHERE fecha_alta <
      CURRENT_DATE - INTERVAL '5 years';

