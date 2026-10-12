# Laboratorio 02 — Cifrado y credenciales

## 1. Introducción

En este laboratorio se analizaron los riesgos de seguridad relacionados con el almacenamiento de contraseñas en texto claro, la protección de información sensible, la transmisión de datos entre clientes y PostgreSQL y la gestión de claves criptográficas.

El objetivo principal fue comprender que la seguridad de una base de datos no depende únicamente de los usuarios y permisos, sino también de los mecanismos utilizados para proteger la información almacenada y transmitida. Para ello, se realizaron ejercicios con funciones criptográficas de PostgreSQL, como las proporcionadas por la extensión `pgcrypto`, y se revisaron los parámetros relacionados con TLS.

## 2. Protección de credenciales

Durante la actividad de protección de credenciales se comparó el almacenamiento de contraseñas en texto claro con el uso de funciones de hash.

El **texto claro** permite leer directamente la contraseña almacenada. Por ejemplo, si se guarda `Password123` en una columna, cualquier persona con permiso de lectura puede conocerla.

El **hash** es una representación calculada mediante una función unidireccional. Para las contraseñas se deben utilizar algoritmos especializados, como Argon2id o bcrypt, con una configuración adecuada. En la práctica se utilizaron las funciones `crypt()` y `gen_salt()` de PostgreSQL para demostrar este mecanismo.

El **cifrado**, a diferencia del hash, permite recuperar la información original cuando se dispone de la clave correcta. Por esta razón, el cifrado reversible no sustituye al hash especializado para almacenar contraseñas.

## 3. Protección de datos sensibles

Se utilizó el RFC como ejemplo de información personal que puede requerir protección adicional. Mediante las funciones `pgp_sym_encrypt()` y `pgp_sym_decrypt()` de la extensión `pgcrypto`, se demostró cómo cifrar un dato y recuperarlo utilizando una clave simétrica.

El propósito fue comprobar que el dato cifrado no se presenta directamente como texto legible y que puede recuperarse mediante el procedimiento de descifrado correspondiente.

El cifrado debe complementarse con permisos restringidos y una gestión segura de las claves. De esta manera, se reduce el riesgo de exposición de la información sensible ante accesos no autorizados.

## 4. TLS

TLS (Transport Layer Security) permite proteger la comunicación entre un cliente y un servidor mediante mecanismos criptográficos que proporcionan confidencialidad e integridad. Cuando se configura correctamente la validación de certificados, también ayuda a verificar la identidad del servidor.

Durante el laboratorio se revisaron los parámetros de PostgreSQL mediante las siguientes consultas:

```sql
SHOW ssl;
SHOW ssl_min_protocol_version;
SHOW port;
SHOW listen_addresses;
```

También se revisó la conexión actual mediante:

```sql
SELECT
    inet_client_addr(),
    inet_client_port();
```

Finalmente, se consultó `pg_stat_ssl` para identificar si la sesión actual utiliza cifrado y conocer la versión del protocolo y el algoritmo de cifrado negociados:

```sql
SELECT
    ssl,
    version,
    cipher
FROM pg_stat_ssl
WHERE pid = pg_backend_pid();
```

Estas consultas permiten distinguir entre la configuración del servidor y el estado real de la conexión actual.

**Resultado de la verificación:** completar con los valores obtenidos al ejecutar las consultas, indicando si `ssl` devolvió `true` o `false`, la versión del protocolo y el algoritmo de cifrado, cuando correspondan.

## 5. Gestión de claves

Las claves criptográficas son necesarias para descifrar información protegida mediante cifrado simétrico. Si se incluyen directamente en los scripts SQL, pueden quedar expuestas mediante repositorios Git, archivos compartidos, registros de ejecución, respaldos o capturas de pantalla.

Durante la práctica se analizó una consulta de demostración que incluía una clave ficticia dentro del código. Esto permitió identificar el riesgo de mantener las claves junto con los scripts que las utilizan.

En un entorno productivo, las claves deben administrarse mediante mecanismos seguros, como gestores de secretos, sistemas de gestión de claves (KMS) o módulos de seguridad de hardware (HSM), según las necesidades de la organización. También deben establecerse controles de acceso, procedimientos de rotación y medidas para responder ante exposiciones accidentales.

## 6. Resultados

Las actividades permitieron identificar los siguientes aspectos:

- El almacenamiento de contraseñas en texto claro permite conocerlas directamente mediante una consulta a la tabla.
- Las funciones `crypt()` y `gen_salt()` permiten demostrar la generación y verificación de hashes para contraseñas.
- Las funciones `pgp_sym_encrypt()` y `pgp_sym_decrypt()` permiten cifrar información sensible y recuperarla con la clave correcta.
- Incluir claves directamente en archivos SQL representa un riesgo de exposición.
- Las consultas a `pg_stat_ssl` permiten verificar el estado de cifrado de la sesión actual de PostgreSQL.
- La protección de los datos requiere combinar mecanismos criptográficos, controles de acceso y una gestión segura de claves.

Los resultados específicos de cada consulta deben respaldarse con las evidencias generadas durante la ejecución del laboratorio.

