# ACTIVIDAD 1. Protección de credenciales

## Objetivo

Evaluar los riesgos de almacenar contraseñas en texto plano dentro de una base de datos y comprender la importancia de proteger las credenciales de los usuarios para evitar que personas no autorizadas puedan conocerlas.

## Comando o procedimiento

Se creó una tabla llamada `usuarios_insegura` con los campos `id`, `usuario` y `password`. Posteriormente, se insertó un usuario de prueba con el nombre `juan` y la contraseña `Password123`.

Finalmente, se ejecutó la consulta `SELECT * FROM usuarios_insegura;` para visualizar los registros almacenados y comprobar cómo se muestran las credenciales cuando no cuentan con una protección adecuada.

## Resultado obtenido

La consulta mostró el nombre de usuario `juan` y su contraseña `Password123` directamente en los resultados. Esto demuestra que la contraseña se almacenó en texto plano, sin ningún mecanismo de protección.
## Evidencias en imagen
![Evidencia](../imagenes/EVIDENCIA%20ACTIVIDAD%201.jpg)

![Evidencia](../imagenes/EVIDENCIA%20ACTIVIDAD%201.1.jpg)

![Evidencia](../imagenes/EVIDENCIA%20ACTIVIDAD%201.2.jpg)

![Evidencia](../imagenes/EVIDENCIA%20ACTIVIDAD%201.3.jpg)

## 7.1

**¿Qué ocurriría si una persona obtiene acceso de lectura a esta tabla?**

La persona que obtenga acceso de lectura a la tabla podrá consultar la información almacenada. Como los datos están en texto plano, podrá conocer las contraseñas y hacer un uso indebido de las credenciales.

## 7.2 Identificar el problema

La consulta anterior permite observar directamente la contraseña.

Esto representa una mala práctica de seguridad, porque una persona con acceso de lectura a la tabla puede obtener inmediatamente la credencial.

Además, almacenar contraseñas en texto plano provoca que una filtración de la base de datos pueda convertirse directamente en una filtración de credenciales.

## 7.3 Generar una representación no reversible

**¿Son iguales?**

No, los resultados son diferentes cada vez que se ejecuta la consulta, aunque se utilice la misma contraseña.

**Si no son iguales, ¿por qué?**

Porque `gen_salt()` genera una sal aleatoria en cada ejecución, lo que provoca que la misma contraseña produzca hashes diferentes.

**¿Qué función cumple `gen_salt()`?**

Genera una sal aleatoria y especifica los parámetros del algoritmo de hash que se utilizará para proteger las contraseñas.

**¿Qué función cumple `crypt()`?**

Permite generar un hash a partir de una contraseña y una sal. También permite verificar si una contraseña ingresada coincide con el hash almacenado.

**¿Esto es cifrado reversible?**

No. Es un proceso unidireccional que no está diseñado para recuperar la contraseña original, sino para verificarla sin almacenarla en texto plano.

## 7.4 Crear una tabla para credenciales protegidas

Se observó que la contraseña original ya no apareció directamente en la consulta, sino que se mostró su representación mediante un hash. Esto permite proteger la contraseña original frente a la consulta directa de los registros.

## 7.5 Verificar una contraseña

**¿Qué resultado obtuviste con la contraseña correcta?**

Obtuve el resultado `true`, porque la contraseña ingresada (`Password123`) coincide con la contraseña protegida mediante hash que está almacenada en la tabla.

**¿Qué resultado obtuviste con la contraseña incorrecta?**

Obtuve el resultado `false`, porque la contraseña ingresada (`OtraPassword`) no coincide con la contraseña registrada.

**¿Por qué no es necesario recuperar la contraseña original?**

Porque el sistema puede verificar la contraseña ingresada utilizando el hash almacenado, sin necesidad de recuperar la contraseña original.

**¿Por qué un hash no debe confundirse con cifrado?**

Porque el hash es un proceso unidireccional que permite verificar una contraseña sin recuperar directamente su valor original. En cambio, el cifrado es reversible cuando se dispone de la clave de descifrado.

## Análisis

Si una persona obtiene acceso de lectura a la tabla que almacena contraseñas en texto plano, podría conocer las credenciales de los usuarios sin necesidad de descifrarlas. Esto representa un riesgo de seguridad, ya que las contraseñas podrían utilizarse para intentar acceder a las cuentas afectadas. Si una persona reutiliza la misma contraseña en otros servicios, también podrían verse comprometidas esas cuentas.

## Conclusión

Almacenar contraseñas en texto plano es una práctica insegura porque permite que cualquier persona con permisos de lectura sobre la tabla pueda conocerlas. Para reducir este riesgo, las contraseñas deben almacenarse mediante algoritmos especializados de hash para contraseñas, como Argon2id, bcrypt o scrypt, utilizando una configuración adecuada. Además, se deben aplicar controles de acceso para limitar quién puede consultar la información sensible.
