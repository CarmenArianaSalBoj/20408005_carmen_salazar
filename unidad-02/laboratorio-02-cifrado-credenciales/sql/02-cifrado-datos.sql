-----------------------------------------------------------------------------
---Alumna: Carmen Ariana Salazar Bojórquez---------------------------------
---Actividad 2-CIFRADO DE INFORMACIÓN SENSIBLE
---------------------------------------------------------------------------

--8.1 CREAR UNA TABLA DE DEMOSTRACIÓN---------------------------------------
CREATE TABLE clientes_protegidos (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    rfc_cifrado BYTEA NOT NULL
);
-----INSERTAR UN REGISTRO UTILZANDP CIFRADO SIMETRICO--------------------------
INSERT INTO clientes_protegidos (
    nombre,
    rfc_cifrado
)
VALUES (
    'Ana López',
    pgp_sym_encrypt('LOPA900101ABC', 'CLAVE-DE-PRUEBA')
);

-------CONSULTA----------------------------------------------------------------
SELECT *
FROM clientes_protegidos;
------------------------------------------------------------------------------

--8.2 RECUPERAR EL DATO-------------------------------------------------------
SELECT
    id,
    nombre,
    pgp_sym_decrypt(
        rfc_cifrado,
        'CLAVE-DE-PRUEBA'
    ) AS rfc
FROM clientes_protegidos;
---------------------------------------------------------------------------------

