# ACTIVIDAD 7. Comparar protección en reposo y protección en tránsito

## Objetivo

Comparar los mecanismos de protección de la información almacenada y transmitida, identificando cuál es apropiado para cada tipo de dato y qué riesgo de seguridad ayuda a reducir.

## Comando o procedimiento

Se analizaron diferentes situaciones relacionadas con contraseñas, datos personales, comunicaciones, respaldos y claves criptográficas. Para cada caso, se seleccionó un mecanismo de protección adecuado y se identificó qué aspecto de la seguridad ayuda a proteger.

## Resultado obtenido

| Situación | Mecanismo apropiado | ¿Qué protege? |
|---|---|---|
| Contraseña de usuario | Hash especializado para contraseñas, como Argon2id o bcrypt, con sal | Evita almacenar la contraseña original y dificulta su recuperación por atacantes. |
| RFC almacenado en una tabla | Cifrado en reposo cuando se requiere confidencialidad, acompañado de controles de acceso | Protege el RFC frente a personas que no deben conocer su contenido. |
| Consulta enviada desde un cliente al servidor | TLS con validación adecuada del certificado del servidor | Protege la confidencialidad e integridad de los datos durante la transmisión y ayuda a verificar la identidad del servidor. |
| Respaldo de una base de datos | Cifrado del respaldo, almacenamiento restringido y control de acceso | Reduce el riesgo de exposición de los datos si el archivo de respaldo es robado o consultado sin autorización. |
| Clave criptográfica | Gestor de secretos o sistema de gestión de claves (KMS/HSM), con acceso restringido | Protege las claves contra divulgación, modificación y uso no autorizado. |

## Análisis

La protección en reposo se aplica a los datos almacenados en bases de datos, archivos y respaldos. La protección en tránsito se aplica a los datos que viajan entre sistemas, por ejemplo, mediante TLS. Las contraseñas requieren un tratamiento diferente al de otros datos sensibles: deben protegerse con funciones especializadas de hash para contraseñas, no mediante cifrado reversible.

Las claves criptográficas necesitan controles especiales porque su exposición puede permitir descifrar información protegida. Por ello, deben almacenarse y administrarse de forma segura, separadas del código que las utiliza.

## Conclusión

La protección de la información requiere seleccionar mecanismos según el tipo de dato y el riesgo que se desea reducir. El hash especializado es adecuado para contraseñas, el cifrado puede proteger datos sensibles y respaldos, TLS protege las comunicaciones y los gestores de claves ayudan a proteger los secretos criptográficos.
