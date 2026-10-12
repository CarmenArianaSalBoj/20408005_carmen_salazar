# ACTIVIDAD 8. Analizar un escenario de seguridad

## Objetivo

Analizar los riesgos de una empresa que almacena información personal y financiera sin aplicar mecanismos adecuados de protección, y proponer medidas de seguridad para reducir la posibilidad de exposición, robo o uso no autorizado de los datos.

## Comando o procedimiento

Se revisó el escenario planteado, considerando los siguientes elementos: nombre, correo electrónico, contraseña, RFC, información financiera y claves criptográficas. También se evaluaron las debilidades relacionadas con las conexiones a la base de datos, los archivos SQL y los respaldos.

Posteriormente, se identificaron los riesgos principales y se propusieron mecanismos de protección para cada elemento.

## Resultado obtenido

### Pregunta 1. ¿Cuáles son los principales riesgos?

Los principales riesgos son:

- **Contraseñas en texto claro:** cualquier persona con acceso de lectura a la tabla podría conocerlas directamente.
- **RFC en texto claro:** se expone información personal que podría utilizarse de forma indebida.
- **Conexiones sin validación adecuada del servidor:** existe el riesgo de conectarse a un servidor impostor y exponer información o credenciales.
- **Claves criptográficas en archivos SQL:** podrían divulgarse al publicar el código en un repositorio o compartir archivos.
- **Respaldos sin protección:** una copia robada o consultada sin autorización podría revelar toda la información almacenada.
- **Información financiera sin protección suficiente:** puede ocasionar fraude, pérdidas económicas y afectaciones a la privacidad.

### Pregunta 2. ¿Qué mecanismo utilizarías para cada elemento?

| Elemento | Mecanismo de protección |
|---|---|
| Nombre | Control de acceso y minimización de los datos almacenados; cifrado cuando el riesgo y los requisitos lo justifiquen. |
| Correo electrónico | Control de acceso y cifrado en reposo cuando sea necesario; TLS durante la transmisión. |
| Contraseña | Hash especializado para contraseñas, como Argon2id o bcrypt, con una configuración adecuada. |
| RFC | Cifrado en reposo cuando corresponda, permisos restringidos y TLS durante la transmisión. |
| Información financiera | Cifrado en reposo y en tránsito, permisos de mínimo privilegio, auditoría y protección de respaldos. |
| Claves criptográficas | Gestor de secretos o KMS/HSM, acceso restringido, rotación, respaldo seguro y revocación cuando corresponda. |

Además, configuraría las conexiones con TLS y validación del certificado del servidor, cifraría los respaldos y eliminaría las claves reales de los archivos SQL y repositorios.

### Pregunta 3. ¿Cuál de los problemas consideras más crítico y por qué?

Considero especialmente crítico el almacenamiento de contraseñas en texto claro, porque cualquier persona que obtenga acceso de lectura a la tabla podría conocerlas inmediatamente. Si los usuarios reutilizan esas contraseñas en otros servicios, el impacto puede extenderse a otras cuentas.

La exposición de las claves criptográficas también es crítica, ya que puede permitir descifrar los datos que protegen. La gravedad final depende del alcance de la exposición, los permisos disponibles y la información comprometida.

### Pregunta 4. ¿Tener correctamente configurados los usuarios y permisos elimina estos riesgos?

No. Tener correctamente configurados los usuarios y permisos reduce el riesgo de accesos no autorizados, pero no elimina todas las vulnerabilidades. Una persona con permisos legítimos podría leer contraseñas almacenadas en texto claro, y los datos también podrían exponerse mediante respaldos sin cifrar, claves publicadas o conexiones sin validación adecuada del servidor.

Por eso, el control de acceso debe complementarse con hash especializado para contraseñas, cifrado de datos sensibles, TLS, gestión segura de claves, protección de respaldos y revisión de secretos antes de publicar el código.

## Análisis

El escenario demuestra que una base de datos puede tener usuarios y roles correctamente configurados y, aun así, presentar riesgos importantes. La seguridad debe considerar todo el ciclo de vida de la información: almacenamiento, transmisión, respaldo, acceso y eliminación.

Cada mecanismo resuelve un problema diferente. El hash protege las contraseñas sin necesidad de recuperarlas; el cifrado protege datos que deben poder recuperarse; TLS protege la comunicación, y la gestión segura de claves reduce el riesgo de que los mecanismos criptográficos sean comprometidos.

## Conclusión

La seguridad de la base de datos no depende únicamente de los permisos. Es necesario combinar controles de acceso con mecanismos criptográficos adecuados y prácticas seguras de administración. Aplicar estas medidas reduce la exposición de información personal, financiera y confidencial, incluso cuando ocurre un acceso no autorizado o se compromete un archivo de respaldo.
