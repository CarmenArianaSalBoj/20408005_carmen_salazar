# ACTIVIDAD 2. Cifrado de información sensible

## Objetivo

Comprender la importancia de proteger la información sensible mediante cifrado simétrico en PostgreSQL, utilizando el RFC como ejemplo, y comprobar cómo se puede recuperar el dato original mediante la clave de descifrado.

## Comando o procedimiento

Primero, se utilizó la extensión `pgcrypto` de PostgreSQL para realizar las operaciones criptográficas. Después, se creó la tabla `clientes_protegidos`, con los campos `id`, `nombre` y `rfc_cifrado`.

Posteriormente, se insertó un registro de prueba correspondiente a Ana López, utilizando la función `pgp_sym_encrypt()` para cifrar el RFC `LOPA900101ABC` con la clave de prueba `CLAVE-DE-PRUEBA`.

Finalmente, se consultó la tabla para observar el dato cifrado y se utilizó `pgp_sym_decrypt()` con la misma clave para recuperar el RFC original.

## Imagenes
![evidencia](EVIDENCIA ACTIVIDAD 2.jpg)
![evidencia](EVIDENCIA ACTIVIDAD 2.1.jpg)

## Resultado obtenido

Al consultar la tabla `clientes_protegidos`, el campo `rfc_cifrado` mostró datos binarios cifrados en lugar del RFC original. Al ejecutar la consulta de descifrado con la clave correcta, se recuperó el RFC `LOPA900101ABC`.

## Análisis

El cifrado permite proteger información sensible para que no pueda leerse directamente sin la clave correspondiente. En esta actividad se comprobó que el RFC puede almacenarse cifrado y recuperarse cuando se dispone de la clave correcta.

Sin embargo, colocar la clave directamente en una consulta representa un riesgo, ya que puede quedar expuesta en el historial de consultas, registros o archivos SQL. En una aplicación real, la clave debe gestionarse de forma segura y no almacenarse junto con los datos cifrados.

## Conclusión

La actividad permitió comprobar que el cifrado simétrico de PostgreSQL protege la información sensible y permite recuperar el dato original mediante una clave. A diferencia del hash utilizado para proteger contraseñas, el cifrado es reversible si se cuenta con la clave adecuada. Por ello, es necesario proteger tanto los datos cifrados como las claves utilizadas para descifrarlos.

## Preguntas

**1. ¿Qué diferencia existe entre `crypt()` y `pgp_sym_encrypt()`?**

La función `crypt()` se utiliza para generar y verificar hashes de contraseñas, mientras que `pgp_sym_encrypt()` cifra información mediante una clave simétrica y permite recuperarla posteriormente con la función de descifrado correspondiente.

**2. ¿Cuál de los dos mecanismos permite recuperar el dato original?**

`pgp_sym_encrypt()` permite recuperar el dato original mediante `pgp_sym_decrypt()` y la clave correcta. El hash generado con `crypt()` no está diseñado para recuperar la contraseña original.

**3. ¿Qué ocurre si se utiliza una clave incorrecta?**

El descifrado normalmente falla y PostgreSQL genera un error indicando que no fue posible descifrar el dato. No se obtiene el RFC original.

**4. ¿Qué problema de seguridad representa colocar la clave directamente en una consulta?**

La clave podría quedar expuesta en el historial de consultas, registros del sistema, archivos SQL o capturas de pantalla. Una persona que obtenga la clave podría descifrar los datos protegidos. Por eso, en aplicaciones reales se deben utilizar mecanismos seguros de gestión de claves y limitar el acceso a ellas.
