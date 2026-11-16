# Actividad 9 — Comparar los tres escenarios

## 1. Comparación de capacidades de auditoría

| Evento auditable | PostgreSQL (bitácora + disparador) | MongoDB Community (perfilador + bitácora) | MongoDB Enterprise/Atlas (auditoría nativa) |
|---|---|---|---|
| Acceso exitoso | Parcial: depende de la configuración de registro de conexiones. | Sí: se observó `Successfully authenticated` para `app_ventas`. | Documentado, no practicado. |
| Acceso fallido | Parcial: depende de los registros de autenticación del servidor. | Sí: se observaron intentos fallidos por contraseña incorrecta y usuario inexistente. | Documentado, no practicado. |
| Cambio de privilegios | Parcial: puede registrarse mediante bitácoras y sentencias de administración. | Parcial: las instantáneas permitieron detectar que se agregó `dbAdmin`, pero no identificar con certeza quién ni cuándo lo hizo. | Documentado, no practicado. |
| Cambio de estructura | Parcial: puede registrarse mediante la bitácora si se configuran los eventos DDL. | Parcial: la bitácora puede registrar comandos administrativos, pero no se comprobó una auditoría completa de cambios de estructura. | Documentado, no practicado. |
| Modificación de datos | Sí: un disparador puede registrar las modificaciones realizadas. | Sí: el perfilador registró operaciones como `update` y `remove`. | Documentado, no practicado. |
| Valor anterior del dato | Sí: un disparador puede utilizar `OLD` para guardar el valor anterior. | No: el perfilador mostró el comando de actualización, pero no conservó el valor anterior del documento. | No: la auditoría nativa no debe confundirse con un historial completo de valores anteriores. |
| Lectura de datos sensibles | Parcial: depende de que la bitácora registre las consultas y de su configuración. | Parcial: el perfilador puede registrar consultas, pero el filtro configurado excluyó las lecturas y no se comprobó la recuperación de los datos sensibles devueltos. | Documentado, no practicado. |
| Cambio de configuración del registro | Parcial: depende de que las modificaciones de configuración queden registradas. | Sí: se observó `Profiler settings changed` y se relacionó con la sesión del usuario `admin`. | Documentado, no practicado. |

**Nota:** En PostgreSQL, las capacidades indicadas dependen de la configuración de la bitácora y de la implementación del disparador. No deben interpretarse como pruebas realizadas si no aparecen en las evidencias del LAB-01.

## 2. Análisis de la comparación

**PostgreSQL**

La combinación de bitácoras y disparadores permite registrar diferentes actividades. Una ventaja importante de los disparadores es que pueden guardar los valores anteriores y nuevos de un registro mediante `OLD` y `NEW`. Sin embargo, para registrar accesos, consultas y cambios administrativos se necesita una configuración adecuada de la bitácora.

**MongoDB Community**

El perfilador permite identificar operaciones realizadas sobre las colecciones, incluyendo consultas y modificaciones, mientras que la bitácora permite revisar eventos de autenticación y cambios de configuración. Durante las actividades se comprobó que es posible identificar al usuario y la aplicación que ejecutaron una operación. Sin embargo, el perfilador no conserva automáticamente los valores anteriores de los documentos y las instantáneas de privilegios no proporcionan una atribución completa del cambio.

**MongoDB Enterprise/Atlas**

Estas versiones cuentan con auditoría nativa, que permite registrar eventos relacionados con autenticación, autorización, operaciones CRUD y cambios de estructura, dependiendo de la configuración. Estas capacidades se consultaron mediante la documentación, pero no se practicaron en este laboratorio.

## 3. Conclusión

Los tres escenarios ofrecen diferentes posibilidades para mantener la trazabilidad de las actividades realizadas en una base de datos. PostgreSQL puede utilizar disparadores para conservar valores anteriores y nuevos, mientras que MongoDB Community combina el perfilador y la bitácora para identificar operaciones y eventos del servidor.

Por otro lado, MongoDB Enterprise y Atlas ofrecen auditoría nativa con mayores posibilidades de seguimiento. En conclusión, la elección depende del nivel de auditoría requerido, los recursos disponibles, la configuración y la necesidad de conservar evidencia confiable para investigar incidentes.
