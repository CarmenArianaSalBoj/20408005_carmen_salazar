---------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
-------------------------------------------------------------------------------
---  ACTIVIDAD 2 - PRINCIPIO DE MINIMIZACIÓN
---  OBJETIVO: LIMITAR LOS DATOS DISPONIBLES PARA ATENCIÓN A CLIENTE.
--------------------------------------------------------------------------


--Supongamos que el área de atención al cliente solicita crear una nueva tabla:
--Con las siguientes caracteristicas (comentada por que es propuesta)

/*CREATE TABLE clientes_soporte (
    id BIGSERIAL,
    nombre VARCHAR(120),
    correo VARCHAR(150),
    telefono VARCHAR(20),
    rfc VARCHAR(13),
    edad INTEGER,
    ciudad VARCHAR(80),
    codigo_postal VARCHAR(10),
    fecha_alta DATE
);*/

/*Analiza la solicitud.

Preguntas
¿Todos los campos son necesarios para atención al cliente?
 No, solo necesitan el ID, nombre, correo electronico y telefono.

¿Por qué soporte necesitaría conocer el RFC?
 En general, no lo necesita. El RFC debe estar disponible para el área de facturación, que lo utiliza para los procesos fiscales correspondientes.

¿Necesita conocer la edad?
 No, porque el escenario no indica que la edad sea necesaria para atender las solicitudes de los clientes. Por lo tanto, no debería mostrarse a esta área.
 
¿Necesita conocer el código postal?
 No necesariamente. Como atención al cliente solo requiere información básica, el código postal no debe estar disponible si no existe una finalidad específica que justifique su consulta.

¿Qué principio de privacidad está relacionado con esta decisión?
El principio de minimización de datos, porque cada área debe acceder únicamente a los datos personales necesarios para cumplir sus funciones. También se relaciona con el principio de limitación de la finalidad, ya que los datos deben utilizarse para propósitos específicos y justificados.

*/

---    8.1 Diseñar una estructura mínima
--Crea una tabla que contenga únicamente los datos necesarios para la finalidad de soporte:

CREATE TABLE clientes_soporte (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    telefono VARCHAR(20)
);

---    Carga información a partir de clientes:

INSERT INTO clientes_soporte (
    id,
    nombre,
    correo,
    telefono
)
---   consultar los datos 
SELECT
    id,
    nombre,
    correo,
    telefono
FROM clientes;

Consulta:

SELECT *
FROM clientes_soporte;



