# Actividad 10 — Responder a Dirección

## 1. ¿Quién cambió el RFC de María García en la Actividad 2? ¿Y en la Actividad 3?

**Actividad 2:**

La modificación se ejecutó mediante la cuenta `app_ventas`, utilizando la aplicación identificada como `app-ventas-web` en la cadena de conexión. El comando modificó el RFC del cliente con `_id: 3`. La operación fue exitosa, con `matchedCount: 1` y `modifiedCount: 1`.

Sin embargo, no se conservó una entrada del perfilador que permitiera confirmar independientemente la identidad del responsable.

**Actividad 3:**

La operación de actualización también se ejecutó utilizando la cuenta `app_ventas` y la aplicación `app-ventas-web`. El perfilador permite identificar el usuario y la aplicación cuando esos datos aparecen en el registro de la operación.

No obstante, para confirmar el registro específico del cambio de RFC de María García se necesita consultar la entrada correspondiente en `system.profile`.

## 2. ¿Cuándo y desde qué aplicación?

**Actividad 2:**

No hay evidencia con esta edición para establecer la hora exacta del cambio. La operación se realizó mediante la conexión configurada con `appName=app-ventas-web`, pero el resultado de `updateOne` no incluye una marca de tiempo.

**Actividad 3:**

La aplicación utilizada fue `app-ventas-web` y el usuario fue `app_ventas@comercial`, de acuerdo con la información de conexión y el formato de los registros del perfilador observados en el laboratorio.

No hay evidencia con esta edición para confirmar la hora exacta del cambio de RFC, porque no se cuenta con el registro específico de esa actualización en la evidencia exportada.

## 3. ¿Qué valor tenía antes?

No hay evidencia con esta edición para recuperar el RFC anterior de María García.

El perfilador puede registrar el filtro y la modificación solicitada, pero no conserva automáticamente una copia del documento antes de actualizarlo. En consecuencia, aunque se conozca el nuevo valor enviado en el comando, no es posible asegurar cuál era el valor anterior.

## 4. ¿Cambió alguien los privilegios de `app_ventas`?

Sí. En la Actividad 7 se compararon dos instantáneas de privilegios y se observó que el usuario `app_ventas` pasó de tener únicamente el rol `readWrite` a tener también el rol `dbAdmin` en la base de datos `comercial`.

Posteriormente, se revocó el rol `dbAdmin` como parte de la restauración de los privilegios originales.

Sin embargo, no hay evidencia con esta edición para identificar con certeza quién realizó el cambio ni la hora exacta en que ocurrió. Las instantáneas permiten detectar la diferencia entre los privilegios registrados, pero no proporcionan por sí solas la atribución y el momento preciso del cambio.

## Conclusión

El laboratorio permitió identificar usuarios, aplicaciones y operaciones realizadas sobre MongoDB. También permitió detectar cambios en los privilegios mediante la comparación de instantáneas.

Sin embargo, MongoDB Community, utilizando el perfilador y la bitácora consultados en estas actividades, no proporcionó toda la información necesaria para reconstruir los incidentes. En particular, no se recuperó el valor anterior del RFC ni se pudo atribuir con certeza quién y cuándo modificó los privilegios. Esto demuestra la importancia de contar con mecanismos adicionales de auditoría y conservación de evidencia.
