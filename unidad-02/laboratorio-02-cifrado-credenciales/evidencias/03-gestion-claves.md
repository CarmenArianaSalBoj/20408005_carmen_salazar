# ACTIVIDAD 3. El problema de la gestión de claves

## Objetivo

Identificar los riesgos de seguridad que implica incluir claves de cifrado directamente en archivos SQL y comprender la importancia de evitar que las claves, contraseñas y otros secretos se publiquen en repositorios Git.

## Comando o procedimiento

Se creó un archivo temporal llamado `sql/ejemplo-mala-practica.sql` con una consulta de demostración que utiliza la clave ficticia `CLAVE-DE-PRUEBA` para descifrar información mediante la función `pgp_sym_decrypt()`.

Posteriormente, se analizó el archivo para identificar los riesgos de incluir una clave directamente en el código fuente y se consideraron las posibles consecuencias de publicar este archivo en un repositorio Git.


## Resultado obtenido

Se identificó que la clave de cifrado aparece directamente en la consulta SQL. Esto significa que cualquier persona que tenga acceso al archivo puede conocer la clave utilizada en la demostración. Aunque el valor empleado es ficticio, la práctica permite comprender el riesgo de exponer secretos dentro del código.

## Análisis

Si la clave fuera utilizada realmente por una organización y el archivo se publicara en un repositorio Git, una persona con acceso al repositorio podría obtenerla y utilizarla para intentar descifrar la información protegida con esa clave. El riesgo también podría mantenerse si el archivo se elimina posteriormente, debido a que Git conserva el historial de cambios.

La exposición de claves puede comprometer la confidencialidad de los datos, especialmente cuando una misma clave protege varios registros o respaldos. Por ello, los secretos deben administrarse mediante mecanismos seguros y no incluirse directamente en los scripts ni en los repositorios.

## Conclusión

La actividad permitió reconocer que la gestión de claves es una parte fundamental de la seguridad de la información. No basta con cifrar los datos; también es necesario proteger las claves que permiten descifrarlos. Para evitar exposiciones, no se deben publicar secretos reales en repositorios Git y se deben utilizar mecanismos seguros de gestión de claves. El archivo temporal de demostración debe eliminarse antes de la entrega final.

## Pregunta

**¿Qué ocurriría si esta clave fuera una clave utilizada realmente por una organización y el archivo se publicara en un repositorio Git?**

La clave quedaría expuesta a las personas que puedan acceder al archivo y podrían utilizarla para descifrar los datos protegidos con ella. Además, aunque el archivo se elimine después, la clave podría seguir disponible en el historial del repositorio. Esto comprometería la confidencialidad de la información y obligaría a evaluar el alcance de la exposición y cambiar o revocar la clave afectada.
