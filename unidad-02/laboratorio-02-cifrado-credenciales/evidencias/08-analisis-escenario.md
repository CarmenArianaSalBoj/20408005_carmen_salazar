# Actividad 8. Análisis de un escenario de seguridad

## Pregunta 1. ¿Cuáles son los principales riesgos?

Los principales riesgos identificados son:

- **Contraseñas en texto claro:** si alguien obtiene acceso a la base de datos, puede conocer las contraseñas de los usuarios y utilizarlas para acceder a otros sistemas.
- **RFC en texto claro:** existe el riesgo de exposición de información personal, suplantación de identidad y uso indebido de los datos.
- **Conexiones sin validación adecuada del servidor:** un atacante podría interceptar la comunicación o hacerse pasar por el servidor legítimo.
- **Claves criptográficas en archivos SQL:** las claves podrían quedar expuestas en el repositorio, los respaldos o los registros de actividad, comprometiendo la información protegida.
- **Respaldos sin protección adicional:** si una persona no autorizada obtiene una copia de seguridad, podría acceder a información confidencial sin necesidad de conectarse a la base de datos.

## Pregunta 2. ¿Qué mecanismo utilizarías para cada elemento?

| Elemento o problema | Mecanismo de seguridad |
|---|---|
| Nombre y correo electrónico | Control de acceso mediante roles, privilegio mínimo y exposición limitada de los datos. |
| Contraseñas | Almacenamiento mediante hashes seguros para contraseñas, como Argon2id o bcrypt, con sal única. Nunca guardarlas en texto claro. |
| RFC | Cifrado cuando sea necesario proteger el dato almacenado, además de restringir el acceso y mostrar solo los datos necesarios. |
| Información financiera | Cifrado en reposo, permisos específicos, auditoría de accesos y protección de respaldos. |
| Claves criptográficas | Almacenarlas fuera de los archivos SQL, en un gestor de secretos o sistema de gestión de claves, con acceso restringido y rotación. |
| Conexiones a la base de datos | Utilizar TLS con validación del certificado y de la identidad del servidor. |
| Respaldos | Cifrarlos, limitar quién puede acceder a ellos y mantener copias protegidas y verificadas. |

## Pregunta 3. ¿Cuál de los problemas consideras más crítico y por qué?

Considero que almacenar las contraseñas en texto claro es uno de los problemas más críticos, porque cualquier persona que obtenga acceso a la tabla podría conocerlas directamente. Además, si los usuarios reutilizan sus contraseñas, el impacto podría extenderse a otros servicios.

También considero muy grave la exposición de las claves criptográficas, ya que un atacante podría utilizarlas para descifrar información protegida o hacerse pasar por un sistema autorizado, dependiendo de la función de cada clave. Por eso, ambos problemas deben atenderse de inmediato.

## Pregunta 4. ¿Tener correctamente configurados los usuarios y permisos elimina estos riesgos?

No. Configurar correctamente los usuarios y permisos reduce el riesgo de accesos no autorizados, pero no elimina todas las vulnerabilidades.

Por ejemplo, una persona que consiga acceso legítimo a una tabla podría leer las contraseñas si están almacenadas en texto claro. De igual manera, los permisos de la base de datos no protegen por sí solos los archivos SQL que contienen claves, las conexiones sin validación adecuada ni los respaldos sin cifrado.

Por lo tanto, la seguridad debe aplicarse en varias capas: control de acceso, almacenamiento seguro de contraseñas, cifrado, gestión de claves, validación de conexiones, protección de respaldos y auditoría. Estas medidas se complementan para reducir la probabilidad y el impacto de un incidente de seguridad.
