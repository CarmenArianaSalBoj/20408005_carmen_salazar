
-- Actividad 3: El problema de la gestión de claves
-- Demostración de una mala práctica.
-- La clave utilizada es ficticia.

SELECT pgp_sym_decrypt(
    rfc_cifrado,
    'CLAVE-DE-PRUEBA'
)
FROM clientes_protegidos;