## 7. Problemas encontrados

Durante el desarrollo del laboratorio fue necesario organizar los scripts SQL y las evidencias Markdown de acuerdo con la estructura de directorios solicitada.

También fue importante distinguir entre los mecanismos de hash y cifrado, ya que ambos tienen propósitos diferentes. El hash permite verificar una contraseña sin recuperar directamente su valor original, mientras que el cifrado permite recuperar los datos cuando se dispone de la clave correcta.

En la etapa de comunicación, fue necesario revisar la configuración de SSL/TLS y consultar el estado de la sesión actual para no asumir que una conexión estaba cifrada únicamente porque el servidor tuviera SSL habilitado.

**Nota:** agregar aquí cualquier error técnico real que se haya presentado durante la ejecución, junto con su solución. No deben documentarse errores que no hayan ocurrido.

## 8. Conclusiones

El laboratorio permitió comprender que la protección de credenciales y datos sensibles requiere mecanismos diferentes según el tipo de información. Las contraseñas deben almacenarse mediante funciones especializadas de hash, mientras que los datos que necesitan recuperarse pueden protegerse mediante cifrado.

También se identificó la importancia de proteger las comunicaciones mediante TLS, administrar las claves criptográficas de forma segura y evitar que los secretos se publiquen en repositorios.

En un entorno productivo aplicaría el principio de mínimo privilegio, hash especializado para contraseñas, cifrado de información sensible y respaldos, validación de certificados TLS, almacenamiento seguro de claves, auditorías y revisión de secretos antes de publicar cambios en GitLab.

---

# 23. Preguntas de reflexión

## 1. ¿Por qué una contraseña no debe almacenarse como texto claro?

Porque cualquier persona con acceso de lectura a la tabla podría conocerla directamente. Si se produce una filtración, las contraseñas quedarían expuestas y podrían utilizarse para acceder a las cuentas afectadas. Por ello, deben almacenarse mediante algoritmos especializados de hash para contraseñas.

## 2. ¿Por qué un hash no es equivalente a un cifrado?

Porque el hash es un mecanismo unidireccional diseñado para generar una representación que permita verificar un dato sin recuperarlo directamente. El cifrado es reversible cuando se dispone de la clave adecuada y permite recuperar la información original.

## 3. ¿Por qué el cifrado de una columna no sustituye al control de acceso?

Porque el cifrado protege la confidencialidad del contenido, pero no determina quién está autorizado a consultar o modificar la tabla. Los permisos siguen siendo necesarios para limitar el acceso a los datos y a las operaciones que pueden realizar los usuarios.

## 4. ¿Por qué TLS no sustituye a los mecanismos de autorización de PostgreSQL?

Porque TLS protege la comunicación entre el cliente y el servidor, pero no decide qué tablas puede consultar cada usuario ni qué operaciones puede ejecutar. La autorización de PostgreSQL continúa siendo necesaria para aplicar permisos y limitar el acceso a los recursos.

## 5. ¿Qué ocurriría si una organización pierde una clave utilizada para cifrar información?

Si no existe una copia recuperable de la clave ni otro mecanismo de recuperación, la organización podría perder permanentemente el acceso a la información cifrada. Por eso es importante contar con respaldos seguros de las claves y procedimientos de recuperación probados.

## 6. ¿Qué ocurriría si una clave criptográfica se publica accidentalmente en GitLab?

La clave podría ser obtenida por personas con acceso al repositorio y utilizada para descifrar información o realizar operaciones no autorizadas. El riesgo puede persistir en el historial de Git aunque se elimine el archivo. Se debe evaluar la exposición y rotar o revocar la clave afectada según corresponda.

## 7. ¿Por qué un repositorio privado no debe considerarse un almacén de secretos?

Porque las personas con acceso al repositorio podrían consultar el contenido y los secretos podrían propagarse mediante clones, respaldos, registros o cambios compartidos. La privacidad del repositorio reduce la exposición, pero no garantiza el nivel de protección necesario para almacenar claves y credenciales.

## 8. ¿Qué diferencia existe entre proteger información almacenada y proteger información durante su transmisión?

La protección en reposo se aplica a los datos almacenados en tablas, archivos y respaldos. La protección en tránsito se aplica a los datos que viajan entre sistemas, por ejemplo, mediante TLS. Ambas son necesarias porque la información puede exponerse tanto en el almacenamiento como durante la comunicación.

## 9. ¿Por qué la gestión de claves es tan importante como el algoritmo criptográfico?

Porque la seguridad del cifrado depende no solo del algoritmo, sino también de la protección de las claves. Si una clave queda expuesta, una persona podría utilizarla para descifrar los datos protegidos. Por eso son fundamentales el almacenamiento seguro, los controles de acceso, la rotación y la revocación.

## 10. ¿Qué mecanismo adicional implementarías en una organización para proteger los respaldos de las bases de datos?

Implementaría cifrado de los respaldos, almacenamiento en una ubicación separada con acceso restringido, controles de integridad y copias protegidas frente a modificaciones o eliminación no autorizada. También realizaría pruebas periódicas de restauración y mantendría las claves de cifrado bajo una gestión segura.

